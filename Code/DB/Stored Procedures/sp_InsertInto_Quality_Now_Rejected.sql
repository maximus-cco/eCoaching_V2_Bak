SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:           Susmitha Palacherla
-- Create Date:      03/01/2019
-- Description:     Determines rejection reason and rejects  logs.
-- Initial revision. TFS 13332 -  03/01/2019
-- Updated logic for handling multiple Strengths and Opportunities texts for QN batch. TFS 14631 - 06/10/2019
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Quality_Now_Rejected] 
@Count INT OUTPUT

AS
BEGIN


BEGIN TRY

  -- Create table to hold latest QN_Strengths_Opportunities per batch
  CREATE TABLE #Temp_Latest_QN_Strengths_Opportunities (
  QN_Batch_ID nvarchar(20)
  ,QN_Strengths_Opportunities nvarchar(2000)
  );


  --Insert latest value of QN_Strengths_Opportunities per batch to temp table
  INSERT INTO #Temp_Latest_QN_Strengths_Opportunities
   SELECT s.QN_Batch_ID, 
  ISNULL([QN_Strengths_Opportunities], '') AS [QN_Strengths_Opportunities]
  FROM [EC].[Quality_Now_Coaching_Stage] s JOIN
  (SELECT QN_Batch_ID, MAX(Eval_Date) AS Max_Eval_Date
  FROM [EC].[Quality_Now_Coaching_Stage]
 WHERE [QN_Strengths_Opportunities] is NOT NULL 
 AND [QN_Strengths_Opportunities] <> '' 
 GROUP BY QN_Batch_ID) l
  ON s.QN_Batch_ID = l.QN_Batch_ID
  AND s.Eval_Date = l.Max_Eval_Date;

 -- Select * From #Temp_Latest_QN_Strengths_Opportunities


  -- Create table to hold logs with non distinct parent attributres for rejection
  CREATE TABLE #Temp_Non_DISTINCT_QNLogs_To_Reject (
  QN_Batch_ID nvarchar(20)
  ,CountLogs int
  );

  
-- Insert logs with Other non distinct values per batch to temp table for rejection
	INSERT INTO #Temp_Non_DISTINCT_QNLogs_To_Reject
	SELECT d.QN_Batch_ID, COUNT(*) as Log_Count FROM
	(SELECT DISTINCT [QN_Batch_ID],[QN_Batch_Status],[User_EMPID],[SUP_EMPID],[MGR_EMPID],[QN_Source] 
	FROM [EC].[Quality_Now_Coaching_Stage])d
	GROUP BY d.QN_Batch_ID
	HAVING COUNT(*) > 1;


 BEGIN TRANSACTION

-- Populate Role and Module
UPDATE EC.Quality_Now_Coaching_Stage
SET [Emp_Role]= 
    CASE WHEN EMP.[Emp_Job_Code]in ('WACS01', 'WACS02','WACS03', 'WACS04') THEN 'C'
    WHEN EMP.[Emp_Job_Code] = 'WACS40' THEN 'S'
	WHEN EMP.[Emp_Job_Code] IN ('WACQ02','WACQ03','WACQ12') THEN 'Q'
    WHEN EMP.[Emp_Job_Code] IN ('WIHD01','WIHD02','WIHD03','WIHD04') THEN 'L'
    WHEN EMP.[Emp_Job_Code] IN ('WTID13','WTTI02','WTTR12','WTTR13') THEN 'T'
    ELSE 'O' END
, [Module] = CASE WHEN [VerintFormName] like '%ATA%' THEN 3 ELSE 1 END
FROM [EC].[Quality_Now_Coaching_Stage] STAGE JOIN [EC].[Employee_Hierarchy]EMP
ON LTRIM(STAGE.User_EMPID) = LTRIM(EMP.Emp_ID);


	-- Updates QN_Strengths_Opportunities in staging table with latest value for batch
     UPDATE EC.Quality_Now_Coaching_Stage
     SET [QN_Strengths_Opportunities] = temp.QN_Strengths_Opportunities
	 FROM #Temp_Latest_QN_Strengths_Opportunities temp 
	 JOIN EC.Quality_Now_Coaching_Stage s ON temp.QN_Batch_ID = s.QN_Batch_ID;

-- Determine and populate Reject Reasons

-- Employee Site Inactive
UPDATE [EC].[Quality_Now_Coaching_Stage]
SET [Reject_Reason]= 'Employee Site Inactive.'
FROM [EC].[Quality_Now_Coaching_Stage] qs JOIN [EC].[Employee_Hierarchy] eh 
ON qs.User_EMPID = eh.Emp_ID JOIN [EC].[DIM_SITE] s
ON eh.Emp_Site = s.[City]
WHERE s.isActive = 0
AND [Reject_Reason] is NULL;

-- Reject Logs where Active Employee record does not exist
UPDATE [EC].[Quality_Now_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to Active Employee.'
WHERE (User_EMPID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Active = 'A'))
 OR User_EMPID = '999999'
AND [Reject_Reason]is NULL;
	
-- Reject Logs that are  for Quality Module and Employee does not have a Qualityjob code-(ATA)
UPDATE [EC].[Quality_Now_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN [Module] = 3
AND [Emp_Role] <> 'Q' THEN N'Employee does not have a Quality job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'Q' and [Reject_Reason]is NULL;

-- Reject Logs that are for CSR Module and Employee does not have a CSR job code.(Non ATA)
UPDATE [EC].[Quality_Now_Coaching_Stage]
SET [Reject_Reason]= CASE WHEN [Module] = 1
AND [Emp_Role] <> 'C' THEN N'Employee does not have a CSR job code.'
ELSE NULL END
WHERE [Emp_Role] <> 'C' AND [Reject_Reason]is NULL;
-- Reject logs with non distinct other parent attributres
UPDATE [EC].[Quality_Now_Coaching_Stage]
SET [Reject_Reason]= N'Log does not have distinct parent record values'
FROM [EC].[Quality_Now_Coaching_Stage] s JOIN #Temp_Non_DISTINCT_QNLogs_To_Reject t
ON s.[QN_Batch_ID]= t.[QN_Batch_ID]
WHERE [Reject_Reason]is NULL;


 -- Write rejected records to Rejected table.
 
INSERT INTO [EC].[Quality_Now_Coaching_Rejected]
			  ([QN_Batch_ID]
			  ,[QN_Batch_Status]
			  ,[Eval_ID]
			  ,[Eval_Date]
			  ,[Eval_Site_ID]
			  ,[User_EMPID]
			  ,[Journal_ID]
			  ,[Call_Date]
			  ,[Source]
			  ,[VerintFormName]
			  ,[isCoachingMonitor]
			  ,[Reject_reason]
			  ,[Date_Rejected])
            SELECT s.[QN_Batch_ID]
			,s.[QN_Batch_Status]
			,s.[Eval_ID]
		   ,s.[Eval_Date]
		   ,s.[Eval_Site_ID]
		   ,s.[User_EmpID]
		   ,s.[Journal_ID]
		   ,s.[Call_Date]
		   ,s.[QN_Source]
		   ,s.[VerintFormName]
		   ,s.[isCoachingMonitor]
		   ,s.[Reject_reason]
		   ,GETDATE()
           FROM [EC].[Quality_Now_Coaching_Stage] s
           WHERE s.[Reject_Reason] is not NULL
		   AND s.[Reject_Reason] <> '';
      


-- Delete rejected records

DELETE FROM [EC].[Quality_Now_Coaching_Stage]
WHERE [Reject_Reason]is not NULL
AND [Reject_Reason] <> '';

SELECT @Count = @@ROWCOUNT;


COMMIT TRANSACTION
END TRY

BEGIN CATCH
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	
  DECLARE @ErrorMessage nvarchar(4000), @ErrorSeverity int, @ErrorState int;
  SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
      
  IF ERROR_NUMBER() IS NULL RETURN 1
  ELSE IF ERROR_NUMBER() <> 0 RETURN ERROR_NUMBER() 
  ELSE RETURN 1
END CATCH 

END  -- [EC].[sp_InsertInto_Quality_Now_Rejected]


GO



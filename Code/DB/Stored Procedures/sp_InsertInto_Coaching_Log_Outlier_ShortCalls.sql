SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        07/05/2019
-- Loads short call records from [EC].[Outlier_Coaching_Stage]to [EC].[Coaching_Log]
-- Initial Revision - TFS 14108 - 07/05/2019
-- Changes to support Feed Load Dashboard - TFS 27523 - 01/02/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Outlier_ShortCalls]
(@Count INT OUTPUT, @ReportCode NVARCHAR(5) OUTPUT)

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @dtmDate DATETIME
              
            
              
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert] 

 
-- Fetches the Date of the Insert
SET @dtmDate  = GETDATE()   
 
      
-- Inserts short call records from the Outlier_Coaching_Stage table to the Coaching_Log Table

 INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpID]
           ,[SubmitterID]
           ,[EventDate]
           ,[isAvokeID]
		   ,[isNGDActivityID]
           ,[isUCID]
           ,[isVerintID]
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSRAcknowledged]
           ,[isCSE]
           ,[EmailSent]
           ,[numReportID]
           ,[strReportCode]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           )
select  Distinct LOWER(cs.CSR_EMPID)	[FormName],
        csr.Emp_Program [ProgramName],                  
        212  [SourceID],                        
        [EC].[fn_strStatusIDFromStatus](cs.Form_Status)[StatusID],
        [EC].[fn_intSiteIDFromEmpID](cs.CSR_EMPID)[SiteID],
        cs.CSR_EMPID                    [EmpID],
        [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)[SubmitterID],
		'' [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
	     EC.fn_nvcHtmlEncode(cs.TextDescription)		[Description],
		 cs.Submitted_Date			SubmittedDate,
		 '' 	[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 '' [numReportID],
		 cs.Report_Code				[strReportCode],
		 [EC].[fn_intModuleIDFromEmpID](cs.CSR_EMPID)  [ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Outlier_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.CSR_EMPID = cf.EmpID and cs.Report_Code = cf.strReportCode
where cs.Report_Code like 'ISQ%'
and cf.EmpID is Null and cf.strReportCode is null
OPTION (MAXDOP 1)

SELECT @Count =@@ROWCOUNT;
SET @ReportCode =  (SELECT DISTINCT  LEFT(Report_Code , LEN(Report_Code)-8)  FROM  [EC].[Outlier_Coaching_Stage]);

-- Updates the strFormID value

WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-M-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.


INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
    SELECT DISTINCT cf.[CoachingID],
            9,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           os.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Outlier_Coaching_Stage] os JOIN  [EC].[Coaching_Log] cf      
    ON os.[Report_Code] = cf.[strReportCode]
	AND os.CSR_EMPID = cf.EMPID
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
	WHERE os.Report_Code like 'ISQ%'
    AND cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)   

 WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 -- Inserts Verint call Ids into Short Call Evaluations table


INSERT INTO [EC].[ShortCalls_Evaluations]
           ([CoachingID]
           ,[VerintCallID]
		   ,[EventDate]
		   ,[StartDate]
           )
    SELECT DISTINCT cf.[CoachingID],
    os.Verint_ID,
	os.[Event_Date],
	os.[Start_Date]
    FROM [EC].[Outlier_Coaching_Stage] os JOIN  [EC].[Coaching_Log] cf      
    ON  os.[Report_Code] = cf.[strReportCode]
	AND os.CSR_EMPID = cf.EMPID
    LEFT OUTER JOIN  [EC].[ShortCalls_Evaluations] sce
    ON cf.[CoachingID] = sce.[CoachingID]  
    WHERE os.Report_Code like 'ISQ%'
	AND sce.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)  
 
 -- Truncate Staging Table
Truncate Table [EC].[Outlier_Coaching_Stage]


CLOSE SYMMETRIC KEY [CoachingKey]   
                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_InsertInto_Coaching_Log_Outlier




GO



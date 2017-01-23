/*
sp_InsertInto_Coaching_Log_Quality(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Quality' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--    ====================================================================
-- Author:           Susmitha Palacherla
-- Create Date:      02/23/2014
-- Description:     This procedure inserts the Quality scorecards into the Coaching_Log table. 
--                     The main attributes of the eCL are written to the Coaching_Log table.
--                     The Coaching Reasons are written to the Coaching_Reasons Table.
-- Modified per TFS 283 to force CRLF in Description value when viewed in UI - 08/31/2015
-- Updated per TFS 3757 to add isCoachingMonitor attribute - 10/28/2016
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality]
@Count INT OUTPUT
  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
      DECLARE @maxnumID INT,
      @strSourceType NVARCHAR(20)
       -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNUll(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])    
      SET @strSourceType = 'Indirect'
      
      -- Inserts records from the Quality_Coaching_Stage table to the Coaching_Log Table

         INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpLanID]
           ,[EmpID]
           ,[SubmitterID]
           ,[EventDate]
           ,[isAvokeID]
		   ,[isNGDActivityID]
           ,[isUCID]
           ,[isVerintID]
           ,[VerintID]
           ,[VerintEvalID]
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSE]
           ,[isCSRAcknowledged]
           ,[VerintFormName]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           ,[isCoachingMonitor])

            SELECT DISTINCT
            lower(csr.Emp_LanID)	[FormName],
            CASE qs.Program  
            WHEN NULL THEN csr.Emp_Program
            WHEN '' THEN csr.Emp_Program
            ELSE qs.Program  END       [ProgramName],
            [EC].[fn_intSourceIDFromSource](@strSourceType, qs.Source)[SourceID],
            [EC].[fn_strStatusIDFromIQSEvalID](qs.CSE, qs.Oppor_Rein )[StatusID],
            [EC].[fn_intSiteIDFromEmpID](LTRIM(qs.User_EMPID))[SiteID],
            lower(csr.Emp_LanID)	[EmpLanID],
            qs.User_EMPID [EmpID],
            qs.Evaluator_ID	 [SubmitterID],       
            qs.Call_Date [EventDate],
            0			[isAvokeID],
		    0			[isNGDActivityID],
            0			[isUCID],
            1 [isVerintID],
            qs.Journal_ID	[VerintID],
            qs.Eval_ID [VerintEvalID],
            --EC.fn_nvcHtmlEncode(qs.Summary_CallerIssues)[Description],	
            REPLACE(EC.fn_nvcHtmlEncode(qs.[Summary_CallerIssues]), CHAR(13) + CHAR(10) ,'<br />')[Description],
            GetDate()  [SubmittedDate], 
		    qs.Eval_Date	[StartDate],
		    CASE WHEN qs.CSE = '' THEN 0
	            	ELSE 1 END	[isCSE],			
		    0 [isCSRAcknowledged],
		    qs.VerintFormname [verintFormName],
		    1 [ModuleID],
		    ISNULL(csr.[Sup_ID],'999999') [SupID],
		    ISNULL(csr.[Mgr_ID],'999999')[MgrID],
		    qs.isCoachingMonitor [isCoachingMonitor]
		    
FROM [EC].[Quality_Coaching_Stage] qs 
join EC.Employee_Hierarchy csr on qs.User_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on qs.Eval_ID = cf.VerintEvalID
where cf.VerintEvalID is null
OPTION (MAXDOP 1)

SELECT @Count =@@ROWCOUNT

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.

INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
    SELECT cf.[CoachingID],
           10,
           42,
           qs.[Oppor_Rein]
    FROM [EC].[Quality_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
    ON qs.[Eval_ID] = cf.[VerintEvalID] 
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)   
 
                  
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
END -- sp_InsertInto_Coaching_Log_Quality



GO


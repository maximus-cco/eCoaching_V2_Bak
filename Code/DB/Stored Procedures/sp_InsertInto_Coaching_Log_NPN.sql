/*
sp_InsertInto_Coaching_Log_NPN(03).sql
Last Modified Date: 10/23/2017
Last Modified By: Susmitha Palacherla

Version 03: Modified to support Encryption of sensitive data. Removed LanID - TFS 7856 - 10/23/2017

Version 02: Additional update from V&V feedback - TFS 5653 - 03/02/2017

Version 01: Document Initial Revision - TFS 5653 - 2/28/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_NPN' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_NPN]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
-- Author:		      Susmitha Palacherla
-- Create date:       02/28/2017
-- Description:	
-- Creates NPN ecls for eligible IQS logs that have been identified and staged.
-- Last update by:   Susmitha Palacherla
-- Initial Revision - Created as part of  TFS 5653 - 02/28/2017
-- Modified to support Encryption of sensitive data. Removed LanID. TFS 7856 - 10/23/2017
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_NPN]

  
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
      DECLARE @maxnumID INT
    
       -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNUll(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])    

  
      -- Inserts records from the Quality_Coaching_Stage table to the Coaching_Log Table

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
           ,[VerintID]
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSE]
           ,[isCSRAcknowledged]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           ,[strReportCode])

            SELECT DISTINCT
            lower(qs.User_EMPID)	[FormName],
            CASE qs.Program  
            WHEN NULL THEN csr.Emp_Program
            WHEN '' THEN csr.Emp_Program
            ELSE qs.Program  END       [ProgramName],
            218   [SourceID],
            6     [StatusID],
            [EC].[fn_intSiteIDFromEmpID](LTRIM(qs.User_EMPID))[SiteID],
            qs.User_EMPID [EmpID],
            '999999'	 [SubmitterID],       
            qs.Call_Date [EventDate],
            0			[isAvokeID],
		    0			[isNGDActivityID],
            0			[isUCID],
            1 [isVerintID],
            qs.Journal_ID	[VerintID],
            
            --EC.fn_nvcHtmlEncode(qs.Summary_CallerIssues)[Description],	
            REPLACE(EC.fn_nvcHtmlEncode([EC].[fn_strNPNDescriptionFromCode](qs.[Summary_CallerIssues])), CHAR(13) + CHAR(10) ,'<br />')+ qs.Journal_ID [Description],
            GetDate()  [SubmittedDate], 
		    qs.Call_Date	[StartDate],
		    0	[isCSE],			
		    0 [isCSRAcknowledged],
		    1 [ModuleID],
		    ISNULL(csr.[Sup_ID],'999999') [SupID],
		    ISNULL(csr.[Mgr_ID],'999999')[MgrID],
	        'NPN' + CONVERT(varchar(8),[EC].[fn_intDatetime_to_YYYYMMDD](GETDATE())) [strReportCode]
		    
FROM [EC].[Quality_Coaching_Stage] qs 
join EC.Employee_Hierarchy csr on qs.User_EMPID = csr.Emp_ID
left outer join (Select * from EC.Coaching_Log with (nolock) where SourceID = 218)cf
on qs.Journal_ID = cf.VerintID 
and qs.User_EMPID = cf.EmpID 
and qs.Call_Date = cf.EventDate
where (cf.VerintID is null and cf.EmpID is null and cf.EventDate is null)
OPTION (MAXDOP 1)



WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.

--INSERT INTO [EC].[Coaching_Log_Reason]
--           ([CoachingID]
--           ,[CoachingReasonID]
--           ,[SubCoachingReasonID]
--           ,[Value])
--    SELECT cf.[CoachingID],
--           5,
--           42,
--           'Opportunity'
--    FROM [EC].[Quality_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
--    ON qs.[Journal_ID] = cf.[VerintID] 
--    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
--    ON cf.[CoachingID] = cr.[CoachingID]  
--    WHERE cr.[CoachingID] IS NULL 
-- OPTION (MAXDOP 1) 
  
 INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
        SELECT cf.[CoachingID],
           5,
           42,
           'Opportunity'
  FROM (SELECT * FROM EC.Coaching_Log with (nolock)
  WHERE SourceID = 218 AND strReportCode LIKE 'NPN%')cf     
  LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
  ON cf.[CoachingID] = cr.[CoachingID]  
  WHERE cr.[CoachingID] IS NULL  
 OPTION (MAXDOP 1)  

 WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

-- Truncate Staging Table
Truncate Table [EC].[Quality_Coaching_Stage]
                  
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



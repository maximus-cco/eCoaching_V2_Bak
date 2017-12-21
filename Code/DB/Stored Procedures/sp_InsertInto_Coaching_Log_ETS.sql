/*
sp_InsertInto_Coaching_Log_ETS(02).sql
Last Modified Date: 10/23/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data. Removed LanID - TFS 7856 - 10/23/2017


Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_ETS' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_ETS]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      11/07/2014
--    Description:     This procedure inserts the ETS records into the Coaching_Log table. 
--                     The main attributes of the eCL are written to the Coaching_Log table.
--                     The Coaching Reasons are written to the Coaching_Reasons Table.
-- Revision History: 
-- Changes for incorporating Compliance Reports per SCR 14031- 01/06/2015
-- Modified to support Encryption of sensitive data. Removed LanID. TFS 7856 - 10/23/2017

--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_ETS]
@Count INT OUTPUT
  
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
           ,[Description]
	       ,[SubmittedDate]
           ,[StartDate]
           ,[isCSE]
           ,[isCSRAcknowledged]
           ,[numReportID]
           ,[strReportCode]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           )

            SELECT DISTINCT
            lower(es.Emp_ID)	[FormName],
            es.Emp_Program   [ProgramName],
            221             [SourceID],
            CASE es.emp_role when 'C' THEN 6 
            WHEN 'S' THEN 5 ELSE -1 END[StatusID],
            [EC].[fn_intSiteIDFromEmpID](LTRIM(es.EMP_ID))[SiteID],
            es.EMP_ID [EmpID],
            '999999'	 [SubmitterID],       
            es.Event_Date [EventDate],
            0			[isAvokeID],
		    0			[isNGDActivityID],
            0			[isUCID],
            0          [isVerintID],
            REPLACE(EC.fn_nvcHtmlEncode(es.TextDescription), CHAR(13) + CHAR(10) ,'<br />')[Description],	
            es.Submitted_Date  [SubmittedDate], 
		    es.Event_Date	[StartDate],
		    0 [isCSE],			
		    0 [isCSRAcknowledged],
		    es.Report_ID [numReportID],
		    es.Report_Code [strReportCode],
		    CASE es.emp_role when 'C' THEN 1
            WHEN 'S' THEN 2 ELSE -1 END [ModuleID],
          	ISNULL(es.[Emp_SupID],'999999')  [SupID],
		    ISNULL(es.[Emp_MgrID],'999999')  [MgrID]
            
FROM [EC].[ETS_Coaching_Stage] es 
left outer join EC.Coaching_Log cf on es.Report_Code = cf.strReportCode
and es.Event_Date = cf.EventDate and  es.Report_ID = cf.numReportID
where cf.strReportCode is null and cf.EventDate is NULL and cf.numReportID is NULL
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
           22,
           [EC].[fn_intSubCoachReasonIDFromETSRptCode](LEFT(cf.strReportCode,LEN(cf.strReportCode)-8)),
           CASE WHEN LEFT(cf.strReportCode,LEN(cf.strReportCode)-8) IN ('OAE','OAS')
           THEN 'Research Required' ELSE 'Opportunity' END
     FROM [EC].[ETS_Coaching_Stage] es  INNER JOIN  [EC].[Coaching_Log] cf      
    ON (es.[Report_Code] = cf.[strReportCode]
   and es.Event_Date = cf.EventDate and es.Emp_ID = cf.EmpID and es.Report_ID = cf.numReportID)
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)  


-- Truncate Staging Table
Truncate Table [EC].[ETS_Coaching_Stage]
                  
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
END -- sp_InsertInto_Coaching_Log_ETS





GO

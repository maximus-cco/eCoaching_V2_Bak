/*
sp_InsertInto_Coaching_Log_Quality_Other(06).sql
Last Modified Date: 05/29/2019
Last Modified By: Susmitha Palacherla

Version 06: Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019

Version 05: Modified to support Quality OTA feed - TFS 12591 - 11/26/2018

Version 04: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 03: Add table [EC].[NPN_Description] to Get NPN Description from table. TFS 5649 - 02/20/2017

Version 02: New quality NPN feed - TFS 5309 - 2/3/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 

    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Quality_Other' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Other]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		        Susmitha Palacherla
-- Last Modified Date: 09/16/2015
-- Last Updated By: Susmitha Palacherla
-- Initial Revision: Setup of CTC Load - TFS 2268 -  6/15/2016
-- Update: HFC and KUD Loads - TFS 3179 and 3186 - 07/15/2016
-- Update: HFC and KUD Load. Start date fix. TFS 3179 - 08/3/2016
-- Update: NPN Load. TFS 5309 - 02/01/2017
-- Update: Get NPN Description from table. TFS 5649 - 02/17/2017
-- Modified to support Encryption of sensitive data. Removed LanID. TFS 7856 - 10/23/2017
-- Modified to support OTA Report. TFS 12591 - 11/26/2018
-- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Other]
@Count INT OUTPUT

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

       DECLARE @dtmDate DATETIME
                        
      -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE()     

-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];  

      
-- Update the value for Pending Acknowledgement

  UPDATE [EC].[Quality_Other_Coaching_Stage]
  SET [Form_Status]= 'Pending Acknowledgement'
  WHERE [Form_Status]= 'Pending Acknowledgment'
  
  WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms
      
-- Inserts records from the Quality_Other_Coaching_Stage table to the Coaching_Log Table

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
select  Distinct LOWER(cs.EMP_ID)	[FormName],
        CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  END       [ProgramName],
        [EC].[fn_intSourceIDFromSource](cs.[Form_Type],cs.[Source])[SourceID],
        [EC].[fn_strStatusIDFromStatus](cs.Form_Status)[StatusID],
        [EC].[fn_intSiteIDFromEmpID](cs.EMP_ID)[SiteID],
        cs.[EMP_ID]                   [EmpID],
        cs.[Submitter_ID]              [Submitter_ID],
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
		-- EC.fn_nvcHtmlEncode(cs.TextDescription)		[Description],
		 CASE WHEN cs.Report_Code LIKE 'CTC%' 
		 THEN  REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br />')
		 WHEN cs.Report_Code LIKE 'NPN%' 
		 THEN  REPLACE(EC.fn_nvcHtmlEncode([EC].[fn_strNPNDescriptionFromCode](cs.TextDescription)), CHAR(13) + CHAR(10) ,'<br />')
		 ELSE  EC.fn_nvcHtmlEncode(cs.TextDescription)END		[Description],
		 cs.Submitted_Date			SubmittedDate,
		 ISNULL(cs.start_Date,cs.Event_Date)				[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 CASE WHEN cs.Report_Code LIKE 'CTC%' THEN 2	
		 WHEN cs.Report_Code LIKE 'OTA%' THEN 3
		 ELSE 1 END						[ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Quality_Other_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.[EMP_ID] = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.Report_ID = cf.numReportID and cs.Report_Code = cf.strReportCode
where cf.numReportID is Null and cf.strReportCode is null

SELECT @Count = @@ROWCOUNT

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

-- Updates the strFormID value


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
    SELECT cf.[CoachingID],
           CASE WHEN cf.strReportCode like 'CTC%' THEN 21 
           WHEN (cf.strReportCode like 'HFC%' OR cf.strReportCode like 'OTA%') THEN 10 
           WHEN cf.strReportCode like 'KUD%' THEN 11
           WHEN cf.strReportCode like 'NPN%' THEN 5
           ELSE 14 END,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           qs.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Quality_Other_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
    ON qs.[Report_ID] = cf.[numReportID] AND  qs.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)   
 
-- Close the symmetric key with which to encrypt the data.  
CLOSE SYMMETRIC KEY [CoachingKey]  


 WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

-- Truncate Staging Table
Truncate Table [EC].[Quality_Other_Coaching_Stage]

                  
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
END -- sp_InsertInto_Coaching_Log_Quality_Other



GO



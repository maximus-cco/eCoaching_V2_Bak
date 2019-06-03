/*
sp_InsertInto_Coaching_Log_Outlier(08).sql
Last Modified Date: 05/29/2019
Last Modified By: Susmitha Palacherla

Version 08: Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019

Version 07: Modified to support separate MSR feed source. TFS 14401 - 05/14/2019

Version 06: Modified to support Encryption of sensitive data. Opened Key and Removed LanID - TFS 7856 - 11/23/2017

Version 05: Updated to support additional Modules - TFS 8793 - 11/16/2017

Version 04: Updated to support MSR and MSRS Feeds. TFS 6147 - 06/02/2017

Version 03: Support for Sup and quality Modules in 
Breaks feeds and also added Output param to capture count of Loaded records - TFS 6377 - 04/24/2017

Version 02: New Breaks BRN and BRL feeds - TFS 6145 - 4/13/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Outlier' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Outlier]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        03/10/2014
-- Loads records from [EC].[Outlier_Coaching_Stage]to [EC].[Coaching_Log]
-- Last Modified Date: 09/16/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per TFS 644 to add IAE, IAT Feeds
-- Modified per TFS 6145 to add BRN and BRL Feeds - 4/12/2017
-- Modified per TFS 6377 to add support for Sup and quality Modules in 
-- Breaks feeds and also added Output param to capture count of Loaded records - 4/24/2017
-- Updated to support MSR and MSRS Feeds. TFS 6147 - 06/02/2017
-- Updated to support additional Modules - TFS 8793 - 11/16/2017
-- Modified to support Encryption of sensitive data. Opened Key and Removed LanID. TFS 7856 - 11/23/2017
-- Modified to support separate MSR feed source. TFS 14401 - 05/14/2019
-- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Outlier]
@Count INT OUTPUT

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE 
              @dtmDate DATETIME,
              @strLCSPretext nvarchar(200),
              @strIAEPretext nvarchar(200),
              @strIATPretext nvarchar(200),
              @strBRText nvarchar(200)
              
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert] 

 
      -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE()   
      SET @strLCSPretext = 'The call associated with this Low CSAT is Verint ID: '
      SET @strIAEPretext = 'You are receiving this eCL because the ARC received an Inappropriate Escalation for this CSR.  Please review the Verint Call, NGD call record and coach as appropriate. '
      SET @strIATPretext = 'You are receiving this eCL because the ARC received an Inappropriate Transfer for this CSR.  Please review the Verint Call, NGD call record and coach as appropriate. '

      
-- Inserts records from the Outlier_Coaching_Stage table to the Coaching_Log Table

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
        CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  END       [ProgramName],
        CASE WHEN cs.Report_Code LIKE 'MSR%'
        THEN  [EC].[fn_intSourceIDFromSource](cs.[Form_Type],cs.[Source])ELSE 212 END [SourceID],                        
        [EC].[fn_strStatusIDFromStatus](cs.Form_Status)[StatusID],
        [EC].[fn_intSiteIDFromEmpID](cs.CSR_EMPID)[SiteID],
        cs.CSR_EMPID                    [EmpID],
        [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)[SubmitterID],
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
	     CASE WHEN cs.Report_Code LIKE 'LCS%' 
		 THEN @strLCSPretext + EC.fn_nvcHtmlEncode(cs.TextDescription)
		 WHEN cs.Report_Code LIKE 'IAE%' 
		 THEN @strIAEPretext + '<br />' + EC.fn_nvcHtmlEncode(cs.TextDescription) + '<br />' + cs.CD1 + '<br />' + cs.CD2
		 WHEN cs.Report_Code LIKE 'IAT%' 
		 THEN @strIATPretext + '<br />' + EC.fn_nvcHtmlEncode(cs.TextDescription) + '<br />' + cs.CD1 + '<br />' + cs.CD2
		 ELSE  EC.fn_nvcHtmlEncode(cs.TextDescription)END		[Description],
		  cs.Submitted_Date			SubmittedDate,
		  		 cs.Start_Date				[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 [EC].[fn_intModuleIDFromEmpID](cs.CSR_EMPID)  [ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 CASE WHEN cs.Report_Code LIKE 'LCS%' THEN ISNULL(cs.[RMgr_ID],'999999')
		 ELSE ISNULL(csr.[Mgr_ID],'999999')END  [MgrID]
	                   
from [EC].[Outlier_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.Report_ID = cf.numReportID and cs.Report_Code = cf.strReportCode
where cf.numReportID is Null and cf.strReportCode is null
OPTION (MAXDOP 1)

SELECT @Count =@@ROWCOUNT

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
    SELECT cf.[CoachingID],
    CASE 
		WHEN (cf.strReportCode like 'BRN%' OR cf.strReportCode like 'BRL%') 
		THEN 56 
		WHEN cf.strReportCode like 'MSR%' THEN 5
		ELSE 9
     END,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           os.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Outlier_Coaching_Stage] os JOIN  [EC].[Coaching_Log] cf      
    ON os.[Report_ID] = cf.[numReportID] AND  os.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
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



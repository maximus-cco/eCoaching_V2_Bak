/*
sp_InsertInto_Coaching_Log_Training(03).sql
Last Modified Date: 05/29/2019
Last Modified By: Susmitha Palacherla

Version 03: Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Training' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Training]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        3/22/2016
--  Created per TFS 2283 to load the Training feed(s) SDR and ODT
-- Modified to support Encryption of sensitive data. Opened Key and Removed LanID. TFS 7856 - 10/23/2017
-- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Training]
@Count INT OUTPUT

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];  

      DECLARE @dtmDate DATETIME
      -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE()  
      
-- Inserts records from the Training_Coaching_Stage table to the Coaching_Log Table

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
select  Distinct cs.CSR_EMPID	[FormName],
        CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  END       [ProgramName],
        210                             [SourceID],
        [EC].[fn_strStatusIDFromStatus](cs.Form_Status)[StatusID],
        [EC].[fn_intSiteIDFromEmpID](cs.CSR_EMPID)[SiteID],
        cs.CSR_EMPID                    [EmpID],
        [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)[SubmitterID],
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
		-- EC.fn_nvcHtmlEncode(cs.TextDescription)		[Description],
		 REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '      '  ,'<br />')[Description],	-- CHAR(13) + CHAR(10)
		 cs.Submitted_Date			SubmittedDate,
		 cs.Start_Date				[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 1							[ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Training_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.Report_ID = cf.numReportID and cs.Report_Code = cf.strReportCode
where cf.numReportID is Null and cf.strReportCode is null

SELECT @Count =@@ROWCOUNT

-- Updates the strFormID value

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

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
           5,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           os.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Training_Coaching_Stage] os JOIN  [EC].[Coaching_Log] cf      
    ON os.[Report_ID] = cf.[numReportID] AND  os.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)   
 
-- Close the symmetric key with which to encrypt the data.  
CLOSE SYMMETRIC KEY [CoachingKey]  


 WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

-- Truncate Staging Table
Truncate Table [EC].[Training_Coaching_Stage]
                  
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


END -- sp_InsertInto_Coaching_Log_Training

GO



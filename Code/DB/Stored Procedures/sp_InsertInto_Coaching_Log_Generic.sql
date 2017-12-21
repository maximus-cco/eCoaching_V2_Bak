/*
sp_InsertInto_Coaching_Log_Generic(03).sql
Last Modified Date: 10/23/2017
Last Modified By: Susmitha Palacherla

Version 03: Modified to support Encryption of sensitive data. Open Key and Removed LanID- TFS 7856 - 10/23/2017

Version 02: Updated to support DTT feed - TFS 7646 -  9/1/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log_Generic' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Generic]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        4/11/2016
--  Created per TFS 2470 to load the Generic feed(s)- 4/11/2016
-- Modified to accomodate Attendance feed for seasonal employees per TFS 3972 - 09/15/2016
-- Modified to support ad-hoc loads by adding more values to the file. TFS 4916 - 12/9/2016
-- Modified to support DTT feed. TFS 7646 - 8/31/2017
-- Modified to support Encryption of sensitive data. Open Key and Removed LanID. TFS 7856 - 10/23/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Generic] 
@Count INT OUTPUT

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @maxnumID INT,
              @dtmDate DATETIME
                        
      -- Fetches the maximum CoachingID before the insert.
      SET @maxnumID = (SELECT IsNULL(MAX([CoachingID]), 0) FROM [EC].[Coaching_Log])  
      -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE()   
  
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert] 

     
-- Inserts records from the Generic_Coaching_Stage table to the Coaching_Log Table

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
           ,[isVerified]
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
SELECT DISTINCT LOWER(cs.CSR_EMPID)	[FormName],

CASE cs.Program  
        WHEN NULL THEN csr.Emp_Program
        WHEN '' THEN csr.Emp_Program
        ELSE cs.Program  
 END [ProgramName],
 
 CASE 
		WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')
        THEN [EC].[fn_intSourceIDFromSource](cs.[Form_Type],cs.[Source])
        ELSE cs.Source_ID 
  END  [SourceID],
  
  CASE
        WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')
        THEN [EC].[fn_strStatusIDFromStatus](cs.Form_Status)
        ELSE cs.Status_ID 
  END   [StatusID],
  
               [EC].[fn_intSiteIDFromEmpID](cs.CSR_EMPID)[SiteID],
        cs.CSR_EMPID                    [EmpID],
        
  CASE
        WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')
        THEN [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)
        ELSE cs.Submitter_ID
  END   [SubmitterID],
  
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
		-- EC.fn_nvcHtmlEncode(cs.TextDescription)		[Description],
  CASE 
		 WHEN cs.[Report_Code] like 'SEA%' 
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br /> <br />')
		 WHEN  cs.[Report_Code] like 'OTH%'
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br />')
		 ELSE REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '      '  ,'<br />') 
  END [Description],	-- CHAR(13) + CHAR(10)
  
         1                          [isVerified],
		 cs.Submitted_Date			[SubmittedDate],
		 cs.Start_Date				[StartDate],
		 0        				    [isCSRAcknowledged],
CASE 
		 WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')
		 THEN 0
		 ELSE cs.isCSE
  END                          [isCSE],
		 
  CASE 
		 WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')
		 THEN 0
		 ELSE cs.EmailSent
  END	[EmailSent],
  
		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],
		 
CASE 
		 WHEN cs.[Report_Code] like 'SEA%'
		 THEN 1
		  WHEN cs.[Report_Code] like 'DTT%'
		 THEN 2
		 ELSE  cs.Module_ID
 END		                      [ModuleID],
  
  
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Generic_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.Report_ID = cf.numReportID and cs.Report_Code = cf.strReportCode
where cf.numReportID is Null and cf.strReportCode is null

OPTION (MAXDOP 1)

SELECT @Count =@@ROWCOUNT
-- Updates the strFormID value

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
    
 CASE 
		 WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')
		 THEN 3
		 ELSE cs.CoachingReason_ID	
 END [CoachingReasonID],
 
 CASE 
		 WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')			
         THEN [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3))
         ELSE cs.SubCoachingReason_ID	
 END [SubCoachingReasonID],
 
  CASE 
		 WHEN (cs.[Report_Code] like 'SEA%' OR cs.[Report_Code] like 'DTT%')		
         THEN  cs.[CoachReason_Current_Coaching_Initiatives]
         ELSE cs.Value 
 END [Value]
 
    FROM [EC].[Generic_Coaching_Stage] cs JOIN  [EC].[Coaching_Log] cf      
    ON cs.[Report_ID] = cf.[numReportID] AND  cs.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL 
 OPTION (MAXDOP 1)   
 
  -- Truncate Staging Table
Truncate Table [EC].[Generic_Coaching_Stage]


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
END -- sp_InsertInto_Coaching_Log_Generic


GO



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
-- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019
-- Modified to support ATT AP% feeds. TFS 15095  - 8/27/2019
-- Modified to support AED feed. TFS 19502  - 11/30/2020
-- Modified to support SUR feed. TFS 23347  - 03/25/2022
-- Changes to support Feed Load Dashboard - TFS 27523 - 01/02/2024
-- Changes to support Promotions Feed - TFS 27634 - 01/19/2024
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
-- Modified to suppport Motivate and Increase CSR Level Promotions Feed. TFS 28262 - 06/12/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Generic] 
(@Count INT OUTPUT, @ReportCode NVARCHAR(5) OUTPUT)

AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @dtmDate DATETIME;
	  -- Fetches the Date of the Insert
      SET @dtmDate  = GETDATE();   
  
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

     
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
		WHEN cs.[Report_Code] like 'OTH%' 
        THEN cs.Source_ID 
        ELSE [EC].[fn_intSourceIDFromSource](cs.[Form_Type],cs.[Source])
  END  [SourceID],
  
   CASE 
		WHEN cs.[Report_Code] like 'OTH%' 
        THEN cs.Status_ID
        ELSE [EC].[fn_strStatusIDFromStatus](cs.Form_Status)
    END  [StatusID],
  
        [EC].[fn_intSiteIDFromEmpID](cs.CSR_EMPID)[SiteID],
        cs.CSR_EMPID                    [EmpID],
    
    CASE 
		WHEN cs.[Report_Code] like 'OTH%' 
        THEN cs.Submitter_ID
        ELSE [EC].[fn_nvcGetEmpIdFromLanId](LOWER(cs.Submitter_LANID),@dtmDate)
    END   [SubmitterID],
  
		cs.Event_Date			            [EventDate],
		 0			[isAvokeID],
		 0			[isNGDActivityID],
         0			[isUCID],
         0          [isVerintID],
  CASE 
		 WHEN cs.[Report_Code] like 'SEA%' 
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br /> <br />')
		 WHEN  (cs.[Report_Code] like 'OTH%' OR cs.[Report_Code] like 'A%')
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '|'  ,'<br />')
		 WHEN  cs.[Report_Code] like 'DTT%'
		 THEN REPLACE(EC.fn_nvcHtmlEncode(cs.TextDescription), '      '  ,'<br />') 
		 ELSE cs.TextDescription   
  END								[Description],	
         1                          [isVerified],
		 cs.Submitted_Date			[SubmittedDate],
		 cs.Start_Date				[StartDate],
		 0        				    [isCSRAcknowledged],


     CASE 
		WHEN cs.[Report_Code] like 'OTH%' 
        THEN cs.isCSE
        ELSE 0
    END   [isCSE],
		 
   CASE 
		WHEN cs.[Report_Code] like 'OTH%' 
        THEN cs.EmailSent
        ELSE 0
    END   [EmailSent],

		 cs.Report_ID				[numReportID],
		 cs.Report_Code				[strReportCode],	
       [EC].[fn_intModuleIDFromEmpID](cs.CSR_EMPID)  [ModuleID],
  		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Generic_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.CSR_EMPID = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.Report_ID = cf.numReportID and cs.Report_Code = cf.strReportCode
where cf.numReportID is Null and cf.strReportCode is null;

SELECT @Count =@@ROWCOUNT
SET @ReportCode =  (SELECT DISTINCT  LEFT(Report_Code , LEN(Report_Code)-8)  FROM  [EC].[Generic_Coaching_Stage]);

-- Updates the strFormID value

WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-M-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%' ;   


WAITFOR DELAY '00:00:00:05'  -- Wait for 5 ms

 -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.


INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
    SELECT cf.[CoachingID],
    
  CASE 
		 WHEN cs.[Report_Code] like 'OTH%' THEN cs.CoachingReason_ID	
		 WHEN cs.[Report_Code] like 'SUR%' THEN 5	
		 WHEN cs.[Report_Code] like 'RES%' THEN 7	
		 WHEN cs.[Report_Code] like 'CPATH%' THEN 25	
		 ELSE 3	
 END [CoachingReasonID],
 
  CASE 
		 WHEN cs.[Report_Code] like 'OTH%' 		
         THEN cs.SubCoachingReason_ID	
		 ELSE [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3))
 END [SubCoachingReasonID],
 
   CASE 
		 WHEN cs.[Report_Code] like 'OTH%' 		
         THEN cs.Value 
		ELSE cs.[CoachReason_Current_Coaching_Initiatives]
 END [Value]
 
    FROM [EC].[Generic_Coaching_Stage] cs JOIN  [EC].[Coaching_Log] cf      
    ON cs.[Report_ID] = cf.[numReportID] AND  cs.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL; 

 
  -- Truncate Staging Table
--Truncate Table [EC].[Generic_Coaching_Stage]

CLOSE SYMMETRIC KEY [CoachingKey];   
                  
				                   
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



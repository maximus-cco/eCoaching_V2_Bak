/*
sp_InsertInto_Coaching_Log_Quality_Other(11).sql
Last Modified Date: 06/08/2021
Last Modified By: Susmitha Palacherla

Version 11: Updated to support WC Bingo records in Bingo feeds. TFS 21493 - 6/8/2021
Version 10: Updated to handle Bingo logs for diffrent Programs for employee in same month. TFS 19526 - 12/21/2020
Version 09: Updated to support wild card bingo images. TFS 15465 - 09/30/2019
Version 08: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 07: Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019
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
-- Updated to support QN Bingo eCoaching logs. TFS 15063 - 08/12/2019
-- Updated to support QM Bingo eCoaching logs. TFS 154653 - 09/23/2019
-- Updated to handle Bingo logs for diffrent Programs for employee in same month. TFS 19526 - 12/21/2020
-- Updated to support WC Bingo records in Bingo feeds. TFS 21493 - 6/8/2021
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Other]
@Count INT OUTPUT

AS
BEGIN


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
  WHERE [Form_Status]= 'Pending Acknowledgment';
  
  WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms
      
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
		--csr.Emp_Program [ProgramName],
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
		 WHEN cs.Report_Code LIKE 'BQ%' 
		 --THEN  REPLACE(EC.fn_nvcHtmlEncode([EC].[fn_strBingoDescriptionFromCompDesc](cs.EMP_ID)), CHAR(13) + CHAR(10) ,'<br />' + '<br />')
		 THEN 'NA'
		 ELSE  EC.fn_nvcHtmlEncode(cs.TextDescription)END		[Description],
		 cs.Submitted_Date			SubmittedDate,
		 ISNULL(cs.start_Date,cs.Event_Date)				[StartDate],
		 0        				    [isCSRAcknowledged],
		 0                          [isCSE],
		 0                          [EmailSent],
		 CASE WHEN (cs.Report_Code LIKE 'BQ%') THEN 1
		 ELSE cs.Report_ID	 END		[numReportID],
		 cs.Report_Code				[strReportCode],
		 CASE WHEN (cs.Report_Code LIKE 'CTC%' OR cs.Report_Code LIKE 'BQ%S%') THEN 2	
		 WHEN cs.Report_Code LIKE 'OTA%' THEN 3
		 ELSE 1 END						[ModuleID],
		 ISNULL(csr.[Sup_ID],'999999')  [SupID],
		 ISNULL(csr.[Mgr_ID],'999999') [MgrID]
	                   
from [EC].[Quality_Other_Coaching_Stage] cs  join EC.Employee_Hierarchy csr on cs.[EMP_ID] = csr.Emp_ID
left outer join EC.Coaching_Log cf on cs.EMP_ID = cf.EmpID and cs.Report_Code = cf.strReportCode
where cf.EmpID is Null and cf.strReportCode is null;

  SELECT @Count = @@ROWCOUNT;

  WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms

-- Updates the strFormID value

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-M-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [FormName] not like 'eCL%';  


  WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms

 -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.


INSERT INTO [EC].[Coaching_Log_Reason]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value])
    SELECT DISTINCT cf.[CoachingID],
           CASE WHEN cf.strReportCode like 'CTC%' THEN 21 
           WHEN (cf.strReportCode like 'HFC%' OR cf.strReportCode like 'OTA%' OR cf.strReportCode like 'BQ%') THEN 10 
           WHEN cf.strReportCode like 'KUD%' THEN 11
           WHEN cf.strReportCode like 'NPN%' THEN 5
		   ELSE 14 END,
           [EC].[fn_intSubCoachReasonIDFromRptCode](SUBSTRING(cf.strReportCode,1,3)),
           qs.[CoachReason_Current_Coaching_Initiatives]
    FROM [EC].[Quality_Other_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
    ON qs.[EMP_ID] = cf.[EmpID] AND  qs.[Report_Code] = cf.[strReportCode]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Reason] cr
    ON cf.[CoachingID] = cr.[CoachingID]  
    WHERE cr.[CoachingID] IS NULL;


  WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms


  -- Insert  detail records into [EC].[Coaching_Log_Quality_Now_Bingo] Table

DECLARE @inserted table ([ID] bigint, [Competency] nvarchar(30));

INSERT INTO [EC].[Coaching_Log_Bingo]
           ([CoachingID]
           ,[Competency]
           ,[Note]
           ,[Description]
		   ,[BingoType])
	OUTPUT INSERTED.CoachingID, INSERTED.Competency INTO @inserted
    SELECT DISTINCT cf.[CoachingID],
           qs.[Competency],
		   qs.[Note],
           qs.[TextDescription],
		   qs.[BingoType]
    FROM [EC].[Quality_Other_Coaching_Stage] qs JOIN  [EC].[Coaching_Log] cf      
    ON qs.[EMP_ID] = cf.[EmpID] AND  qs.[Report_Code] = cf.[strReportCode]
	AND qs.[Program] = cf.[ProgramName]
    LEFT OUTER JOIN  [EC].[Coaching_Log_Bingo]cb
    ON cf.[CoachingID] = cb.[CoachingID]  
    WHERE qs.Report_Code LIKE 'BQ%'
	AND cb.[CoachingID] IS NULL 
	ORDER BY [CoachingID],[Competency];


  WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms
  --select * from @inserted;
/*
Set the [Include] flag
This is to support the functionality for Written Corr channel Quality Correspondence competency.
Up to 4 QC records can arrive for an employee in the feed but only combinations of QC1 and QC2 or QC1 + QC2 + QC3 + QC4 are valid.
QC1 and QC1 + QC2 + QC3 combinations are rejected.
Of the valid accepted combinations only the Description for Q2 or Q4 is expected to be displayed.
The [Include] flag will help in the determination of the images to be included and the derivation of the Description text.
*/

WITH qc As
(SELECT b.[CoachingID],b.[Competency],ROW_NUMBER() over (partition by b.[CoachingID]
                          order by b.[Competency] desc) RowNumber 
 FROM [EC].[Coaching_Log_Bingo]b JOIN @inserted i ON ( b.CoachingID = i.ID  and b.Competency = i.Competency)
WHERE b.[Competency] like 'Quality Correspondent%')

,flagqc AS
 (SELECT * FROM qc  WHERE RowNumber > 1)
   --SELECT * FROM flagqc;

 UPDATE bl 
 SET [Include] = 0
 FROM [EC].[Coaching_Log_Bingo] bl JOIN flagqc
 ON (bl.CoachingID = flagqc.CoachingID AND  bl.Competency = flagqc.Competency);


 -- populate the image for the corresponding competency

 Update [EC].[Coaching_Log_Bingo]
Set CompImage =  [EC].[fn_strImageForCompetency]([Competency],[BingoType])
Where [CompImage] is NULL;

 WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms

 -- Populate the Description for Bingo logs

 WITH selectedcl AS
    (SELECT DISTINCT cl.CoachingID From ec.Coaching_Log cl INNER JOIN ec.Quality_Other_Coaching_Stage qs
	  ON cl.strReportCode = qs.Report_Code)
--select * from selectedcl

,condesc AS
(SELECT bl.CoachingID, STRING_AGG(CONVERT(nvarchar(max), bl.Description), N' | ') AS [ConDescText] -- Consolidated Description
FROM ec.Coaching_Log_Bingo bl INNER JOIN selectedcl cl
ON bl.CoachingID = cl.CoachingID 
WHERE [Include] = 1
GROUP BY bl.CoachingID)
 --select coachingid, REPLACE([ConDescText], N' | ',  '<br />' + '<br />') FROM condesc;
 
 UPDATE cl
 Set [Description] = REPLACE(c.[ConDescText], N' | ',  '<br />' + '<br />')
 FROM [EC].[Coaching_Log] cl INNER JOIN condesc c
 ON cl.CoachingID = c.CoachingID;

 WAITFOR DELAY '00:00:00:02'; -- Wait for 2 ms

-- Close the symmetric key with which to encrypt the data.  
CLOSE SYMMETRIC KEY [CoachingKey]  


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



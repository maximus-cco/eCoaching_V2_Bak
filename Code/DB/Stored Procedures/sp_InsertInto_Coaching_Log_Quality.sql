/*
sp_InsertInto_Coaching_Log_Quality(05).sql
Last Modified Date: 1/15/2019
Last Modified By: Lili Huang

Version 05: Modified to decrease coaching_log table locking time TFS 13282 - 1/15/2019
Version 04: Modified to handle inactive evaluations. TFS 9204 - 03/26/2018
Version 03: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
Version 02: Updated to Incorporate ATA Scorecards - TFS 7541 - 09/19/2017
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



--    ========================================================================================
-- Author:           Susmitha Palacherla
-- Create Date:      02/23/2014
-- Description:     This procedure inserts the Quality scorecards into the Coaching_Log table. 
--                     The main attributes of the eCL are written to the Coaching_Log table.
--                     The Coaching Reasons are written to the Coaching_Reasons Table.
-- Modified per TFS 283 to force CRLF in Description value when viewed in UI - 08/31/2015
-- Updated per TFS 3757 to add isCoachingMonitor attribute - 10/28/2016
-- Updated to Incorporate ATA Scorecards - TFS 7541 - 09/19/2017
-- Modified to support Encryption of sensitive data. Removed LanID. TFS 7856 - 10/23/2017
-- Modified to handle inactive evaluations. TFS 9204 - 03/26/2018
-- Modified to decrease coaching_log table locking time TFS 13282 - 1/15/2019 LH
--    =======================================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality]
@Count INT OUTPUT
AS
BEGIN

  SET NOCOUNT ON;
  SET XACT_ABORT ON;
  
  DECLARE @maxnumID INT, @strSourceType NVARCHAR(20);
  DECLARE @logsInserted TABLE ( 
    CoachingLogID bigint,
	ModuleID int,
	VerintEvalID nvarchar(20) 
  );

  -- Fetches the maximum CoachingID before the insert.
  SET @maxnumID = (SELECT IsNUll(MAX(CoachingID), 0) FROM EC.Coaching_Log);    
  SET @strSourceType = 'Indirect'; 

  CREATE TABLE #Temp_Logs_To_Insert (
    FormName nvarchar(50),
	ProgramName nvarchar(50),
	SourceID int,
	StatusID int,
	SiteID int,
	EmpID nvarchar(10),
	SubmitterID nvarchar(10),
	EventDate datetime,
	isAvokeID bit,
	isNGDActivityID bit,
	isUCID bit,
	isVerintID bit,
	VerintID nvarchar(40),
	VerintEvalID nvarchar(20),
	[Description] nvarchar(max),
	SubmittedDate datetime,
	StartDate datetime,
	isCSE bit,
	isCSRAcknowledged bit,
	VerintFormName nvarchar(50),
	ModuleID int,
	SupID nvarchar(20),
	MgrID nvarchar(20),
	isMonitor nvarchar(3)
  );

  BEGIN TRY
    
	INSERT INTO #Temp_Logs_To_Insert
    SELECT DISTINCT 
       User_EMPID
      ,CASE qcs.Program
         WHEN NULL THEN eh.Emp_Program
	     WHEN '' THEN eh.Emp_Program
	     ELSE qcs.Program
	   END ProgramName
      ,EC.fn_intSourceIDFromSource(@strSourceType, qcs.Source) -- SourceID
	  ,EC.fn_strStatusIDFromIQSEvalID(qcs.CSE, qcs.Oppor_Rein) -- StatusID
	  ,EC.fn_intSiteIDFromEmpID(LTRIM(RTRIM(qcs.User_EMPID)))  -- SiteID
	  ,qcs.User_EMPID    -- EmpID
	  ,qcs.Evaluator_ID  -- SubmitterID
	  ,qcs.Call_Date     -- EventDate
	  ,0                 -- isAvokeID
	  ,0                 -- isNGDActivityID
	  ,0                 -- isUCID
	  ,1                 -- isVerintID
	  ,qcs.Journal_ID    -- VerintID
	  ,qcs.Eval_ID       -- VerintEvalID
	  ,REPLACE(EC.fn_nvcHtmlEncode(qcs.Summary_CallerIssues), CHAR(13) + CHAR(10) ,'<br />') -- Description
	  ,GetDate()         -- SubmittedDate
	  ,qcs.Eval_Date     -- StartDate
	  ,CASE              -- isCSE
	     WHEN qcs.CSE = '' THEN 0
	     ELSE 1
	   END isCSE        
      ,0                  -- isCSRAcknowledged
	  ,qcs.VerintFormName -- VerintFormName
	  ,qcs.Module         -- ModuleID
	  ,ISNULL(qcs.Sup_ID, '999999')  -- SupID
	  ,ISNULL(qcs.Mgr_ID, '999999')  -- MgrID
	  ,qcs.isCoachingMonitor         -- isCoaachingMonitor
    FROM EC.Quality_Coaching_Stage qcs 
    JOIN EC.Employee_Hierarchy eh WITH (NOLOCK) ON qcs.User_EMPID = eh.Emp_ID
    LEFT JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.Eval_ID = cl.VerintEvalID
    WHERE cl.VerintEvalID IS NULL AND qcs.EvalStatus = 'Active';

	BEGIN TRANSACTION
      -- Insert into coaching log table
	  INSERT INTO EC.Coaching_Log  (
	     FormName
        ,ProgramName
        ,SourceID
        ,StatusID
        ,SiteID
        ,EmpID
        ,SubmitterID
        ,EventDate
        ,isAvokeID
        ,isNGDActivityID
        ,isUCID
        ,isVerintID
        ,VerintID
        ,VerintEvalID
        ,[Description]
        ,SubmittedDate
        ,StartDate
        ,isCSE
        ,isCSRAcknowledged
        ,VerintFormName
        ,ModuleID
        ,SupID
        ,MgrID
		,isCoachingMonitor)
	  OUTPUT INSERTED.[CoachingID], INSERTED.[VerintEvalID] INTO @logsInserted
	  SELECT * 
	  FROM #Temp_Logs_To_Insert;

      SELECT @Count =@@ROWCOUNT;

      -- Update formname for the inserted logs
	  UPDATE EC.Coaching_Log 
	  SET FormName = 'eCL-' + FormName + '-' + convert(varchar,CoachingID)
	  FROM @logsInserted 
	  WHERE CoachingID IN (SELECT CoachingLogID FROM @logsInserted);  

      -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.
      INSERT INTO EC.Coaching_Log_Reason
      SELECT 
	    CoachingLogID
       ,CASE 
          WHEN (ModuleID = 3) THEN 15 
          ELSE 10
        END
       ,42
       ,qcs.Oppor_Rein
      FROM EC.Quality_Coaching_Stage qcs 
	  JOIN @logsInserted inserted ON qcs.Eval_ID = inserted.VerintEvalID 
 
     --Truncate Staging Table
     Truncate Table EC.Quality_Coaching_Stage
	
	COMMIT TRANSACTION
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	
    DECLARE @ErrorMessage nvarchar(4000), @ErrorSeverity int, @ErrorState int;
    SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
      
    IF ERROR_NUMBER() IS NULL RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 RETURN ERROR_NUMBER() 
    ELSE RETURN 1
  END CATCH
END -- sp_InsertInto_Coaching_Log_Quality


GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ========================================================================================
-- Author:           Susmitha Palacherla
-- Create Date:      03/01/2019
-- Description:     
-- This procedure inserts the Quality Now scorecards into the Coaching_Log table. 
-- The main attributes of the eCL per QN batch are written to the Coaching_Log table.
-- Individual Evaluation details are written to the Coaching_Log_QN_Evaluations table       
-- The Coaching Reasons are written to the Coaching_Reasons Table.
-- Initial revision. TFS 13332 -  03/01/2019
-- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019
-- Updated logic for handling multiple Strengths and Opportunities texts for QN batch. TFS 14631 - 06/10/2019
-- Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
-- Updated to support Quality Now workflow enhancement. TFS 22187 - 09/27/2021
-- Updated to support QN Supervisor evaluation changes. TFS 26002 - 02/02/2023
--    =======================================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Coaching_Log_Quality_Now]
@Count INT OUTPUT
AS
BEGIN

  SET NOCOUNT ON;
  SET XACT_ABORT ON;
  
  DECLARE @strSourceType NVARCHAR(20);
  DECLARE @logsInserted TABLE ( 
    CoachingLogID bigint,
	ModuleID int,
	SourceId int,
	QNBatchID nvarchar(20) 
  );


  SET @strSourceType = 'Indirect'; 

  --Create table #Temp_Logs_To_Insert

  CREATE TABLE #Temp_Logs_To_Insert (
    FormName nvarchar(50),
	QNBatchID nvarchar(20),
	QNBatchStatus nvarchar(10),
	ProgramName nvarchar(50),
	SourceID int,
	StatusID int,
	SiteID int,
	EmpID nvarchar(10),
	SubmitterID nvarchar(10),
	isAvokeID bit,
	isNGDActivityID bit,
	isUCID bit,
	isVerintID bit,
	[Description] nvarchar(max),
	SubmittedDate datetime,
	isCSE bit,
	isCSRAcknowledged bit,
	ModuleID int,
	SupID nvarchar(20),
	MgrID nvarchar(20),
	QnStrengthsOpportunities nvarchar(2000)
	);
 

  BEGIN TRY

  -- Select logs for Insert into Temp Table
    
	INSERT INTO #Temp_Logs_To_Insert
    SELECT DISTINCT 
       User_EMPID
	   ,qcs.QN_Batch_ID
	   ,qcs.QN_Batch_Status
      ,eh.Emp_Program
	  ,EC.fn_intSourceIDFromSource('Indirect' , qcs.QN_Source) -- SourceID
	  ,6 -- StatusID (Pending Supervisor Review)
      ,EC.fn_intSiteIDFromEmpID(LTRIM(RTRIM(qcs.User_EMPID)))  -- SiteID
	  ,qcs.User_EMPID    -- EmpID
	  ,'999999'  -- SubmitterID
	  ,0                 -- isAvokeID
	  ,0                 -- isNGDActivityID
	  ,0                 -- isUCID
	  ,0                 -- isVerintID
	  ,'NA' -- Description
	  ,GetDate()         -- SubmittedDate
	  ,0                 --isCSE
      ,0                  -- isCSRAcknowledged
	  ,qcs.Module         -- ModuleID
	  ,ISNULL(qcs.SUP_EMPID, '999999')  -- SupID
	  ,ISNULL(qcs.Mgr_EMPID, '999999')  -- MgrID
	  ,QN_Strengths_Opportunities
	FROM EC.Quality_Now_Coaching_Stage qcs 
    JOIN EC.Employee_Hierarchy eh WITH (NOLOCK) ON qcs.User_EMPID = eh.Emp_ID
    LEFT JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.QN_Batch_ID = cl.QNBatchID
    WHERE (cl.QNBatchID IS NULL AND qcs.QN_Batch_Status = 'Active')
	OR (cl.QNBatchID IS NOT NULL AND cl.QNBatchStatus = 'Inactive' AND qcs.QN_Batch_Status = 'Active');

	BEGIN TRANSACTION

-- Insert into coaching log table

	  INSERT INTO EC.Coaching_Log  (
	     FormName
	    ,QNBatchID
	    ,QNBatchStatus 
        ,ProgramName
        ,SourceID
        ,StatusID
        ,SiteID
        ,EmpID
        ,SubmitterID
        ,isAvokeID
        ,isNGDActivityID
        ,isUCID
        ,isVerintID
        ,[Description]
        ,SubmittedDate
        ,isCSE
        ,isCSRAcknowledged
        ,ModuleID
        ,SupID
        ,MgrID
		,QNStrengthsOpportunities
		)
	  OUTPUT INSERTED.[CoachingID], INSERTED.[ModuleID], INSERTED.[SourceID], INSERTED.[QNBatchID] INTO @logsInserted
	  SELECT * FROM #Temp_Logs_To_Insert;

      --SELECT @Count = @@ROWCOUNT;

    -- Update formname for the inserted logs

	  UPDATE EC.Coaching_Log 
	  SET FormName = 'eCL-M-' + FormName + '-' + convert(varchar,CoachingID)
	  FROM @logsInserted 
	  WHERE CoachingID IN (SELECT CoachingLogID FROM @logsInserted);  

	    -- Populate Followup Due Date for Verint-CCO logs

	  UPDATE EC.Coaching_Log 
	  SET FollowupDueDate = DATEADD(DAY, 30, DATEADD(dd, 0, DATEDIFF(dd, 0, submitteddate))) -- Submitteddate + 30 Days
	  FROM @logsInserted 
	  WHERE CoachingID IN (SELECT CoachingLogID FROM @logsInserted WHERE SourceID = 235);  

	
	  -- Insert Evaluation details for each batch into Evaluations table

	  INSERT INTO [EC].[Coaching_Log_Quality_Now_Evaluations]
        SELECT DISTINCT
	    [QNBatchID]
	   ,[CoachingLogID]
	   ,[Eval_ID]
      ,[Eval_Date]
      ,[Evaluator_ID]
      ,[Call_Date]
      ,[Journal_ID]
      ,[EvalStatus]
       --,REPLACE(EC.fn_nvcHtmlEncode([Summary_CallerIssues]), CHAR(13) + CHAR(10) ,'<br />') 
	   ,'NA'
      ,[Program]
      ,[VerintFormName]
      ,[isCoachingMonitor]
      ,[Business_Process]
      ,[Business_Process_Reason]
      ,[Business_Process_Comment]
      ,[Info_Accuracy]
      ,[Info_Accuracy_Reason]
      ,[Info_Accuracy_Comment]
      ,[Privacy_Disclaimers]
      ,[Privacy_Disclaimers_Reason]
      ,[Privacy_Disclaimers_Comment]
      ,[Issue_Resolution]
      ,[Issue_Resolution_Comment]
      ,[Call_Efficiency]
      ,[Call_Efficiency_Comment]
      ,[Active_Listening]
      ,[Active_Listening_Comment]
      ,[Personality_Flexing]
      ,[Personality_Flexing_Comment]
      ,[Customer_Temp_Start]
      ,[Customer_Temp_Start_Comment]
      ,[Customer_Temp_End]
      ,[Customer_Temp_End_Comment]
	  ,GetDate()
	  ,GetDate()
	  ,[Channel]
      ,[ActivityID]
      ,[DCN]
      ,[CaseNumber]
	  ,[Reason_For_Contact]
      ,[Contact_Reason_Comment]
	  FROM EC.Quality_Now_Coaching_Stage qcs 
	 JOIN @logsInserted inserted ON qcs.QN_Batch_ID = inserted.QNBatchID;
	 
	 SELECT @Count = @@ROWCOUNT;

      -- Inserts records into Coaching_Log_reason table for each record inserted into Coaching_log table.

      INSERT INTO EC.Coaching_Log_Reason
      SELECT DISTINCT
	    CoachingLogID
       ,CASE 
          WHEN (ModuleID = 3) THEN 58
          ELSE 57
        END
       ,42
       ,'NA'
      FROM EC.Quality_Now_Coaching_Stage qcs 
	  JOIN @logsInserted inserted ON qcs.QN_Batch_ID = inserted.QNBatchID; 
 
     --Truncate Staging Table
     --Truncate Table EC.Quality_Now_Coaching_Stage;
	
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
END -- sp_InsertInto_Coaching_Log_Quality_Now

GO



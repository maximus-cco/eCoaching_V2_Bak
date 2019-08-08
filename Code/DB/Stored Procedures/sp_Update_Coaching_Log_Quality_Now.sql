/*
sp_Update_Coaching_Log_Quality_Now(05).sql
Last Modified Date: 08/07/2019
Last Modified By: Susmitha Palacherla


Version 05: Updated to change data type for Customer Temp Start and End to nvarchar. TFS 15058 - 08/07/2019
Version 04: Updated logic for handling multiple Strengths and Opportunities texts for QN batch. TFS 14631 - 06/10/2019
Version 03: Fix bug with updates to QNStrengthsOpportunities  - TFS 14555 - 06/03/2019
Version 02: Updates from Unit and System testing - TFS 13332 - 04/20/2019
Version 01: Document Initial Revision - TFS 13332 - 03/19/2019
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Coaching_Log_Quality_Now' 
)
   DROP PROCEDURE [EC].[sp_Update_Coaching_Log_Quality_Now]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ===========================================================================================
-- Author:           Susmitha Palacherla
-- Create Date:      03/01/2019
-- Description:     This procedure updates the Quality Now scorecards in the Coaching_Log and QN_Evaluations tables. 
-- Initial revision. TFS 13332 -  03/01/2019
-- Fix bug with updates to QNStrengthsOpportunities  - TFS 14555 - 06/03/2019
-- Updated logic for handling multiple Strengths and Opportunities texts for QN batch. TFS 14631 - 06/10/2019
-- Updated to change data type for Customer Temp Start and End to nvarchar. TFS 15058 - 08/07/2019
--    ===========================================================================================
CREATE PROCEDURE [EC].[sp_Update_Coaching_Log_Quality_Now] AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
  CREATE TABLE #Temp_Coaching_Logs_To_Inactivate (
    CoachingID bigint
  );

  CREATE TABLE #Temp_Coaching_Logs_To_Inactivate_Audit (
    CoachingID bigint,
	FormName nvarchar(50),
	LastKnownStatus int
  );

  CREATE TABLE #Temp_Coaching_Logs_To_Update (
    CoachingID bigint,
	QNBatchID nvarchar(20),
	QNStrengthsOpportunities nvarchar(2000) 
  );

   CREATE TABLE #Temp_Quality_Now_Evaluations_To_Update (
    CoachingID bigint,
	QNBatchID nvarchar(20),
	EvalID nvarchar(20),
	EvalStatus nvarchar(10),
	SummaryCallerIssues nvarchar(max),
	BusinessProcess [nvarchar](20),
	BusinessProcessReason [nvarchar](200),
	BusinessProcessComment [nvarchar](2000),
	InfoAccuracy [nvarchar](20),
	InfoAccuracyReason [nvarchar](200),
	InfoAccuracyComment [nvarchar](2000),
	PrivacyDisclaimers [nvarchar](20),
	PrivacyDisclaimersReason [nvarchar](200),
	PrivacyDisclaimersComment [nvarchar](2000),
	IssueResolution [nvarchar](50),
	IssueResolutionComment [nvarchar](2000),
	CallEfficiency [nvarchar](50),
	CallEfficiencyComment [nvarchar](2000),
	ActiveListening [nvarchar](50),
	ActiveListeningComment [nvarchar](2000),
	PersonalityFlexing [nvarchar](50),
	PersonalityFlexingComment [nvarchar](2000),
	CustomerTempStart [nvarchar](30),
	CustomerTempStartComment [nvarchar](2000),
	CustomerTempEnd [nvarchar](30),
	CustomerTempEndComment [nvarchar](2000),
  );


  -- Populates #Temp_Coaching_Logs_To_Inactive

  INSERT INTO #Temp_Coaching_Logs_To_Inactivate 
  SELECT DISTINCT cl.CoachingID
  FROM EC.Quality_Now_Coaching_Stage qcs 
  JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.[QN_Batch_ID] = cl.[QNBatchID]
  WHERE cl.StatusID <> 2 AND qcs.[QN_Batch_Status] = N'Inactive';

  -- Populates #Temp_Coaching_Logs_To_Inactivate_Audit

  INSERT INTO #Temp_Coaching_Logs_To_Inactivate_Audit
  SELECT DISTINCT cl.CoachingID, cl.Formname, cl.StatusID
  FROM EC.Quality_Now_Coaching_Stage qcs 
  JOIN EC.Coaching_Log cl WITH (NOLOCK) ON qcs.[QN_Batch_ID] = cl.[QNBatchID]
  WHERE cl.StatusID <> 2
  AND qcs.[QN_Batch_Status] = N'Inactive'
  AND cl.FormName NOT IN 
  (SELECT FormName FROM EC.AT_Coaching_Inactivate_Reactivate_Audit 
   WHERE Reason = N'Batch Inactive' AND RequesterComments = N'Quality Now Load Process' 
   );


     -- Populates #Temp_Coaching_Logs_To_Update where QN_Strengths_Opportunities changed
  INSERT INTO #Temp_Coaching_Logs_To_Update
  SELECT DISTINCT cl.CoachingID, cl.QNBatchID, qcs.[QN_Strengths_Opportunities]
   FROM (SELECT DISTINCT QN_BATCH_ID, QN_Strengths_Opportunities FROM EC.Quality_Now_Coaching_Stage
	  WHERE QN_Strengths_Opportunities is NOT NULL 
	  AND QN_Strengths_Opportunities <> ''
	  AND QN_Batch_Status = 'Active')qcs JOIN EC.Coaching_Log cl
	  ON qcs.QN_Batch_ID = cl.QNBatchID
	    WHERE qcs.[QN_Strengths_Opportunities] <> ISNULL(cl.QNStrengthsOpportunities,'');

  -- Populates #Temp_Quality_Now_Evaluations_To_Update
  INSERT INTO #Temp_Quality_Now_Evaluations_To_Update
  SELECT cqe.[CoachingID]
       ,cqe.[QNBatchID]
	   ,cqe.[Eval_ID]
      ,qcs.[EvalStatus]
      ,replace(EC.fn_nvcHtmlEncode(qcs.Summary_CallerIssues), CHAR(13) + CHAR(10) ,'<br />')
      ,qcs.[Business_Process]
      ,qcs.[Business_Process_Reason]
      ,qcs.[Business_Process_Comment]
      ,qcs.[Info_Accuracy]
      ,qcs.[Info_Accuracy_Reason]
      ,qcs.[Info_Accuracy_Comment]
      ,qcs.[Privacy_Disclaimers]
      ,qcs.[Privacy_Disclaimers_Reason]
      ,qcs.[Privacy_Disclaimers_Comment]
      ,qcs.[Issue_Resolution]
      ,qcs.[Issue_Resolution_Comment]
      ,qcs.[Call_Efficiency]
      ,qcs.[Call_Efficiency_Comment]
      ,qcs.[Active_Listening]
      ,qcs.[Active_Listening_Comment]
      ,qcs.[Personality_Flexing]
      ,qcs.[Personality_Flexing_Comment]
      ,qcs.[Customer_Temp_Start]
      ,qcs.[Customer_Temp_Start_Comment]
      ,qcs.[Customer_Temp_End]
      ,qcs.[Customer_Temp_End_Comment]
  FROM EC.Quality_Now_Coaching_Stage qcs
  JOIN EC.Coaching_Log_Quality_Now_Evaluations cqe WITH (NOLOCK) ON 
  qcs.[Eval_ID] = cqe.[Eval_ID]
  AND qcs.QN_Batch_ID = cqe.QNBatchID
    WHERE CHECKSUM(
  CONCAT(qcs.[EvalStatus] , '|'
      ,replace(EC.fn_nvcHtmlEncode(qcs.Summary_CallerIssues), CHAR(13) + CHAR(10) ,'<br />') , '|'
      ,qcs.[Business_Process] , '|'
      ,qcs.[Business_Process_Reason] , '|'
      ,qcs.[Business_Process_Comment] , '|'
      ,qcs.[Info_Accuracy] , '|'
      ,qcs.[Info_Accuracy_Reason] , '|'
      ,qcs.[Info_Accuracy_Comment] , '|'
      ,qcs.[Privacy_Disclaimers] , '|'
      ,qcs.[Privacy_Disclaimers_Reason] , '|'
      ,qcs.[Privacy_Disclaimers_Comment] , '|'
      ,qcs.[Issue_Resolution] , '|'
      ,qcs.[Issue_Resolution_Comment] , '|'
      ,qcs.[Call_Efficiency] , '|'
      ,qcs.[Call_Efficiency_Comment] , '|'
      ,qcs.[Active_Listening] , '|'
      ,qcs.[Active_Listening_Comment] , '|'
      ,qcs.[Personality_Flexing] , '|'
      ,qcs.[Personality_Flexing_Comment] , '|'
      ,qcs.[Customer_Temp_Start], '|'
      ,qcs.[Customer_Temp_Start_Comment], '|'
      ,qcs.[Customer_Temp_End], '|'
      ,qcs.[Customer_Temp_End_Comment])) <>
CHECKSUM(
CONCAT(cqe.[EvalStatus] , '|'
      ,cqe.[Summary_CallerIssues] , '|'
      ,cqe.[Business_Process] , '|'
      ,cqe.[Business_Process_Reason] , '|'
      ,cqe.[Business_Process_Comment] , '|'
      ,cqe.[Info_Accuracy] , '|'
      ,cqe.[Info_Accuracy_Reason] , '|'
      ,cqe.[Info_Accuracy_Comment] , '|'
      ,cqe.[Privacy_Disclaimers] , '|'
      ,cqe.[Privacy_Disclaimers_Reason] , '|'
      ,cqe.[Privacy_Disclaimers_Comment] , '|'
      ,cqe.[Issue_Resolution] , '|'
      ,cqe.[Issue_Resolution_Comment] , '|'
      ,cqe.[Call_Efficiency] , '|'
      ,cqe.[Call_Efficiency_Comment] , '|'
      ,cqe.[Active_Listening] , '|'
      ,cqe.[Active_Listening_Comment] , '|'
      ,cqe.[Personality_Flexing] , '|'
      ,cqe.[Personality_Flexing_Comment] , '|'
      ,cqe.[Customer_Temp_Start], '|'
      ,cqe.[Customer_Temp_Start_Comment], '|'
      ,cqe.[Customer_Temp_End], '|'
      ,cqe.[Customer_Temp_End_Comment]));

-- Update from here

  BEGIN TRANSACTION
    -- Inactivates Logs for Inactive Batches

	-- Step 1: Audit entry for all logs being Inactivated due to 'Inactive' Batch status in the stage table

	INSERT INTO EC.AT_Coaching_Inactivate_Reactivate_Audit
      ([CoachingID], [FormName], [LastKnownStatus], [Action], [ActionTimestamp], [RequesterID], [Reason], [RequesterComments])
    SELECT *, N'Inactivate',  Getdate(), N'999998', N'Batch Inactive', N'Quality Now Load Process' 
	FROM #Temp_Coaching_Logs_To_Inactivate_Audit;

	-- Step 2: Inactivates all logs with 'Inactive' Batch status in the stage table

	UPDATE EC.Coaching_Log SET StatusID = 2,
	QNBatchStatus = 'Inactive'
    FROM #Temp_Coaching_Logs_To_Inactivate temp 
	JOIN EC.Coaching_Log cl ON temp.CoachingID = cl.CoachingID;
	
	-- Updates QNStrengthsOpportunities for existing Coaching log records

     UPDATE EC.Coaching_Log 
     SET [QNStrengthsOpportunities] = temp.QNStrengthsOpportunities
	 FROM #Temp_Coaching_Logs_To_Update temp 
	 JOIN EC.Coaching_Log cl ON temp.CoachingID = cl.CoachingID;

	-- Updates changed evaluations in Quality Now Evaluations table 

       UPDATE EC.Coaching_Log_Quality_Now_Evaluations
       SET [EvalStatus] = temp.[EvalStatus] 
      ,[Summary_CallerIssues] = temp.[SummaryCallerIssues]
      ,[Business_Process] = temp.[BusinessProcess] 
      ,[Business_Process_Reason] = temp.[BusinessProcessReason] 
      ,[Business_Process_Comment] = temp.[BusinessProcessComment] 
      ,[Info_Accuracy] = temp.[InfoAccuracy] 
      ,[Info_Accuracy_Reason] = temp.[InfoAccuracyReason] 
      ,[Info_Accuracy_Comment] = temp.[InfoAccuracyComment] 
      ,[Privacy_Disclaimers] = temp.[PrivacyDisclaimers] 
      ,[Privacy_Disclaimers_Reason] = temp.[PrivacyDisclaimersReason] 
      ,[Privacy_Disclaimers_Comment] = temp.[PrivacyDisclaimersComment] 
      ,[Issue_Resolution] = temp.[IssueResolution] 
      ,[Issue_Resolution_Comment] = temp.[IssueResolutionComment] 
      ,[Call_Efficiency] = temp.[CallEfficiency] 
      ,[Call_Efficiency_Comment] = temp.[CallEfficiencyComment] 
      ,[Active_Listening] = temp.[ActiveListening] 
      ,[Active_Listening_Comment] = temp.[ActiveListeningComment] 
      ,[Personality_Flexing] = temp.[PersonalityFlexing] 
      ,[Personality_Flexing_Comment] = temp.[PersonalityFlexingComment] 
      ,[Customer_Temp_Start] = temp.[CustomerTempStart]
      ,[Customer_Temp_Start_Comment] = temp.[CustomerTempStartComment]
      ,[Customer_Temp_End] = temp.[CustomerTempEnd]
      ,[Customer_Temp_End_Comment] = temp.[CustomerTempEndComment]
	  ,[Last_Updated_date] = GetDate()
	FROM  #Temp_Quality_Now_Evaluations_To_Update temp JOIN EC.Coaching_Log_Quality_Now_Evaluations qne
	ON qne.CoachingID = temp.CoachingID
	AND qne.QNBatchID = temp.QNBatchID
	AND qne.Eval_ID = temp.EvalID ;

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

END -- [EC].[sp_Update_Coaching_Log_Quality_Now]

GO















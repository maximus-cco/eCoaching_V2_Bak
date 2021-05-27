/*
sp_Insert_Into_Coaching_Log_Archive(07).sql
Last Modified Date: 5/24/2021
Last Modified By: Susmitha Palacherla

Version 07: Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
Version 06: Updated to archive Quality Now, Short Calls and Bingo detail records - TFS 17655 -  07/20/2020
Version 05: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019
Version 04: Modified to add ConfirmedCSE. TFS 14049 - 04/26/2019
Version 03: Modified to incorporate Quality Now. TFS 13332 - 03/19/2019
Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Insert_Into_Coaching_Log_Archive' 
)
   DROP PROCEDURE [EC].[sp_Insert_Into_Coaching_Log_Archive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:   10/10/2016
-- Description:	Archive Inactive Coaching logs older than 1 year
-- Last Modified By: Susmitha Palacherla
-- Revision History:
-- Intial Revision: Created per TFS 3932 - 10/10/2016
--  Modified to support Encryption of sensitive data - Removed EmpLanID. TFS 7856 - 10/23/2017
--  Modified to incorporate Quality Now. TFS 13332 - 03/01/2019
--  Modified to incorporate new column ConfirmedCSE. TFS 14049 - 04/18/2019
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to archive Quality Now, Short Calls and Bingo detail records - TFS 17655 -  07/20/2020
-- Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
-- =============================================
CREATE PROCEDURE [EC].[sp_Insert_Into_Coaching_Log_Archive] @strArchivedBy nvarchar(50)= 'Automated Process'

AS
BEGIN

  SET NOCOUNT ON;
  SET XACT_ABORT ON;
 
 BEGIN TRY
  
-- Drop if exists and create a Temp Table to hold the CoachingIDs to be archived.
IF OBJECT_ID(N'tempdb..#ArchiveLogs') IS NOT NULL
BEGIN
DROP TABLE #ArchiveLogs;
END

CREATE TABLE #ArchiveLogs
(
 CoachingID bigint
)

  -- Select logs for Insert into Temp Table
  INSERT INTO #ArchiveLogs
  SELECT DISTINCT [CoachingID]
  FROM [EC].[Coaching_Log] CL
  WHERE CL.StatusID = 2
  and CL.[SubmittedDate] < dateadd(year,-1,getdate());

  --SELECT * FROM #ArchiveLogs;

 
BEGIN TRANSACTION
-- Insert Coaching log records in Archive table.
INSERT INTO [EC].[Coaching_Log_Archive]
           ([CoachingID]
           ,[FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpID]
           ,[SubmitterID]
           ,[EventDate]
           ,[CoachingDate]
           ,[isAvokeID]
           ,[AvokeID]
           ,[isNGDActivityID]
           ,[NGDActivityID]
           ,[isUCID]
           ,[UCID]
           ,[isVerintID]
           ,[VerintID]
           ,[VerintEvalID]
           ,[Description]
           ,[CoachingNotes]
           ,[isVerified]
           ,[SubmittedDate]
           ,[StartDate]
           ,[SupReviewedAutoDate]
           ,[isCSE]
           ,[MgrReviewManualDate]
           ,[MgrReviewAutoDate]
           ,[MgrNotes]
           ,[isCSRAcknowledged]
           ,[CSRReviewAutoDate]
           ,[CSRComments]
           ,[EmailSent]
           ,[numReportID]
           ,[strReportCode]
           ,[isCoachingRequired]
           ,[strReasonNotCoachable]
           ,[txtReasonNotCoachable]
           ,[VerintFormName]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           ,[Review_SupID]
           ,[Review_MgrID]
           ,[Behavior]
           ,[SurveySent]
           ,[NotificationDate]
           ,[ReminderSent]
           ,[ReminderDate]
           ,[ReminderCount]
           ,[ReassignDate]
           ,[ReassignCount]
           ,[ReassignedToID]
           ,[isCoachingMonitor] 
	       ,[QNBatchID]
		   ,[QNBatchStatus]
		   ,[QNStrengthsOpportunities]
		   ,[ConfirmedCSE]
		   ,[IsFollowupRequired]
           ,[FollowupDueDate]
           ,[FollowupActualDate]
           ,[SupFollowupAutoDate]
           ,[SupFollowupCoachingNotes]
           ,[IsEmpFollowupAcknowledged]
           ,[EmpAckFollowupAutoDate]
           ,[EmpAckFollowupComments]
		   ,[FollowupSupID]
           ,[ArchivedBy]
           ,[ArchivedDate]
		)
     SELECT CL.[CoachingID]
      ,[FormName]
      ,[ProgramName]
      ,[SourceID]
      ,[StatusID]
      ,[SiteID]
      ,[EmpID]
      ,[SubmitterID]
      ,[EventDate]
      ,[CoachingDate]
      ,[isAvokeID]
      ,[AvokeID]
      ,[isNGDActivityID]
      ,[NGDActivityID]
      ,[isUCID]
      ,[UCID]
      ,[isVerintID]
      ,[VerintID]
      ,[VerintEvalID]
      ,[Description]
      ,[CoachingNotes]
      ,[isVerified]
      ,[SubmittedDate]
      ,[StartDate]
      ,[SupReviewedAutoDate]
      ,[isCSE]
      ,[MgrReviewManualDate]
      ,[MgrReviewAutoDate]
      ,[MgrNotes]
      ,[isCSRAcknowledged]
      ,[CSRReviewAutoDate]
      ,[CSRComments]
      ,[EmailSent]
      ,[numReportID]
      ,[strReportCode]
      ,[isCoachingRequired]
      ,[strReasonNotCoachable]
      ,[txtReasonNotCoachable]
      ,[VerintFormName]
      ,[ModuleID]
      ,[SupID]
      ,[MgrID]
      ,[Review_SupID]
      ,[Review_MgrID]
      ,[Behavior]
      ,[SurveySent]
      ,[NotificationDate]
      ,[ReminderSent]
      ,[ReminderDate]
      ,[ReminderCount]
      ,[ReassignDate]
      ,[ReassignCount]
      ,[ReassignedToID]
      ,[isCoachingMonitor] 
	  ,[QNBatchID]
	  ,[QNBatchStatus]
	  ,[QNStrengthsOpportunities]
	  ,[ConfirmedCSE]
	  ,[IsFollowupRequired]
      ,[FollowupDueDate]
      ,[FollowupActualDate]
      ,[SupFollowupAutoDate]
      ,[SupFollowupCoachingNotes]
      ,[IsEmpFollowupAcknowledged]
      ,[EmpAckFollowupAutoDate]
      ,[EmpAckFollowupComments]
	  ,[FollowupSupID]
      ,@strArchivedBy
	  ,GetDate()
  FROM [EC].[Coaching_Log] CL JOIN #ArchiveLogs A
  ON CL.CoachingID = A.CoachingID;

  
-- Insert Coaching log reason records in Archive table.
INSERT INTO [EC].[Coaching_Log_Reason_Archive]
           ([CoachingID]
           ,[CoachingReasonID]
           ,[SubCoachingReasonID]
           ,[Value]
           ,[ArchivedBy]
           ,[ArchivedDate])
    SELECT CLR.[CoachingID]
      ,[CoachingReasonID]
      ,[SubCoachingReasonID]
      ,ISNULL([Value],'')
      ,@strArchivedBy
      ,GETDATE()
  FROM [EC].[Coaching_Log_Reason]CLR JOIN #ArchiveLogs A
  ON CLR.CoachingID = A.CoachingID;

-- Insert Quality Noew detail records in Archive table.
  INSERT INTO [EC].[Coaching_Log_Quality_Now_Evaluations_Archive]
           ([QNBatchID]
           ,[CoachingID]
           ,[Eval_ID]
           ,[Eval_Date]
           ,[Evaluator_ID]
           ,[Call_Date]
           ,[Journal_ID]
           ,[EvalStatus]
           ,[Summary_CallerIssues]
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
           ,[Inserted_Date]
           ,[Last_Updated_Date]
           ,[ArchivedBy]
           ,[ArchivedDate]
		   ,[Channel]
           ,[ActivityID]
           ,[DCN]
           ,[CaseNumber]
		   ,[Reason_For_Contact]
           ,[Contact_Reason_Comment])
   SELECT qne.[QNBatchID]
      ,qne.[CoachingID]
      ,[Eval_ID]
      ,[Eval_Date]
      ,[Evaluator_ID]
      ,[Call_Date]
      ,[Journal_ID]
      ,[EvalStatus]
      ,[Summary_CallerIssues]
      ,[Program]
      ,qne.[VerintFormName]
      ,qne.[isCoachingMonitor]
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
      ,[Inserted_Date]
      ,[Last_Updated_Date]
	  ,@strArchivedBy
	  ,GetDate()
	  ,[Channel]
      ,[ActivityID]
      ,[DCN]
      ,[CaseNumber]
	  ,[Reason_For_Contact]
      ,[Contact_Reason_Comment]
  FROM [EC].[Coaching_Log_Quality_Now_Evaluations] QNE JOIN #ArchiveLogs A
  ON QNE.CoachingID = A.CoachingID;
  
-- Insert Short Calls detail records in Archive table.
INSERT INTO [EC].[ShortCalls_Evaluations_Archive]
           ([CoachingID]
           ,[VerintCallID]
           ,[EventDate]
           ,[StartDate]
           ,[Valid]
           ,[BehaviorID]
           ,[Action]
           ,[CoachingNotes]
           ,[LSAInformed]
           ,[MgrAgreed]
           ,[MgrComments]
           ,[ArchivedBy]
           ,[ArchivedDate])
   SELECT sce.[CoachingID]
      ,[VerintCallID]
      ,sce.[EventDate]
      ,sce.[StartDate]
      ,[Valid]
      ,[BehaviorID]
      ,[Action]
      ,sce.[CoachingNotes]
      ,[LSAInformed]
      ,[MgrAgreed]
      ,[MgrComments]
	  ,@strArchivedBy
	  ,GetDate()
  FROM [EC].[ShortCalls_Evaluations] SCE JOIN #ArchiveLogs A
  ON SCE.CoachingID = A.CoachingID;

-- Insert Bingo detail records in Archive table.  
INSERT INTO [EC].[Coaching_Log_Bingo_Archive]
           ([CoachingID]
           ,[Competency]
           ,[Note]
           ,[Description]
           ,[CompImage]
           ,[BingoType]
           ,[ArchivedBy]
           ,[ArchivedDate])
  SELECT clb.[CoachingID]
      ,[Competency]
      ,[Note]
      ,clb.[Description]
      ,[CompImage]
      ,[BingoType]
	  ,@strArchivedBy
	  ,GetDate()
  FROM [EC].[Coaching_Log_Bingo] CLB JOIN #ArchiveLogs A
  ON CLB.CoachingID = A.CoachingID;

  -- Delete archived coaching log and related detailed records

--Delete archived Coaching Log Reason records
	DELETE CLR
	FROM [EC].[Coaching_Log_Reason] CLR JOIN #ArchiveLogs A
    ON CLR.CoachingID = A.CoachingID;
	
-- Delete archived Quality Now detail records
	DELETE QNE
	FROM [EC].[Coaching_Log_Quality_Now_Evaluations] QNE JOIN #ArchiveLogs A
    ON QNE.CoachingID = A.CoachingID;

  -- Delete archived Short Calls detail records
  	DELETE SCE
    FROM [EC].[ShortCalls_Evaluations] SCE JOIN #ArchiveLogs A
    ON SCE.CoachingID = A.CoachingID;

  -- Delete archived Bingo detail records
  	DELETE CLB
    FROM [EC].[Coaching_Log_Bingo] CLB JOIN #ArchiveLogs A
    ON CLB.CoachingID = A.CoachingID;

-- Delete archived Coaching Log records
	DELETE CL
	FROM [EC].[Coaching_Log] CL JOIN #ArchiveLogs A
    ON CL.CoachingID = A.CoachingID;

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
END -- sp_Insert_Into_Coaching_Log_Archive

GO



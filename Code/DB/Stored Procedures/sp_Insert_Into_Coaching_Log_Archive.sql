/*
sp_Insert_Into_Coaching_Log_Archive(04).sql
Last Modified Date: 04/26/2019
Last Modified By: Susmitha Palacherla

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
-- =============================================
CREATE PROCEDURE [EC].[sp_Insert_Into_Coaching_Log_Archive]@strArchivedBy nvarchar(50)= 'Automated Process'

AS
BEGIN


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

BEGIN TRY
PRINT @strArchivedBy

-- Archive coaching logs older than 1 year

BEGIN
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
           ,[ArchivedBy]
           ,[ArchivedDate]
		)
     SELECT [CoachingID]
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
      ,@strArchivedBy
      ,GetDate()
  FROM [EC].[Coaching_Log] CL
  WHERE CL.StatusID = 2
  and CL.[SubmittedDate] < dateadd(year,-1,getdate())
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms



-- Archive coaching log reasons for coaching logs older than 1 year

BEGIN
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
  FROM [EC].[Coaching_Log_Reason]CLR JOIN [EC].[Coaching_Log] CL
  ON CLR.CoachingID = CL.CoachingID
    WHERE CL.StatusID = 2
  and CL.[SubmittedDate] < dateadd(year,-1,getdate())
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

-- Delete archived coaching log reason records

BEGIN
	DELETE CLR
	FROM [EC].[Coaching_Log_Reason]CLR JOIN [EC].[Coaching_Log_Reason_Archive]CLRA 
    ON CLR.[CoachingID] = CLRA.[CoachingID] JOIN [EC].[Coaching_Log] CL
    ON CLR.[CoachingID] = CL.[CoachingID]
   WHERE CL.StatusID = 2
  and CL.[SubmittedDate] < dateadd(year,-1,getdate())
	
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms



-- Delete archived coaching log records

BEGIN
	DELETE CL
	FROM [EC].[Coaching_Log] CL JOIN [EC].[Coaching_Log_Archive]CLA
	ON CL.[CoachingID] = CLA.[CoachingID]
  WHERE CL.StatusID = 2
  and CL.[SubmittedDate] < dateadd(year,-1,getdate())
OPTION (MAXDOP 1)
END


COMMIT TRANSACTION
END TRY

  BEGIN CATCH
  ROLLBACK TRANSACTION
  END CATCH

END  -- [EC].[sp_Insert_Into_Coaching_Log_Archive]

GO




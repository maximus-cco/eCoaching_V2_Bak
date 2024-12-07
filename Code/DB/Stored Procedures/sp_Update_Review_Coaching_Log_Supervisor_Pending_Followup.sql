IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Review_Coaching_Log_Supervisor_Pending_Followup' 
)
   DROP PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Supervisor_Pending_Followup]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:      08/28/2019
--    Description: *    This procedure allows supervisors to update the e-Coaching records from review page. 
--    Initial Revision. Incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--    Modified to support Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--    =====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Supervisor_Pending_Followup]
(
  @nvcFormID BIGINT,
  @nvcFormStatus Nvarchar(60),
  @nvcReviewSupID Nvarchar(10),
  @dtmSupReviewedAutoDate datetime,
  @dtmSupFollowupDate datetime,
  @nvctxtCoachingNotes Nvarchar(max) 
)
AS

BEGIN

DECLARE @intSourceID int,
        @RetryCounter INT;
SET @RetryCounter = 1;
SET @intSourceID = (Select SourceID from EC.Coaching_log where CoachingID =   @nvcFormID )

RETRY: -- Label RETRY


BEGIN TRANSACTION;

BEGIN TRY


UPDATE [EC].[Coaching_Log]
SET 
  StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
  [FollowupSupID] = @nvcReviewSupID,
  [SupFollowupAutoDate] = @dtmSupReviewedAutoDate,
  [FollowupActualDate]= @dtmSupFollowupDate,
  [SupFollowupCoachingNotes]= @nvctxtCoachingNotes,
  [ReassignCount] = 0
WHERE CoachingID = @nvcFormID;

IF @intSourceID in (235,236)
BEGIN
UPDATE [EC].[Coaching_Log_Quality_Now_Summary]
SET [IsReadOnly]= 1
   ,[LastModifyDate]= GetDate()
   ,[LastModifyBy]=  @nvcReviewSupID
WHERE CoachingID = @nvcFormID AND [IsReadOnly] = 0;
END  

	
COMMIT TRANSACTION;
END TRY

BEGIN CATCH
  ROLLBACK TRANSACTION;
  
  DECLARE @DoRetry bit; -- Whether to Retry transaction or not
  DECLARE @ErrorMessage NVARCHAR(4000);
  DECLARE @ErrorSeverity INT;
  DECLARE @ErrorState INT;

  SELECT   
    @ErrorMessage = ERROR_MESSAGE(),  
    @ErrorSeverity = ERROR_SEVERITY(),  
    @ErrorState = ERROR_STATE();
    
  SET @doRetry = 0;
	
  IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
  BEGIN
    SET @doRetry = 1;      -- Set @doRetry to 1 only for Deadlock
  END

  IF @DoRetry = 1
  BEGIN
    SET @RetryCounter = @RetryCounter + 1; -- Increment Retry Counter By one
    IF (@RetryCounter > 3)                 -- Check whether Retry Counter reached to 3
    BEGIN
      -- Raise Error Message if still deadlock occurred after three retries
	  RAISERROR(@ErrorMessage, 18, 1); 
	END
    ELSE
    BEGIN
      WAITFOR DELAY '00:00:00.05'; -- Wait for 5 ms
      GOTO RETRY;	               -- Go to Label RETRY
    END
  END
  ELSE -- @DoRetry = 0, not deadlock error
  BEGIN
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
  END -- ELSE
END CATCH;

END --sp_Update_Review_Coaching_Log_Supervisor_Pending_Followup

GO


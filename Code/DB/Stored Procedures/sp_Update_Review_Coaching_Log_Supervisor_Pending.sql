SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:      11/16/12
--    Description: *    This procedure allows supervisors to update the e-Coaching records from review page. 
--    Updated per TFS 115/118 to fix issue with Coaching Notes overwritten - 07/22/2015
--    Updated per TFS 1709 Admin tool setup to reset reassign count  - 5/2/2016
--    TFS 7856 encryption/decryption - emp name, emp lanid, email
--    TFS 7137 move my dashboard to new architecture - 06/12/2018
--    Modified to support Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--    Modified to suppport Motivate and Increase CSR Level Promotions Feed. TFS 28262 - 06/12/2024
--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Supervisor_Pending]
(
  @nvcFormID BIGINT,
  @nvcFormStatus Nvarchar(60),
  @nvcReviewSupID Nvarchar(10),
  @dtmSupReviewedAutoDate datetime,
  @bitisFollowupRequired bit,
  @dtmSupFollowupDueDate datetime,
  @nvctxtCoachingNotes Nvarchar(max) 
)
AS

BEGIN

DECLARE  @intSourceID int
		,@intStatusID int
        ,@RetryCounter INT;

SET @intSourceID = (Select SourceID from EC.Coaching_log where CoachingID =   @nvcFormID )
SET @intStatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus);
SET @RetryCounter = 1;

RETRY: -- Label RETRY

BEGIN TRANSACTION;
BEGIN TRY

UPDATE [EC].[Coaching_Log]
SET 
  StatusID = @intStatusID,
  Review_SupID = @nvcReviewSupID,
  SupReviewedAutoDate = @dtmSupReviewedAutoDate,
  IsFollowupRequired = @bitisFollowupRequired, 
  FollowupDueDate = @dtmSupFollowupDueDate,
  CoachingNotes = @nvctxtCoachingNotes,
  ReassignCount = 0
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

END --sp_Update_Review_Coaching_Log_Supervisor_Pending
GO



IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update7Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update7Review_Coaching_Log]
GO

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update_Review_Coaching_Log_Supervisor_Acknowledge' 
)
   DROP PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Supervisor_Acknowledge]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--    ====================================================================
--    Author:                 Jourdain Augustin
--    Create Date:      7/31/13
--    Description: *    This procedure allows Sups to update the e-Coaching records from the review page for Pending Acknowledgment records. 
--    Last Update:    12/16/2014
--    Updated per SCR 13891 to capture review sup id.
--    TFS 7856 encryption/decryption - emp name, emp lanid, email
--    TFS 7137 move my dashboard to new architecture - 06/12/2018
--    TFS 12591 Modified to support OTA Report - 11/26/2018
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Supervisor_Acknowledge]
(
  @nvcFormID BIGINT,
  @nvcCoachingNotes Nvarchar(4000),
  @nvcFormStatus Nvarchar(30),
  @nvcReviewSupID Nvarchar(10),
  @dtmSUPReviewAutoDate datetime
)
AS

BEGIN

DECLARE @RetryCounter INT;
SET @RetryCounter = 1;

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;

BEGIN TRY


UPDATE [EC].[Coaching_Log]
SET 
  StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
  CoachingNotes = @nvcCoachingNotes,
  Review_SupID = @nvcReviewSupID,
  SUPReviewedAutoDate = @dtmSUPReviewAutoDate
WHERE CoachingID = @nvcFormID
OPTION (MAXDOP 1);
	
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

END --sp_Update_Review_Coaching_Log_Supervisor_Acknowledge



GO



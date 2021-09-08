IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update_Review_Coaching_Log_Manager_Pending_CSE' 
)
   DROP PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Manager_Pending_CSE]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:     11/16/12
--    Description:    This procedure allows managers to update the e-Coaching records from the review page with No, this is not a confirmed Customer Service Escalation. 
--    Updated per SCR 13891 to capture review mgr id - 12/16/2014
--    Updated per TFS 1709 Admin tool setup to reset reassign count to 0 - 5/2/2016
--    TFS 7856 encryption/decryption - emp name, emp lanid, email
--    TFS 7137 move my dashboard to new architecture - 06/12/2018
--    Modified to add ConfirmedCSE. TFS 14049 - 04/26/2019
--    Modified to support Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--    =====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Manager_Pending_CSE]
(
  @nvcFormID BIGINT,
  @nvcFormStatus Nvarchar(60),
  @nvcReviewMgrID Nvarchar(10),
  @dtmMgrReviewAutoDate datetime,
  @dtmMgrReviewManualDate datetime,
  @ConfirmedCSE bit,
  @nvcMgrNotes Nvarchar(max)
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
  Review_MgrID = @nvcReviewMgrID,
  ConfirmedCSE = @ConfirmedCSE,
  MgrReviewAutoDate = @dtmMgrReviewAutoDate,
  MgrReviewManualDate = @dtmMgrReviewManualDate,
  MgrNotes = @nvcMgrNotes,
  ReassignCount = 0
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

END --sp_Update_Review_Coaching_Log_Manager_Pending_CSE





GO



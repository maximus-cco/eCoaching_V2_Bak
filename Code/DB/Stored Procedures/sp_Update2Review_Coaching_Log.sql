IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update2Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update2Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:      11/16/11
--    Description: *    This procedure allows managers to update the e-Coaching records from the review page with Yes, this is a confirmed Customer Service Escalation. 
--    Updated per TFS 115/118 to fix issue with Coaching Notes overwritten - 07/22/2015
--    Updated per TFS 1709 Admin tool setup to reset reassign count to 0 - 5/2/2016
--    TFS 7856 encryption/decryption - emp name, emp lanid, email
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update2Review_Coaching_Log]
(
  @nvcFormID Nvarchar(50),
  @nvcFormStatus Nvarchar(30),
  @nvcReviewMgrLanID Nvarchar(20),
  @dtmMgrReviewAutoDate datetime,
  @dtmMgrReviewManualDate datetime,
  @bitisCSE bit,
  @nvctxtMgrNotes nvarchar(max)
)
AS

BEGIN

DECLARE @RetryCounter INT;
SET @RetryCounter = 1;

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;

BEGIN TRY 

DECLARE @nvcReviewMgrID Nvarchar(10);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];   
SET @nvcReviewMgrID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewMgrLanID, GETDATE());
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
      
UPDATE [EC].[Coaching_Log]
SET
  StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
  Review_MgrID = @nvcReviewMgrID,
  MgrReviewAutoDate = @dtmMgrReviewAutoDate,
  MgrReviewManualDate = @dtmMgrReviewManualDate,
  isCSE = @bitisCSE,
  MgrNotes = @nvctxtMgrNotes,
  ReassignCount = 0
WHERE FormName = @nvcFormID
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

END --sp_Update2Review_Coaching_Log
GO
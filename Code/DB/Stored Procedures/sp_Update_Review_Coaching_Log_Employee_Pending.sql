/*
Last Modified Date: 11/18/2019
Last Modified By: Susmitha Palacherla

Version 01: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019

*/


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update4Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update4Review_Coaching_Log]
GO


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update_Review_Coaching_Log_Employee_Pending' 
)
   DROP PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Employee_Pending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:     11/16/12
--    Description:    This procedure allows csrs to update the e-Coaching records from the review page. 
--    Last Update:    03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query
--    TFS 7856 encryption/decryption - emp name, emp lanid, email
--    Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Employee_Pending]
(
  @nvcLogType nvarchar(20),
  @nvcFormID BIGINT,
  @nvcFormStatus Nvarchar(30),
  @bitisCSRAcknowledged bit,
  @nvcCSRComments Nvarchar(max),
  @dtmCSRReviewAutoDate datetime
)
AS

BEGIN

DECLARE @RetryCounter INT;
SET @RetryCounter = 1;

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;

BEGIN TRY

IF  @nvcLogType = N'Coaching'
BEGIN
UPDATE [EC].[Coaching_Log]
SET 
  StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
  isCSRAcknowledged = @bitisCSRAcknowledged,
  CSRReviewAutoDate = @dtmCSRReviewAutoDate,
  CSRComments = @nvcCSRComments
WHERE CoachingID = @nvcFormID
OPTION (MAXDOP 1);	
END

ELSE
BEGIN
UPDATE [EC].[Warning_Log]
SET 
  StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
  isCSRAcknowledged = @bitisCSRAcknowledged,
  CSRReviewAutoDate = @dtmCSRReviewAutoDate,
  CSRComments = @nvcCSRComments
WHERE WarningID = @nvcFormID
OPTION (MAXDOP 1);	
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

END --sp_Update_Review_Coaching_Log_Employee_Pending
GO





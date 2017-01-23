/*
sp_Update7Review_Coaching_Log(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update7Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update7Review_Coaching_Log]
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
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update7Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcReviewSupLanID Nvarchar(20),
      @dtmSUPReviewAutoDate datetime
	
)
AS

BEGIN
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
DECLARE @nvcReviewSupID Nvarchar(10),
	    @dtmDate datetime
       
SET @dtmDate  = GETDATE()   
SET @nvcReviewSupID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewSupLanID,@dtmDate)

UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
	       Review_SupID = @nvcReviewSupID,
		   SUPReviewedAutoDate = @dtmSUPReviewAutoDate
from EC.Coaching_Log        
	WHERE FormName = @nvcFormID
	OPTION (MAXDOP 1)

	
COMMIT TRANSACTION
END TRY

BEGIN CATCH
	--PRINT 'Rollback Transaction'
	ROLLBACK TRANSACTION
	DECLARE @DoRetry bit; -- Whether to Retry transaction or not
	DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    
	SET @doRetry = 0;
	
	IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
	BEGIN
		SET @doRetry = 1; -- Set @doRetry to 1 only for Deadlock
	END
	IF @DoRetry = 1
	BEGIN
		SET @RetryCounter = @RetryCounter + 1 -- Increment Retry Counter By one
		IF (@RetryCounter > 3) -- Check whether Retry Counter reached to 3
		BEGIN
			RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
				-- still deadlock occurred after three retries
		END
		ELSE
		BEGIN
			WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
			GOTO RETRY	-- Go to Label RETRY
		END
	END
	ELSE
	BEGIN
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
END               
END CATCH


END --sp_Update7Review_Coaching_Log

GO


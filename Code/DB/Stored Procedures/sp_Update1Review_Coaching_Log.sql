/*
sp_Update1Review_Coaching_Log(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update1Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update1Review_Coaching_Log]
GO

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
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update1Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcReviewSupLanID Nvarchar(20),
      @dtmSupReviewedAutoDate datetime,
	  @nvctxtCoachingNotes Nvarchar(max) 
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
		   SupReviewedAutoDate = @dtmSupReviewedAutoDate,
		   CoachingNotes = @nvctxtCoachingNotes,
		   ReassignCount = 0
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


END --sp_Update1Review_Coaching_Log

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/13/2021
--	Description: *	This procedure allows supervisors to insert or update Quality Now
--  Eval Summary notes to be shared CSRs during review.
--    =====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Quality_Now_Summary]
(
  @nvcFormID BIGINT,
  @nvcEvalSummary Nvarchar(max),
  @nvcUserID Nvarchar(10)
)
AS

BEGIN

DECLARE @RetryCounter INT;
SET @RetryCounter = 1;

RETRY: -- Label RETRY

BEGIN TRANSACTION;

BEGIN TRY

IF EXISTS 
(SELECT * FROM [EC].[Coaching_Log_Quality_Now_Summary] WHERE [CoachingID] = @nvcFormID AND ISNULL([IsReadOnly], 0) <> 1)
		BEGIN
		   UPDATE [EC].[Coaching_Log_Quality_Now_Summary]
		   SET [EvalSummaryNotes]= @nvcEvalSummary
			  ,[LastModifyDate]= GetDate()
			  ,[LastModifyBy]=  @nvcUserID
           WHERE CoachingID = @nvcFormID
		   AND [IsReadOnly]= 0

		END
ELSE
		BEGIN
		INSERT INTO [EC].[Coaching_Log_Quality_Now_Summary] ([CoachingID],[EvalSummaryNotes],[CreateDate],[CreateBy],[LastModifyDate],[LastModifyBy],[IsReadOnly]) 
		VALUES (@nvcFormID
			   ,@nvcEvalSummary
			   ,GetDate()
			   ,@nvcUserID
			   ,GetDate()
			   ,@nvcUserID
			   ,0);
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

END --sp_Update_Review_Coaching_Log_Quality_Now_Summary
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      05/31/2022
--    Description:     This procedure stages a record for each new submission notification.
--    The mailType To, Cc, Subject and Body are captured for each log.
--    Initial Revision. Team Coaching Log Submission. TFS 23273 - 05/31/2022
--    Modified to remove default value for MailType param. TFS 25964 - 01/03/2023
--    =====================================================================
CREATE OR ALTER   PROCEDURE [EC].[sp_InsertInto_Email_Notifications_Stage]
(     @tableRecs MailStageTableType READONLY,
      @nvcMailType Nvarchar(50),
	  @nvcUserID Nvarchar(10)
)

AS
BEGIN

DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


BEGIN TRANSACTION
BEGIN TRY  

-- Stage the Notifications to be sent
 
         INSERT INTO [EC].[Email_Notifications_Stage]
            ([MailType]
           ,[LogID]
           ,[LogName]
           ,[To]
           ,[Cc]
		   ,[From]
		   ,[FromDisplayName]
		   ,[Subject]
           ,[Body]
		   ,[IsHtml]
		   ,[CreateUserID]
		   ,[LastModifyUserID]
      )
SELECT @nvcMailType,
     RECS.LogID, 
	 RECS.LogName,
	 RECS.[To],
	  RECS.[Cc], 
	  RECS.[From],
	  RECS.[FromDisplayName],
	 RECS.[Subject],
	 RECS.[Body],
	 RECS.[IsHtml],
	 @nvcUserID,
	 @nvcUserID
	 FROM  @tableRecs RECS;
	 	 

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
     SELECT @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE()
    
    
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
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
   END
  END CATCH  

  END -- sp_InsertInto_Email_Notifications_Stage
GO



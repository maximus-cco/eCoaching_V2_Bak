
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      05/31/2022
--    Description:     This procedure is used by the Notifications app to query the staged Notifications for 
--                     actually sending them out.
--    History:
--    Initial Revision. Team Coaching Log Submission. TFS 23273 - 05/31/2022
--    Updated to add MailType to the Return. TFS 25964 - 01/03/2023
--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Get_Staged_Notifications]
   
AS
BEGIN
   
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


BEGIN TRANSACTION
BEGIN TRY 

-- Get Notifications with Missing attributes
       IF OBJECT_ID(N'tempdb..#move') IS NOT NULL
		BEGIN
		DROP TABLE #move;
		END
		
		CREATE TABLE #move (MailID int primary key);
		INSERT INTO #move
		SELECT [MailID] from [EC].[Email_Notifications_Stage]
		WHERE ISNULL([To], '') = '';

-- Record Notifications with missing attributes in Mail History Table
		 INSERT INTO [EC].[Email_Notifications_History]
            ([MailType]
           ,[LogID]
           ,[LogName]
           ,[To]
           ,[Cc]
           ,[SendAttemptDate]
           ,[Success]
		   ,[CreateUserID]
      )
			 SELECT [MailType],[LogID],[LogName],[To],[Cc],GetDate() ,0,'999999'
			 FROM [EC].[Email_Notifications_Stage]
			 WHERE [MailID] IN (SELECT MailID FROM #move);

-- Delete Notifications with missing attributes
	DELETE ens
	FROM [EC].[Email_Notifications_Stage] ens INNER JOIN [EC].[Email_Notifications_History] ehs
	ON ens.LogID = ehs.LogID 
	WHERE ISNULL(ens.[To],'') = '' AND ens.MailID IN (SELECT MailID FROM #move);

-- Get Top 100 Open Notifications
       IF OBJECT_ID(N'tempdb..#open') IS NOT NULL
		BEGIN
		DROP TABLE #open;
		END
		
		CREATE TABLE #open (MailID int primary key)

		INSERT INTO #open
		SELECT TOP 100 [MailID] from [EC].[Email_Notifications_Stage]
		 WHERE [InProcess] = 0
		 AND [SendAttemptCount] <= 3
		

   --Return Open Notifications for app to send
 
        SELECT [MailID]
			  ,[MailType]
		      ,[LogID]
              ,[LogName]
			  ,[To]
			  ,[Cc] 
			  ,[From]
			  ,[FromDisplayName]
		      ,[Subject]
			  ,[Body]
			  ,[IsHtml]
			  ,[MailType]
	  FROM [EC].[Email_Notifications_Stage]
	  WHERE [MailID] IN (SELECT MailID FROM #open)
	  ORDER BY [CreateDate];

	  --Set selected Notifications to processing

	  UPDATE [EC].[Email_Notifications_Stage]
	  SET [InProcess] = 1
	  WHERE [MailID] IN (SELECT MailID FROM #open);

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

  END -- sp_Get_Staged_Notifications
GO



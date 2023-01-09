SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      11/08/2021
--    Description:     This procedure inserts a record for each Notification attempt made from UI.
--    The mailTypem To, Cc, Success Flag and Attempt DateTime are captured for each log.
--    History 
--    Initial Revision. Team Coaching Log Submission. TFS 23273 - 05/31/2022
--    Modified to remove MailType param and use value from tabletype. TFS 25964 - 01/03/2023
--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Email_Notifications_History]
(     @tableRecs MailHistoryTableType READONLY,
	  @nvcUserID Nvarchar(10)
)
   
AS
BEGIN
   
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


BEGIN TRANSACTION
BEGIN TRY  

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

DECLARE @inserted AS TABLE (LogID bigint);

-- Log the results of the Notification attempts
 
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
	 OUTPUT inserted.LogID INTO @inserted
     SELECT RECS.MailType, RECS.LogID, RECS.LogName,
	 RECS.[To],
	 RECS.[Cc], 
	 RECS.SendAttemptDate, RECS.Success, @nvcUserID
	 FROM @tableRecs RECS;

 -- Update SendAttemptDate,SendAttemptCount and InProcess flag in Staging table

 	 UPDATE [EC].[Email_Notifications_Stage]
	 SET SendAttemptDate = RECS.SendAttemptDate
	 ,[SendAttemptCount] = [SendAttemptCount] + 1
	 ,[InProcess] = 0
	 ,LastModifyDate = GetDate()
	 ,LastModifyUserID =  @nvcUserID 
	 FROM [EC].[Email_Notifications_Stage] es INNER JOIN @tableRecs RECS ON
     es.LogID = RECS.LogID AND es.LogName = RECS.LogName;

	-- Delete Successfully Sent Emails and those Exceeding an Attempt Count of 3

	DELETE ens
	FROM [EC].[Email_Notifications_Stage] ens INNER JOIN [EC].[Email_Notifications_History] ehs
	ON ens.LogID = ehs.LogID AND ens.SendAttemptDate = ehs.SendAttemptDate
	WHERE (ens.SendAttemptCount >= 3  OR ehs.Success = 1 OR ISNULL(ens.[To],'') = '');


 -- Return the list of logged Notification attempts for the transaction
          
 Select mh.[LogID], mh.[LogName], 
        mh.[To],
		mh.[Cc],
		mh.[SendAttemptDate],
		mh.[Success]
 FROM [EC].[Email_Notifications_History]  mh INNER JOIN  @inserted i
 ON mh.LogID = i.LogID;


 CLOSE SYMMETRIC KEY [CoachingKey];

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

  END -- sp_InsertInto_Email_Notifications_History
GO



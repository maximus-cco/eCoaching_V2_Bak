IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Email_Notifications_History' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Email_Notifications_History]
GO

	
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      11/08/2021
--    Description:     This procedure inserts a record for each Notification attempt made from UI.
--    The mailTypem To, Cc, Success Flag and Attempt DateTime are captured for each log.
--    Last Modified Date: 
--    Last Updated By: 

--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Email_Notifications_History]
(     @tableRecs MailHistoryTableType READONLY,
      @nvcMailType Nvarchar(50) = N'UI-Submissions'
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

DECLARE @inserted AS TABLE (CoachingID bigint);

-- Log the results of the Notification attempts
 
         INSERT INTO [EC].[Email_Notifications_History]
            ([MailType]
           ,[CoachingID]
           ,[FormName]
           ,[To]
           ,[Cc]
           ,[SendAttemptDate]
           ,[Success]
      )
	 OUTPUT inserted.CoachingID INTO @inserted
     SELECT @nvcMailType, CL.CoachingID, RECS.FormName,
	 EncryptByKey(Key_GUID('CoachingKey'), RECS.[To]),
	 EncryptByKey(Key_GUID('CoachingKey'), RECS.[Cc]), 
	 RECS.SendAttemptDate, RECS.Success
	 FROM [EC].[Coaching_Log] CL JOIN @tableRecs RECS ON
     CL.FormName = RECS.FormName;

 -- Return the list of logged Notification attempts for the transaction
          
 Select mh.[CoachingID], mh.[FormName], 
        CONVERT(nvarchar(50),DecryptByKey(mh.[To])) AS [To],
		CONVERT(nvarchar(50),DecryptByKey(mh.[Cc])) AS [Cc],
		mh.[SendAttemptDate],
		mh.[Success]
 FROM [EC].[Email_Notifications_History]  mh INNER JOIN  @inserted i
 ON mh.CoachingID = i.CoachingID;


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







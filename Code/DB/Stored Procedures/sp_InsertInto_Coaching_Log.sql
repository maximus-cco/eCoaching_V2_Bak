/*
sp_InsertInto_Coaching_Log(03).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla

Version 03: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      02/03/2014
--    Description:     This procedure inserts the e-Coaching records into the Coaching_Log table. 
--                     The main attributes of the eCL are written to the Coaching_Log table.
--                     The Coaching Reasons are written to the Coaching_Reasons Table.
-- Last Modified Date: 07/23/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per TFS 363/402 to update formname from CoachingID after insert. 
-- Modified to support Encryption of sensitive data. Open key and removed LanID. TFS 7856 - 10/23/2017
-- Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log]
(     @nvcEmpID Nvarchar(10),
      @nvcProgramName Nvarchar(50),
      @intSourceID INT,
      --@intStatusID INT,
      @SiteID INT,
      @nvcSubmitterID Nvarchar(10),
      @dtmEventDate datetime,
      @dtmCoachingDate datetime,
      @bitisAvokeID bit  ,
      @nvcAvokeID Nvarchar(40) ,
      @bitisNGDActivityID bit,
      @nvcNGDActivityID Nvarchar(40) ,
      @bitisUCID bit,
      @nvcUCID Nvarchar(40),
      @bitisVerintID bit,
      @nvcVerintID Nvarchar(255),
      @intCoachReasonID1 INT,
      @nvcSubCoachReasonID1 Nvarchar(255),
      @nvcValue1 Nvarchar(30),
      @intCoachReasonID2 INT ,
      @nvcSubCoachReasonID2 Nvarchar(255),
      @nvcValue2 Nvarchar(30),
      @intCoachReasonID3 INT ,
      @nvcSubCoachReasonID3 Nvarchar(255),
      @nvcValue3 Nvarchar(30),
      @intCoachReasonID4 INT ,
      @nvcSubCoachReasonID4 Nvarchar(255) ,
      @nvcValue4 Nvarchar(30),
      @intCoachReasonID5 INT,
      @nvcSubCoachReasonID5 Nvarchar(255),
      @nvcValue5 Nvarchar(30),
      @intCoachReasonID6 INT,
      @nvcSubCoachReasonID6 Nvarchar(255),
      @nvcValue6 Nvarchar(30),
      @intCoachReasonID7 INT,
      @nvcSubCoachReasonID7 Nvarchar(255),
      @nvcValue7 Nvarchar(30),
      @intCoachReasonID8 INT,
      @nvcSubCoachReasonID8 Nvarchar(255),
      @nvcValue8 Nvarchar(30),
      @intCoachReasonID9 INT,
      @nvcSubCoachReasonID9 Nvarchar(255),
      @nvcValue9 Nvarchar(30),
      @intCoachReasonID10 INT,
      @nvcSubCoachReasonID10 Nvarchar(255),
      @nvcValue10 Nvarchar(30),
      @intCoachReasonID11 INT,
      @nvcSubCoachReasonID11 Nvarchar(255),
      @nvcValue11 Nvarchar(30),
      @intCoachReasonID12 INT,
      @nvcSubCoachReasonID12 Nvarchar(255),
      @nvcValue12 Nvarchar(30),
      @nvcDescription Nvarchar(3000) ,
      @nvcCoachingNotes Nvarchar(3000) ,
      @bitisVerified bit  ,
      @dtmSubmittedDate datetime ,
      @dtmStartDate datetime ,
      @dtmSupReviewedAutoDate datetime ,
      @bitisCSE bit  ,
      @dtmMgrReviewManualDate datetime ,
      @dtmMgrReviewAutoDate datetime ,
      @nvcMgrNotes Nvarchar(3000) ,
      @bitisCSRAcknowledged bit  ,
      @dtmCSRReviewAutoDate datetime ,
      @nvcCSRComments Nvarchar(3000),
      @bitEmailSent bit ,
      @ModuleID INT,
      @Behaviour Nvarchar(30),
      @nvcNewFormName Nvarchar(50)OUTPUT
      )
   
AS
BEGIN
   
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
    --	Fetch the Employee ID of the current User (@nvcCSR) and Employee ID of the Submitter (@nvcSubmitter).

	DECLARE 
	        --@nvcEmpID Nvarchar(10),
	        --@nvcSubmitterID	Nvarchar(10),
	        @nvcSupID Nvarchar(10),
	        @nvcMgrID Nvarchar(10),
	        @nvcNotPassedSiteID INT
	        --@dtmDate datetime
	        
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]  
	        
	        
	--SET @dtmDate  = GETDATE()   
	--SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanID,@dtmDate)
	--SET @nvcSubmitterID = EC.fn_nvcGetEmpIdFromLanID(@nvcSubmitter,@dtmDate)
	SET @nvcNotPassedSiteID = EC.fn_intSiteIDFromEmpID(@nvcEmpID)
    SET @nvcSupID = (SELECT [Sup_ID] FROM [EC].[Employee_Hierarchy]WHERE [Emp_ID]= @nvcEmpID)
    SET @nvcMgrID = (SELECT [Mgr_ID] FROM [EC].[Employee_Hierarchy]WHERE [Emp_ID]= @nvcEmpID)
  
         INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpID]
           ,[SubmitterID]
           ,[EventDate]
           ,[CoachingDate]
           ,[isAvokeID]
           ,[AvokeID]
           ,[isNGDActivityID]
           ,[NGDActivityID]
           ,[isUCID]
           ,[UCID]
           ,[isVerintID]
           ,[VerintID]
           ,[Description]
	       ,[CoachingNotes]
           ,[isVerified]
           ,[SubmittedDate]
           ,[StartDate]
           ,[SupReviewedAutoDate]
           ,[isCSE]
           ,[MgrReviewManualDate]
           ,[MgrReviewAutoDate]
           ,[MgrNotes]
           ,[isCSRAcknowledged]
           ,[CSRReviewAutoDate]
           ,[CSRComments]
           ,[EmailSent]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           ,[Behavior])
     VALUES
           (@nvcEmpID 
           ,@nvcProgramName 
           ,@intSourceID 
           ,[EC].[fn_intStatusIDFromInsertParams](@ModuleID,  @intSourceID, @bitisCSE)
           ,ISNULL(@SiteID,@nvcNotPassedSiteID)
           ,@nvcEmpID 
           ,@nvcSubmitterID
           ,@dtmEventDate 
           ,@dtmCoachingDate 
		   ,@bitisAvokeID 
           ,@nvcAvokeID 
           ,@bitisNGDActivityID 
		   ,@nvcNGDActivityID 
		   ,@bitisUCID 
		   ,@nvcUCID 
		   ,@bitisVerintID 
		   ,@nvcVerintID 
		   ,@nvcDescription 
		   ,@nvcCoachingNotes
           ,@bitisVerified 
		   ,@dtmSubmittedDate 
		   ,@dtmStartDate 
		   ,@dtmSupReviewedAutoDate 
		   ,@bitisCSE 
		   ,@dtmMgrReviewManualDate 
		   ,@dtmMgrReviewAutoDate 
		   ,@nvcMgrNotes 
		   ,@bitisCSRAcknowledged 
		   ,@dtmCSRReviewAutoDate 
		   ,@nvcCSRComments
		   ,@bitEmailSent
		   ,@ModuleID
		   ,ISNULL(@nvcSupID,'999999')
		   ,ISNULL(@nvcMgrID,'999999')
		   ,@Behaviour)
            
 CLOSE SYMMETRIC KEY [CoachingKey] 
            
     --PRINT 'STEP1'
            
    SELECT @@IDENTITY AS 'Identity';
    --PRINT @@IDENTITY
    
    DECLARE @I BIGINT = @@IDENTITY,
            @MaxSubReasonRowID INT,
            @SubReasonRowID INT
       
            
--WAITFOR DELAY '00:00:00:02'  -- Wait for 5 ms

UPDATE [EC].[Coaching_Log]
SET [FormName] = 'eCL-'+[FormName] +'-'+ convert(varchar,CoachingID)
where [CoachingID] = @I  AND [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:01'  -- Wait for 5 ms

SET @nvcNewFormName = (SELECT [FormName] FROM  [EC].[Coaching_Log] WHERE [CoachingID] = @I)

     /*
           IF NOT @intCoachReasonID1 IS NULL
       BEGIN
            INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID1,@intSubCoachReasonID1,
            CASE WHEN @intCoachReasonID1 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID1 = 10 AND @nvcValue1 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID1 = 10 AND @nvcValue1 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue1 END) 
        END
        
        */
    
 IF NOT @intCoachReasonID1 IS NULL
  BEGIN
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ','))
       --PRINT  @MaxSubReasonRowID
       SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
   BEGIN
   
   
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID1,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID1 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID1 = 10 AND @nvcValue1 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID1 = 10 AND @nvcValue1 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue1 END)       
             
		SET @SubReasonRowID = @SubReasonRowID + 1

     END           
  END
 
        
       /*  
        IF NOT @intCoachReasonID2 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID2,@intSubCoachReasonID2,@nvcValue2)
        END 

*/


 IF NOT @intCoachReasonID2 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID2, ','))
  	   SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID2,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID2, ',')where Rowid = @SubReasonRowID )
           ,@nvcValue2)       
         
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END 


  IF NOT @intCoachReasonID3 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID3, ','))
  	   SET @SubReasonRowID = 1

While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID3,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID3, ',')where Rowid = @SubReasonRowID )
           , @nvcValue3)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END      
   
	 IF NOT @intCoachReasonID4 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID4, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID4,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID4, ',')where Rowid = @SubReasonRowID )
           , @nvcValue4)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END  
  
   IF NOT @intCoachReasonID5 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID5, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID5,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID5, ',')where Rowid = @SubReasonRowID )
            ,@nvcValue5)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END     


 IF NOT @intCoachReasonID6 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID6, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID6,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID6, ',')where Rowid = @SubReasonRowID )
           , @nvcValue6) 
                    
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END 
  
  
   IF NOT @intCoachReasonID7 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID7, ','))
 	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID7,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID7, ',')where Rowid = @SubReasonRowID )
        , @nvcValue7)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END 
  
  
  IF NOT @intCoachReasonID8 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID8, ','))
   	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID8,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID8, ',')where Rowid = @SubReasonRowID )
          , @nvcValue8)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
	
    END
  END  
  
  
   IF NOT @intCoachReasonID9 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID9, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID9,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID9, ',')where Rowid = @SubReasonRowID )
          , @nvcValue9)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
	
    END
  END 
  
  
   IF NOT @intCoachReasonID10 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID10, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID10,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID10, ',')where Rowid = @SubReasonRowID )
            , @nvcValue10)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
		
    END
  END 
  
   IF NOT @intCoachReasonID11 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID11, ','))
 	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID11,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID11, ',')where Rowid = @SubReasonRowID )
            , @nvcValue11)        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
	
    END
  END
  
  
   IF NOT @intCoachReasonID12 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID12, ','))
	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID12,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID12, ',')where Rowid = @SubReasonRowID )
            ,@nvcValue12) 
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
    

   
    
  END  
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

  END -- sp_InsertInto_Coaching_Log





GO



/*
sp_InsertInto_Warning_Log(04).sql
Last Modified Date: 06/20/2018
Last Modified By: Susmitha Palacherla

Version 04: Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 06/20/2019
Version 03: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Warning_Log' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Warning_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      10/03/2014
--    Description:     This procedure inserts the Warning records into the Warning_Log table. 
--                     The main attributes of the Warning are written to the warning_Log table.
--                     The Warning Reasons are written to the Warning_Reasons Table.
--  Last Modified By: Susmitha Palacherla
--  Modified  to add Behavior to the insert to support warnings for Training Module - per TFS 861 - 10/21/2015 
 -- Modified to support Encryption of sensitive data. Open key and removed LanID. TFS 7856 - 10/23/2017
 -- Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018.
 -- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 06/20/2019
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Warning_Log]
(     @nvcEmpID Nvarchar(10),
      @nvcProgramName Nvarchar(50),
      @SiteID INT,
      @nvcSubmitterID Nvarchar(10),
      @dtmEventDate datetime,
      @intCoachReasonID1 INT,
      @nvcSubCoachReasonID1 Nvarchar(255),
      @dtmSubmittedDate datetime ,
      @ModuleID INT,
      @nvcBehavior Nvarchar(30),
      @isDup BIT OUTPUT,
      @nvcNewFormName Nvarchar(50) OUTPUT
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
	        --@nvcSubmitterID	Nvarchar(10),
	        @nvcSupID nvarchar(10),
	        @nvcMgrID nvarchar(10),
	        @nvcNotPassedSiteID INT,
	        --@dtmDate datetime,
	        @intWarnIDExists BIGINT
	        
	OPEN SYMMETRIC KEY [CoachingKey]  
    DECRYPTION BY CERTIFICATE [CoachingCert]    
	 	        

	--SET @nvcSubmitterID = EC.fn_nvcGetEmpIdFromLanID(@nvcSubmitter,@dtmDate)
	SET @nvcSupID = (Select Sup_ID from EC.Employee_Hierarchy Where Emp_ID = @nvcEmpID)
	SET @nvcMgrID = (Select Mgr_ID from EC.Employee_Hierarchy Where Emp_ID = @nvcEmpID)  
	SET @nvcNotPassedSiteID = EC.fn_intSiteIDFromEmpID(@nvcEmpID)
	SET @isDup = 1
	
SET @intWarnIDExists = (SELECT WL.WarningID
FROM [EC].[Warning_Log]WL join [EC].[Warning_Log_Reason]WLR
ON WL.WarningID = WLR.WarningID
WHERE WL.[EmpID]= @nvcEmpID
AND WL.[WarningGivenDate]= @dtmEventDate 
AND WLR.[CoachingReasonID] = @intCoachReasonID1
AND WLR.[SubCoachingReasonID]= @nvcSubCoachReasonID1
AND [Active] = 1)


IF @intWarnIDExists IS NULL 
        
 BEGIN 
         INSERT INTO [EC].[Warning_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpID]
           ,[SubmitterID]
           ,[SupID]
           ,[MgrID]
           ,[WarningGivenDate]
           ,[SubmittedDate]
           ,[ModuleID]
           ,[Behavior])
     VALUES
           (@nvcEmpID 
           ,@nvcProgramName 
           ,120
           ,1
           ,ISNULL(@SiteID,@nvcNotPassedSiteID)
           ,@nvcEmpID 
           ,@nvcSubmitterID
           ,@nvcSupID
           ,@nvcMgrID
           ,@dtmEventDate 
	       ,@dtmSubmittedDate 
		   ,@ModuleID
		   ,@nvcBehavior)
            
  CLOSE SYMMETRIC KEY [CoachingKey] 
     
     --PRINT 'STEP1'
            
    SELECT @@IDENTITY AS 'Identity';
    --PRINT @@IDENTITY
    
    DECLARE @I BIGINT = @@IDENTITY,
            @MaxSubReasonRowID INT,
            @SubReasonRowID INT
    
UPDATE [EC].[Warning_Log]
SET [FormName] = 'eCL-M-'+[FormName] +'-'+ convert(varchar,WarningID)
where [WarningID] = @I  AND [FormName] not like 'eCL%'    
OPTION (MAXDOP 1)

WAITFOR DELAY '00:00:00:01'  -- Wait for 5 ms

SET @nvcNewFormName = (SELECT [FormName] FROM  [EC].[Warning_Log] WHERE [WarningID] = @I)


 IF NOT @intCoachReasonID1 IS NULL
  BEGIN
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ','))
       --PRINT  @MaxSubReasonRowID
       SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
   BEGIN
   
   
		INSERT INTO [EC].[Warning_Log_Reason]
            ([WarningID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID1,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ',')where Rowid = @SubReasonRowID ),
             'Opportunity')       
             
		SET @SubReasonRowID = @SubReasonRowID + 1

     END           
  END
 
 SET @isDup = 0
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

  END -- sp_InsertInto_Warning_Log
GO




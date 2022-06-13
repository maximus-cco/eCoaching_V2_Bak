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
 -- Initial Revision. Created during changes to Warnings workflow. TFS 15803 - 10/17/2019
 -- Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
 -- Updated to Support Team Submission. TFS 23273 - 06/07/2022
--    =====================================================================
CREATE OR ALTER   PROCEDURE [EC].[sp_InsertInto_Warning_Log]
(     @tableEmpIDs EmpIdsTableType readonly,
      @nvcProgramName Nvarchar(50),
      @nvcSubmitterID Nvarchar(10),
      @dtmEventDate datetime,
      @intCoachReasonID1 INT,
      @nvcSubCoachReasonID1 Nvarchar(255),
      @dtmSubmittedDate datetime ,
      @ModuleID INT,
      @nvcBehavior Nvarchar(30)
      )
   
AS
BEGIN
   
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
	DECLARE @nvcSupID nvarchar(10),
	        @nvcMgrID nvarchar(10),
	        --@nvcNotPassedSiteID INT,
	        @intWarnIDExists BIGINT;

	DECLARE	@inserted AS TABLE (WarningID bigint);
	        
	OPEN SYMMETRIC KEY [CoachingKey]  
    DECRYPTION BY CERTIFICATE [CoachingCert];   

DROP TABLE IF EXISTS #tEmpRecs;
SELECT * INTO #tEmpRecs FROM @tableEmpIDs;

ALTER TABLE  #tEmpRecs
ADD EmpSiteID int
    ,SupID Nvarchar(10)
	,MgrID Nvarchar(10)
	,ErrorReason Nvarchar(1000);

-- Populate Supervisor and Manager Information
UPDATE t
SET EmpSiteID = EC.fn_intSiteIDFromEmpID(t.EmpID)
    ,SupID = eh.Sup_ID
	,MgrID = eh.Mgr_ID
FROM #tEmpRecs t INNER JOIN EC.Employee_Hierarchy eh
ON t.EmpID = eh.Emp_ID;

-- Perform Validations
/* Add Validations here*/    


SET @intWarnIDExists = (SELECT WL.WarningID
FROM #tEmpRecs T INNER JOIN [EC].[Warning_Log]WL 
ON T.EmpID = WL.EmpID INNER JOIN [EC].[Warning_Log_Reason]WLR
ON WL.WarningID = WLR.WarningID
WHERE WL.[WarningGivenDate]= @dtmEventDate 
AND WLR.[CoachingReasonID] = @intCoachReasonID1
AND WLR.[SubCoachingReasonID]= @nvcSubCoachReasonID1
AND [Active] = 1);

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
		   OUTPUT inserted.WarningID INTO @inserted
     SELECT t.EmpID
           ,@nvcProgramName 
           ,120
           ,4
           ,t.EmpSiteID
           , t.EmpID
           ,@nvcSubmitterID
     	   ,ISNULL(t.SupID,'999999')
		   ,ISNULL(t.MgrID,'999999')
           ,@dtmEventDate 
	       ,@dtmSubmittedDate 
		   ,@ModuleID
		   ,@nvcBehavior
		   	FROM #tEmpRecs t ;
            
  --WAITFOR DELAY '00:00:00:01'  -- Wait for 1 ms       
     
UPDATE [EC].[Warning_Log]
SET [FormName] = 'eCL-M-'+[FormName] +'-'+ convert(varchar,w.WarningID)
FROM EC.Warning_Log w INNER JOIN @inserted i
ON w.WarningID = i.WarningID
WHERE [FormName] not like 'eCL%' ;

 --WAITFOR DELAY '00:00:00:01'  -- Wait for 1 ms     

 -- Warning Log Reason table Inserts 

    DECLARE @MaxSubReasonRowID INT,
            @SubReasonRowID INT;


 IF NOT @intCoachReasonID1 IS NULL
  BEGIN
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ','))
       --PRINT  @MaxSubReasonRowID
       SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
   BEGIN
   
   
		INSERT INTO [EC].[Warning_Log_Reason]
            ([WarningID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT WarningID, @intCoachReasonID1,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ',')where Rowid = @SubReasonRowID ),
             'Opportunity'
			 FROM  @inserted;         
             
		SET @SubReasonRowID = @SubReasonRowID + 1;

     END           
  END

   --WAITFOR DELAY '00:00:00:01'  -- Wait for 1 ms

-- Return Inserted Row
SELECT w.[WarningID] LogID,
       w.[FormName] LogName,
	   w.EmpID EmployeeID,
       veh.Emp_Name EmployeeName,
	   FORMAT (w.[SubmittedDate], 'MM/dd/yyyy hh:mm:ss tt') + N' EST' CreateDateTime,
	   veh.Emp_Email EmpEmail,
		veh.Sup_Email SupEmail,
		veh.Mgr_Email MgrEmail,
	   '' ErrorReason
FROM EC.Warning_Log w INNER JOIN @inserted i
ON w.WarningID = i.WarningID INNER JOIN EC.Employee_Hierarchy eh
ON w.EmpID = eh.Emp_ID INNER JOIN EC.View_Employee_Hierarchy veh
ON eh.Emp_ID = veh.Emp_ID;

 END 
 
 ELSE

 -- Return Not Inserted Row
 BEGIN
 SELECT '-1' LogID, '-1' LogName, t.EmpID EmployeeID,
 eh.Emp_Name EmployeeName, '' CreateDateTime,
 	   	'' EmpEmail,
		'' SupEmail,
		'' MgrEmail,
 'An Active Warning Log for the Given Warning Reason Exists for Employee ' + t.EmpID + ' (' + eh.Emp_Name + ').'  AS ErrorReason
 FROM #tEmpRecs t INNER JOIN EC.View_Employee_Hierarchy eh
ON t.EmpID = eh.Emp_ID;
END

 CLOSE SYMMETRIC KEY [CoachingKey] ;

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



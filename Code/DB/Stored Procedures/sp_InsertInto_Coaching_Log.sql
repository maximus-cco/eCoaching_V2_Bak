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
-- Updated to add 'M' to Formnames to indicate Maximus ID - TFS 13777 - 05/29/2019
-- Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
-- Updated to support special handling for WAH- Return to Site - TFS 18255 - 08/27/2020
-- Updated to support New Coaching Reason for Quality - TFS 23051 - 09/29/2021
-- Updated to remove EmailSent parameter. TFS 23389 - 11/08/2021
-- Updated to Support Team Submission. TFS 23273 - 06/07/2022
-- Updated to fix Value Translation bug for Quality Subcoaching Reason. TFS 25250 - 8/29/2022
--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_InsertInto_Coaching_Log]
(     @tableEmpIDs EmpIdsTableType readonly,
      @nvcProgramName Nvarchar(50),
      @intSourceID INT,
      --@SiteID INT,
      @nvcSubmitterID Nvarchar(10),
      @dtmEventDate datetime,
      @dtmCoachingDate datetime,
      @bitisAvokeID bit,
      @nvcAvokeID Nvarchar(40),
      @bitisNGDActivityID bit,
      @nvcNGDActivityID Nvarchar(40),
      @bitisUCID bit,
      @nvcUCID Nvarchar(40),
      @bitisVerintID bit,
      @nvcVerintID Nvarchar(255),
      @intCoachReasonID1 INT,
      @nvcSubCoachReasonID1 Nvarchar(255),
      @nvcValue1 Nvarchar(30),
      @intCoachReasonID2 INT,
      @nvcSubCoachReasonID2 Nvarchar(255),
      @nvcValue2 Nvarchar(30),
      @intCoachReasonID3 INT,
      @nvcSubCoachReasonID3 Nvarchar(255),
      @nvcValue3 Nvarchar(30),
      @intCoachReasonID4 INT,
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
      @nvcCoachingNotes Nvarchar(3000),
      @bitisVerified bit ,
      @dtmSubmittedDate datetime,
      @dtmStartDate datetime,
      @bitisCSE bit,
      @ModuleID INT,
      @Behaviour Nvarchar(30),
	  @bitisFollowupRequired bit,
	  @dtmFollowupDueDate datetime,
	  @dtmPFDCompletedDate datetime
       )
   
AS
BEGIN
   
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY

BEGIN TRANSACTION
BEGIN TRY
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  --- May be snapshot isolation for longer reporting queries


	DECLARE @nvcSupID Nvarchar(10),
	        @nvcMgrID Nvarchar(10),
	        @nvcNotPassedSiteID INT,
			@isWAHReturnToSite bit,
			@SubCoachingSource nvarchar(100);
	DECLARE	@inserted AS TABLE (CoachingID bigint,EmpID Nvarchar(10));
	       
	        
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]; 

DROP TABLE IF EXISTS #tEmpRecs;
SELECT * INTO #tEmpRecs FROM @tableEmpIDs;

ALTER TABLE  #tEmpRecs
ADD EmpSiteID int
    ,SupID Nvarchar(10)
	,MgrID Nvarchar(10)
	,ErrorReason Nvarchar(1000);

-- Populate Site, Supervisor and Manager Information
UPDATE t
SET EmpSiteID = EC.fn_intSiteIDFromEmpID(t.EmpID)
    ,SupID = eh.Sup_ID
	,MgrID = eh.Mgr_ID
FROM #tEmpRecs t INNER JOIN EC.Employee_Hierarchy eh
ON t.EmpID = eh.Emp_ID;

-- Perform Validations
/* Add Validations here*/

UPDATE #tEmpRecs
SET [ErrorReason] = N'Employee Not found in Hierarchy table.'
WHERE EmpID NOT IN
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy])
AND [ErrorReason] is NULL;
	        

	SET @SubCoachingSource = (SELECT SubCoachingSource from EC.DIM_Source WHERE SourceID = @intSourceID); 
	SET @isWAHReturnToSite = (CASE WHEN (@intCoachReasonID1 = 63 OR @intCoachReasonID2= 63 OR @intCoachReasonID3 = 63 OR @intCoachReasonID4= 63
	OR @intCoachReasonID5= 63 OR @intCoachReasonID6 = 63 OR @intCoachReasonID7= 63 OR @intCoachReasonID8= 63 OR @intCoachReasonID9 = 63 OR @intCoachReasonID10= 63
	OR @intCoachReasonID11= 63 OR @intCoachReasonID12 = 63) THEN 1 ELSE 0 END); 
  
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
           ,[isCSE]
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           ,[Behavior]
		   ,[IsFollowupRequired]
		   ,[FollowupDueDate]
		   ,PFDCompletedDate)
	 OUTPUT inserted.CoachingID, inserted.EmpID INTO @inserted
     SELECT t.EmpID
           ,@nvcProgramName 
           ,CASE WHEN @isWAHReturnToSite = 1 THEN [EC].[fn_intSourceIDFromSource]('Direct', @SubCoachingSource) ELSE @intSourceID END
           ,CASE WHEN @isWAHReturnToSite = 1 THEN 4 ELSE [EC].[fn_intStatusIDFromInsertParams](@ModuleID,  @intSourceID, @bitisCSE)END
	      ,t.EmpSiteID
		   ,t.EmpID
           ,@nvcSubmitterID
           ,CASE WHEN @isWAHReturnToSite = 1 THEN NULL ELSE @dtmEventDate END 
           ,CASE WHEN @isWAHReturnToSite = 1 THEN COALESCE(@dtmEventDate, @dtmCoachingDate) ELSE @dtmCoachingDate END
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
		   ,@bitisCSE 
		   ,@ModuleID
		   ,ISNULL(t.SupID,'999999')
		   ,ISNULL(t.MgrID,'999999')
		   ,@Behaviour
		   ,@bitisFollowupRequired
		   ,@dtmFollowupDueDate
		   ,@dtmPFDCompletedDate
	FROM #tEmpRecs t
	WHERE t.ErrorReason is NULL;
            
           
--WAITFOR DELAY '00:00:00:02'  -- Wait for 5 ms

-- Generate FormName from EmpID and CoachingID

UPDATE c
SET [FormName] = 'eCL-M-'+[FormName] +'-'+ convert(varchar,c.CoachingID)
FROM EC.Coaching_Log c INNER JOIN @inserted i
ON c.CoachingID = i.CoachingID
WHERE [FormName] not like 'eCL%' ;  


-- Coaching Log Reason table Inserts 

WAITFOR DELAY '00:00:00:01'  -- Wait for 1 ms
    
    DECLARE @MaxSubReasonRowID INT,
            @SubReasonRowID INT;
       
-- Coaching Reason 1 and associated Subcoaching Reason and Values
 IF NOT @intCoachReasonID1 IS NULL
  BEGIN
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ','))
       --PRINT  @MaxSubReasonRowID
       SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
   BEGIN
   
   
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID1,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID1, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID1 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID1 = 10 AND @nvcValue1 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID1 = 10 AND @nvcValue1 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue1 END FROM  @inserted;     
             
		SET @SubReasonRowID = @SubReasonRowID + 1

     END           
  END

 -- Coaching Reason 2 and associated Subcoaching Reason and Values
 IF NOT @intCoachReasonID2 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID2, ','))
  	   SET @SubReasonRowID = 1
	

While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
					INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID2,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID2, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID2 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID2 = 10 AND @nvcValue2 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID2 = 10 AND @nvcValue2 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue2 END FROM  @inserted;     
         
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END 

  -- Coaching Reason 3 and associated Subcoaching Reason and Values
  IF NOT @intCoachReasonID3 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID3, ','))
  	   SET @SubReasonRowID = 1

While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID3,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID3, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID3 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID3 = 10 AND @nvcValue3 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID3 = 10 AND @nvcValue3 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue3 END FROM  @inserted;      
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END  
  -- Coaching Reason 4 and associated Subcoaching Reason and Values
   
	 IF NOT @intCoachReasonID4 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID4, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID4,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID4, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID4 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID4 = 10 AND @nvcValue4 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID4 = 10 AND @nvcValue4 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue4 END FROM  @inserted;       
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END  

-- Coaching Reason 5 and associated Subcoaching Reason and Values  
   IF NOT @intCoachReasonID5 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID5, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID5,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID5, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID5 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID5 = 10 AND @nvcValue5 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID5 = 10 AND @nvcValue5 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue5 END FROM  @inserted;     
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END     

-- Coaching Reason 6 and associated Subcoaching Reason and Values
 IF NOT @intCoachReasonID6 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID6, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID6,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID6, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID6 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID6 = 10 AND @nvcValue6 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID6 = 10 AND @nvcValue6 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue6 END FROM  @inserted; 
                    
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END 
  
  -- Coaching Reason 7 and associated Subcoaching Reason and Values
   IF NOT @intCoachReasonID7 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID7, ','))
 	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID7,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID7, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID7 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID7 = 10 AND @nvcValue7 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID7 = 10 AND @nvcValue7 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue7 END FROM  @inserted;    
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END
  END 
  
 -- Coaching Reason 8 and associated Subcoaching Reason and Values 
  IF NOT @intCoachReasonID8 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID8, ','))
   	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID8,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID8, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID8 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID8 = 10 AND @nvcValue8 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID8 = 10 AND @nvcValue8 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue8 END FROM  @inserted;     
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
	
    END
  END  
  
  -- Coaching Reason 9 and associated Subcoaching Reason and Values
   IF NOT @intCoachReasonID9 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID9, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID9,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID9, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID9 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID9 = 10 AND @nvcValue9 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID9 = 10 AND @nvcValue9 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue9 END FROM  @inserted;        
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
	
    END
  END 
  
  -- Coaching Reason 10 and associated Subcoaching Reason and Values
   IF NOT @intCoachReasonID10 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID10, ','))
       SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID10,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID10, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID10 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID10 = 10 AND @nvcValue10 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID10 = 10 AND @nvcValue10 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue10 END FROM  @inserted;     
             
      	SET @SubReasonRowID = @SubReasonRowID + 1
		
    END
  END 
  
  -- Coaching Reason 11 and associated Subcoaching Reason and Values
   IF NOT @intCoachReasonID11 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID11, ','))
 	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN

		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID11,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID11, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID11 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID11 = 10 AND @nvcValue11 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID11 = 10 AND @nvcValue11 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue11 END FROM  @inserted; 

      	SET @SubReasonRowID = @SubReasonRowID + 1
	
    END
  END
  
 -- Coaching Reason 12 and associated Subcoaching Reason and Values 
   IF NOT @intCoachReasonID12 IS NULL  
    BEGIN
        
       SET @MaxSubReasonRowID = (Select MAX(RowID) FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID12, ','))
	   SET @SubReasonRowID = 1


While @SubReasonRowID <= @MaxSubReasonRowID 
    BEGIN
		INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             SELECT CoachingID, @intCoachReasonID12,
            (Select Item FROM [EC].[fnSplit_WithRowID]( @nvcSubCoachReasonID12, ',')where Rowid = @SubReasonRowID ),
             CASE WHEN @intCoachReasonID12 = 6 THEN 'Opportunity'
                 WHEN (@intCoachReasonID12 = 10 AND @nvcValue12 = 'Opportunity') THEN 'Did Not Meet Goal'
                 WHEN (@intCoachReasonID12 = 10 AND @nvcValue12 = 'Reinforcement') THEN 'Met Goal'
             ELSE @nvcValue12 END FROM  @inserted; 
             
      	SET @SubReasonRowID = @SubReasonRowID + 1

    END    
  END  

 WAITFOR DELAY '00:00:00:01'  -- Wait for 1 ms

 -- Return Inserted Log Details

-- Coaching Logs Inserted
SELECT c.[CoachingID] LogID,
       c.[FormName] LogName,
	   c.EmpID EmployeeID,
       veh.Emp_Name EmployeeName,
	   --CONVERT( VARCHAR(24), c.[SubmittedDate], 121)CreateDateTime
	    --FORMAT (c.[SubmittedDate], 'yyyy-MM-dd hh:mm:ss') CreateDateTime
		FORMAT (c.[SubmittedDate], 'MM/dd/yyyy hh:mm:ss tt') + N' EST' CreateDateTime,
		veh.Emp_Email EmpEmail,
		veh.Sup_Email SupEmail,
		veh.Mgr_Email MgrEmail,
	   '' ErrorReason
FROM EC.Coaching_Log c INNER JOIN @inserted i
ON c.CoachingID = i.CoachingID INNER JOIN EC.Employee_Hierarchy eh
ON c.EmpID = eh.Emp_ID INNER JOIN EC.View_Employee_Hierarchy veh
ON eh.Emp_ID = veh.Emp_ID

UNION

-- Return Not Inserted Log Details

SELECT '-1' LogID,
       '-1' LogName,
	   t.EmpID EmployeeID,
	   CONVERT(nvarchar(70),DecryptByKey(Emp_Name)) EmployeeName,
	   '' CreateDateTime,
	   	'' EmpEmail,
		'' SupEmail,
		'' MgrEmail,
	   t.ErrorReason
FROM #tEmpRecs t  LEFT JOIN EC.Employee_Hierarchy eh
ON t.EmpID = eh.Emp_ID 
WHERE t.EmpID NOT IN (Select EmpID FROM @inserted);


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

  END -- sp_InsertInto_Coaching_Log
GO



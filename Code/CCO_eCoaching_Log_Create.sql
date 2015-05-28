/*
eCoaching_Log_Create(01).sql
Last Modified Date: 04/03/2014
Last Modified By: Susmitha Palacherla



Version 01: Initial Revision 

Summary

Tables
1. [EC].[Coaching_Log]
2. [EC].[Coaching_Log_Reason]

Procedures
1. [EC].[sp_InsertInto_Coaching_Log]
2. [EC].[sp_SelectRecordStatus]
3. [EC].[sp_SelectCSRsbyLocation]
4. [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted]
5. [EC].[sp_SelectFrom_Coaching_Log_CSRPending]
6. [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP]
7. [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted]
8. [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending]
9. [EC].[sp_SelectFrom_Coaching_Log_MGRPending]
10. [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff]
11. [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff]
12.  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard]
13. [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR]
14. [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP]
15. [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted]
16. [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending]
17.  [EC].[sp_SelectFrom_Coaching_Log_SUPPending]
18. [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted]
19. [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2]
20.  [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted]
21. [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2]
22. [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted]
23. [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2]
24. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]
25. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted]
26. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam]
27. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted]
28. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted]
29. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP]
30. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted]
31. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam]
32. [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted]
33. [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted]
34. [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted]
35. [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted]
36. [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted]
37. [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted]
38. [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]
39.[EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR]
40. [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam]
41.[EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted]
42. [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR]
43.[EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]
44.[EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP]
45.[EC].[sp_SelectReviewFrom_Coaching_Log]
46. [EC].[sp_Update1Review_Coaching_Log]
47.[EC].[sp_Update2Review_Coaching_Log]
48. [EC].[sp_Update3Review_Coaching_Log]
49.[EC].[sp_Update4Review_Coaching_Log]
50. [EC].[sp_Update5Review_Coaching_Log]
51.[EC].[sp_Update6Review_Coaching_Log]
52.[EC].[sp_Update7Review_Coaching_Log]
53.[EC].[sp_Whoami]
54.[EC].[sp_Whoisthis]



*/


 --Details

**************************************************************
--Tables
**************************************************************

--1. Create Table  [EC].[Coaching_Log]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log](
	[CoachingID] [bigint] IDENTITY(1,1) NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[ProgramName] [nvarchar](50) NULL,
	[SourceID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	[CSR] [nvarchar](50) NOT NULL,
	[CSRID] [nvarchar](10) NOT NULL,
	[SubmitterID] [nvarchar](10) NULL,
	[EventDate] [datetime] NULL,
	[CoachingDate] [datetime] NULL,
	[isAvokeID] [bit] NULL,
	[AvokeID] [nvarchar](40) NULL,
	[isNGDActivityID] [bit] NULL,
	[NGDActivityID] [nvarchar](40) NULL,
	[isUCID] [bit] NULL,
	[UCID] [nvarchar](40) NULL,
	[isVerintID] [bit] NULL,
	[VerintID] [nvarchar](40) NULL,
	[VerintEvalID] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[CoachingNotes] [nvarchar](4000) NULL,
	[isVerified] [bit] NULL,
	[SubmittedDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[SupReviewedAutoDate] [datetime] NULL,
	[isCSE] [bit] NULL,
	[MgrReviewManualDate] [datetime] NULL,
	[MgrReviewAutoDate] [datetime] NULL,
	[MgrNotes] [nvarchar](3000) NULL,
	[isCSRAcknowledged] [bit] NULL,
	[CSRReviewAutoDate] [datetime] NULL,
	[CSRComments] [nvarchar](3000) NULL,
	[EmailSent] [bit] NULL,
	[numReportID] [int] NULL,
	[strReportCode] [nvarchar](30) NULL,
	[isCoachingRequired] [bit] NULL,
	[strReasonNotCoachable] [nvarchar](30) NULL,
	[txtReasonNotCoachable] [nvarchar](3000) NULL,
 CONSTRAINT [PK_Coaching_Log] PRIMARY KEY CLUSTERED 
(
	[CoachingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Coaching_Log] ADD  DEFAULT ((0)) FOR [EmailSent]
GO


ALTER TABLE [EC].[Coaching_Log]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingSourceID] FOREIGN KEY([SourceID])
REFERENCES [EC].[Dim_Source] ([SourceID])
GO

ALTER TABLE [EC].[Coaching_Log] CHECK CONSTRAINT [fkCoachingSourceID]
GO


ALTER TABLE [EC].[Coaching_Log]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingStatusID] FOREIGN KEY([StatusID])
REFERENCES [EC].[Dim_Status] ([StatusID])
GO

ALTER TABLE [EC].[Coaching_Log] CHECK CONSTRAINT [fkCoachingStatusID]
GO

ALTER TABLE [EC].[Coaching_Log]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingSiteID] FOREIGN KEY([SiteID])
REFERENCES [EC].[Dim_Site] ([SiteID])
GO

ALTER TABLE [EC].[Coaching_Log] CHECK CONSTRAINT [fkCoachingSiteID]
GO



**************************************************************

--2. Create Table  [EC].[Coaching_Log_Reason]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Reason](
	[CoachingID] [bigint] NOT NULL,
	[CoachingReasonID] [bigint] NOT NULL,
	[SubCoachingReasonID] [bigint] NOT NULL,
	[Value] [nvarchar](30) NULL,
 CONSTRAINT [PK_Coaching_Log_Reason] PRIMARY KEY CLUSTERED 
(
	[CoachingID] ASC,
	[CoachingReasonID] ASC,
	[SubCoachingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Coaching_Log_Reason] WITH NOCHECK ADD  CONSTRAINT [fkCoachingID] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log] ([CoachingID])
GO

ALTER TABLE [EC].[Coaching_Log_Reason] CHECK CONSTRAINT [fkCoachingID]
GO

**************************************************************



**************************************************************

--Procedures

**************************************************************

--1. Create SP  [EC].[sp_InsertInto_Coaching_Log]

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
--
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log]
(     @nvcFormName Nvarchar(50),
      @nvcCSR Nvarchar(40),
      @nvcProgramName Nvarchar(50),
      @intSourceID INT,
      @intStatusID INT,
      @SiteID INT,
      @nvcSubmitter Nvarchar(40),
      @dtmEventDate datetime,
      @dtmCoachingDate datetime,
      @bitisAvokeID bit  ,
      @nvcAvokeID Nvarchar(40)= NULL ,
      @bitisNGDActivityID bit,
      @nvcNGDActivityID Nvarchar(40)= NULL ,
      @bitisUCID bit,
      @nvcUCID Nvarchar(40)= NULL,
      @bitisVerintID bit,
      @nvcVerintID Nvarchar(255)= NULL,
      @intCoachReasonID1 INT,
      @intSubCoachReasonID1 INT,
      @nvcValue1 Nvarchar(30),
      @intCoachReasonID2 INT = NULL,
      @intSubCoachReasonID2 INT = NULL,
      @nvcValue2 Nvarchar(30) = NULL,
      @intCoachReasonID3 INT = NULL,
      @intSubCoachReasonID3 INT = NULL,
      @nvcValue3 Nvarchar(30) = NULL,
      @intCoachReasonID4 INT = NULL,
      @intSubCoachReasonID4 INT = NULL,
      @nvcValue4 Nvarchar(30) = NULL,
      @intCoachReasonID5 INT,
      @intSubCoachReasonID5 INT,
      @nvcValue5 Nvarchar(30),
      @intCoachReasonID6 INT,
      @intSubCoachReasonID6 INT,
      @nvcValue6 Nvarchar(30),
      @intCoachReasonID7 INT,
      @intSubCoachReasonID7 INT,
      @nvcValue7 Nvarchar(30),
      @intCoachReasonID8 INT,
      @intSubCoachReasonID8 INT,
      @nvcValue8 Nvarchar(30),
      @intCoachReasonID9 INT,
      @intSubCoachReasonID9 INT,
      @nvcValue9 Nvarchar(30),
      @intCoachReasonID10 INT,
      @intSubCoachReasonID10 INT,
      @nvcValue10 Nvarchar(30),
      @intCoachReasonID11 INT,
      @intSubCoachReasonID11 INT,
      @nvcValue11 Nvarchar(30),
      @intCoachReasonID12 INT,
      @intSubCoachReasonID12 INT,
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
      @bitEmailSent bit 
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

	DECLARE @nvcEmpID Nvarchar(10),
	        @nvcSubmitterID	Nvarchar(10),
	        @dtmDate datetime
	        
	SET @dtmDate  = GETDATE()   
	SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcCSR,@dtmDate)
	SET @nvcSubmitterID = EC.fn_nvcGetEmpIdFromLanID(@nvcSubmitter,@dtmDate)
        
      
         INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[CSR]
           ,[CSRID]
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
           ,[EmailSent])
     VALUES
           (@nvcFormName
           ,@nvcProgramName 
           ,@intSourceID 
           ,@intStatusID 
           ,@SiteID 
           ,@nvcCSR
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
		   ,@bitEmailSent)
            
    SELECT @@IDENTITY AS 'Identity';
    DECLARE @I BIGINT = @@IDENTITY

        
       IF NOT @intCoachReasonID1 IS NULL
       BEGIN
            INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID1,@intSubCoachReasonID1,
            CASE WHEN @intCoachReasonID1 = 6 THEN 'Opportunity' ELSE @nvcValue1 END) 
        END
         
                  
        IF NOT @intCoachReasonID2 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID2,@intSubCoachReasonID2,@nvcValue2)
        END 


        IF NOT @intCoachReasonID3 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID3, @intSubCoachReasonID3,@nvcValue3)
        END
        
        
        IF NOT @intCoachReasonID4 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID4, @intSubCoachReasonID4,@nvcValue4)
            END
   
             
        IF NOT @intCoachReasonID5 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID5, @intSubCoachReasonID5,@nvcValue5)
        END
        
        
        IF NOT @intCoachReasonID6 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID6, @intSubCoachReasonID6,@nvcValue6)
       END
        
        
        IF NOT @intCoachReasonID7 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID7, @intSubCoachReasonID7,@nvcValue7)
        END
        
              
        IF NOT @intCoachReasonID8 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID8, @intSubCoachReasonID8,@nvcValue8)
        END
        
        
        IF NOT @intCoachReasonID9 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID9, @intSubCoachReasonID9,@nvcValue9)
        END
               
        
        IF NOT @intCoachReasonID10 IS NULL  
        BEGIN
			 INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID10, @intSubCoachReasonID10,@nvcValue10)
       END
         
                       
        IF NOT @intCoachReasonID11 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
            VALUES (@I, @intCoachReasonID11, @intSubCoachReasonID11,@nvcValue11)
        END
                
        IF NOT @intCoachReasonID12 IS NULL  
        BEGIN
			INSERT INTO [EC].[Coaching_Log_Reason]
            ([CoachingID],[CoachingReasonID],[SubCoachingReasonID],[Value])
             VALUES (@I, @intCoachReasonID12, @intSubCoachReasonID12,@nvcValue12)
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


******************************************************************

--2. Create SP  [EC].[sp_SelectRecordStatus]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectRecordStatus' 
)
   DROP PROCEDURE [EC].[sp_SelectRecordStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: 	This procedure selects the status of a record from the Coaching_Log table
--	Last Update:	12/13/13
--  Last Update:    03/05/2014
--  Updated per SCR 12359 to add NOLOCK Hint
--	Last Update:	<3/14/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectRecordStatus] @strFormID nvarchar(50)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT s.Status	strFormStatus
      FROM [EC].[Coaching_Log] cl WITH (NOLOCK),
			[EC].[DIM_Status] s
		Where cl.StatusID = s.StatusID 	
		And cl.FormName = 	'''+@strFormID+''''	
		
EXEC (@nvcSQL)	
	    
END --sp_SelectRecordStatus
GO



******************************************************************

--3. Create SP  [EC].[sp_SelectCSRsbyLocation]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCSRsbyLocation' 
)
   DROP PROCEDURE [EC].[sp_SelectCSRsbyLocation]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	7/16/13
--	Description: *	This procedure selects the CSRs from a table by location
--	Last Modified By:	Susmitha Palacherla
--  Last Modified Date: 09/13/2013
--  Modified per SCR 11095 to selects only records with CSR, SUP and MGR LanIDs not missing.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCSRsbyLocation] 

@strCSRSitein nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strEDate nvarchar(8),
@strRole1 nvarchar(30),
@strRole2 nvarchar(30),
@strRole3 nvarchar(30),
@strRole4 nvarchar(30)


Set @strEDate = '99991231'
Set @strRole1 = 'WACS01'
Set @strRole2 = 'WACS02'
Set @strRole3 = 'WACS03'
Set @strRole4 = '%Engineer%'

SET @nvcSQL = 'SELECT [Emp_Name] + '' ('' + [Emp_LanID] + '') '' + [Emp_Job_Description] as FrontRow1
	  ,[Emp_Name] + ''$'' + [Emp_Email] + ''$'' + [Emp_LanID] + ''$'' + [Sup_Name] + ''$'' + [Sup_Email] + ''$'' + [Sup_LanID] + ''$'' + [Sup_Job_Description] + ''$'' + [Mgr_Name] + ''$'' + [Mgr_Email] + ''$'' + [Mgr_LanID] + ''$'' + [Mgr_Job_Description] as BackRow1, [Emp_Site]
       FROM [EC].[Employee_Hierarchy] WITH (NOLOCK)
where (([Emp_Job_Code] Like '''+@strRole1+''') OR ([Emp_Job_Code] Like '''+@strRole2+''') OR ([Emp_Job_Code] Like '''+@strRole3+''') OR ([Emp_Job_Description] Like '''+@strRole4+''')) 
and [End_Date] = ''99991231''
and [Emp_Site] = '''+@strCSRSitein+'''
and [Emp_LanID]is not NULL and [Sup_LanID] is not NULL and [Mgr_LanID]is not NULL
Order By [Emp_Site] ASC, [Emp_Name] ASC'

EXEC (@nvcSQL)	
	    
END -- sp_SelectCSRsbyLocation
GO

******************************************************************


--4. Create SP  [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted] @strCSRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Emp_LanID] = '''+@strCSRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END -- sp_SelectFrom_Coaching_Log_CSRCompleted
GO


******************************************************************

--5. Create SP  [EC].[sp_SelectFrom_Coaching_Log_CSRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_CSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<07/25/2013>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending] @strCSRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)


 Set @strFormStatus = 'Pending CSR Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Emp_LanID] = '''+@strCSRin+'''
and ([S].[Status] = '''+@strFormStatus+''' or [S].[Status] = '''+@strFormStatus2+''')
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_CSRPending
GO



******************************************************************

--6. Create SP  [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_HistoricalSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	4/30/12
--	Description: *	This procedure selects the CSR e-Coaching completed records to display on SUP historical page
--  Last Update:    03/07/2014 - Updated for ECoachingDev 
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/28/2014> - Adapted for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP] 

@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strIsOpp nvarchar(8),
@strStatusin nvarchar(30), 
@strIsForce nvarchar(8) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
--@strFormStatus2 nvarchar(30),
--@strFormStatus3 nvarchar(30),
--@strFormStatus4 nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8)


Set @strFormStatus = 'Inactive'
--Set @strFormStatus2 = 'Pending CSR Review'
--Set @strFormStatus3 = 'Pending Supervisor Review'
--Set @strFormStatus4 = 'Pending Manager Review'

Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
 

SET @nvcSQL = 'select	 x.strFormID
		,x.strCSRName
		,x.strCSRSupName
		,x.strCSRMgrName
		,x.strFormStatus
		,x.strSource
		,x.SubmittedDate
		,x.strSubmitterName
		,x.numOpportunity
		,x.numReinforcement
from (
SELECT [cl].[FormName]	strFormID
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[s].[Status]		strFormStatus
		,[so].[SubCoachingSource]	strSource
		,[cl].[SubmittedDate]	SubmittedDate
		,[sh].[Emp_Name]	strSubmitterName
		,case when [clr].[Value] = ''Opportunity'' THEN 1 ELSE 0 END numOpportunity
		,case when [clr].[Value] = ''Reinforcement'' THEN 1 ELSE 0 END numReinforcement
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK),
	 [EC].[DIM_Source] so,
	 [EC].[Coaching_Log_Reason] clr,
	 [EC].[DIM_Site] si
WHERE cl.CSRID = eh.Emp_ID
AND cl.StatusID = s.StatusID
AND cl.SubmitterID = sh.EMP_ID 
AND cl.SourceID = so.SourceID
AND cl.CoachingID = clr.CoachingID
AND cl.SiteID = si.SiteID
AND [so].[SubCoachingSource] Like '''+@strSourcein+'''
and [s].[Status] Like '''+@strStatusin+'''
AND ISNULL([eh].[Emp_Name], '' '') LIKE '''+@strCSRin+''' 
AND ISNULL([eh].[Sup_Name], '' '') LIKE '''+@strSUPin+''' 
AND ISNULL([eh].[Mgr_Name], '' '') LIKE '''+@strMGRin+''' 
and ISNULL([si].[City], '' '') LIKE '''+@strCSRSitein+'''
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
and [s].[Status] <> '''+@strFormStatus+'''
) x
where ISNULL(x.numOpportunity, '' '') LIKE '''+@strIsOpp+'''
and ISNULL(x.numReinforcement, '' '') LIKE '''+@strIsForce+'''
Order By x.SubmittedDate DESC'


EXEC (@nvcSQL)	
   
END -- sp_SelectFrom_Coaching_Log_HistoricalSUP


******************************************************************


--7. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/17/2014> - Removed Submitter name from query
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRCompleted] 

@strSourcein nvarchar(100),
@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime
 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8)

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
 

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like  '''+@strCSRSUPin+''' 
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
Order By [cl].[SubmittedDate] DESC'


		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MGRCSRCompleted
GO


******************************************************************

--8. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRCSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/17/2014> - Removed Submitter name from query
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending] 

@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strSourcein nvarchar(100),
@strCSRin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@strFormStatus4 nvarchar(30)

Set @strFormStatus = 'Pending CSR Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Manager Review'
Set @strFormStatus4 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]  
and [eh].[Mgr_LanID] = '''+@strCSRMGRin+'''
and (([S].[Status] = '''+@strFormStatus+''') or ([S].[Status] = '''+@strFormStatus2+''') or ([S].[Status] = '''+@strFormStatus3+''') or ([S].[Status] = '''+@strFormStatus4+'''))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
Order By [SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MGRCSRPending
GO


******************************************************************


--9. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MGRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MGRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Pending Review. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/14/2014> - Per Jourdain Augustin modified the CSR and SUP filters to use the name instead of the LanID
--									and changed the manager and status filters
--	Last Update:	<03/17/2014> - Removed Submitter name from query
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending] 
@strCSRMGRin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRSUPin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)


 Set @strFormStatus = 'Pending Manager Review'
 Set @strFormStatus2 = 'Pending Supervisor Review'
 Set @strFormStatus3 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_LanID] strCSR,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and (([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''' and [S].[Status] = '''+@strFormStatus+''') OR ([eh].[Sup_LanID] =  '''+@strCSRMGRin+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
Order By [SubmittedDate] DESC'


		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MGRPending
GO

******************************************************************


--10. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff]
GO
O

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the support staff's submitted comopleted records from the Coaching_Log table and displayed on dashboard
-- Where the user's LAN is strSubmitter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/11/14> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

 Set @strFormStatus = 'Completed'


SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID
		,[s].[Status]	strFormStatus
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
WHERE cl.CSRID = eh.Emp_ID
AND cl.StatusID = s.StatusID
AND cl.SubmitterID = sh.EMP_ID 
AND sh.Emp_LanID = '''+@strUserin+''' 
AND [eh].[Emp_Name]= '''+@strCSRin+''' 
AND [eh].[Sup_Name]= '''+@strCSRSupin+''' 
AND [eh].[Mgr_Name]= '''+@strCSRMgrin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END--sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff
GO



******************************************************************


--11. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the support staff's submitted pending records from the Coaching_Log table and displayed on dashboard
-- Where the user's LAN is strSubmitter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/11/14> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)


 Set @strFormStatus = 'Pending CSR Review'
 Set @strFormStatus2 = 'Pending Manager Review'
 Set @strFormStatus3 = 'Pending Supervisor Review'



SET @nvcSQL = 'SELECT
		 cl.FormName	strFormID
		,S.Status	strFormStatus
		,eh.Emp_Name	strCSRName
		,eh.Sup_Name	strCSRSupName
		,eh.Mgr_Name	strCSRMgrName
		,cl.SubmittedDate	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strUserin+''' 
and eh.Emp_Name Like '''+@strCSRin+'%''
and eh.Sup_Name Like '''+@strCSRSupin+'%''
and eh.Mgr_Name Like '''+@strCSRMgrin+'%''
and ((S.Status = '''+@strFormStatus+''') or (S.Status = '''+@strFormStatus2+''') or (S.Status = '''+@strFormStatus3+'''))
Order By cl.SubmittedDate DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff
GO



******************************************************************


--12. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the user's recent submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter.
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/11/14> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard] 
@strUserin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[s].[Status]	strFormStatus,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strUserin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'
		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard
GO

******************************************************************

--13. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the Supervisor user's submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint
--	Last Update:	<3/12/14> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30), 
@strStatusin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		eh.[Emp_Name]	strCSRName,
		eh.[Sup_Name]	strCSRSupName,
		eh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
from EC.Coaching_Log cl WITH(NOLOCK),
	EC.Employee_Hierarchy eh,
	EC.DIM_Status s
where cl.StatusID = s.StatusID
and cl.CSRID = eh.Emp_ID
and cl.submitterID = (
select sh.emp_ID
from EC.Employee_Hierarchy sh
where sh.emp_LanID = '''+@strUserin+''')
and eh.[Emp_Name] LIKE '''+@strCSRin+'''
and eh.[Sup_Name] LIKE '''+@strCSRSupin+'''
and eh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
and s.[Status] LIKE '''+@strStatusin+'''
and s.[Status] <> '''+@strFormStatus+'''

Order by cl.[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR
GO



******************************************************************


--14. Create SP  [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the Supervisor user's submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint
--	Last Update:	<3/12/14> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30), 
@strStatusin nvarchar(30) 

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		eh.[Emp_Name]	strCSRName,
		eh.[Sup_Name]	strCSRSupName,
		eh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
from EC.Coaching_Log cl WITH(NOLOCK),
	EC.Employee_Hierarchy eh,
	EC.DIM_Status s
where cl.StatusID = s.StatusID
and cl.CSRID = eh.Emp_ID
and cl.submitterID = (
select sh.emp_ID
from EC.Employee_Hierarchy sh
where sh.emp_LanID = '''+@strUserin+''')
and eh.[Emp_Name] LIKE '''+@strCSRin+'''
and eh.[Sup_Name] LIKE '''+@strCSRSupin+'''
and eh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
and s.[Status] LIKE '''+@strStatusin+'''
and s.[Status] <> '''+@strFormStatus+'''

Order by cl.[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP
GO



******************************************************************

--15. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the SUP e-Coaching records from the Coaching_Log table
-- Where the status is Completed. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/17/2014> - Removed Submitter name from query
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRCompleted] 
@strSourcein nvarchar(100),
@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime


AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8)

Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Sup_LanID] =  '''+@strCSRSUPin+''' 
and [eh].[Mgr_Name] Like '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
Order By [cl].[SubmittedDate] DESC'

	
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_SUPCSRCompleted
GO



******************************************************************


--16. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPCSRPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<07/28/2013>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
--	Last Update:	<3/14/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/17/2014> - Removed Submitter name from query
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending] 

@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30), 
@strSourcein nvarchar(100)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)

 Set @strFormStatus = 'Pending CSR Review'
 Set @strFormStatus2 = 'Pending Manager Review'
 Set @strFormStatus3 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Sup_LanID] =  '''+@strCSRSUPin+'''
and (([S].[Status] = '''+@strFormStatus+''') or ([S].[Status] = '''+@strFormStatus2+''') or ([S].[Status] = '''+@strFormStatus3+'''))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
Order By [eh].[Sup_LanID],[cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_SUPCSRPending
GO



******************************************************************

--17. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SUPPending]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SUPPending' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<07/20/2013>
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
--	Last Update:	<03/12/2014> - Modified for eCoachingDev DB
--	Last Update:	<03/17/2014> - Removed Submitter name from query
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

 Set @strFormStatus = 'Pending Supervisor Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
			[eh].[Emp_LanID] strCSR,
			[eh].[Emp_Name]	strCSRName,
			[eh].[Sup_Name] strCSRSupName,
			[S].[Status]	strFormStatus,
			[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Sup_LanID] = '''+@strCSRSUPin+'''
and ([S].[Status] = '''+@strFormStatus+''' OR [S].[Status] = '''+@strFormStatus2+''')
Order By [cl].[SubmittedDate] DESC'


		
EXEC (@nvcSQL)	
	    
END --sp_SelectFrom_Coaching_Log_SUPPending
GO



******************************************************************


--18. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<4/30/12>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from completed e-Coaching records to display on Historical dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--  Last Update:    03/27/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Emp_Name	CSR,
		s.City	strCSRSite
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Site] s,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Emp_Name ASC'

		
EXEC (@nvcSQL)	

END --sp_SelectFrom_Coaching_LogDistinctCSRCompleted
GO

******************************************************************

--19. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<4/30/12>
--  Last Update:    03/07/2014
--  Updated per SCR 12414 to add NOLOCK Hint 
--  Last Update:    03/27/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Emp_Name	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Emp_Name ASC'

		
EXEC (@nvcSQL)	

End  --sp_SelectFrom_Coaching_LogDistinctCSRCompleted2
GO




******************************************************************

--20. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctMGRCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/12/12>
--	Description: *	This procedure selects the distinct MGRs from completed e-Coaching records to display on Historical dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--  Last Update:    03/27/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Mgr_Name MGR,
		s.City	strCSRSite
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Site] s,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Mgr_Name ASC'

		
EXEC (@nvcSQL)	

END --sp_SelectFrom_Coaching_LogDistinctMGRCompleted
GO

******************************************************************


--21. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctMGRCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/12/12>
--	Description: *	This procedure selects the distinct MGRs from completed e-Coaching records to display on Historical dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--  Last Update:    03/27/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT DISTINCT eh.Mgr_Name MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Mgr_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctMGRCompleted2
GO




******************************************************************

--22. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/12/12>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct SUPs from completed e-Coaching records to display on Historical dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--  Last Update:    03/27/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.Sup_Name	SUP,
		s.City	strCSRSite
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Site] s,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Sup_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctSUPCompleted
GO



******************************************************************


--23. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/12/12>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct SUPs from completed e-Coaching records to display on Historical dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--  Last Update:    03/27/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT DISTINCT eh.Sup_Name	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] st,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Sup_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctSUPCompleted2
GO

******************************************************************


--24. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/14/2014> - Changed filters, added additional Manager filter and 2 more status filters per Jourdain Augustin 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'


SET @nvcSQL = 'SELECT DISTINCT	[eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and (([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''' and [S].[Status] = '''+@strFormStatus+''') OR ([eh].[Sup_LanID] =  '''+@strCSRMGRin+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
Order By [eh].[Emp_Name] ASC'
		
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSR
GO

******************************************************************


--25. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/12/14> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'	

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted
GO
******************************************************************


--26. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/12/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@strFormStatus4 nvarchar(30)

 Set @strFormStatus = 'Pending CSR Review'
 Set @strFormStatus2 = 'Pending Supervisor Review'
 Set @strFormStatus3 = 'Pending Manager Review'
 Set @strFormStatus4 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and (([S].[Status] = '''+@strFormStatus+''') or ([S].[Status] = '''+@strFormStatus2+''') or ([S].[Status] = '''+@strFormStatus3+''') or ([S].[Status] = '''+@strFormStatus4+'''))
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam
GO



******************************************************************

--27. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted

GO



******************************************************************


--28. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/12/2014>  - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'	

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted
GO

******************************************************************

-29. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/14/2014> - Changed filters, added additional Manager filter and 2 more status filters per Jourdain Augustin 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'

	
		
SET @nvcSQL = 'SELECT DISTINCT	[eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and (([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''' and [S].[Status] = '''+@strFormStatus+''') OR ([eh].[Sup_LanID] =  '''+@strCSRMGRin+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
Order By [eh].[Sup_Name] ASC'
		

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUP

******************************************************************


--30. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/12/2014>  - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT distinct [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'	

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted
GO


******************************************************************

--31. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<07/30/2013>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@strFormStatus4 nvarchar(30)

 Set @strFormStatus = 'Pending CSR Review'
 Set @strFormStatus2 = 'Pending Supervisor Review'
 Set @strFormStatus3 = 'Pending Manager Review'
 Set @strFormStatus4 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and (([S].[Status] = '''+@strFormStatus+''') or ([S].[Status] = '''+@strFormStatus2+''') or ([S].[Status] = '''+@strFormStatus3+''') or ([S].[Status] = '''+@strFormStatus4+'''))
Order By [eh].[Sup_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam
GO

******************************************************************


--32. Create SP  [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/13/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted
GO



******************************************************************

--33. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/11/2014>  - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


Set @strFormStatus = 'Completed'
		
SET @nvcSQL = 'SELECT distinct [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'		

EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted
GO



******************************************************************

--34. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct managers from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/11/2014>  - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted] 
@strCSRMGRin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Completed'
		
SET @nvcSQL = 'SELECT distinct [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'		

EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted
GO

******************************************************************


--35. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct Supervisors from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<03/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted] 
@strCSRMGRin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Completed'	

SET @nvcSQL = 'SELECT distinct [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'

EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted


******************************************************************

--36. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

Set @strFormStatus = 'Completed'
Set @strFormStatus2 = 'Inactive'


SET @nvcSQL = 'SELECT distinct [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Emp_Name] ASC'		


		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted
GO



******************************************************************


--37. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct managers from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

Set @strFormStatus = 'Completed'
Set @strFormStatus2 = 'Inactive'


SET @nvcSQL = 'SELECT distinct [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Mgr_Name] ASC'		

 
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted
GO



******************************************************************


--38. Create SP  [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct Supervisors from e-Coaching records to display on staff dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint 
--	Last Update:	<3/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]  
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)

Set @strFormStatus = 'Completed'
Set @strFormStatus2 = 'Inactive'

 
SET @nvcSQL = 'SELECT distinct [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Sup_Name] ASC' 
 
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted
GO




******************************************************************


--39. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctCSR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint
--	Last Update:	<3/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.[Emp_Name] AS CSR
FROM [EC].[Coaching_Log] cl WITH(NOLOCK),
[EC].[Employee_Hierarchy] eh,
[EC].[Employee_Hierarchy] sh,
[EC].[DIM_Status] s
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By CSR ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctCSR
GO




******************************************************************


--40. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctCSRTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/12/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam] 

@strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30)

 Set @strFormStatus = 'Pending CSR Review'
 Set @strFormStatus2 = 'Pending Manager Review'
 Set @strFormStatus3 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Sup_LanID] = '''+@strCSRSUPin+'''
and (([S].[Status] = '''+@strFormStatus+''') or ([S].[Status] = '''+@strFormStatus2+''') or ([S].[Status] = '''+@strFormStatus3+'''))
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctCSRTeam

GO


******************************************************************

--41. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/12/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted] 

@strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'


SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and [eh].[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted

GO
******************************************************************


--42. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctMGR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint
--	Last Update:	<3/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.[Mgr_Name] AS MGR
FROM [EC].[Coaching_Log] cl WITH(NOLOCK),
[EC].[Employee_Hierarchy] eh,
[EC].[Employee_Hierarchy] sh,
[EC].[DIM_Status] s
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By MGR ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctMGR


******************************************************************

--43. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct managers for supervisors from e-Coaching records to display on dashboard for filter. 
--	Last Update:	<3/12/2014> - Modified for eCoachingDev DB and Updated per SCR 12369 to add NOLOCK Hint 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]

 @strCSRSUPin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)


 Set @strFormStatus = 'Completed'


SET @nvcSQL = 'SELECT DISTINCT [eh].[Mgr_Name]	MGR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and [eh].[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted

GO



******************************************************************



--44. Create SP  [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctSUP' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
--  Last Update:    03/07/2014
--  Updated per SCR 12369 to add NOLOCK Hint
--	Last Update:	<3/11/2014> - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT DISTINCT eh.[Sup_Name] AS SUP
FROM [EC].[Coaching_Log] cl WITH(NOLOCK),
[EC].[Employee_Hierarchy] eh,
[EC].[Employee_Hierarchy] sh,
[EC].[DIM_Status] s
where cl.CSRID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By SUP ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctSUP





******************************************************************

--45. Create SP  [EC].[sp_SelectReviewFrom_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: 	This procedure selects an e-Coaching record from the Coaching_Log table for review. 
--  Last Modified by: Susmitha Palacherla
--  Last Update:    03/05/2014
--  Updated per SCR 12359 to add NOLOCK Hint
--  Last Update:    03/24/2014 - Modified for eCoachingDev DB
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log] @strFormIDin nvarchar(50)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT cl.CoachingID 	numID,
		cl.FormName	strFormID,
		sc.CoachingSource	strFormType,
		s.Status	strFormStatus,
		cl.EventDate	EventDate,
		cl.CoachingDate	CoachingDate,
		sh.Emp_LanID	strSubmitter,		
		sh.Emp_Name	strSubmitterName,
		sh.Emp_Email	strSubmitterEmail,			
		cl.CSR	strCSR,
		eh.Emp_Name	strCSRName,
		eh.Emp_Email	strCSREmail,
		st.City	strCSRSite,
		eh.Sup_LanID	strCSRSup,
		eh.Sup_Name	strCSRSupName,
		eh.Sup_Email	strCSRSupEmail,
		eh.Mgr_LanID	strCSRMgr,
		eh.Mgr_Name	strCSRMgrName,
		eh.Mgr_Email	strCSRMgrEmail,
		sc.SubCoachingSource	strSource,
		CL.UCID	strCID,
		CL.isVerintID	isVerintMonitor,
		CL.VerintID	strVerintID,
		CL.isAvokeID	isBehaviorAnalyticsMonitor,
		CL.AvokeID	strBehaviorAnalyticsID,
		CL.isNGDActivityID	isNGDActivityID,
		CL.NGDActivityID	strNGDActivityID,
		CC.AHT,
		CC.ARC "ARC Issue",		
		CC.Attendance,
		CC.BCCPPI	"BCC Process Procedure Issues",
		CC.CCI	"Current Coaching Initiative",
		CC.CSE	"Customer Service Escalation",
		CC.Feedback,
		CC.HR	"HR Guideline Issues",
		CC.OMR	"OMR / Exceptions",
		CC.Quality,
		CC.Recognition,
		CC.Schedule	"Schedule Adherence",
		CC.SecFloor	"Secure Floor Violations",
		CC.Other,
		CL.Description txtDescription,
		CL.CoachingNotes txtCoachingNotes,
		CL.isVerified,
		CL.SubmittedDate,
		CL.StartDate,
		CL.SupReviewedAutoDate,
		CL.isCSE,
		CL.MgrReviewManualDate,
		CL.MgrReviewAutoDate,
		CL.MgrNotes txtMgrNotes,
		CL.isCSRAcknowledged,
		CL.isCoachingRequired,
		CL.CSRReviewAutoDate,
		CL.CSRComments txtCSRComments
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[DIM_Source] sc,
	 [EC].[DIM_Site] st,
	 (SELECT  ccl.FormName,
		MAX(CASE WHEN [cr].[CoachingReason] = ''AHT'' THEN [clr].[Value] ELSE NULL END)	AHT,
		MAX(CASE WHEN [cr].[CoachingReason] = ''ARC Issue'' THEN [clr].[Value] ELSE NULL END)	ARC,		
		MAX(CASE WHEN [cr].[CoachingReason] = ''Attendance'' THEN [clr].[Value] ELSE NULL END)	Attendance,
		MAX(CASE WHEN [cr].[CoachingReason] = ''BCC Process Procedure Issues'' THEN [clr].[Value] ELSE NULL END)	BCCPPI,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Current Coaching Initiative'' THEN [clr].[Value] ELSE NULL END)	CCI,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Customer Service Escalation'' THEN [clr].[Value] ELSE NULL END)	CSE,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Feedback'' THEN [clr].[Value] ELSE NULL END)	Feedback,
		MAX(CASE WHEN [cr].[CoachingReason] = ''HR Guideline Issues'' THEN [clr].[Value] ELSE NULL END)	HR,
		MAX(CASE WHEN [cr].[CoachingReason] = ''OMR / Exceptions'' THEN [clr].[Value] ELSE NULL END)	OMR,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Quality'' THEN [clr].[Value] ELSE NULL END)	Quality,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Recognition'' THEN [clr].[Value] ELSE NULL END)	Recognition,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Schedule Adherence'' THEN [clr].[Value] ELSE NULL END)	Schedule,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Secure Floor Violations'' THEN [clr].[Value] ELSE NULL END)	SecFloor,
		MAX(CASE WHEN [cr].[CoachingReason] = ''Other'' THEN [clr].[Value] ELSE NULL END)	Other
	 FROM [EC].[Coaching_Log_Reason] clr,
	 [EC].[DIM_Coaching_Reason] cr,
	 [EC].[Coaching_Log] ccl WITH(NOLOCK)
	 WHERE [ccl].[FormName] = '''+@strFormIDin+'''
	 AND [clr].[CoachingReasonID] = [cr].[CoachingReasonID]
	 AND [ccl].[CoachingID] = [clr].[CoachingID] 
	 GROUP BY ccl.FormName ) CC,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[CSRID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [cl].[SiteID] = [st].[SiteID]
and [cl].[SubmitterID] = [sh].[Emp_ID]
and [cl].[FormName] = [CC].[FormName] 
Order By [cl].[FormName]'
		
EXEC (@nvcSQL)	
	    
END --sp_SelectReviewFrom_Coaching_Log
GO




******************************************************************

--46. Create SP  [EC].[sp_Update1Review_Coaching_Log]

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
--    Last Update:    03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query	
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update1Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @dtmSupReviewedAutoDate datetime,
	  @dtmCoachingDate datetime,
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
       

UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
		   SupReviewedAutoDate = @dtmSupReviewedAutoDate,
		   CoachingDate = @dtmCoachingDate,
           CoachingNotes = @nvctxtCoachingNotes
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





******************************************************************

--47. Create SP  [EC].[sp_Update2Review_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update2Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update2Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:      11/16/11
--    Description: *    This procedure allows managers to update the e-Coaching records from the review page with Yes, this is a confirmed Customer Service Escalation. 
--    Last Update:     12/13/13
--    Updated per SCR xxxxx to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query	
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update2Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @dtmSupReviewedAutoDate datetime,
	  @dtmCoachingDate datetime,
	  @bitisCSE bit,
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
      
UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
		   SupReviewedAutoDate = @dtmSupReviewedAutoDate,
		   CoachingDate = @dtmCoachingDate,
		   isCSE = @bitisCSE,
           CoachingNotes = @nvctxtCoachingNotes
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


END --sp_Update2Review_Coaching_Log
GO




******************************************************************

--48. Create SP  [EC].[sp_Update3Review_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update3Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update3Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:     11/16/12
--    Description:    This procedure allows managers to update the e-Coaching records from the review page with No, this is not a confirmed Customer Service Escalation. 
--    Last Update:     03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update3Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @dtmMgrReviewAutoDate datetime,
      @dtmMgrReviewManualDate datetime,
      @bitisCSE bit,
      @nvcMgrNotes Nvarchar(max)
    
)
AS
BEGIN
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
      
	
UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
		   isCSE = @bitisCSE,
		   MgrReviewAutoDate = @dtmMgrReviewAutoDate,
		   MgrReviewManualDate = @dtmMgrReviewManualDate,
           MgrNotes = @nvcMgrNotes	
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


END --sp_Update3Review_Coaching_Log
GO




******************************************************************

--49. Create SP  [EC].[sp_Update4Review_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update4Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update4Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:     11/16/12
--    Description:    This procedure allows csrs to update the e-Coaching records from the review page. 
--    Last Update:    03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update4Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @bitisCSRAcknowledged bit,
      @nvcCSRComments Nvarchar(max),
      @dtmCSRReviewAutoDate datetime
	
)
AS
BEGIN
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
            

UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
		   isCSRAcknowledged = @bitisCSRAcknowledged,
		   CSRReviewAutoDate = @dtmCSRReviewAutoDate,
		   CSRComments = @nvcCSRComments
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


END --sp_Update4Review_Coaching_Log
GO




******************************************************************

--50. Create SP  [EC].[sp_Update5Review_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update5Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update5Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:    11/16/12
--    Description:    This procedure allows managers to update the e-Coaching records from the review page for Outlier records. 
--    Last Update:    03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/27/2014 - Modified for eCoachingDev DB
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update5Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcstrReasonNotCoachable Nvarchar(30),
      @dtmMgrReviewAutoDate datetime,
      @dtmMgrReviewManualDate datetime,
      @bitisCoachingRequired bit,
--      @nvcstrCoachReason_Current_Coaching_Initiatives Nvarchar(30), 
      @nvcMgrNotes Nvarchar(max),
      @nvctxtReasonNotCoachable Nvarchar(max)
    
)
AS
BEGIN
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY
            
      
UPDATE 	EC.Coaching_Log
SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
		strReasonNotCoachable = @nvcstrReasonNotCoachable,
		isCoachingRequired = @bitisCoachingRequired,
		MgrReviewAutoDate = @dtmMgrReviewAutoDate,
		MgrReviewManualDate = @dtmMgrReviewManualDate,
		MgrNotes = @nvcMgrNotes,		   
		txtReasonNotCoachable = @nvctxtReasonNotCoachable 
	WHERE FormName = @nvcFormID
        OPTION (MAXDOP 1)

UPDATE EC.Coaching_Log_Reason
SET Value = (CASE WHEN @bitisCoachingRequired = 'True' then 'Opportunity' ELSE 'Not Coachable' END)
  	FROM EC.Coaching_Log cl INNER JOIN EC.Coaching_Log_Reason clr
	ON cl.CoachingID = clr.CoachingID
	INNER JOIN EC.DIM_Coaching_Reason cr ON cr.CoachingReasonID = clr.CoachingReasonID
WHERE cl.FormName = @nvcFormID
and cr.CoachingReason = 'Current Coaching Initiative'
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


END --sp_Update5Review_Coaching_Log
GO




******************************************************************

--51. Create SP  [EC].[sp_Update6Review_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update6Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update6Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:                 Jourdain Augustin
--    Create Date:      7/31/13
--    Description: *    This procedure allows csrs to update the e-Coaching records from the review page for Pending Acknowledgment records. 
--    Last Update:    03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update6Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @bitisCSRAcknowledged bit,
      @dtmCSRReviewAutoDate datetime
	
)
AS
BEGIN
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      
UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where Status = @nvcFormStatus),
		   isCSRAcknowledged = @bitisCSRAcknowledged,
		   CSRReviewAutoDate = @dtmCSRReviewAutoDate
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


END --sp_Update6Review_Coaching_Log
GO




******************************************************************

--52. Create SP  [EC].[sp_Update7Review_Coaching_Log]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update7Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update7Review_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:                 Jourdain Augustin
--    Create Date:      7/31/13
--    Description: *    This procedure allows Sups to update the e-Coaching records from the review page for Pending Acknowledgment records. 
--    Last Update:    03/04/2014
--    Updated per SCR 12359 to handle deadlocks with retries.
--    Last Update:    03/17/2014 - Modified for eCoachingDev DB
--    Last Update:    03/25/2014 - Modified Update query
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update7Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @dtmSUPReviewAutoDate datetime
	
)
AS

BEGIN
DECLARE @RetryCounter INT
SET @RetryCounter = 1

RETRY: -- Label RETRY


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY


UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
		   SUPReviewedAutoDate = @dtmSUPReviewAutoDate
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


END --sp_Update7Review_Coaching_Log
GO




******************************************************************

--53. Create SP  [EC].[sp_Whoami]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Whoami' 
)
   DROP PROCEDURE [EC].[sp_Whoami]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/22/13>
--	Last Update:	<>
--	Description: *	This procedure selects the user's info from a table 
--  Updated per SCR 12369 to add NOLOCK Hint
--	Last Update:	<3/12/2014> - Updated per SCR 12369 to add NOLOCK Hint
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoami] 


(
 @strUserin	Nvarchar(30)
)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT [Emp_Job_Code] + ''$'' + [Emp_Email] + ''$'' +  [Emp_Name] as Submitter
              FROM [EC].[Employee_Hierarchy]WITH(NOLOCK)
              WHERE [Emp_LanID] = '''+@strUserin+''''

		
EXEC (@nvcSQL)	


END --sp_Whoami
GO


******************************************************************

--54. Create SP  [EC].[sp_Whoisthis]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Whoisthis' 
)
   DROP PROCEDURE [EC].[sp_Whoisthis]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	<7/23/13>
--	Last Update:	<>
--	Description: *	This procedure selects the CSR's hierarchy information from a table 
--  
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoisthis] 


(
 @strUserin	Nvarchar(30)
)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT [Sup_LanID] + ''$'' + [Mgr_LanID] Flow
              FROM [EC].[Employee_Hierarchy]
              WHERE [Emp_LanID] = '''+@strUserin+''''

		
EXEC (@nvcSQL)	


END --sp_Whoisthis
GO



******************************************************************

--55. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************


--56. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************

--57. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************


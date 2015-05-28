/*
eCoaching_Log_Create(09).sql
Last Modified Date: 11/3/2014
Last Modified By: Susmitha Palacherla

Version 09:
1. Additional Update to (SP # 47) to update MgrReviewAutoDate and MgrNotes
   fields for Manager updates.  per SCR 13631.
2. Additional Update to (SP # 62) to replace'Other' as a SubCoaching Reason 
   for Progressive Warnings functionality with Other Policy (non-Security/Privacy) per SCR 13479. 
3. Changes for SCR 13659- ETS Feed Load
    Altered table Coaching_Log to add 2 additional columns. SupID and MgrID.
4. Modified (SP # 17) to allow acting managers to review Pending supervisor
   review eCLs per SCR 13794.


Version 08:
1. Additonal Update to (SP # 62) to support 'Other' as a SubCoaching Reason 
   for Progressive Warnings functionality per SCR 13479.


Version 07:
1. Updated 1 procedures to support ETS as a SubCoaching Reason 
   for Progressive Warnings functionality per SCR 13479.(SP # 62).
  

Version 06:
1. Updated 2 procedures to support Progressive Warnings functionality
    per SCR 13479.(SP #'s 56 and 60).
  

Version 05:
1. Updated sp_Select_CallID_By_Module(61) to remove sort order per program request.

Version 04:
1. Added several new procedures and modified existing procedures to
   support the modular design to add 2 new Supervisor and Quality Modules.
   All references to CSRID and CSR were updated to EmpID and EmpLanID respectively.

Version 03:
1. Updated [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP] (6)  per SCR 13265 
    to group multiple coaching reasons and display total count per eCL in dashboards.

Version 02: 
1.  Updated per SCR 13054 to Import additional attribute VerintFormName
     Updated impacted tables to add new Column and Stored procedures
      Table [EC].[Coaching_Log] and SP [EC].[sp_InsertInto_Coaching_Log](1)
2.  Updated per SCR 12930 to display VerintFormName on Review dashboard.
      [EC].[sp_SelectReviewFrom_Coaching_Log] (45)
3.  Updated per SCR 13138 to support insertion of Quality logs from web interface.
     SP [EC].[sp_InsertInto_Coaching_Log]
4. Updated sp [EC].[sp_Update5Review_Coaching_Log] (50) per SCR 13213 to 
    add Coaching Reason 'OMR / Exceptions' to the filter criteria for the review page.

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
55.[EC].[sp_Select_Employees_By_Module]
56. [EC].[sp_Select_Modules_By_Job_Code]
57.[EC].[sp_Display_Sites_For_Module]
58.[EC].[sp_Select_Source_By_Module]
59.[EC].[sp_Select_Programs]
60.[EC].[sp_Select_CoachingReasons_By_Module]
61.[EC].[sp_Select_CallID_By_Module]
62.[EC].[sp_Select_SubCoachingReasons_By_Reason]
63.[EC].[sp_Select_Email_Attributes]
64. [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]
65. [EC].[sp_Select_Values_By_Reason]
66.
67.
68.
69.
70.



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
	[EmpLanID] [nvarchar](50) NOT NULL,
	[EmpID] [nvarchar](10) NOT NULL,
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
	[VerintFormName] [nvarchar]50) NULL,
                  [ModuleID][int],
                  [SupID] [nvarchar](20) NULL,
                  [MgrID] [nvarchar](20) NULL,
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
-- Last Modified Date: 08/13/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to support the Modular design.
--
--    =====================================================================
CREATE PROCEDURE [EC].[sp_InsertInto_Coaching_Log]
(     @nvcFormName Nvarchar(50),
      @nvcEmpLanID Nvarchar(40),
      @nvcProgramName Nvarchar(50),
      @intSourceID INT,
      @intStatusID INT,
      @SiteID INT,
      @nvcSubmitter Nvarchar(40),
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
      @ModuleID INT
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
	        @nvcNotPassedSiteID INT,
	        @dtmDate datetime
	        
	  
	        
	        
	SET @dtmDate  = GETDATE()   
	SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanID,@dtmDate)
	SET @nvcSubmitterID = EC.fn_nvcGetEmpIdFromLanID(@nvcSubmitter,@dtmDate)
	SET @nvcNotPassedSiteID = EC.fn_intSiteIDFromEmpID(@nvcEmpID)
        
  
         INSERT INTO [EC].[Coaching_Log]
           ([FormName]
           ,[ProgramName]
           ,[SourceID]
           ,[StatusID]
           ,[SiteID]
           ,[EmpLanID]
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
           ,[ModuleID])
     VALUES
           (@nvcFormName
           ,@nvcProgramName 
           ,@intSourceID 
           ,@intStatusID 
           ,ISNULL(@SiteID,@nvcNotPassedSiteID)
           ,@nvcEmpLanID
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
		   ,@ModuleID)
            
            
     --PRINT 'STEP1'
            
    SELECT @@IDENTITY AS 'Identity';
    --PRINT @@IDENTITY
    
    DECLARE @I BIGINT = @@IDENTITY,
            @MaxSubReasonRowID INT,
            @SubReasonRowID INT
    

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
--	Create Date:	11/16/11
-- Last Modified Date: 08/20/2014
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending] @strCSRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30)


 Set @strFormStatus = 'Pending Employee Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Emp_LanID] = '''+@strCSRin+'''
and ([S].[Status] = '''+@strFormStatus+''' or [S].[Status] = '''+@strFormStatus2+''')
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END -- sp_SelectFrom_Coaching_Log_CSRPending


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
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
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
		,SUM(case when [clr].[Value] = ''Opportunity'' THEN 1 ELSE 0 END) numOpportunity
		,SUM(case when [clr].[Value] = ''Reinforcement'' THEN 1 ELSE 0 END) numReinforcement
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[Employee_Hierarchy] sh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK),
	 [EC].[DIM_Source] so,
	 [EC].[Coaching_Log_Reason] clr,
	 [EC].[DIM_Site] si
WHERE cl.EmpID = eh.Emp_ID
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
GROUP BY [cl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[cl].[SubmittedDate],[sh].[Emp_Name]
) x
where ISNULL(x.numOpportunity, '' '') LIKE '''+@strIsOpp+'''
and ISNULL(x.numReinforcement, '' '') LIKE '''+@strIsForce+'''
Order By x.SubmittedDate DESC'


EXEC (@nvcSQL)	
	    
END -- sp_SelectFrom_Coaching_Log_HistoricalSUP



GO






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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSR and CSRID to EmpLanID and EmpID to support the Modular design.
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
where [cl].[EmpID] = [eh].[Emp_ID]
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE  PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRCSRPending] 

@strCSRMGRin nvarchar(30),
@strCSRSUPin nvarchar(30),
@strSourcein nvarchar(100),
@strCSRin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)




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
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]  
and [eh].[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] like ''Pending%''
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Pending Review. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending] 
@strCSRMGRin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRSUPin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(50),
@strFormStatus2 nvarchar(50),
@strFormStatus3 nvarchar(50),
@strFormStatus4 nvarchar(50),
@strFormStatus5 nvarchar(50),
@strFormStatus6 nvarchar(50)


 Set @strFormStatus1 = 'Pending Manager Review'
 Set @strFormStatus2 = 'Pending Supervisor Review'
 Set @strFormStatus3 = 'Pending Acknowledgement'
 Set @strFormStatus4 = 'Pending Sr. Manager Review'
 Set @strFormStatus5 = 'Pending Deputy Program Manager Review'
 Set @strFormStatus6 = 'Pending Quality Lead Review'

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_LanID] strCSR,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and ((([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''') and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus4+''' OR [S].[Status] = '''+@strFormStatus5+''')) 
OR (([eh].[Sup_LanID] =  '''+@strCSRMGRin+''') and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+''' OR [S].[Status] = '''+@strFormStatus3+''' OR [S].[Status] = '''+@strFormStatus6+''')))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
Order By [SubmittedDate] DESC'
		
EXEC (@nvcSQL)	
--Print @nvcsql
	    
END -- sp_SelectFrom_Coaching_Log_MGRPending




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
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the support staff's submitted comopleted records from the Coaching_Log table and displayed on dashboard
-- Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
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
WHERE cl.EmpID = eh.Emp_ID
AND cl.StatusID = s.StatusID
AND cl.SubmitterID = sh.EMP_ID 
AND sh.Emp_LanID = '''+@strUserin+''' 
AND [eh].[Emp_Name]= '''+@strCSRin+''' 
AND [eh].[Sup_Name]= '''+@strCSRSupin+''' 
AND [eh].[Mgr_Name]= '''+@strCSRMgrin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END -- sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the support staff's submitted pending records from the Coaching_Log table and displayed on dashboard
-- Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
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


 Set @strFormStatus = 'Pending Employee Review'
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the user's recent submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter.
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename  CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the Supervisor user's submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
--  Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
and cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the Supervisor user's submitted records from the Coaching_Log table and displayed on dashboard (includes completed)
-- Where the user's LAN is strSubmitter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
and cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the SUP e-Coaching records from the Coaching_Log table
-- Where the status is Completed. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where [cl].[EmpID] = [eh].[Emp_ID]
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending] 

@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30), 
@strSourcein nvarchar(100)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


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
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [eh].[Sup_LanID] =  '''+@strCSRSUPin+'''
and [S].[Status] like ''Pending%''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
Order By [eh].[Sup_LanID],[cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
	    
END--sp_SelectFrom_Coaching_Log_SUPCSRPending



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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the CSR e-Coaching records from the Coaching_Log table
-- Where the status is Prnding Review. 
-- Last Modified Date: 11/17/2014
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 13794 to allow acting Managers to view Supervisor level records.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPPending] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus1 nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@strFormStatus4 nvarchar(30),
@strFormStatus5 nvarchar(30)

 Set @strFormStatus1 = 'Pending Supervisor Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'
 Set @strFormStatus3 = 'Pending Manager Review'
 Set @strFormStatus4 = 'Pending Quality Lead Review'
 Set @strFormStatus5 = 'Pending Employee Review'
 
SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
			[eh].[Emp_LanID] strCSR,
			[eh].[Emp_Name]	strCSRName,
			[eh].[Sup_Name] strCSRSupName,
			[S].[Status]	strFormStatus,
			[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and (((eh.[Sup_LanID] = '''+@strCSRSUPin+''' OR eh.[Mgr_LanID] = '''+@strCSRSUPin+''' )
and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+'''OR [S].[Status] = '''+@strFormStatus3+'''OR [S].[Status] = '''+@strFormStatus4+'''))
or (eh.[Emp_LanID] = '''+@strCSRSUPin+''' and [S].[Status] = '''+@strFormStatus5+'''))

Order By [cl].[SubmittedDate] DESC'
		
EXEC (@nvcSQL)	
--Print @nvcSQL
	    
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
--	Create Date:	4/30/12
--	Description: *	This procedure selects the distinct CSRs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Emp_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted


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
--	Create Date:	4/30/12
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Emp_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted2


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
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct MGRs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.SiteID = s.SiteID
and cl.StatusID = st.StatusID
and st.Status <> '''+@strFormStatus+'''
Order By eh.Mgr_Name ASC'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctMGRCompleted


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
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct MGRs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct SUPs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	7/12/12
--	Description: *	This procedure selects the distinct SUPs from completed e-Coaching records to display on Historical dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where [cl].[EmpID] = [eh].[Emp_ID]
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] like ''Pending%''
Order By [eh].[Emp_Name] ASC'
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam



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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'	

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where [cl].[EmpID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and (([eh].[Mgr_LanID] =  '''+@strCSRMGRin+''' and [S].[Status] = '''+@strFormStatus+''') OR ([eh].[Sup_LanID] =  '''+@strCSRMGRin+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
Order By [eh].[Sup_Name] ASC'
		

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctSUP


GO

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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam] 

@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT DISTINCT [eh].[Sup_Name]	SUP
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] like ''Pending%''
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Mgr_LanID] = '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Emp_Name] ASC'		

EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted


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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'		

EXEC (@nvcSQL)	

End

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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct Supervisors from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
and s.[Status] <> '''+@strFormStatus+'''
Order By [eh].[Sup_Name] ASC'

EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted


GO


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct managers from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.[SubmitterID] = sh.[Emp_ID]
and sh.[Emp_LanID] = '''+@strCSRMGRin+''' 
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
Order By [eh].[Mgr_Name] ASC'		

 
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct Supervisors from e-Coaching records to display on staff dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By CSR ASC'
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSupDistinctCSR


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam] 

@strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT DISTINCT [eh].[Emp_Name]	CSR
FROM [EC].[Employee_Hierarchy] eh,
	 [EC].[DIM_Status] s,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and eh.[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] like ''Pending%''
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By MGR ASC'
		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogSupDistinctMGR


GO


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct managers for supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and [eh].[Sup_LanID] = '''+@strCSRSUPin+'''
and [S].[Status] = '''+@strFormStatus+'''
Order By [eh].[Mgr_Name] ASC'
		
EXEC (@nvcSQL)	

End  --sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted


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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Modified Date: 08/20/14
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
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
where cl.EmpID = eh.Emp_ID
and cl.StatusID = s.StatusID
and cl.SubmitterID = sh.Emp_ID
and sh.Emp_LanID = '''+@strCSRSUPin+''' 
and s.Status <> '''+@strFormStatus+'''
Order By SUP ASC'
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSupDistinctSUP


GO



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
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Coaching Log attributes for given Form Name. 
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log] @strFormIDin nvarchar(50)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

	 
  SET @nvcSQL = 'SELECT cl.CoachingID 	numID,
		cl.FormName	strFormID,
		m.Module,
		sc.CoachingSource	strFormType,
		s.Status	strFormStatus,
		cl.EventDate	EventDate,
		cl.CoachingDate	CoachingDate,
		sh.Emp_LanID	strSubmitter,		
		sh.Emp_Name	strSubmitterName,
		sh.Emp_Email	strSubmitterEmail,			
		cl.EmpLanID	strEmpLanID,
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
		CL.isUCID    isUCID,
		CL.UCID	strUCID,
		CL.isVerintID	isVerintMonitor,
		CL.VerintID	strVerintID,
		CL.VerintFormName VerintFormName,
		CL.isAvokeID	isBehaviorAnalyticsMonitor,
		CL.AvokeID	strBehaviorAnalyticsID,
		CL.isNGDActivityID	isNGDActivityID,
		CL.NGDActivityID	strNGDActivityID,
		CASE WHEN CC.CSE = ''Opportunity'' Then 1 ELSE 0 END	"Customer Service Escalation",
		CASE WHEN CC.CCI is Not NULL Then 1 ELSE 0 END	"Current Coaching Initiative",
		CASE WHEN CC.OMR is Not NULL Then 1 ELSE 0 END	"OMR / Exceptions",
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
	 [EC].[DIM_Module] m,
	 (SELECT  ccl.FormName,
	 MAX(CASE WHEN [cr].[CoachingReason] = ''Customer Service Escalation'' THEN [clr].[Value] ELSE NULL END)	CSE,
	 MAX(CASE WHEN [cr].[CoachingReason] = ''Current Coaching Initiative'' THEN [clr].[Value] ELSE NULL END)	CCI,
	 MAX(CASE WHEN [cr].[CoachingReason] = ''OMR / Exceptions'' THEN [clr].[Value] ELSE NULL END)	OMR
	 FROM [EC].[Coaching_Log_Reason] clr,
	 [EC].[DIM_Coaching_Reason] cr,
	 [EC].[Coaching_Log] ccl WITH(NOLOCK)
	 WHERE [ccl].[FormName] = '''+@strFormIDin+'''
	 AND [clr].[CoachingReasonID] = [cr].[CoachingReasonID]
	 AND [ccl].[CoachingID] = [clr].[CoachingID] 
	 GROUP BY ccl.FormName ) CC,
	 [EC].[Coaching_Log] cl WITH(NOLOCK)
where [cl].[EMPID] = [eh].[Emp_ID]
and [cl].[StatusID] = [s].[StatusID]
and [cl].[SourceID] = [sc].[SourceID]
and [cl].[SiteID] = [st].[SiteID]
and [cl].[ModuleID] = [m].[ModuleID]
and [cl].[SubmitterID] = [sh].[Emp_ID]
and [cl].[FormName] = [CC].[FormName] 
Order By [cl].[FormName]'
		

EXEC (@nvcSQL)
--Print (@nvcSQL)
	    
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
--    Last Update:     10/31/2014
--    Updated per SCR 13631 to update MgrReviewAutoDate and MgrNotes fields for Manager updates. 

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
		   MgrReviewAutoDate = @dtmSupReviewedAutoDate,
		   CoachingDate = @dtmCoachingDate,
		   isCSE = @bitisCSE,
           MgrNotes = @nvctxtCoachingNotes
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
--    Last modified by:    Susmitha Palacherla
--    Modified per SCR 13213 to add Coaching Reason 'OMR / Exceptions' to the filter criteria for the review page.

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
and cr.CoachingReason in ('OMR / Exceptions', 'Current Coaching Initiative')
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
--	Create Date:	07/22/13
--  Last Modified Date: 08/21/14
--  Last Modified By: Susmitha Palacherla
--  Modified during the modular design to look up the Employee ID using the Employee ID From Lan ID Function.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoami] 

(
 @strUserin	Nvarchar(30)
)
AS

BEGIN
DECLARE	
@EmpID nvarchar(100),
@nvcSQL nvarchar(max)

--SET @EmpID = (Select Emp_ID from [EC].[Employee_Hierarchy]where Emp_LanID = @strUserin)

SET @EmpID = (Select [EC].[fn_nvcGetEmpIdFromLanId](@strUserin,GETDATE()))
/*
SET @nvcSQL = 'SELECT [Emp_Job_Code] + ''$'' + [Emp_Email] + ''$'' +  [Emp_Name] as Submitter
              FROM [EC].[Employee_Hierarchy]WITH(NOLOCK)
              WHERE [Emp_LanID] = '''+@strUserin+''''
 */
 SET @nvcSQL = 'SELECT [Emp_Job_Code] + ''$'' + [Emp_Email] + ''$'' +  [Emp_Name] as Submitter
              FROM [EC].[Employee_Hierarchy]WITH(NOLOCK)
              WHERE [Emp_ID] = '''+@EmpID+''''
            
		
EXEC (@nvcSQL)	
--Print @nvcSQL
END -- sp_Whoami
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

--55. Create SP  [EC].[sp_Select_Employees_By_Module]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Employees_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_Employees_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/31/14
--	Description: *	This procedure pulls the list of Employee names to be displayed 
--  in the drop downs for the selected Module using the job_code in the Employee_Selection table.
--  Created to replace the sp_SelectCSRsbyLocation used by the original CSR Module 
--  
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_By_Module] 

@strModulein nvarchar(30), @strCSRSitein nvarchar(30)= NULL

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(max),
@nvcSQL02 nvarchar(max),
@nvcSQL03 nvarchar(max)

SET @nvcSQL01 = 'select [Emp_Name] + '' ('' + [Emp_LanID] + '') '' + [Emp_Job_Description] as FrontRow1
	  ,[Emp_Name] + ''$'' + [Emp_Email] + ''$'' + [Emp_LanID] + ''$'' + [Sup_Name] + ''$'' + [Sup_Email] + ''$'' + [Sup_LanID] + ''$'' + [Sup_Job_Description] + ''$'' + [Mgr_Name] + ''$'' + [Mgr_Email] + ''$'' + [Mgr_LanID] + ''$'' + [Mgr_Job_Description]  + ''$'' + [Emp_Site] as BackRow1, [Emp_Site]
       from [EC].[Employee_Hierarchy] WITH (NOLOCK) JOIN [EC].[Employee_Selection]
       on [EC].[Employee_Hierarchy].[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code]
where [EC].[Employee_Selection].[is'+ @strModulein + ']= 1'

SET @nvcSQL02 = ' and [Emp_Site] = ''' +@strCSRSitein + ''''


SET @nvcSQL03 = ' and [End_Date] = ''99991231''
and [Emp_LanID]is not NULL and [Sup_LanID] is not NULL and [Mgr_LanID]is not NULL
order By [Emp_Name] ASC'

--IF @strModulein = 'CSR'
SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isBySite = 1

SET @nvcSQL = @nvcSQL01 + @nvcSQL02 +@nvcSQL03 
ELSE
SET @nvcSQL = @nvcSQL01 + @nvcSQL03 

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Employees_By_Module


GO

******************************************************************


--56. Create SP  [EC].[sp_Select_Modules_By_Job_Code]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Modules_By_Job_Code' 
)
   DROP PROCEDURE [EC].[sp_Select_Modules_By_Job_Code]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/31/14
--	Description: *	This procedure takes the lan ID of the user and looks up the job code.
--  If Job code exists in the submisison table returns the valid submission modules.
--  If job code does not exist in the submisisons table returns 'CSR' as a valid sumission module.
--  Last Modified By: Susmitha Palacherla
--  Last Modified Date: 10/02/2014
--  Modified per SCR 13479 to Incorporate progtessive Warnings for CSRs

--  
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Modules_By_Job_Code] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@nvcCSR nvarchar(30),
	@dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)

SET @nvcCSR = (SELECT CASE WHEN [CSR]= 1 THEN N'CSR' ELSE NULL END  as Module FROM [EC].[Module_Submission]
WHERE Job_Code = @nvcEmpJobCode)

--print @nvcCSR

if @nvcCSR is null


/*
 The BySite string below is a combination of the  following
 1. whether site will be a selection
 2. Module Name
 3. Module ID
 4. Whether CSE will be displayed or not
 5. Whether warning will be diaplayed for Direct or Not
*/

SET @nvcSQL = 'SELECT TOP 1 CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, ''1-CSR-1-1-1'' as BySite
from [EC].[Module_Submission]'
 
ELSE

SET @nvcSQL = 'SELECT Module, BySite FROM 
(SELECT CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, ''1-CSR-1-1-1'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION
SELECT CASE WHEN [Supervisor]= 1 THEN N''Supervisor'' ELSE NULL END as Module, ''0-Supervisor-2-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [Quality]= 1 THEN N''Quality'' ELSE NULL END as Module, ''0-Quality Specialist-3-0-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+''')AS Modulelist
where Module is not Null '
--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Modules_By_Job_Code
GO



******************************************************************

--57. Create SP  [EC].[sp_Display_Sites_For_Module]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[sp_Display_Sites_For_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/01/14
--	Description: *	This procedure takes in a Module ID and returns the list of sites if the Module passed in 
--  supports By Site submissions.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Display_Sites_For_Module] 

@strModulein nvarchar(30)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcSQL nvarchar(max)


SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isBySite = 1

SET @nvcSQL = 'select [SiteID],[City] FROM [EC].[DIM_Site]WHERE [isActive] = 1 ORDER BY City'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Display_Sites_For_Module
  

GO




******************************************************************
--58. Create SP  [EC].[sp_Select_Source_By_Module]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Source_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_Source_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module and Source (Direct or Indirect)
--  and returns the Source IDis for the coresponding Sub Coaching Source.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Source_By_Module] 
@strModulein nvarchar(30), @strSourcein nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'Select [SourceID] as SourceID, [SubCoachingSource]as Source from [EC].[DIM_Source]
Where ' + @strModulein +' = 1 and 
IsActive = 1 and 
CoachingSource =  '''+@strSourcein+'''
Order by [SubCoachingSource] '


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Source_By_Module

GO


******************************************************************

--59. Create SP  [EC].[sp_Select_Programs]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Programs' 
)
   DROP PROCEDURE [EC].[sp_Select_Programs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure returns a list of Active Programs to
--  be made available in the UI submission page.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Programs] 
@strModulein nvarchar(30)

AS
BEGIN
	DECLARE	
	@isByProgram BIT,
	@nvcSQL nvarchar(max)
	
SET @isByProgram = (SELECT ByProgram FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isByProgram = 1

SET @nvcSQL = 'Select [Program] as Program from [EC].[DIM_Program]
Where isActive = 1
Order by [Program] '

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Programs
GO


******************************************************************

--60. Create SP  [EC].[sp_Select_CoachingReasons_By_Module]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_CoachingReasons_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_CoachingReasons_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/20/2014
--	Description: *	This procedure takes a Module 
--  and returns the Coaching Reasons associated with the Module. 
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 09/25/2014
-- Modified per SCR 13479 to add logic for incorporating WARNINGs.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_CoachingReasons_By_Module] 
@strModulein nvarchar(30), @strSourcein nvarchar(30), @isSplReason BIT, @splReasonPrty INT, @strCSRin nvarchar(30), @strSubmitterin nvarchar(30)

AS
BEGIN
	DECLARE	
	
	@nvcSQL nvarchar(max),
	@nvcDirectHierarchy nvarchar(10)
	
SET @nvcDirectHierarchy = [EC].[fn_strDirectUserHierarchy] (@strCSRin, @strSubmitterin, GETDATE())

--print @nvcDirectHierarchy
	
IF @isSplReason = 1 

IF @nvcDirectHierarchy = 'Yes'

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
AND IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 1
AND [splReasonPrty] = '''+ CONVERT(NVARCHAR,@splReasonPrty) + '''
Order by  [CoachingReasonID]'

Else

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
AND IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 1
AND [splReasonPrty] = 2
Order by  [CoachingReason]'

ELSE

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 and 
IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 0
Order by  [CoachingReason]'

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_CoachingReasons_By_Module
GO




******************************************************************

--61. Create SP  [EC].[sp_Select_CallID_By_Module]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_CallID_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_CallID_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module value and returns the Call Ids 
--                  valid for that Module and the format for the corresponding Ids for validation.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_CallID_By_Module] 
@strModulein nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'Select [CallIdType] as CallIdType, [Format]as IdFormat from [EC].[CallID_Selection]
Where ' + @strModulein +' = 1' 


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_CallID_By_Module

GO


******************************************************************

--62. Create SP  [EC].[sp_Select_SubCoachingReasons_By_Reason]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_SubCoachingReasons_By_Reason' 
)
   DROP PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module, Direct or Indirect, a Coaching Reason and the submitter lanid 
--  and returns the Sub Coaching Reasons associated with the Coaching Reason.
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 10/29/2014
-- Modified per SCR to display ETS as a Sub coaching Reason irrespective of Job Code
-- for Warnings related Coaching Reasons.
--
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason] 
@strReasonin nvarchar(200), @strModulein nvarchar(30), @strSourcein nvarchar(30), @nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcEmpID nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@dtmDate datetime,
	@nvcSQL nvarchar(max)
	
	
SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)

IF  (@strSourcein = 'Direct' and (@nvcEmpJobCode like 'WISY13' OR @nvcEmpJobCode like 'WSQA70' OR @nvcEmpJobCode like '%CS40%' OR @nvcEmpJobCode like '%CS50%' OR @nvcEmpJobCode like '%CS60%'))
OR
(@strSourcein = 'Direct' and @strReasonin in ('Verbal Warning', 'Written Warning' ,'Final Written Warning'))

SET @nvcSQL = 'Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
Order by CASE WHEN [SubCoachingReason] in (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'') Then 1 Else 0 END, [SubCoachingReason]'

ELSE

SET @nvcSQL = 'Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
AND [SubCoachingReason] <> ''ETS''
Order by CASE WHEN [SubCoachingReason] in (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'') Then 1 Else 0 END, [SubCoachingReason]'

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SubCoachingReasons_By_Reason




GO





******************************************************************

--63. Create SP  [EC].[sp_Select_Email_Attributes]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Email_Attributes' 
)
   DROP PROCEDURE [EC].[sp_Select_Email_Attributes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/1814
--	Description: *	This procedure takes a Module, Source(Direct/Indirect), SubCoachingSource and isCSE and returns the  
--                  Status and Email attributes.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Email_Attributes] 
@strModulein NVARCHAR(30), @intSourceIDin INT, @bitisCSEin BIT

AS
BEGIN
	DECLARE	
	@Source nvarchar(30),
	@SubSource nvarchar(100),
	@nvcSQL nvarchar(max)
	
	SET @Source = (Select [CoachingSource] from [EC].[DIM_Source]WHERE [SourceID]=  @intSourceIDin)
	SET @SubSource = (Select [SubCoachingSource] from [EC].[DIM_Source]WHERE [SourceID]=  @intSourceIDin)

SET @nvcSQL = 'Select [EC].[fn_strStatusIDFromStatus]([Status]) as StatusID, [Status]as StatusName, [Recipient] as Receiver,
 [Body] as EmailText, [isCCRecipient] as isCCReceiver, [CCRecipient] as CCReceiver
 from [EC].[Email_Notifications]
Where [Module]= '''+@strModulein+'''
and [Source] = '''+@Source+'''
and [SubSource] = '''+@SubSource+'''
and [isCSE] = '''+CONVERT(NVARCHAR(1),@bitisCSEin)+''''

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Email_Attributes


GO


******************************************************************

--64. Create SP  [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_Reasons' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Coaching Log Reason and Sub Coaching Reason values for 
--  a given Form Name.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons] @strFormIDin nvarchar(50)
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@intCoachingID INT

 
SET @intCoachingID = (SELECT CoachingID From [EC].[Coaching_Log]where[FormName]=@strFormIDin)


SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, clr.value
FROM [EC].[Coaching_Log_Reason] clr join [EC].[DIM_Coaching_Reason] cr
ON[clr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [clr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where CoachingID = '''+CONVERT(NVARCHAR(20),@intCoachingID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,clr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_Reasons

GO






******************************************************************

--65. Create SP  [EC].[sp_Select_Values_By_Reason]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Values_By_Reason'
)
   DROP PROCEDURE [EC].[sp_Select_Values_By_Reason]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module 
--  and returns the Coaching Reasons associated with the Module. 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Values_By_Reason] 
@strReasonin nvarchar(200), @strModulein nvarchar(30), @strSourcein nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'Select CASE WHEN [isOpportunity] = 1 THEN ''Opportunity'' ElSE NULL END as Value from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
UNION
Select CASE WHEN [isReinforcement] = 1 THEN ''Reinforcement'' ElSE NULL END as Value from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Values_By_Reason

GO




******************************************************************

--66. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************

--67. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************

--68. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************

--69. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************

--70. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************

--71. Create SP  [EC].[]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'' 
)
   DROP PROCEDURE [EC].[]
GO



******************************************************************




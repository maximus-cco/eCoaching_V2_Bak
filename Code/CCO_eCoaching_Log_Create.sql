/*
eCoaching_Log_Create(31).sql
Last Modified Date: 07/08/2015
Last Modified By: Susmitha Palacherla

Version 31:
1. Updates for SCR 14916 additional HR job codes
    Updated Procedures #6,68 and 79.

Version 30:
1. Additional updates for SCR 14893. Updated SP #66
2. Updates for SCR 14966 Cleanup code to accomodate Duplicate Lan ID integration with UI.
    Updated Procedures #45,53 and 54.


Version 29:
1. Marked the following procedures as Obsolete#18,19,20,21,22,23(replaced with new procedures listed in Item 3)
2. Updated the following procedures to use dynamic where clause # 6,79, 80
3. Added 6 new Procedures # 81,82,83,84,85,86
   All above chnages per SCR 14893.

Version 28:
1. Modified procedures #6,18,20,22,66,and 67 to support performance improvement 
  changes for SCR 14893
2. Added 2 new procedures #79 and #80.



Version 27:
1. Modified procedures #45 to add LCS flag for supporting custom Review text in UI.
 LCSAT feed per SCR 14818.


Version 26:
1. Modified procedures #9 to support acting sup view for LCS ecls 
 LCSAT feed per SCR 14818.


Version 25:
1. Modified procedures #9 and #45 to support LCSAT feed per SCR 14818.


Version 24:
1. Added new procedure #78 per SCR 14951 to select Reasons records
from coaching or Warning table given a formname.

Version 23:
1. Post Phase III correction to add missed current lanid check to SP # 68 per SCR 14955.


Version 22:
1. Changes to overcome Performance Issues during release of Phase III dashboard redesign 
    SCRs 14422 and 14423 and 13618.
   This work is being tracked in SCR 14840.
   Added NOLOCK option to Coaching_log table and moved fn out of where clause.
   Modified procedures #4 through #44 and Procedure #66 and  #72 through #76.


Version 21:
1. Changes for Training Module SCR 14512.
      Added Column to  [Behavior] Table #1 [EC].[Coaching_Log]
      Added new sp #77
     Modified procedures #1, #55 and #56 
2. Added new SP # 78 for Historical Dashboard export functionality per SCR 14676.

Version 20:
1. Phase III post testing update for dashboard redesign SCR 14422
   Modified procedures #14 to remove subcoaching reason and value from select.

Version 19:
1. Phase III Updates for dashboard redesign SCR 14422
   Modified procedures #4 through #44.
    Added new procedures #66 through #71.

2. Phase III Updates for Sr Management dashboard SCR 14423
      Added new procedures #72 through #76.

Version 18:
Updates to [EC].[sp_Select_Employees_By_Module](SP # 55) to restrict users from 
submitting ecls for themselves by not showing them in the drop down per SCR 14323.

Version 17:
Updates to [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP](SP # 6) to support warnings 
display for HR job codes per SCR 14065.


Version 16:
Additional post V&V Updates to support Compliance ETS Reports per SCR 14031.
1.Update to procedure #50.

Version 15:
Updates to support Compliance ETS Reports per SCR 14031.
1.Update to procedures #45 and #50.


Version 14:
1. Update to  [EC].[sp_Select_Modules_By_Job_Code] (SP # 56 ) to support LSA Module
 SCR 13653


Version 13:
Post V&V Updates for SCR 13891
1.Update to Review SP (update2) #s 47


Version 12:
Updates for SCr 13891
1. Update to Table #1 Coaching_log to add 2 new fields.
2. Update to insert into coaching log sp #1 to add supid and mgrid at time of submission
3.Update to Review SPs #s 46,47,48,50,52 to capture Reviewer ID.
4. Update to select for review sp #  45 to add Reviewer Name to the return.


Version 11:
1. Update to 1 procedure (SP # 56) to set warning flag for supervisors to 1.
  (Modules by job code)SCR 13542

Version 10:
1. Update 1 procedure (SP # 8) to add source filter that was
  discovered to be missing during testing for SCR 13659.

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
18. [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted] --Obsolete (Effective 06/10/15 SCR 14983)
19. [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2] --Obsolete (Effective 06/10/15 SCR 14983)
20.  [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted] --Obsolete (Effective 06/10/15 SCR 14983)
21. [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2] --Obsolete (Effective 06/10/15 SCR 14983)
22. [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted] --Obsolete (Effective 06/10/15 SCR 14983)
23. [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2]--Obsolete (Effective 06/10/15 SCR 14983)
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
66. [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2]
67. [EC].[sp_Select_Sites_For_Dashboard] 
68. [EC].[sp_Select_Sources_For_Dashboard] 
69. [EC].[sp_Select_States_For_Dashboard]
70. [EC].[sp_Select_Statuses_For_Dashboard] 
71. [EC].[sp_Select_Values_For_Dashboard] 
72. [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching] 
73. [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam] 
74. [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam] 
75. [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam] 
76. [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] 
77. [EC].[sp_Select_Behaviors]
78. [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons_Combined]
79. [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP_Count] 
80. [EC].[sp_SelectFrom_Coaching_Log_Historical_Export] 
81. [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All] 
82. [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site] 
83. [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All] 
84. [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site] 
85. [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All] 
86. [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site] 
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
                  [Review_SupID] [nvarchar](20) NULL,
                  [Review_MgrID] [nvarchar](20) NULL,
                  [Behavior] [nvarchar](30) NULL,
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
-- Last Modified Date: 04/10/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14512 to capture 'behavior' for Training Module.
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
      @ModuleID INT,
      @Behaviour Nvarchar(30)
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
	        @nvcSupID Nvarchar(10),
	        @nvcMgrID Nvarchar(10),
	        @nvcNotPassedSiteID INT,
	        @dtmDate datetime
	        
	  
	        
	        
	SET @dtmDate  = GETDATE()   
	SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanID,@dtmDate)
	SET @nvcSubmitterID = EC.fn_nvcGetEmpIdFromLanID(@nvcSubmitter,@dtmDate)
	SET @nvcNotPassedSiteID = EC.fn_intSiteIDFromEmpID(@nvcEmpID)
    SET @nvcSupID = (SELECT [Sup_ID] FROM [EC].[Employee_Hierarchy]WHERE [Emp_ID]= @nvcEmpID)
    SET @nvcMgrID = (SELECT [Mgr_ID] FROM [EC].[Employee_Hierarchy]WHERE [Emp_ID]= @nvcEmpID)
  
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
           ,[ModuleID]
           ,[SupID]
           ,[MgrID]
           ,[Behavior])
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
		   ,@ModuleID
		   ,ISNULL(@nvcSupID,'999999')
		   ,ISNULL(@nvcMgrID,'999999')
		   ,@Behaviour)
            
            
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
-- Author:			Susmitha Palacherla
-- Create Date:	11/16/11
-- Description: Displays an Employee's Completed logs in the My Dashboard.
-- Last Modified Date: 04/16/2015
-- Last Updated By: Susmitha Palacherla
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRCompleted] @strCSRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcEmpID Nvarchar(10),
@dtmDate datetime

 SET @dtmDate  = GETDATE()   
 SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strCSRin,@dtmDate)
 SET @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
where cl.EmpID = '''+@nvcEmpID+''' 
and [S].[Status] = '''+@strFormStatus+'''
and  cl.EmpID <> ''999999''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
END -- sp_SelectFrom_Coaching_Log_CSRCompleted

GO



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
--	Create Date:	11/16/2011
--  Description: Displays an Employees Pending logs in the My Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_CSRPending] @strCSRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@nvcEmpID Nvarchar(10),
@dtmDate datetime

 SET @dtmDate  = GETDATE()   
 SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strCSRin,@dtmDate)
 SET @strFormStatus = 'Pending Employee Review'
 SET @strFormStatus2 = 'Pending Acknowledgement'

SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
		[eh].[Emp_Name]	strCSRName,
		[S].[Status]	strFormStatus,
		[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
where  cl.EmpID = '''+@nvcEmpID+''' 
and ([S].[Status] = '''+@strFormStatus+''' or [S].[Status] = '''+@strFormStatus2+''')
and cl.EmpID <> ''999999''
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
--	Create Date:	4/30/2012
--	Description: *	This procedure selects the CSR e-Coaching completed records to display on SUP historical page
--  Last Modified: 06/11/2015
--  Last Modified Bt: Susmitha Palacherla
--  Modified per SCR 14916 to add additional HR job codes.

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP] 

@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSubmitterin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strStatusin nvarchar(30), 
@strjobcode  nvarchar(20),
@strvalue  nvarchar(30),
@PageSize int,
@startRowIndex int, 
@sortBy nvarchar(100),
@sortASC nvarchar(1)
AS

--[cl].[SubmittedDate]
BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@nvcSQL4 nvarchar(100),
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@UpperBand int,
@LowerBand int,
@SortExpression nvarchar(100),
@SortOrder nvarchar(10) ,
@OrderKey nvarchar(10),
@where nvarchar(max)        

SET @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
SET @LowerBand  = @startRowIndex 
SET @UpperBand  = @startRowIndex + @PageSize 

SET @where = ' WHERE convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''' +  
			 ' AND convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''' +
			 ' AND [cl].[StatusID] <> 2'
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = '''+@strSourcein+''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = '''+@strStatusin+''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = '''+@strvalue+''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   '''+@strCSRin+'''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = '''+@strSUPin+'''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = '''+@strMGRin+'''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = '''+@strSubmitterin+'''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[cl].[SiteID]) = '''+@strCSRSitein+''''
END			 

--PRINT @UpperBand
IF @sortASC = 'y' 
SET @SortOrder = ' ASC' ELSE 
SET @SortOrder = ' DESC' 
SET @OrderKey = 'orderkey, '
SET  @SortExpression = @OrderKey + @sortBy +  @SortOrder

PRINT @SortExpression

SET @nvcSQL1 = 'WITH TempCoaching AS 
        (select DISTINCT x.strFormID
		,x.strCSRName
		,x.strCSRSupName
		,x.strCSRMgrName
		,x.strFormStatus
		,x.strSource
		,x.SubmittedDate
		,x.strSubmitterName
		,x.strCoachingReason
		,x.strSubCoachingReason
		,x.strValue
		,x.orderkey
		,ROW_NUMBER() OVER (ORDER BY '+ @SortExpression +' ) AS RowNumber    
from (
     SELECT DISTINCT [cl].[FormName]	strFormID
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[s].[Status]		strFormStatus
		,[so].[SubCoachingSource]	strSource
		,[cl].[SubmittedDate]	SubmittedDate
		,[sh].[Emp_Name]	strSubmitterName
	    ,[EC].[fn_strCoachingReasonFromCoachingID](cl.CoachingID)strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromCoachingID](cl.CoachingID)strSubCoachingReason
	    ,[EC].[fn_strValueFromCoachingID](cl.CoachingID)strValue
	   	,''ok1'' orderkey
		FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK)
ON cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID JOIN  [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
ON cl.CoachingID = clr.CoachingID' + 
@where + 
' GROUP BY [cl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[cl].[SubmittedDate],[sh].[Emp_Name],[cl].[CoachingID]'


SET @where = ' WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''' +  
			 ' AND convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''' +
			 ' AND [wl].[StatusID] <> 2'
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = '''+@strSourcein+''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = '''+@strStatusin+''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [wlr].[value] = '''+@strvalue+''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [wl].[EmpID] = '''+@strCSRin+'''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = '''+@strSUPin+'''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = '''+@strMGRin+''''
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [wl].[SubmitterID] = '''+@strSubmitterin+'''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[wl].[SiteID]) = '''+@strCSRSitein+''''
END	

SET @nvcSQL2 = ' UNION
     SELECT DISTINCT [wl].[FormName]	strFormID
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[s].[Status]		strFormStatus
		,[so].[SubCoachingSource]	strSource
		,[wl].[SubmittedDate]	SubmittedDate
		,[sh].[Emp_Name]	strSubmitterName
	    ,[EC].[fn_strCoachingReasonFromWarningID](wl.WarningID)strCoachingReason
	    ,[EC].[fn_strSubCoachingReasonFromWarningID](wl.WarningID)strSubCoachingReason
	    ,[EC].[fn_strValueFromWarningID](wl.WarningID)strValue
	   	,''ok2'' orderkey
		FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log] wl WITH(NOLOCK)
ON wl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON wl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON wl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON wl.SourceID = so.SourceID JOIN  [EC].[Warning_Log_Reason] wlr WITH (NOLOCK)
ON wl.WarningID = wlr.WarningID' +
@where + 
' GROUP BY [wl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[wl].[SubmittedDate],[sh].[Emp_Name],[wl].[WarningID]'

SET @nvcSQL3 = ' ) x
 )
 SELECT strFormID
		,strCSRName
	    ,strCSRSupName
		,strCSRMgrName
		,strFormStatus
		,strSource
		,SubmittedDate
		,strSubmitterName
	    ,strCoachingReason
	    ,strSubCoachingReason
	    ,strValue
		,RowNumber                 
		FROM TempCoaching
		WHERE RowNumber >= '''+CONVERT(VARCHAR,@LowerBand)+'''  AND RowNumber < '''+CONVERT(VARCHAR, @UpperBand) +
        ''' ORDER BY ' + @SortExpression       
 
 
 IF @strjobcode in ('WHER13', 'WHER50',
'WHHR12', 'WHHR13', 'WHHR14',
'WHHR50', 'WHHR60', 'WHHR80',
'WHHR11', 'WHRC11', 'WHRC12', 'WHRC13')

SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3 

ELSE

SET @nvcSQL = @nvcSQL1 + @nvcSQL3

EXEC (@nvcSQL)	

--PRINT @nvcSQL
	    
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


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/2011
--	Description: This procedure selects the completed e-Coaching records 
--  for a given Manager's employees in the Manager Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@strEDate nvarchar(8),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

SET @strFormStatus = 'Completed'
SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)
SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

 

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
[cl].[EmpID] = [eh].[Emp_ID]Join [EC].[DIM_Status] s ON
[cl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[cl].[SourceID] = [sc].[SourceID] 
where eh.[Mgr_ID] = '''+@nvcMGRID+''' 
and [S].[Status] = '''+@strFormStatus+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like  '''+@strCSRSUPin+''' 
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
and eh.[Mgr_ID] <> ''999999''
Order By [cl].[SubmittedDate] DESC'
	
EXEC (@nvcSQL)
--PRINT 	@nvcSQL
	   
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the Pendingd e-Coaching records 
--  for a given Manager's employees in the Manager Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@nvcMGRID Nvarchar(10),
@dtmDate datetime


SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
[cl].[EmpID] = [eh].[Emp_ID] Join [EC].[DIM_Status] s ON
[cl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[cl].[SourceID] = [sc].[SourceID] 
where eh.[Mgr_ID] = '''+@nvcMGRID+''' 
and [S].[Status] like ''Pending%''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
and eh.[Mgr_ID] <> ''999999''
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
--	Description: This procedure selects the Pending e-Coaching records 
--  for a given Manager in the Manager Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:  05/22/2015
-- Updated per SCR 14818 to support rotating managers for Low CSAT
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MGRPending] 
@strCSRMGRin nvarchar(30),
@strCSRin nvarchar(30),
@strCSRSUPin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(2000),
@nvcSQL2 nvarchar(20),
@nvcSQL3 nvarchar(2000),
@nvcSQL4 nvarchar(100),
@strReportCode nvarchar(30),
@strFormStatus1 nvarchar(50),
@strFormStatus2 nvarchar(50),
@strFormStatus3 nvarchar(50),
@strFormStatus4 nvarchar(50),
@strFormStatus5 nvarchar(50),
@strFormStatus6 nvarchar(50),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

 Set @strReportCode = 'LCS%'
 Set @strFormStatus1 = 'Pending Manager Review'
 Set @strFormStatus2 = 'Pending Supervisor Review'
 Set @strFormStatus3 = 'Pending Acknowledgement'
 Set @strFormStatus4 = 'Pending Sr. Manager Review'
 Set @strFormStatus5 = 'Pending Deputy Program Manager Review'
 Set @strFormStatus6 = 'Pending Quality Lead Review'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL1 = 'select DISTINCT x.strFormID
        ,x.strCSR
		,x.strCSRName
		,x.strCSRSupName
		,x.strFormStatus
		,x.submitteddate
	from (SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_LanID] strCSR,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
where ((eh.[Mgr_ID] = '''+@nvcMGRID+''' and ([S].[Status] = '''+@strFormStatus1+''' OR
[S].[Status] = '''+@strFormStatus4+''' OR [S].[Status] = '''+@strFormStatus5+''')) OR
(eh.[Sup_ID] = '''+@nvcMGRID+'''and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+''' OR [S].[Status] = '''+@strFormStatus3+''' OR [S].[Status] = '''+@strFormStatus6+''')))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
and ([cl].[strReportCode] not like '''+@strReportCode+''' OR [cl].[strReportCode] is NULL)
and (eh.[Mgr_ID] <> ''999999'' and eh.[Sup_ID] <> ''999999''))X'

		
SET @nvcSQL2 = ' UNION '

SET @nvcSQL3 = 'select DISTINCT x.strFormID
        ,x.strCSR
		,x.strCSRName
		,x.strCSRSupName
		,x.strFormStatus
		,x.submitteddate
	from (SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_LanID] strCSR,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[s].[Status]	strFormStatus,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
where ((cl.[MgrID] = '''+@nvcMGRID+''' and [S].[Status] = '''+@strFormStatus1+''') OR
(eh.[Sup_ID] = '''+@nvcMGRID+''' and [S].[Status] = '''+@strFormStatus2+'''))
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [eh].[Sup_Name] Like '''+@strCSRSUPin+'''
and [cl].[strReportCode] like '''+@strReportCode+'''
and (cl.[MgrID] <> ''999999'' and eh.[Sup_ID] <> ''999999'')) X'

SET @nvcSQL4 = '  Order By [SubmittedDate] DESC'


SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3 + @nvcSQL4

	
	
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the completed records from the Coaching_Log table 
--  and displays on the My submissions dashboard where the logged in user is the ecl submitter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@strFormStatus nvarchar(30),
@nvcSubmitterID Nvarchar(10),
@dtmDate datetime

 SET @strFormStatus = 'Completed'
 SET @dtmDate  = GETDATE()   
 SET @nvcSubmitterID  = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)

SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID
		,[s].[Status]	strFormStatus
		,[eh].[Emp_Name]	strCSRName
		,[eh].[Sup_Name]	strCSRSupName
		,[eh].[Mgr_Name]	strCSRMgrName
		,[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
WHERE sh.Emp_ID = '''+@nvcSubmitterID+''' 
AND [eh].[Emp_Name] Like '''+@strCSRin+''' 
AND [eh].[Sup_Name] Like '''+@strCSRSupin+''' 
AND [eh].[Mgr_Name] Like '''+@strCSRMgrin+''' 
and s.[Status] = '''+@strFormStatus+'''
and sh.Emp_ID <> ''999999''
Order By [cl].[SubmittedDate] DESC'

		
EXEC (@nvcSQL)	
--print @nvcSQL
	    
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending records from the Coaching_Log table 
--  and displays on the My submissions dashboard where the logged in user is the ecl submitter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added additional statuses.
-- 3. Lan ID association by date.

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
@nvcSubmitterID Nvarchar(10),
@dtmDate datetime


 SET @dtmDate  = GETDATE()   
 SET @nvcSubmitterID  = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)

SET @nvcSQL = 'SELECT
		 cl.FormName	strFormID
		,S.Status	strFormStatus
		,eh.Emp_Name	strCSRName
		,eh.Sup_Name	strCSRSupName
		,eh.Mgr_Name	strCSRMgrName
		,cl.SubmittedDate	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl  WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
WHERE sh.Emp_ID = '''+@nvcSubmitterID+''' 
and eh.Emp_Name Like '''+@strCSRin+'%''
and eh.Sup_Name Like '''+@strCSRSupin+'%''
and eh.Mgr_Name Like '''+@strCSRMgrin+'%''
and S.Status Like ''Pending%''
and sh.Emp_ID <> ''999999''
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending and completed records from the Coaching_Log table 
--  and displays on the My submissions dashboard where the logged in user is the ecl submitter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard] 
@strUserin nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSubmitterID Nvarchar(10),
@dtmDate datetime

 SET @strFormStatus = 'Inactive'
 SET @dtmDate  = GETDATE()   
 SET @nvcSubmitterID  = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)


SET @nvcSQL = 'SELECT [cl].[FormName]	strFormID,
		[s].[Status]	strFormStatus,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName,
		[eh].[Mgr_Name]	strCSRMgrName,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
WHERE sh.Emp_ID = '''+@nvcSubmitterID+''' 
and s.[Status] <> '''+@strFormStatus+'''
and sh.Emp_ID <> ''999999''
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending and completed records from the Coaching_Log table 
--  and displays on the My submissions manager dashboard where the logged in manager is the ecl submitter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@strFormStatus nvarchar(30),
@nvcSubmitterID Nvarchar(10),
@dtmDate datetime

 SET @strFormStatus = 'Inactive'
 SET @dtmDate  = GETDATE()   
 SET @nvcSubmitterID  = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)
 
SET @nvcSQL = 'SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		eh.[Emp_Name]	strCSRName,
		eh.[Sup_Name]	strCSRSupName,
		eh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl  WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
WHERE sh.Emp_ID = '''+@nvcSubmitterID+''' 
and eh.[Emp_Name] LIKE '''+@strCSRin+'''
and eh.[Sup_Name] LIKE '''+@strCSRSupin+'''
and eh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
and s.[Status] LIKE '''+@strStatusin+'''
and s.[Status] <> '''+@strFormStatus+'''
and sh.Emp_ID <> ''999999''
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending and completed records from the Coaching_Log table 
--  and displays on the My submissions manager dashboard where the logged in supervisor is the ecl submitter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@strFormStatus nvarchar(30),
@nvcSubmitterID Nvarchar(10),
@dtmDate datetime

  SET @strFormStatus = 'Inactive'
 SET @dtmDate  = GETDATE()   
 SET @nvcSubmitterID  = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)


SET @nvcSQL = 'SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		eh.[Emp_Name]	strCSRName,
		eh.[Sup_Name]	strCSRSupName,
		eh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID 
WHERE sh.Emp_ID = '''+@nvcSubmitterID+''' 
and eh.[Emp_Name] LIKE '''+@strCSRin+'''
and eh.[Sup_Name] LIKE '''+@strCSRSupin+'''
and eh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
and s.[Status] LIKE '''+@strStatusin+'''
and s.[Status] <> '''+@strFormStatus+'''
and sh.Emp_ID <> ''999999''
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the completed e-Coaching records 
--  for a given supervisor's employees in the supervisor Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@strEDate nvarchar(8),
@nvcSUPID Nvarchar(10),
@dtmDate datetime


Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
Set @dtmDate  = GETDATE()   
Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
ON cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] sc
ON cl.SourceID = sc.SourceID 
where [eh].[Sup_ID] = '''+@nvcSUPID +''' 
and [eh].[Mgr_Name] Like '''+@strCSRMGRin+'''
and [S].[Status] = '''+@strFormStatus+'''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
and [eh].[Sup_ID] <> ''999999''
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
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending e-Coaching records 
--  for a given supervisor's employees in the supervisor Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SUPCSRPending] 

@strCSRSUPin nvarchar(30),
@strCSRin nvarchar(30), 
@strSourcein nvarchar(100)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

Set @dtmDate  = GETDATE()   
Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

Set @nvcSQL = 'SELECT	[cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strCSRName,
		[eh].[Sup_Name]	strCSRSupName, 
		[eh].[Mgr_Name]	strCSRMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource]	strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
ON cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] sc
ON cl.SourceID = sc.SourceID 
where [eh].[Sup_ID] = '''+@nvcSUPID +''' 
and [S].[Status] like ''Pending%''
and [eh].[Emp_Name] Like '''+@strCSRin+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [eh].[Sup_ID] <> ''999999''
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
--	Description: This procedure selects the Pending e-Coaching records 
--  for a given Supervisor in the Supervisor Dashboard.
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date:04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Lan ID association by date.
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
@strFormStatus5 nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus1 = 'Pending Supervisor Review'
 Set @strFormStatus2 = 'Pending Acknowledgement'
 Set @strFormStatus3 = 'Pending Manager Review'
 Set @strFormStatus4 = 'Pending Quality Lead Review'
 Set @strFormStatus5 = 'Pending Employee Review'
 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)
 
SET @nvcSQL = 'SELECT [cl].[FormName] strFormID,
			[eh].[Emp_LanID] strCSR,
			[eh].[Emp_Name]	strCSRName,
			[eh].[Sup_Name] strCSRSupName,
			[S].[Status]	strFormStatus,
			[cl].[SubmittedDate] SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID
and (((eh.[Sup_ID] = '''+@nvcSUPID+''' OR eh.[Mgr_ID] = '''+@nvcSUPID+''' )
and ([S].[Status] = '''+@strFormStatus1+''' OR [S].[Status] = '''+@strFormStatus2+'''OR [S].[Status] = '''+@strFormStatus3+'''OR [S].[Status] = '''+@strFormStatus4+'''))
or (eh.[Emp_ID] = '''+@nvcSUPID+''' and [S].[Status] = '''+@strFormStatus5+'''))
and (eh.[Sup_ID] <> ''999999'' AND eh.[Mgr_ID] <> ''999999'')
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
-- Last Modified Date: 06/01/2015
-- Last Modified Bt: Susmitha Palacherla
-- Modified per SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT X.CSRText, X.CSRValue, X.strCSRSite FROM
(SELECT ''All Employees'' CSRText, ''%'' CSRValue, ''%'' strCSRSite, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	CSRText, cl.EmpID CSRValue, CONVERT(nvarchar,cl.SiteID) strCSRSite, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and cl.EmpID is not NULL) X
Order By X.Sortorder, X.CSRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 03/05/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added 'All Employees' to the return
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT X.CSRText, X.CSRValue FROM
(SELECT ''All Employees'' CSRText, ''%'' CSRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	CSRText, eh.Emp_Name CSRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] st ON 
cl.StatusID = st.StatusID 
and st.Status <> '''+@strFormStatus+''')X
ORDER BY X.Sortorder, X.CSRText'

		
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
-- Last Modified Date: 06/01/2015
-- Last Modified Bt: Susmitha Palacherla
-- Modified per SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue, X.strCSRSite FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, ''%'' strCSRSite, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.MGR_Name	MGRText, eh.MGR_ID MGRValue, CONVERT(nvarchar,cl.SiteID) strCSRSite, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and (eh.MGR_Name is not NULL or eh.Mgr_ID  <> ''999999'')) X
Order By X.Sortorder, X.MGRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 03/05/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added 'All Managers' to the return
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'

SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] st ON 
cl.StatusID = st.StatusID 
where st.Status <> '''+@strFormStatus+'''
and eh.Mgr_Name is not NULL) X
Order By X.Sortorder, X.MgrText'

		
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
-- Last Modified Date: 06/01/2015
-- Last Modified Bt: Susmitha Palacherla
-- Modified per SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue, X.strCSRSite FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, ''%'' strCSRSite, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Sup_Name	SUPText, eh.Sup_ID SUPValue,  CONVERT(nvarchar,cl.SiteID) strCSRSite, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and eh.Sup_Name is not NULL
and (eh.Sup_ID <> ''999999'' or eh.Sup_ID is NOT NULL)) X
Order By X.Sortorder, X.SUPText'


		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 03/05/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added 'All Supervisors' to the return
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30)

Set @strFormStatus = 'Inactive'


SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Sup_Name	SUPText, eh.Sup_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] st ON 
cl.StatusID = st.StatusID 
where st.Status <> '''+@strFormStatus+'''
and eh.Sup_Name is not NULL) X
Order By X.Sortorder, X.SUPText'

		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'
Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)


SET @nvcSQL =  'SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employeess'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID 
where (([eh].[Mgr_ID] =   '''+@nvcMGRID+''' and [S].[Status] = '''+@strFormStatus+''')
 OR ([eh].[Sup_ID] =   '''+@nvcMGRID+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
and eh.Emp_Name is NOT NULL
and ([eh].[Mgr_ID] <> ''999999'' AND [eh].[Sup_ID] <> ''999999'')) X
ORDER BY X.Sortorder, X.EmpText'
		
		
EXEC (@nvcSQL)
--PRINT @nvcSQL
	

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
-- Last Updated By: Susmitha Palacherla
-- Modified during dashboard redesign SCR 14422.
-- Last Modified Date: 04/16/2015
-- 1. To Replace old style joins.
-- 2. Added All employees to the return
-- 3. Lan ID association by date
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Inactive'
Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT X.EMPText, X.EMPValue FROM
(SELECT ''All Employees'' EMPText, ''%'' EMPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.EMP_Name	EMPText, eh.EMP_Name EMPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID =  '''+@nvcMGRID+''' 
and s.Status <> '''+@strFormStatus+'''
and eh.EMP_Name is NOT NULL
and sh.Emp_ID <> ''999999'') X
Order By X.Sortorder, X.EMPText'

		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL =  'SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employees'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID 
where eh.[Mgr_ID] = '''+@nvcMGRID+''' 
and [S].[Status] like ''Pending%''
and eh.Emp_Name is NOT NULL
and eh.[Mgr_ID] <> ''999999'') X
ORDER BY X.Sortorder, X.EmpText'
		
		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted] 

@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
SET @strFormStatus = 'Completed'

SET @nvcSQL = 'SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employees'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID 
where eh.[Mgr_ID] = '''+@nvcMGRID+''' 
and [S].[Status] = '''+@strFormStatus+'''
and eh.Emp_Name is NOT NULL
and eh.[Mgr_ID] <> ''999999'') X
ORDER BY X.Sortorder, X.EmpText'
		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Managers to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

SET @strFormStatus = 'Inactive'
SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 
'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+''' 
and s.Status <> '''+@strFormStatus+'''
and eh.Mgr_Name is NOT NULL
and sh.Emp_ID <> ''999999'') X
Order By X.Sortorder, X.MgrText'

		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUP] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'
Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

		
SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID  JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where (([eh].[Mgr_ID] =  '''+@nvcMGRID+''' and [S].[Status] = '''+@strFormStatus+''') 
OR ([eh].[Sup_ID] =  '''+@nvcMGRID+'''  and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
and eh.SUP_Name is NOT NULL
and ([eh].[Mgr_ID] <> ''999999'' AND [eh].[Sup_ID] <> ''999999'')) X
Order By X.Sortorder, X.SUPText'
		

		
EXEC (@nvcSQL)
--PRINT @nvcSQL	

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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Inactive'
Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
and s.Status <> '''+@strFormStatus+'''
and eh.SUP_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.SUPText'

		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where eh.Mgr_ID = '''+@nvcMGRID+'''
AND S.Status like ''Pending%''
and eh.SUP_Name is NOT NULL
and eh.Mgr_ID <> ''999999'') X
Order By X.Sortorder, X.SUPText'

		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted] 

@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime


 Set @strFormStatus = 'Completed'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where eh.Mgr_ID = '''+@nvcMGRID+'''
AND S.Status = '''+@strFormStatus+'''
and eh.SUP_Name is NOT NULL
and eh.Mgr_ID <> ''999999'' ) X
Order By X.Sortorder, X.SUPText'
		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime



 Set @strFormStatus = 'Completed'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
		
SET @nvcSQL = 'SELECT X.EMPText, X.EMPValue FROM
(SELECT ''All Employees'' EMPText, ''%'' EMPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.EMP_Name EMPText, eh.EMP_Name EMPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
and s.[Status] = '''+@strFormStatus+'''
and eh.EMP_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.EMPText'	
	

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
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct managers from e-Coaching records to display on staff dashboard for filter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Managers to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted] 
@strCSRMGRin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime


 Set @strFormStatus = 'Completed'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
		
SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
and s.Status = '''+@strFormStatus+'''
and eh.Mgr_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.MgrText'

EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted

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
-- Last Modified Date: 04/16/2015
-- Last Updated By: Susmitha Palacherla
-- Modified to rename CSRID to EmpID to support the Modular design.
-- 1. To Replace old style joins.
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted] 
@strCSRMGRin nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Completed'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)
 	

SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
AND S.Status = '''+@strFormStatus+'''
and eh.SUP_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.SUPText'

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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted] 
@strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Completed'
 Set @strFormStatus2 = 'Inactive'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)


SET @nvcSQL = 'SELECT X.EMPText, X.EMPValue FROM
(SELECT ''All Employees'' EMPText, ''%'' EMPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.EMP_Name	EMPText, eh.EMP_Name EMPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
and s.[Status] <> '''+@strFormStatus+'''
AND S.Status <> '''+@strFormStatus2+'''
and eh.EMP_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.EMPText'	

		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Managers to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Completed'
 Set @strFormStatus2 = 'Inactive'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
and eh.Mgr_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.MgrText'	

 
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted]  
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Completed'
 Set @strFormStatus2 = 'Inactive'
 Set @dtmDate  = GETDATE()   
 Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

 
SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
		AND S.Status <> '''+@strFormStatus+'''
		AND S.Status <> '''+@strFormStatus2+'''
and eh.SUP_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.SUPText'
 
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All employees to the return
-- 3. Lan ID association by date
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSR] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Inactive'
 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT X.EMPText, X.EMPValue FROM
(SELECT ''All Employees'' EMPText, ''%'' EMPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.EMP_Name	EMPText, eh.EMP_Name EMPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcSUPID+'''
and s.Status <> '''+@strFormStatus+'''
and eh.EMP_Name is NOT NULL
and sh.Emp_ID <> ''999999'') X
Order By X.Sortorder, X.EMPText'
		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeam] 
@strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employeess'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID 
where eh.Sup_ID = '''+@nvcSUPID+'''
and [S].[Status] like ''Pending%''
and eh.Emp_Name is NOT NULL
and eh.Sup_ID <> ''999999'') X
ORDER BY X.Sortorder, X.EmpText'

		
EXEC (@nvcSQL)
--PRINT @nvcSQL	

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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Employees to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted] 
@strCSRSUPin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime


 Set @strFormStatus = 'Completed'
 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)


SET @nvcSQL = 'SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employeess'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID 
where eh.Sup_ID = '''+@nvcSUPID+'''
and [S].[Status] = '''+@strFormStatus+'''
and eh.Emp_Name is NOT NULL
and eh.Sup_ID <> ''999999'') X
ORDER BY X.Sortorder, X.EmpText'

		
EXEC (@nvcSQL)
--PRINT @nvcSQL	

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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Managers to the return
-- 3. Lan ID association by date
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Inactive'
 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcSUPID+'''
and s.Status <> '''+@strFormStatus+'''
and eh.Mgr_Name is NOT NULL
and sh.Emp_ID <> ''999999'') X
Order By X.Sortorder, X.MgrText'
		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Managers to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted]
 @strCSRSUPin nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Completed'
 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where eh.Sup_ID = '''+@nvcSUPID+'''
and s.Status = '''+@strFormStatus+'''
and eh.Mgr_Name is NOT NULL
and eh.Sup_ID <> ''999999'') X
Order By X.Sortorder, X.MgrText'
		
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All supervisors to the return
-- 3. Lan ID association by date
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctSUP] @strCSRSUPin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSUPID Nvarchar(10),
@dtmDate datetime

 Set @strFormStatus = 'Inactive'
 Set @dtmDate  = GETDATE()   
 Set @nvcSUPID = EC.fn_nvcGetEmpIdFromLanID(@strCSRSUPin,@dtmDate)

SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID ='''+@nvcSUPID+'''
and s.Status <> '''+@strFormStatus+'''
and eh.SUP_Name is NOT NULL
and  sh.Emp_ID <> ''999999'') X
Order By X.Sortorder, X.SUPText'
		
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
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 06/12/2015
-- Updated per SCR 14966 to add EmpID and SubmitterID to the select list.
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log] @strFormIDin nvarchar(50)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)
	 
  SET @nvcSQL = 'SELECT  cl.CoachingID 	numID,
		cl.FormName	strFormID,
		m.Module,
		sc.CoachingSource	strFormType,
		s.Status	strFormStatus,
		cl.EventDate	EventDate,
		cl.CoachingDate	CoachingDate,
		cl.SubmitterID strSubmitterID,
		sh.Emp_LanID	strSubmitter,		
		sh.Emp_Name	strSubmitterName,
		sh.Emp_Email	strSubmitterEmail,	
		cl.EmpID strEmpID,		
		cl.EmpLanID	strEmpLanID,
		eh.Emp_Name	strCSRName,
		eh.Emp_Email	strCSREmail,
		st.City	strCSRSite,
		eh.Sup_LanID strCSRSup,
		eh.Sup_Name	 strCSRSupName,
		eh.Sup_Email  strCSRSupEmail,
		CASE WHEN cl.[strReportCode] like ''LCS%'' 
		 THEN [EC].[fn_strEmpLanIDFromEmpID](cl.[MgrID])
		 ELSE eh.Mgr_LanID END	strCSRMgr,
		eh.Mgr_Name  strCSRMgrName,
		eh.Mgr_Email strCSRMgrEmail,
		ISNULL(suph.Emp_Name,''Unknown'') strReviewer,
        sc.SubCoachingSource	strSource,
        CASE WHEN sc.SubCoachingSource in (''Verint-GDIT'',''Verint-TQC'',''LimeSurvey '',''IQS'')
		THEN 1 ELSE 0 END 	isIQS,
		cl.isUCID    isUCID,
		cl.UCID	strUCID,
		cl.isVerintID	isVerintMonitor,
		cl.VerintID	strVerintID,
		cl.VerintFormName VerintFormName,
		cl.isAvokeID	isBehaviorAnalyticsMonitor,
		cl.AvokeID	strBehaviorAnalyticsID,
		cl.isNGDActivityID	isNGDActivityID,
		cl.NGDActivityID	strNGDActivityID,
		CASE WHEN cc.CSE = ''Opportunity'' Then 1 ELSE 0 END	"Customer Service Escalation",
		CASE WHEN cc.CCI is Not NULL Then 1 ELSE 0 END	"Current Coaching Initiative",
		CASE WHEN cc.OMR is Not NULL AND cc.LCS is NULL Then 1 ELSE 0 END	"OMR / Exceptions",
		CASE WHEN cc.ETSOAE is Not NULL Then 1 ELSE 0 END	"ETS / OAE",
		CASE WHEN cc.ETSOAS is Not NULL Then 1 ELSE 0 END	"ETS / OAS",
		CASE WHEN cc.LCS is Not NULL Then 1 ELSE 0 END	"LCS",
		cl.Description txtDescription,
		cl.CoachingNotes txtCoachingNotes,
		cl.isVerified,
		cl.SubmittedDate,
		cl.StartDate,
		cl.SupReviewedAutoDate,
		cl.isCSE,
		cl.MgrReviewManualDate,
		cl.MgrReviewAutoDate,
		cl.MgrNotes txtMgrNotes,
		cl.isCSRAcknowledged,
		cl.isCoachingRequired,
		cl.CSRReviewAutoDate,
		cl.CSRComments txtCSRComments
	    FROM  [EC].[Coaching_Log] cl JOIN
	  (SELECT  ccl.FormName,
	 MAX(CASE WHEN [cr].[CoachingReason] = ''Customer Service Escalation'' THEN [clr].[Value] ELSE NULL END)	CSE,
	 MAX(CASE WHEN [cr].[CoachingReason] = ''Current Coaching Initiative'' THEN [clr].[Value] ELSE NULL END)	CCI,
	 MAX(CASE WHEN [cr].[CoachingReason] = ''OMR / Exceptions'' THEN [clr].[Value] ELSE NULL END)	OMR,
	 MAX(CASE WHEN [clr].[SubCoachingReasonID] = 120 THEN [clr].[Value] ELSE NULL END)	ETSOAE,
	 MAX(CASE WHEN [clr].[SubCoachingReasonID] = 121 THEN [clr].[Value] ELSE NULL END)	ETSOAS,
	 MAX(CASE WHEN [clr].[SubCoachingReasonID] = 34 THEN [clr].[Value] ELSE NULL END)	LCS
	 FROM [EC].[Coaching_Log_Reason] clr,
	 [EC].[DIM_Coaching_Reason] cr,
	 [EC].[Coaching_Log] ccl 
	 WHERE [ccl].[FormName] = '''+@strFormIDin+'''
	 AND [clr].[CoachingReasonID] = [cr].[CoachingReasonID]
	 AND [ccl].[CoachingID] = [clr].[CoachingID] 
	 GROUP BY ccl.FormName ) cc
ON [cl].[FormName] = [cc].[FormName] JOIN  [EC].[Employee_Hierarchy] eh
	 ON [cl].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	 ON [cl].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] suph
	 ON ISNULL([cl].[Review_SupID],''999999'') = [suph].[Emp_ID] JOIN [EC].[Employee_Hierarchy] mgrh
	 ON ISNULL([cl].[Review_MgrID],''999999'') = [mgrh].[Emp_ID]JOIN [EC].[DIM_Status] s
	 ON [cl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source] sc
     ON [cl].[SourceID] = [sc].[SourceID] JOIN [EC].[DIM_Site] st
	 ON [cl].[SiteID] = [st].[SiteID] JOIN [EC].[DIM_Module] m ON [cl].[ModuleID] = [m].[ModuleID]
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
--    Last Update:    12/16/2014
--    Updated per SCR 13891 to capture review sup id.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update1Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcReviewSupLanID Nvarchar(20),
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

DECLARE @nvcReviewSupID Nvarchar(10),
	    @dtmDate datetime
       
SET @dtmDate  = GETDATE()   
SET @nvcReviewSupID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewSupLanID,@dtmDate)

UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
	       Review_SupID = @nvcReviewSupID,
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
--    Last Update:    12/16/2014
--    Updated per SCR 13891 to capture review sup id.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update2Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcReviewMgrLanID Nvarchar(20),
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

DECLARE @nvcReviewMgrID Nvarchar(10),
	    @dtmDate datetime
       
SET @dtmDate  = GETDATE()   
SET @nvcReviewMgrID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewMgrLanID,@dtmDate)
      
UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
	       Review_MgrID = @nvcReviewMgrID,
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
--    Last Update:    12/16/2014
--    Updated per SCR 13891 to capture review mgr id.
--    =====================================================================
CREATE  PROCEDURE [EC].[sp_Update3Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcReviewMgrLanID Nvarchar(20),
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
      
      DECLARE @nvcReviewMgrID Nvarchar(10),
	    @dtmDate datetime
       
SET @dtmDate  = GETDATE()   
SET @nvcReviewMgrID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewMgrLanID,@dtmDate)
	
UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
	       Review_MgrID = @nvcReviewMgrID,
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
--    Last Update:    01/16/2015
--    Updated per SCR 14031 to incorporate OA Reports.

--    =====================================================================
ALTER PROCEDURE [EC].[sp_Update5Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcstrReasonNotCoachable Nvarchar(30),
      @nvcReviewerLanID Nvarchar(20),
      @dtmReviewAutoDate datetime,
      @dtmReviewManualDate datetime,
      @bitisCoachingRequired bit,
      @nvcReviewerNotes Nvarchar(max),
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

DECLARE @nvcReviewerID Nvarchar(10),
	    @dtmDate datetime,
	    @nvcCat Nvarchar (10)
       
SET @dtmDate  = GETDATE()   
SET @nvcReviewerID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewerLanID,@dtmDate)
SET @nvcCat = (select RTRIM(LEFT(strReportCode,LEN(strReportCode)-8)) from EC.Coaching_Log where FormName = @nvcFormID) 


  IF @nvcCat IN ('OAE','OAS')

BEGIN      
UPDATE 	EC.Coaching_Log
SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
        Review_SupID = @nvcReviewerID,
		strReasonNotCoachable = @nvcstrReasonNotCoachable,
		isCoachingRequired = @bitisCoachingRequired,
		SupReviewedAutoDate =  @dtmReviewAutoDate,
		CoachingDate =  @dtmReviewManualDate,
		CoachingNotes = @nvcReviewerNotes,		   
		txtReasonNotCoachable = @nvctxtReasonNotCoachable 
	WHERE FormName = @nvcFormID
        OPTION (MAXDOP 1)
        
  
UPDATE EC.Coaching_Log_Reason
SET Value = (CASE WHEN @bitisCoachingRequired = 'True' then 'Opportunity' ELSE 'Not Coachable' END)
  	FROM EC.Coaching_Log cl INNER JOIN EC.Coaching_Log_Reason clr
	ON cl.CoachingID = clr.CoachingID
	WHERE cl.FormName = @nvcFormID
and clr.SubCoachingReasonID in (120,121)
        OPTION (MAXDOP 1)

END

ELSE

BEGIN

UPDATE 	EC.Coaching_Log
SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
        Review_MgrID = @nvcReviewerID,
		strReasonNotCoachable = @nvcstrReasonNotCoachable,
		isCoachingRequired = @bitisCoachingRequired,
		MgrReviewAutoDate = @dtmReviewAutoDate,
		MgrReviewManualDate = @dtmReviewManualDate,
		MgrNotes = @nvcReviewerNotes,		   
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

--    ====================================================================
--    Author:                 Jourdain Augustin
--    Create Date:      7/31/13
--    Description: *    This procedure allows Sups to update the e-Coaching records from the review page for Pending Acknowledgment records. 
--    Last Update:    12/16/2014
--    Updated per SCR 13891 to capture review sup id.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update7Review_Coaching_Log]
(
      @nvcFormID Nvarchar(50),
      @nvcFormStatus Nvarchar(30),
      @nvcReviewSupLanID Nvarchar(20),
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
DECLARE @nvcReviewSupID Nvarchar(10),
	    @dtmDate datetime
       
SET @dtmDate  = GETDATE()   
SET @nvcReviewSupID = EC.fn_nvcGetEmpIdFromLanID(@nvcReviewSupLanID,@dtmDate)

UPDATE [EC].[Coaching_Log]
	   SET StatusID = (select StatusID from EC.DIM_Status where status = @nvcFormStatus),
	       Review_SupID = @nvcReviewSupID,
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 06/12/2015
-- Updated per SCR 14966 to add EmpID and Active flag to the select list.
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
 SET @nvcSQL = 'SELECT [Emp_Job_Code] + ''$'' + [Emp_Email] + ''$'' +  [Emp_Name] + ''$'' + 
              [Emp_ID] + ''$'' +  CASE WHEN [Active] = ''A'' THEN ''Y'' ELSE ''N'' END  as Submitter
              FROM [EC].[Employee_Hierarchy]WITH(NOLOCK)
              WHERE [Emp_ID] = '''+@EmpID+''''
            
		
EXEC (@nvcSQL)	
--Print @nvcSQL
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 06/12/2015
-- Updated per SCR 14966 to use the Employee ID as input parameter instead of Emp Lan ID.
--  
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Whoisthis] 


(
 @strUserIDin	Nvarchar(30)
)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT [Sup_LanID] + ''$'' + [Mgr_LanID] Flow
              FROM [EC].[Employee_Hierarchy]
              WHERE [Emp_ID] = '''+ @strUserIDin+''''

		
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
--  Last Modified By: Susmitha Palacherla
--  Last Modified date: 04/15/2015
--  Modified per SCR 14512 while adding Training Module to restrict  users with certain 
--  job codes from submitting Training ecls for some job codes.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_By_Module] 

@strModulein nvarchar(30), @strCSRSitein nvarchar(30)= NULL,
@strUserLanin nvarchar(20)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcEmpJobCode nvarchar(30),
@nvcEmpID nvarchar(10),
@dtmDate datetime,
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(1000),
@nvcSQL02 nvarchar(1000),
@nvcSQL03 nvarchar(1000),
@nvcSQL04 nvarchar(1000)

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strUserLanin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)

-- General Selection of employees based on Job codes flagged in Employee Selection table.

SET @nvcSQL01 = 'select [Emp_Name] + '' ('' + [Emp_LanID] + '') '' + [Emp_Job_Description] as FrontRow1
	  ,[Emp_Name] + ''$'' + [Emp_Email] + ''$'' + [Emp_LanID] + ''$'' + [Sup_Name] + ''$'' + [Sup_Email] + ''$'' + [Sup_LanID] + ''$'' + [Sup_Job_Description] + ''$'' + [Mgr_Name] + ''$'' + [Mgr_Email] + ''$'' + [Mgr_LanID] + ''$'' + 

[Mgr_Job_Description]  + ''$'' + [Emp_Site] as BackRow1, [Emp_Site]
       from [EC].[Employee_Hierarchy] WITH (NOLOCK) JOIN [EC].[Employee_Selection]
       on [EC].[Employee_Hierarchy].[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code]
where [EC].[Employee_Selection].[is'+ @strModulein + ']= 1
and [Emp_lanID] <> '''+@strUserLanin+ ''''


-- Conditional filter for Modules that are flagged as BySite in DIM Module

SET @nvcSQL02 = ' and [Emp_Site] = ''' +@strCSRSitein + ''''


-- Conditional Filter to restrtict Training staff with specific job codes to submit only for certain job codes.

SET @nvcSQL03 = ' and [Emp_Job_Code] NOT IN (''WTTR12'', ''WTTR13'', ''WTID13'')' 


-- Generic  Filter for all scenarios.

SET @nvcSQL04 = ' and [End_Date] = ''99991231''
and [Emp_LanID]is not NULL and [Sup_LanID] is not NULL and [Mgr_LanID]is not NULL
order By [Emp_Name] ASC'

--IF @strModulein = 'CSR'
SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isBySite = 1

SET @nvcSQL = @nvcSQL01 + @nvcSQL02 +@nvcSQL04 
ELSE

IF @nvcEmpJobCode IN ('WTTR12', 'WTTR13', 'WTID13') 

SET @nvcSQL = @nvcSQL01 + @nvcSQL03 + @nvcSQL04 

ELSE
SET @nvcSQL = @nvcSQL01 + @nvcSQL04 

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
--  Last Modified Date: 04/10/2015
--  Modified per SCR 14512 to add Training Module.

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
 5. Whether warning will be displayed for Direct or Not
 6.Whether program will be a selection or not
 7. whether behavior will be a selection or not
*/

SET @nvcSQL = 'SELECT TOP 1 CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, ''1-CSR-1-1-1-1-0'' as BySite
from [EC].[Module_Submission]'
 
ELSE

SET @nvcSQL = 'SELECT Module, BySite FROM 
(SELECT CASE WHEN [CSR]= 1 THEN N''CSR'' ELSE N''CSR'' END as Module, ''1-CSR-1-1-1-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION
SELECT CASE WHEN [Supervisor]= 1 THEN N''Supervisor'' ELSE NULL END as Module, ''0-Supervisor-2-1-1-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [Quality]= 1 THEN N''Quality'' ELSE NULL END as Module, ''0-Quality Specialist-3-0-0-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [LSA]= 1 THEN N''LSA'' ELSE NULL END as Module, ''0-LSA-4-0-0-1-0'' as BySite from [EC].[Module_Submission] 
where Job_Code = '''+@nvcEmpJobCode+'''
UNION 
SELECT CASE WHEN [Training]= 1 THEN N''Training'' ELSE NULL END as Module, ''0-Training-5-1-0-0-1'' as BySite from [EC].[Module_Submission] 
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

--66. Create SP  [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	03/10/2015
--  Description: Populates the Submitter values in the dashboard filter dropdown.
--  Created as part of SCR 14422 for the dashboard redesign.
-- Last Modified Date: 05/28/2015
-- Modified to add unknown as a constant per SCr 14893 Round 2 perf improvement.
-- 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)

-- UNION of 3 separate selects for ordering.
-- Wild card value followed by regular data followed by unknown values.

SET @nvcSQL = 'SELECT X.SubmitterText, X.SubmitterValue FROM
(SELECT ''All Submitters'' SubmitterText, ''%'' SubmitterValue, 01 Sortorder 
UNION
SELECT DISTINCT sh.Emp_Name	SubmitterText, cl.SubmitterID SubmitterValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh  ON
cl.SubmitterID = sh.Emp_ID
where cl.SubmitterID is not NULL 
and cl.SubmitterID  <> ''999999''
and cl.StatusID <> 2
UNION
SELECT ''Unknown'' SubmitterText, ''999999'' SubmitterValue, 03 Sortorder
)X
ORDER BY X.Sortorder, X.SubmitterText'


--Print @nvcSQL
EXEC (@nvcSQL)	


End --sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2


GO



******************************************************************

--67. Create SP  [EC].[sp_Select_Sites_For_Dashboard]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Sites_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Sites_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Sites to be displayed in the dashboard
--  Site dropdown list.
-- Last Modified Date: 06/01/2015
-- Last Modified Bt: Susmitha Palacherla
-- Modified per SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Sites_For_Dashboard] 

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.SiteText, X.SiteValue FROM
(SELECT ''All Locations'' SiteText, ''%'' SiteValue, 01 Sortorder From [EC].[DIM_Site]
UNION
SELECT [City] SiteText, CONVERT(nvarchar,[SiteID]) SiteValue, 02 Sortorder From [EC].[DIM_Site]
where [isActive]= 1)X
ORDER BY X.Sortorder'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sites_For_Dashboard
GO


******************************************************************

--68. Create SP  [EC].[sp_Select_Sources_For_Dashboard]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Sources_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Sources_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Sources to be displayed in the dashboard
--  Source dropdown list.
--  Last Modified: 06/11/2015
--  Last Modified Bt: Susmitha Palacherla
--  Modified per SCR 14916 to add additional HR job codes.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Sources_For_Dashboard] 
@strUserin nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@strjobcode  nvarchar(20),
	@nvcEmpID nvarchar(10),
	@dtmDate datetime
	
		
	
SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)
SET @strjobcode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)	
	


-- Check users job code and show 'Warning' as a source only for HR users.

IF @strjobcode in ('WHER13', 'WHER50',
'WHHR12', 'WHHR13', 'WHHR14',
'WHHR50', 'WHHR60', 'WHHR80',
'WHHR11', 'WHRC11', 'WHRC12', 'WHRC13')

SET @nvcSQL = 'SELECT X.SourceText, X.SourceValue FROM
(SELECT ''All Sources'' SourceText, ''%'' SourceValue, 01 Sortorder From [EC].[DIM_Source]
UNION
SELECT [SubCoachingSource] SourceText,  [SubCoachingSource] SourceValue, 02 Sortorder From [EC].[DIM_Source]
Where [SubCoachingSource] <> ''Unknown''
and [isActive]= 1)X
ORDER BY X.Sortorder'

ELSE

SET @nvcSQL = 'SELECT X.SourceText, X.SourceValue FROM
(SELECT ''All Sources'' SourceText, ''%'' SourceValue, 01 Sortorder From [EC].[DIM_Source]
UNION
SELECT  [SubCoachingSource] SourceText,  [SubCoachingSource] SourceValue, 02 Sortorder From [EC].[DIM_Source]
Where [SubCoachingSource] not in ( ''Warning'',''Unknown'')
and [isActive]= 1)X
ORDER BY X.Sortorder'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sources_For_Dashboard

GO





******************************************************************

--69. Create SP  [EC].[sp_Select_States_For_Dashboard]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_States_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_States_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/13/2015
--	Description: *	This procedure returns list of possible States for Warning Logs.
--  The 2 possible States of a Warning log are Active (within 91 days of warning given date) and Expired 
--  for logs that have WarningGivenDate over 91 days.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_States_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.StateText, X.StateValue FROM
(SELECT ''All States'' StateText, ''%'' StateValue, 01 Sortorder 
UNION
SELECT ''Active'' StateText, ''1'' StateValue, 02 Sortorder 
UNION
SELECT ''Expired'' StateText, ''0'' StateValue, 03 Sortorder 
)X
ORDER BY X.Sortorder'



--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_States_For_Dashboard


GO




******************************************************************

--70. Create SP  [EC].[sp_Select_Statuses_For_Dashboard] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Statuses_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Statuses_For_Dashboard]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Statuses to be displayed in the dashboard
--  Status dropdown list.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Statuses_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.StatusText, X.StatusValue FROM
(SELECT ''All Statuses'' StatusText, ''%'' StatusValue, 01 Sortorder From [EC].[DIM_Status]
UNION
SELECT [Status] StatusText, [Status] StatusValue, 02 Sortorder From [EC].[DIM_Status]
Where [Status] NOT IN (''Inactive'', ''Unknown''))X
ORDER BY X.Sortorder'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Statuses_For_Dashboard



GO





******************************************************************

--71. Create SP  [EC].[sp_Select_Values_For_Dashboard]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Values_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Values_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Values to be displayed in the dashboard
--  filter dropdown list.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Values_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.ValueText, X.ValueValue FROM
(SELECT ''All Values'' ValueText, ''%'' ValueValue, 01 Sortorder 
UNION
SELECT Distinct [Value] ValueText, [Value] ValueValue, 02 Sortorder From [EC].[Coaching_Log_Reason]
Where [Value] IS NOT NULL
AND [Value] <> ''Not Coachable'')X
ORDER BY X.Sortorder, X.ValueText'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Values_For_Dashboard

GO


******************************************************************

--72. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/05/2015
--	Description: *	This procedure selects all the Coaching logs for Employees that fall under the Senior Manager 
--  in the Hierarchy table.
-- Last Modified Date: 04/17/2015
-- Last Updated By: Susmitha Palacherla
-- Created per SCR 14423 to extend dashboard functionality to senior leadership.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching] 
@strEMPSRMGRin nvarchar(30),
@strEMPMGRin nvarchar(30),
@strEMPSUPin nvarchar(30),
@strEMPin nvarchar(30), 
@strSourcein nvarchar(100),
@strSDatein datetime,
@strEDatein datetime,
@strStatus nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strSrMgrEmpID nvarchar(10),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@intStatusID INT

Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))
Set @strFormStatus = 'Inactive'

SET @nvcSQL = ';WITH SrHierarchy As
(SELECT Emp_ID, [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])as Lvl1Mgr,
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])as Lvl2Mgr,
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])as Lvl3Mgr 
From [EC].[Employee_Hierarchy]H
where [H].[Emp_Name] Like '''+@strEMPin+'''
and [H].[Sup_Name] Like '''+@strEMPSUPin+'''
and [H].[Mgr_Name] Like '''+@strEMPMGRin+''')
SELECT [cl].[FormName]	strFormID,
		[eh].[Emp_Name]	strEmpName,
		[eh].[Sup_Name]	strEmpSupName, 
		[eh].[Mgr_Name]	strEmpMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[cl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
[cl].[EmpID] = [eh].[Emp_ID]Join [EC].[DIM_Status] s ON
[cl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[cl].[SourceID] = [sc].[SourceID] JOIN SrHierarchy ON
SrHierarchy.Emp_ID = [eh].[Emp_ID]
WHERE (SrHierarchy.Lvl1Mgr = '''+@strSrMgrEmpID+''' OR
SrHierarchy.Lvl2Mgr = '''+@strSrMgrEmpID+''' OR SrHierarchy.Lvl3Mgr = '''+@strSrMgrEmpID+''')
and [S].[Status] like  '''+@strStatus+''' + ''%''
and convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''
and [sc].[SubCoachingSource] Like '''+@strSourcein+'''
and [s].[Status] <> '''+@strFormStatus+'''
and SrHierarchy.Lvl1Mgr <> ''999999''
and SrHierarchy.Lvl2Mgr <> ''999999'' 
and SrHierarchy.Lvl3Mgr <> ''999999''
ORDER BY submitteddate desc'



EXEC (@nvcSQL)
--Print @nvcSQL	   
END --sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching
GO




******************************************************************

--73. Create SP  [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/23/2015
--	Description: *	This procedure selects the distinct Employees under a senior manager from e-Coaching records to display on dashboard for filter. 
--  Created per scr 14423.
--  Last Modified by: Susmitha Palacherla
--  Last Modified Date: 04/17/2015

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam] 
@strCSRSrMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSrMgrEmpID nvarchar(10)

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strCSRSrMGRin, GETDATE()))
SET @strFormStatus = 'Inactive'

SET @nvcSQL =  ';WITH SrHierarchy As
(SELECT Emp_ID, [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])as Lvl1Mgr,
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])as Lvl2Mgr,
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])as Lvl3Mgr 
From [EC].[Employee_Hierarchy]H WITH (NOLOCK)
)SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employees'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID JOIN SrHierarchy ON
SrHierarchy.Emp_ID = [eh].[Emp_ID]
WHERE (SrHierarchy.Lvl1Mgr = '''+@strSrMgrEmpID+''' OR
SrHierarchy.Lvl2Mgr = '''+@strSrMgrEmpID+''' OR SrHierarchy.Lvl3Mgr = '''+@strSrMgrEmpID+''')
and [S].[Status] <> '''+@strFormStatus+'''
and eh.Emp_Name is NOT NULL
and SrHierarchy.Lvl1Mgr <> ''999999''
and SrHierarchy.Lvl2Mgr <> ''999999'' 
and SrHierarchy.Lvl3Mgr <> ''999999'') X
ORDER BY X.Sortorder, X.EmpText'
		
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam



GO




******************************************************************

--74. Create SP  [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/23/2015
--	Description: *	This procedure selects the distinct Managers under a senior manager from e-Coaching records 
--  in the dasboard filter. 
--  Created per scr 14423.
--  Last Modified by: Susmitha Palacherla
--  Last Modified Date: 04/17/2015

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam] 
@strCSRSrMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSrMgrEmpID nvarchar(10)

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strCSRSrMGRin, GETDATE()))
SET @strFormStatus = 'Inactive'

SET @nvcSQL =  ';WITH SrHierarchy As
(SELECT Emp_ID, [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])as Lvl1Mgr,
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])as Lvl2Mgr,
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])as Lvl3Mgr 
From [EC].[Employee_Hierarchy]H WITH (NOLOCK))
SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.MGR_Name	MGRText, eh.MGR_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID JOIN SrHierarchy ON
SrHierarchy.Emp_ID = [eh].[Emp_ID]
WHERE (SrHierarchy.Lvl1Mgr = '''+@strSrMgrEmpID+''' OR
SrHierarchy.Lvl2Mgr = '''+@strSrMgrEmpID+''' OR SrHierarchy.Lvl3Mgr = '''+@strSrMgrEmpID+''')
and [S].[Status] <> '''+@strFormStatus+'''
and eh.MGR_Name is NOT NULL
and SrHierarchy.Lvl1Mgr <> ''999999''
and SrHierarchy.Lvl2Mgr <> ''999999'' 
and SrHierarchy.Lvl3Mgr <> ''999999'') X
Order By X.Sortorder, X.MGRText'
		
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam



GO


******************************************************************

--75. Create SP  [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/23/2015
--	Description: *	This procedure selects the distinct Supervisors  under a senior manager from e-Coaching records 
--  in the dasboard filter. 
--  Created per scr 14423.
--  Last Modified by: Susmitha Palacherla
--  Last Modified Date: 04/17/2015

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam] 
@strCSRSrMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSrMgrEmpID nvarchar(10)

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strCSRSrMGRin, GETDATE()))
SET @strFormStatus = 'Inactive'

SET @nvcSQL =  ';WITH SrHierarchy As
(SELECT Emp_ID, [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])as Lvl1Mgr,
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])as Lvl2Mgr,
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])as Lvl3Mgr 
From [EC].[Employee_Hierarchy]H WITH (NOLOCK))
SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID JOIN SrHierarchy ON
SrHierarchy.Emp_ID = [eh].[Emp_ID]
WHERE (SrHierarchy.Lvl1Mgr = '''+@strSrMgrEmpID+''' OR
SrHierarchy.Lvl2Mgr = '''+@strSrMgrEmpID+''' OR SrHierarchy.Lvl3Mgr = '''+@strSrMgrEmpID+''')
and [S].[Status] <> '''+@strFormStatus+'''
and eh.SUP_Name is NOT NULL
and SrHierarchy.Lvl1Mgr <> ''999999''
and SrHierarchy.Lvl2Mgr <> ''999999'' 
and SrHierarchy.Lvl3Mgr <> ''999999'') X
Order By X.Sortorder, X.SUPText'
		
		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam



GO




******************************************************************

--76. Create SP  [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/05/2015
--	Description: *	This procedure selects all the Warning logs for Employees that fall under the Senior Manager 
--  in the Hierarchy table.
-- Last Modified Date: -- Last Modified Date: 04/17/2015
-- Last Updated By: 
-- Created per SCR 14423 to extend dashboard functionality to senior leadership.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@bitActive nvarchar(1)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@strSrMgrEmpID Nvarchar(10),
@dtmDate datetime


Set @strFormStatus = 'Completed'
Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)
Set @dtmDate  = GETDATE()   
Set @strSrMgrEmpID = EC.fn_nvcGetEmpIdFromLanID(@strEMPSRMGRin,@dtmDate)


SET @nvcSQL = ';WITH SrHierarchy As
(SELECT Emp_ID, [EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])as Lvl1Mgr,
[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])as Lvl2Mgr,
[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])as Lvl3Mgr 
From [EC].[Employee_Hierarchy]H WITH (NOLOCK)
)
SELECT [wl].[FormName]	strFormID,
		[eh].[Emp_Name]	strEmpName,
		[eh].[Sup_Name]	strEmpSupName, 
		[eh].[Mgr_Name]	strEmpMgrName, 
		[s].[Status]	strFormStatus,
		[sc].[SubCoachingSource] strSource,
		[wl].[SubmittedDate]	SubmittedDate
FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN [EC].[Warning_Log] wl WITH (NOLOCK) ON
[wl].[EmpID] = [eh].[Emp_ID] Join [EC].[DIM_Status] s ON
[wl].[StatusID] = [s].[StatusID] JOIN  [EC].[DIM_Source] sc ON
[wl].[SourceID] = [sc].[SourceID] JOIN SrHierarchy ON
SrHierarchy.Emp_ID = [eh].[Emp_ID]
WHERE (SrHierarchy.Lvl1Mgr = '''+@strSrMgrEmpID+''' OR
SrHierarchy.Lvl2Mgr = '''+@strSrMgrEmpID+''' OR SrHierarchy.Lvl3Mgr = '''+@strSrMgrEmpID+''')
and [s].[Status] = '''+@strFormStatus+'''
and convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
and [wl].[Active] like '''+ CONVERT(NVARCHAR,@bitActive) + '''
and SrHierarchy.Lvl1Mgr <> ''999999''
and SrHierarchy.Lvl2Mgr <> ''999999'' 
and SrHierarchy.Lvl3Mgr <> ''999999''
ORDER BY submitteddate desc'

		
EXEC (@nvcSQL)
--Print @nvcSQL	   
END --sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning
GO




******************************************************************


--77. Create SP  [EC].[sp_Select_Behaviors] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Behaviors' 
)
   DROP PROCEDURE [EC].[sp_Select_Behaviors]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/10/2015
--	Description: *	This procedure returns a list of Behaviors to
--  be made available in the UI submission page for Modules that track Behavior.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Behaviors] 
@strModulein nvarchar(30)

AS
BEGIN
	DECLARE	
	@isByBehavior BIT,
	@nvcSQL nvarchar(max)
	
SET @isByBehavior = (SELECT ByBehavior FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isByBehavior = 1

SET @nvcSQL = 'Select [Behavior] as Behavior from [EC].[DIM_Behavior]
Order by CASE WHEN [Behavior] = ''Other'' Then 1 Else 0 END, [Behavior]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Behaviors

GO

******************************************************************







--78. Create SP  [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons_Combined] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_Reasons_Combined' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons_Combined]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/12/2015
--	Description: 	This procedure displays the Coaching Log or Warning log Reasons 
--  and Sub Coaching Reason values for a given Form Name.

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons_Combined] @strFormIDin nvarchar(50)
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@intCoachingID INT,
	@intWarningID INT

 
SET @intCoachingID = (SELECT CoachingID From [EC].[Coaching_Log]where[FormName]=@strFormIDin)

IF @intCoachingID IS NULL

BEGIN

SET @intWarningID = (SELECT WarningID From [EC].[Warning_Log]where[FormName]=@strFormIDin)


SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, wlr.value
FROM [EC].[Warning_Log_Reason] wlr join [EC].[DIM_Coaching_Reason] cr
ON[wlr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [wlr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where WarningID = '''+CONVERT(NVARCHAR(20),@intWarningID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,wlr.value'

END

ELSE

SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, clr.value
FROM [EC].[Coaching_Log_Reason] clr join [EC].[DIM_Coaching_Reason] cr
ON[clr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [clr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where CoachingID = '''+CONVERT(NVARCHAR(20),@intCoachingID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,clr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_Reasons_Combined

GO


--******************************************************************

--79. Create SP [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP_Count] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_HistoricalSUP_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/28/2015
--	Description: *	This procedure returns the count of completed   e-Coaching  records that will be 
--  displayed for the selected criteria on the SUP historical page.
-- Create per SCR 14893 dashboard redesign performance round 2.
--  Last Modified: 06/11/2015
--  Last Modified Bt: Susmitha Palacherla
--  Modified per SCR 14916 to add additional HR job codes.

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP_Count] 

@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSubmitterin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strStatusin nvarchar(30), 
@strjobcode  nvarchar(20),
@strvalue  nvarchar(30)
--@intRecordCount int OUT

AS


BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@where nvarchar(max) 
      
    
SET @strFormStatus = 'Inactive'
SET @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)

SET @where = ' WHERE convert(varchar(8),[cl].[SubmittedDate],112) >= '''+@strSDate+'''' +  
			 ' AND convert(varchar(8),[cl].[SubmittedDate],112) <= '''+@strEDate+'''' +
			 ' AND [cl].[StatusID] <> 2'
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = '''+@strSourcein+''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = '''+@strStatusin+''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = '''+@strvalue+''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   '''+@strCSRin+'''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = '''+@strSUPin+'''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = '''+@strMGRin+'''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = '''+@strSubmitterin+'''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[cl].[SiteID]) = '''+@strCSRSitein+''''
END			 

SET @nvcSQL1 = 'WITH TempCoaching AS 
        (select DISTINCT x.strFormID
	from (
     SELECT DISTINCT [cl].[FormName]	strFormID
	 FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK)
ON cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si
ON cl.SiteID = si.SiteID JOIN  [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
ON cl.CoachingID = clr.CoachingID'
+ @where + 
' GROUP BY [cl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[cl].[SubmittedDate],[sh].[Emp_Name],[cl].[CoachingID]'

SET @where = ' WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+'''' +  
			 ' AND convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''' +
			 ' AND [wl].[StatusID] <> 2'
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = '''+@strSourcein+''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = '''+@strStatusin+''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [wlr].[value] = '''+@strvalue+''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [wl].[EmpID] = '''+@strCSRin+'''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = '''+@strSUPin+'''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = '''+@strMGRin+''''
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [wl].[SubmitterID] = '''+@strSubmitterin+'''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[wl].[SiteID]) = '''+@strCSRSitein+''''
END	


SET @nvcSQL2 = ' UNION
     SELECT DISTINCT [wl].[FormName]	strFormID
	FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log] wl WITH(NOLOCK)
ON wl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON wl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON wl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON wl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si
ON wl.SiteID = si.SiteID JOIN  [EC].[Warning_Log_Reason] wlr WITH (NOLOCK)
ON wl.WarningID = wlr.WarningID'
+ @where + 
' GROUP BY [wl].[FormName],[eh].[Emp_Name],[eh].[Sup_Name],[eh].[Mgr_Name],
[s].[Status],[so].[SubCoachingSource],[wl].[SubmittedDate],[sh].[Emp_Name],[wl].[WarningID]'

SET @nvcSQL3 = ' ) x
 )
 SELECT count(strFormID) FROM TempCoaching'
	   
  
 IF @strjobcode in ('WHER13', 'WHER50',
'WHHR12', 'WHHR13', 'WHHR14',
'WHHR50', 'WHHR60', 'WHHR80',
'WHHR11', 'WHRC11', 'WHRC12', 'WHRC13')

SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3 

ELSE

SET @nvcSQL = @nvcSQL1 + @nvcSQL3

EXEC (@nvcSQL)	

--PRINT @nvcSQL
	    
END -- sp_SelectFrom_Coaching_Log_HistoricalSUP_Count


GO





--******************************************************************

--80. Create SP [EC].[sp_SelectFrom_Coaching_Log_Historical_Export] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Historical_Export' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/14/2015
--	Description: *	This procedure selects the  e-Coaching completed records for export.
-- Last Modified Date:06/2/2015
-- Last Updated By: Susmitha Palacherla
-- Modified per SCR 14893 dashboard redesign performance round 2.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Historical_Export] 

@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSubmitterin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strStatusin nvarchar(30), 
@strvalue  nvarchar(30)

AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@where nvarchar(max)  


Set @strSDate = convert(varchar(8),@strSDatein,112)
Set @strEDate = convert(varchar(8),@strEDatein,112)

SET @where = ' '
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = '''+@strSourcein+''''
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = '''+@strStatusin+''''
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = '''+@strvalue+''''
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   '''+@strCSRin+'''' 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = '''+@strSUPin+'''' 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = '''+@strMGRin+'''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = '''+@strSubmitterin+'''' 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[cl].[SiteID]) = '''+@strCSRSitein+''''
END			 


SET @nvcSQL = ';WITH CL AS
(SELECT * From [EC].[Coaching_Log]WITH (NOLOCK)
WHERE convert(varchar(8),[SubmittedDate],112) >= '''+@strSDate+'''
and convert(varchar(8),[SubmittedDate],112) <= '''+@strEDate+'''
AND [StatusID] <> 2
)
SELECT [cl].[CoachingID]	CoachingID
        ,[cl].[FormName]	FormName
        ,[cl].[ProgramName]	ProgramName
        ,[cl].[EmpID]	EmpID
		,[eh].[Emp_Name]	CSRName
		,[eh].[Sup_Name]	CSRSupName
		,[eh].[Mgr_Name]	CSRMgrName
		,[si].[City]		FormSite
		,[so].[CoachingSource]		FormSource
		,[so].[SubCoachingSource]	FormSubSource
		,[dcr].[CoachingReason]	CoachingReason
		,[dscr].[SubCoachingReason]	SubCoachingReason
		,[clr].[Value]	Value
		,[s].[Status]		FormStatus
		,[sh].[Emp_Name]	SubmitterName
		,[cl].[EventDate]	EventDate
		,[cl].[VerintID]	VerintID
		,[cl].[Description]	Description
		,[cl].[CoachingNotes]	CoachingNotes
		,[cl].[SubmittedDate]	SubmittedDate
		,[cl].[SupReviewedAutoDate]	SupReviewedAutoDate
		,[cl].[MgrReviewManualDate]	MgrReviewManualDate
		,[cl].[MgrReviewAutoDate]	MgrReviewAutoDate
		,[cl].[MgrNotes]	MgrNotes
		,[cl].[CSRReviewAutoDate]	CSRReviewAutoDate
		,[cl].[CSRComments]	CSRComments
		FROM [EC].[Employee_Hierarchy] eh WITH (NOLOCK) JOIN cl
ON cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh
ON cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID JOIN [EC].[DIM_Site] si
ON cl.SiteID = si.SiteID JOIN [EC].[Coaching_Log_Reason]clr WITH (NOLOCK) 
ON cl.CoachingID = clr.CoachingID JOIN [EC].[DIM_Coaching_Reason]dcr
ON clr.CoachingReasonID = dcr.CoachingReasonID JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID '
+ @where + 
' ORDER BY [cl].[CoachingID]'

EXEC (@nvcSQL)	

--PRINT @nvcSQL
	    
END -- sp_SelectFrom_Coaching_Log_Historical_Export
GO

--******************************************************************

--81. Create SP [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of all Employees who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT X.CSRText, X.CSRValue FROM
(SELECT ''All Employees'' CSRText, ''%'' CSRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	CSRText, cl.EmpID CSRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and cl.EmpID is not NULL
) X
Order By X.Sortorder, X.CSRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All


GO



--******************************************************************

--82. Create SP [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of Employees at a selected site who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site] 
@strCSRSitein nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT X.CSRText, X.CSRValue FROM
(SELECT ''All Employees'' CSRText, ''%'' CSRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	CSRText, cl.EmpID CSRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and cl.EmpID is not NULL
and CONVERT(nvarchar,cl.SiteID) = '''+@strCSRSitein+''') X
Order By X.Sortorder, X.CSRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site


GO





--******************************************************************

--83. Create SP [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of all Supervisors who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Sup_Name	SUPText, eh.Sup_ID SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and eh.Sup_Name is not NULL
and eh.Sup_ID <> ''999999'' 
) X
Order By X.Sortorder, X.SUPText'


		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All



GO






--******************************************************************

--84. Create SP [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of Supervisors at a selected site who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site] 
@strCSRSitein nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Sup_Name	SUPText, eh.Sup_ID SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and eh.Sup_Name is not NULL
and eh.Sup_ID <> ''999999'' 
and CONVERT(nvarchar,cl.SiteID) = '''+@strCSRSitein+''') X
Order By X.Sortorder, X.SUPText'


		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site



GO




--******************************************************************

--85. Create SP [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of all Managers who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE  PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.MGR_Name	MGRText, eh.MGR_ID MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and eh.MGR_Name is not NULL 
and eh.Mgr_ID  <> ''999999''
) X
Order By X.Sortorder, X.MGRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

End --sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All



GO






--******************************************************************

--86. Create SP [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of Managers at a selected site who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site] 
@strCSRSitein nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.MGR_Name	MGRText, eh.MGR_ID MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and eh.MGR_Name is not NULL 
and eh.Mgr_ID  <> ''999999''
and CONVERT(nvarchar,cl.SiteID) = '''+@strCSRSitein+''') X
Order By X.Sortorder, X.MGRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

End --sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site



GO




--******************************************************************


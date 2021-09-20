/*
CCO_eCoaching_Maintenance_Tables_Create.(09).sql
Last Modified Date:9/15/2021
Last Modified By: Susmitha Palacherla

Version 09: Quality Now workflow enhancement. TFS 22187 - 09/15/2021
Version 08: TFS 21493 - Written Corr Bingo records in bingo feeds
Version 07: TFS 21276 - Update QN Alt Channels compliance and mastery levels 
Version 06: Updated to add additional archive tables for Quality Now, Short Calls and Bingo detail records - TFS 17655 -  07/20/2020
Version 05: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/09/2019
version 04: Added ConfirmedCSE to Coaching Log Archive Table - TFS 14049 - 04/26/2019
version 03: Updated to incorporate Quality Now - TFS 13332 - 03/19/2019
Version 02: Updated to increase column size for
strReasonNotCoachable in Coaching_Log_Archive to 100 - TFS 6881 - 06/01/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************

1. Create Table [EC].[Inactivations_Stage]
2. Create Table [EC].[Coaching_Log_Archive]
3. Create Table [EC].[Coaching_Log_Reason_Archive]
4. Create Table [EC].[Coaching_Log_Quality_Now_Evaluations_Archive]
5. Create Table [EC].[ShortCalls_Evaluations_Archive]
6. Create Table [EC].[Coaching_Log_Bingo_Archive]
7. Create Table [EC].[Coaching_Log_Quality_Now_Summary_Archive]
**************************************************************

--Table creates

**************************************************************/





--1. Create Table [EC].[Inactivations_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Inactivations_Stage](
	[FormName] [nvarchar](50) NULL,
	[Message] [nvarchar](100) NULL,
	[ProcessDate] [datetime] NULL
) ON [PRIMARY]

GO

--**************************************************************

--2. Create Table [EC].[Coaching_Log_Archive]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Archive](
	[CoachingID] [bigint] NOT NULL,
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
	[strReasonNotCoachable] [nvarchar](100) NULL,
	[txtReasonNotCoachable] [nvarchar](3000) NULL,
	[VerintFormName] [nvarchar](50) NULL,
	[ModuleID] [int] NULL,
	[SupID] [nvarchar](20) NULL,
	[MgrID] [nvarchar](20) NULL,
	[Review_SupID] [nvarchar](20) NULL,
	[Review_MgrID] [nvarchar](20) NULL,
	[Behavior] [nvarchar](30) NULL,
	[SurveySent] [bit] NULL,
	[NotificationDate] [datetime] NULL,
	[ReminderSent] [bit] NULL,
	[ReminderDate] [datetime] NULL,
	[ReminderCount] [int] NULL,
	[ReassignDate] [datetime] NULL,
	[ReassignCount] [int] NOT NULL,
	[ReassignedToID] [nvarchar](20) NULL,
	[ArchivedBy] [nvarchar](50) NULL,
	[ArchivedDate] [datetime] NOT NULL,
        [isCoachingMonitor] [nvarchar](3) NULL,
	[QNBatchID] [nvarchar](20) NULL,
	[QNBatchStatus] [nvarchar](10) NULL,
	[QNStrengthsOpportunities] [nvarchar](2000) NULL,
        [ConfirmedCSE][bit] NULL,
        [IsFollowupRequired] bit NULL,
	[FollowupDueDate][datetime] NULL,
	[FollowupActualDate][datetime] NULL,
	[SupFollowupAutoDate][datetime] NULL,
	[SupFollowupCoachingNotes][nvarchar](4000) NULL,
	[IsEmpFollowupAcknowledged] bit NULL,
	[EmpAckFollowupAutoDate][datetime] NULL,
	[EmpAckFollowupComments][nvarchar](3000) NULL,
	[FollowupSupID] nvarchar(20) NULL,
 CONSTRAINT [PK_Coaching_Log_Archive] PRIMARY KEY CLUSTERED 
(
	[CoachingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Coaching_Log_Archive] ADD  CONSTRAINT [ArchivedBy_def]  DEFAULT ('Manual') FOR [ArchivedBy]
GO


--**************************************************************

--3. Create Table [EC].[Coaching_Log_Reason_Archive]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Reason_Archive](
	[CoachingID] [bigint] NOT NULL,
	[CoachingReasonID] [bigint] NOT NULL,
	[SubCoachingReasonID] [bigint] NOT NULL,
	[Value] [nvarchar](30) NOT NULL,
	[ArchivedBy] [nvarchar](50) NULL,
	[ArchivedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Coaching_Log_Reason_Archive] PRIMARY KEY CLUSTERED 
(
	[CoachingID] ASC,
	[CoachingReasonID] ASC,
	[SubCoachingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Coaching_Log_Reason_Archive]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingIDArchive] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log_Archive] ([CoachingID])
GO

ALTER TABLE [EC].[Coaching_Log_Reason_Archive] CHECK CONSTRAINT [fkCoachingIDArchive]
GO

ALTER TABLE [EC].[Coaching_Log_Reason_Archive] ADD  CONSTRAINT [ArchivedByReason_def]  DEFAULT ('Manual') FOR [ArchivedBy]
GO


--**************************************************************

--4. Create Table [EC].[Coaching_Log_Quality_Now_Evaluations_Archive]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Quality_Now_Evaluations_Archive](
	[QNBatchID] [nvarchar](20) NOT NULL,
	[CoachingID] [bigint] NOT NULL,
	[Eval_ID] [nvarchar](20) NOT NULL,
	[Eval_Date] [datetime] NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Call_Date] [datetime] NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[EvalStatus] [nvarchar](10) NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Program] [nvarchar](20) NULL,
	[VerintFormName] [nvarchar](50) NULL,
	[isCoachingMonitor] [nvarchar](3) NULL,
	[Business_Process] [nvarchar](20) NULL,
	[Business_Process_Reason] [nvarchar](200) NULL,
	[Business_Process_Comment] [nvarchar](2000) NULL,
	[Info_Accuracy] [nvarchar](20) NULL,
	[Info_Accuracy_Reason] [nvarchar](200) NULL,
	[Info_Accuracy_Comment] [nvarchar](2000) NULL,
	[Privacy_Disclaimers] [nvarchar](20) NULL,
	[Privacy_Disclaimers_Reason] [nvarchar](200) NULL,
	[Privacy_Disclaimers_Comment] [nvarchar](2000) NULL,
	[Issue_Resolution] [nvarchar](50) NULL,
	[Issue_Resolution_Comment] [nvarchar](2000) NULL,
	[Call_Efficiency] [nvarchar](50) NULL,
	[Call_Efficiency_Comment] [nvarchar](2000) NULL,
	[Active_Listening] [nvarchar](50) NULL,
	[Active_Listening_Comment] [nvarchar](2000) NULL,
	[Personality_Flexing] [nvarchar](50) NULL,
	[Personality_Flexing_Comment] [nvarchar](2000) NULL,
	[Customer_Temp_Start] [nvarchar](30) NULL,
	[Customer_Temp_Start_Comment] [nvarchar](2000) NULL,
	[Customer_Temp_End] [nvarchar](30) NULL,
	[Customer_Temp_End_Comment] [nvarchar](2000) NULL,
	[Inserted_Date] [datetime] NULL,
	[Last_Updated_Date] [datetime] NULL,
	[ArchivedBy] [nvarchar](50) NOT NULL,
	[ArchivedDate] [datetime] NOT NULL,
        [Channel] [nvarchar](30) NULL,
	[ActivityID] [nvarchar](30) NULL,
	[DCN] [nvarchar](20) NULL,
	[CaseNumber] [nvarchar](10) NULL,
	[Reason_For_Contact] [nvarchar](100) NULL,
	[Contact_Reason_Comment] [nvarchar](1024) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [EC].[Coaching_Log_Quality_Now_Evaluations_Archive] ADD  DEFAULT ('Manual') FOR [ArchivedBy]
GO



--**************************************************************
--5. Create Table [EC].[ShortCalls_Evaluations_Archive]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ShortCalls_Evaluations_Archive](
	[CoachingID] [bigint] NOT NULL,
	[VerintCallID] [nvarchar](20) NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[StartDate] [datetime] NULL,
	[Valid] [nvarchar](3) NULL,
	[BehaviorID] [int] NULL,
	[Action] [nvarchar](1000) NULL,
	[CoachingNotes] [nvarchar](4000) NULL,
	[LSAInformed] [nvarchar](3) NULL,
	[MgrAgreed] [nvarchar](3) NULL,
	[MgrComments] [nvarchar](3000) NULL,
	[ArchivedBy] [nvarchar](50) NOT NULL,
	[ArchivedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [EC].[ShortCalls_Evaluations_Archive] ADD  DEFAULT ('Manual') FOR [ArchivedBy]
GO




--**************************************************************

--6. Create Table [EC].[Coaching_Log_Bingo_Archive]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Bingo_Archive](
	[CoachingID] [bigint] NOT NULL,
	[Competency] [nvarchar](30) NULL,
	[Note] [nvarchar](30) NULL,
	[Description] [nvarchar](4000) NULL,
	[CompImage] [nvarchar](100) NULL,
	[BingoType] [nvarchar](30) NULL,
	[ArchivedBy] [nvarchar](50) NOT NULL,
	[ArchivedDate] [datetime] NOT NULL,
        [Include] [bit] NULL
) ON [PRIMARY]
GO

ALTER TABLE [EC].[Coaching_Log_Bingo_Archive] ADD  DEFAULT ('Manual') FOR [ArchivedBy]
GO


--**************************************************************

--7. Create Table [EC].[Coaching_Log_Quality_Now_Summary_Archive]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Quality_Now_Summary_Archive](
	[SummaryID] [bigint] NOT NULL,
	[CoachingID] [bigint] NOT NULL,
	[EvalSummaryNotes] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
	[CreateBy] [nvarchar](20) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyBy] [nvarchar](20) NULL,
	[IsReadOnly] [bit] NULL,
	[ArchivedBy] [nvarchar](50) NOT NULL,
	[ArchivedDate] [datetime] NOT NULL
	) ON [PRIMARY]
GO


ALTER TABLE [EC].[Coaching_Log_Quality_Now_Summary_Archive] ADD  DEFAULT ('Manual') FOR [ArchivedBy]
GO


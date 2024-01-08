/*
CCO_eCoaching_Log_Tables_Create.sql(12).sql

Last Modified Date: 01/08/2024
Last Modified By: Susmitha Palacherla

Version 12: TFS 27523 - Dashboard to view the feed load history in the Admin Tool- 01/08/2024
Version 11: Updated to Support Coaching Static Text during work for OMR Aud Feed. TFS 26432 - 04/10/2023
Version 10: Updated to Support Team Submission. TFS 23273 - 06/07/2022
Version 09: Updated to suport email process change in user interface. TFS 23389 - 11/08/2021
Version 08: Updated to support New Coaching Reason for Quality - 23051 - 10/6/2021
Version 07: Quality Now workflow enhancement. TFS 22187 - 09/15/2021
Version 06: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/09/2019
version 05: Added ConfirmedCSE to Coaching Log Table - TFS 14049 - 04/26/2019
version 04: Updated to incorporate Quality Now - TFS 13332 - 03/19/2019
version 03: Updated to document changes for data encryption TFS 7856.
Version 02: Updated to increase column size for
strReasonNotCoachable in Coaching_Log to 100 - TFS 6881 - 06/01/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

-- Table list

**************************************************************



1. [EC].[Coaching_Log]
2. [EC].[Coaching_Log_Reason]
3. [EC].[Coaching_Log_Quality_Now_Summary]
4. [EC].[Email_Notifications_History]
5. [EC].[Email_Notifications_Stage]
6. [EC].[Coaching_Log_StaticText]
7. [EC].[Feed_Load_History]

**************************************************************

--Table creates

**************************************************************/



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
	[txtReasonNotCoachable] [nvarchar](4000) NULL,
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
	[isCoachingMonitor] [nvarchar](3) NULL,
	[QNBatchID] [nvarchar](20) NULL,
	[QNBatchStatus] [nvarchar](10) NULL,
	[QNStrengthsOpportunities] [nvarchar](2000) NULL,
	[ConfirmedCSE] [bit] NULL,
	[IsFollowupRequired] [bit] NULL,
	[FollowupDueDate] [datetime] NULL,
	[FollowupActualDate] [datetime] NULL,
	[SupFollowupAutoDate] [datetime] NULL,
	[SupFollowupCoachingNotes] [nvarchar](4000) NULL,
	[IsEmpFollowupAcknowledged] [bit] NULL,
	[EmpAckFollowupAutoDate] [datetime] NULL,
	[EmpAckFollowupComments] [nvarchar](3000) NULL,
	[FollowupSupID] [nvarchar](20) NULL,
	[SupFollowupReviewAutoDate] [datetime] NULL,
	[SupFollowupReviewCoachingNotes] [nvarchar](4000) NULL,
	[SupFollowupReviewMonitoredLogs] [nvarchar](200) NULL,
	[FollowupReviewSupID] [nvarchar](20) NULL,
	[PFDCompletedDate] [datetime] NULL,
 CONSTRAINT [PK_Coaching_Log] PRIMARY KEY CLUSTERED 
(
	[CoachingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [EC].[Coaching_Log] ADD  DEFAULT ((0)) FOR [EmailSent]
GO

ALTER TABLE [EC].[Coaching_Log] ADD  DEFAULT ((0)) FOR [SurveySent]
GO

ALTER TABLE [EC].[Coaching_Log] ADD  DEFAULT ((0)) FOR [ReminderSent]
GO

ALTER TABLE [EC].[Coaching_Log] ADD  DEFAULT ((0)) FOR [ReminderCount]
GO

ALTER TABLE [EC].[Coaching_Log] ADD  DEFAULT ((0)) FOR [ReassignCount]
GO

ALTER TABLE [EC].[Coaching_Log]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingSiteID] FOREIGN KEY([SiteID])
REFERENCES [EC].[DIM_Site] ([SiteID])
GO

ALTER TABLE [EC].[Coaching_Log] CHECK CONSTRAINT [fkCoachingSiteID]
GO

ALTER TABLE [EC].[Coaching_Log]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingSourceID] FOREIGN KEY([SourceID])
REFERENCES [EC].[DIM_Source] ([SourceID])
GO

ALTER TABLE [EC].[Coaching_Log] CHECK CONSTRAINT [fkCoachingSourceID]
GO

ALTER TABLE [EC].[Coaching_Log]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingStatusID] FOREIGN KEY([StatusID])
REFERENCES [EC].[DIM_Status] ([StatusID])
GO

ALTER TABLE [EC].[Coaching_Log] CHECK CONSTRAINT [fkCoachingStatusID]
GO




--**************************************************************

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

--**************************************************************


--3. Create Table [EC].[Coaching_Log_Quality_Now_Summary]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Quality_Now_Summary](
	[SummaryID] [bigint] IDENTITY(1,1) NOT NULL,
	[CoachingID] [bigint] NOT NULL,
	[EvalSummaryNotes] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
	[CreateBy] [nvarchar](20) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyBy] [nvarchar](20) NULL,
	[IsReadOnly] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SummaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [EC].[Coaching_Log_Quality_Now_Summary]  WITH NOCHECK ADD  CONSTRAINT [fkQNSummaryCoachingID] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log] ([CoachingID])
ON DELETE CASCADE
GO

ALTER TABLE [EC].[Coaching_Log_Quality_Now_Summary] CHECK CONSTRAINT [fkQNSummaryCoachingID]
GO





--**************************************************************


--4. Create Table [EC].[Email_Notifications_History]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Email_Notifications_History](
	[MailID] [bigint] IDENTITY(1,1) NOT NULL,
	[MailType] [nvarchar](50) NOT NULL,
	[LogID] [bigint] NULL,
	[LogName] [nvarchar](50) NOT NULL,
	[To] [nvarchar](400) NULL,
	[Cc] [nvarchar](400) NULL,
	[SendAttemptDate] [datetime] NOT NULL,
	[Success] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [EC].[Email_Notifications_History] ADD  CONSTRAINT [DF_Email_Notifications_History_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

--**************************************************************


--5. Create Table [EC].[Email_Notifications_Stage]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Email_Notifications_Stage](
	[MailID] [bigint] IDENTITY(1,1) NOT NULL,
	[MailType] [nvarchar](50) NOT NULL,
	[LogID] [bigint] NOT NULL,
	[LogName] [nvarchar](50) NOT NULL,
	[To] [nvarchar](400) NULL,
	[Cc] [nvarchar](400) NULL,
	[From] [nvarchar](400) NULL,
	[Subject] [nvarchar](500) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[isHtml] [bit] NOT NULL,
	[SendAttemptDate] [datetime] NULL,
	[SendAttemptCount] [smallint] NULL,
	[InProcess] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
	[LastModifyDate] [datetime] NOT NULL,
	[LastModifyUserID] [nvarchar](50) NOT NULL,
	[FromDisplayName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Email_Notifications_Stage] PRIMARY KEY CLUSTERED 
(
	[MailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [EC].[Email_Notifications_Stage] ADD  CONSTRAINT [DF_ENS_SendAttemptCount]  DEFAULT ((0)) FOR [SendAttemptCount]
GO

ALTER TABLE [EC].[Email_Notifications_Stage] ADD  CONSTRAINT [DF_ENS_Inprocess]  DEFAULT ((0)) FOR [InProcess]
GO

ALTER TABLE [EC].[Email_Notifications_Stage] ADD  CONSTRAINT [DF_ENS_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

ALTER TABLE [EC].[Email_Notifications_Stage] ADD  CONSTRAINT [DF_ENS_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
GO


--**************************************************************

--6. Create Table[EC].[Coaching_Log_StaticText]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_StaticText](
	[TextID] [int] NOT NULL,
	[TextDescription] [nvarchar](4000) NOT NULL,
	[Active] [bit] NOT NULL,
	[CoachingReasonID] [int] NOT NULL,
	[SubCoachingReasonID] [int] NOT NULL,
	[CSR] [bit] NULL,
	[Supervisor] [bit] NULL,
	[Quality] [bit] NULL,
	[LSA] [bit] NULL,
	[Training] [bit] NULL,
	[StartDate] [int] NOT NULL,
	[EndDate] [int] NOT NULL
) ON [PRIMARY]
GO


--**************************************************************

--7. Create Table [EC].[Feed_Load_History]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Feed_Load_History](
	[SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](200) NULL,
	[LoadDate] [datetime] NULL,
	[LoadTime] [datetime] NULL,
	[CountStaged] [int] NULL,
	[CountLoaded] [int] NULL, 
	[CountRejected] [int] NULL, 
	[Category] [nvarchar](60) NULL,
	[Code] [nvarchar](10) NULL,
	[Description] [nvarchar](200) NULL,
) ON [PRIMARY]
GO


--**************************************************************
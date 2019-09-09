/*
CCO_eCoaching_Maintenance_Tables_Create.(05).sql
Last Modified Date: 09/09/2019
Last Modified By: Susmitha Palacherla


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









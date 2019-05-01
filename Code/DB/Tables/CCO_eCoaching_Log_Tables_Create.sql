/*
CCO_eCoaching_Log_Tables_Create.sql(05).sql

Last Modified Date: 04/26/2019
Last Modified By: Susmitha Palacherla

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
	--[EmpLanID] [nvarchar](50) NOT NULL,
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
	[VerintFormName] [nvarchar]50) NULL,
        [ModuleID][int],
        [SupID] [nvarchar](20) NULL,
        [MgrID] [nvarchar](20) NULL,
        [Review_SupID] [nvarchar](20) NULL,
        [Review_MgrID] [nvarchar](20) NULL,
        [Behavior] [nvarchar](30) NULL,
        [SurveySent][bit] DEFAULT (0) NULL,
        [NotificationDate] [datetime] NULL,
        [ReminderSent][bit] DEFAULT (0),
        [ReminderDate] [datetime] NULL,
        [ReminderCount][int] DEFAULT (0),
        [ReassignDate] [datetime] NULL,
        [ReassignCount] [INT] DEFAULT(0)NOT NULL,
        [ReassignedToID][nvarchar](20) NULL,
        [isCoachingMonitor] nvarchar(3) NULL,
      	[QNBatchID] [nvarchar](20) NULL,
	[QNBatchStatus] [nvarchar](10) NULL,
	[QNStrengthsOpportunities] [nvarchar](2000) NULL,
        [ConfirmedCSE][bit] NULL,
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












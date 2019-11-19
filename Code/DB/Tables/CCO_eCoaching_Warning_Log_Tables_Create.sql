/*
CCO_eCoaching_Warning_Log_Tables_Create(03).sql
Last Modified Date: 11/18/2019
Last Modified By: Susmitha Palacherla

Version 03: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
version 02: Updated to document changes for data encrryption TFS 7856.
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

**************************************************************

--Table list

**************************************************************



Tables
1. [EC].[Warning_Log]
2. [EC].[Warning_Log_Reason]



**************************************************************

--Table creates

**************************************************************/



--1. Create Table  [EC].[Warning_Log]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EC].[Warning_Log](
	[WarningID] [bigint] IDENTITY(1,1) NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[ProgramName] [nvarchar](50) NULL,
	[SourceID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	--[EmpLanID] [nvarchar](50) NOT NULL,
	[EmpID] [nvarchar](10) NOT NULL,
	[SubmitterID] [nvarchar](10) NULL,
	[SupID] [nvarchar](10) NOT NULL,
	[MgrID] [nvarchar](10) NOT NULL,
	[WarningGivenDate] [datetime] NOT NULL,
	[Description] [varbinary](max) NULL,
	[CoachingNotes] [varbinary](max) NULL,
	[SubmittedDate] [datetime] NULL,
	[ModuleID] [int] NULL,
	[Active] [bit] NULL,
        [numReportID] [int] NOT NULL,
        [strReportCode]  [nvarchar](30) NOT NULL,
        [Behavior] [nvarchar](30) NULL,
        [isCSRAcknowledged] [bit] NULL,
	[CSRReviewAutoDate] [datetime] NULL,
	[CSRComments] [nvarchar](3000) NULL,
	[EmailSent] [bit] NOT NULL,
	[ReminderSent] [bit] NOT NULL DEFAULT (0),
	[ReminderDate] [datetime] NULL,
	[ReminderCount] [int] NOT NULL DEFAULT (0),
 CONSTRAINT [PK_Warning_Log] PRIMARY KEY CLUSTERED 
(
	[WarningID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EC].[Warning_Log]  WITH NOCHECK ADD  CONSTRAINT [fkWarningSiteID] FOREIGN KEY([SiteID])
REFERENCES [EC].[DIM_Site] ([SiteID])
GO

ALTER TABLE [EC].[Warning_Log] CHECK CONSTRAINT [fkWarningSiteID]
GO

ALTER TABLE [EC].[Warning_Log]  WITH NOCHECK ADD  CONSTRAINT [fkWarningSourceID] FOREIGN KEY([SourceID])
REFERENCES [EC].[DIM_Source] ([SourceID])
GO

ALTER TABLE [EC].[Warning_Log] CHECK CONSTRAINT [fkWarningSourceID]
GO

ALTER TABLE [EC].[Warning_Log]  WITH NOCHECK ADD  CONSTRAINT [fkWarningStatusID] FOREIGN KEY([StatusID])
REFERENCES [EC].[DIM_Status] ([StatusID])
GO

ALTER TABLE [EC].[Warning_Log] CHECK CONSTRAINT [fkWarningStatusID]
GO

ALTER TABLE [EC].[Warning_Log] ADD  DEFAULT ((1)) FOR [Active]
GO




--**************************************************************

--2. Create Table  [EC].[Warning_Log_Reason]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Warning_Log_Reason](
	[WarningID] [bigint] NOT NULL,
	[CoachingReasonID] [bigint] NOT NULL,
	[SubCoachingReasonID] [bigint] NOT NULL,
	[Value] [nvarchar](30) NULL,
 CONSTRAINT [PK_Warning_Log_Reason] PRIMARY KEY CLUSTERED 
(
	[WarningID] ASC,
	[CoachingReasonID] ASC,
	[SubCoachingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Warning_Log_Reason]  WITH NOCHECK ADD  CONSTRAINT [fkWarningID] FOREIGN KEY([WarningID])
REFERENCES [EC].[Warning_Log] ([WarningID])
GO

ALTER TABLE [EC].[Warning_Log_Reason] CHECK CONSTRAINT [fkWarningID]
GO




--**************************************************************






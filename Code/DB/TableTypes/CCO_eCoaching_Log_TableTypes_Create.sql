--IdsTableType
CREATE TYPE [EC].[IdsTableType] AS TABLE(
	[ID] [bigint] NOT NULL
)
GO

--****************************************

--MailHistoryTableType
CREATE TYPE [EC].[MailHistoryTableType] AS TABLE(
	[LogID] [bigint] NOT NULL,
	[LogName] [nvarchar](50) NOT NULL,
	[To] [nvarchar](400) NULL,
	[Cc] [nvarchar](400) NULL,
	[SendAttemptDate] [datetime] NOT NULL,
	[Success] [bit] NOT NULL
)
GO

--****************************************

--MailStageTableType
CREATE TYPE [EC].[MailStageTableType] AS TABLE(
	[LogID] [bigint] NOT NULL,
	[LogName] [nvarchar](50) NOT NULL,
	[To] [nvarchar](400) NULL,
	[Cc] [nvarchar](400) NULL,
	[From] [nvarchar](400) NOT NULL,
	[FromDisplayName] [nvarchar](100) NULL,
	[Subject] [nvarchar](500) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[IsHtml] [bit] NOT NULL
)
GO

--****************************************

--ResponsesTableType
CREATE TYPE [EC].[ResponsesTableType] AS TABLE(
	[QuestionID] [int] NOT NULL,
	[ResponseID] [int] NOT NULL,
	[Comments] [nvarchar](4000) NULL
)
GO

--****************************************


--SCMgrReviewTableType
CREATE TYPE [EC].[SCMgrReviewTableType] AS TABLE(
	[VerintCallID] [nvarchar](30) NOT NULL,
	[MgrAgreed] [nvarchar](3) NULL,
	[MgrComments] [nvarchar](3000) NULL
)
GO

--****************************************


--SCSupReviewTableType
CREATE TYPE [EC].[SCSupReviewTableType] AS TABLE(
	[VerintCallID] [nvarchar](30) NOT NULL,
	[Valid] [nvarchar](3) NULL,
	[BehaviorId] [int] NULL,
	[Action] [nvarchar](1000) NULL,
	[CoachingNotes] [nvarchar](4000) NULL,
	[LSAInformed] [nvarchar](3) NULL
)
GO

--****************************************


--SharepointUploadBingoTableType
CREATE TYPE [EC].[SharepointUploadBingoTableType] AS TABLE(
	[Title] [nvarchar](50) NOT NULL,
	[Employee_Name] [nvarchar](50) NOT NULL,
	[Employee_ID] [nvarchar](10) NOT NULL,
	[Employee_Site] [nvarchar](50) NOT NULL,
	[Competencies] [nvarchar](500) NOT NULL,
	[Month_Year] [nvarchar](7) NOT NULL,
	[Employee_Email] [nvarchar](50) NULL,
	[Upload_Status] [nvarchar](50) NULL
)
GO

--****************************************
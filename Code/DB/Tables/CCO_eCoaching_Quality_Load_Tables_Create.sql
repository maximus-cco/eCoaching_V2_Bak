/*
CCO_eCoaching_Quality_Load_Tables_Create(01).sql

Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************

1. Create Table [EC].[Quality_Coaching_Stage]
2. Create Table [EC].[Quality_Coaching_Fact]
3. Create Table [EC].[Quality_Coaching_Rejected]
4. Create Table [EC].[Quality_FileList]


**************************************************************

--Table creates

**************************************************************/


--1. Create Table [EC].[Quality_Coaching_Stage]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Coaching_Stage](
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_ID] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[User_LANID] [nvarchar](30) NULL,
	[SUP_ID] [nvarchar](20) NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_ID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Coaching_Goal_Discussion] [nvarchar](4000) NULL,
	[CSE] [nvarchar](2) NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Program] [nvarchar](20) NULL,
	[Source] [nvarchar](30) NULL,
	[Oppor_Rein] [nvarchar](20) NULL,
	[Date_Inserted] [datetime] NULL,
        [VerintFormName] [nvarchar) (50) NULL,
	[isCoachingMonitor] nvarchar(3)	
) ON [PRIMARY]

GO







--**************************************************************************************************

--2. Create Table [EC].[Quality_Coaching_Fact]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Coaching_Fact](
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_ID] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[User_LANID] [nvarchar](30) NULL,
	[SUP_ID] [nvarchar](20) NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_ID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Coaching_Goal_Discussion] [nvarchar](4000) NULL,
	[CSE] [nvarchar](2) NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Program] [nvarchar](20) NULL,
	[Source] [nvarchar](30) NULL,
	[Oppor_Rein] [nvarchar](20) NULL,
	[Date_Inserted] [datetime] NULL,
        [VerintFormName] [nvarchar) (50) NULL,
	[isCoachingMonitor] nvarchar(3)
) ON [PRIMARY]

GO


--**************************************************************************************************

--3. Create Table [EC].[Quality_Coaching_Rejected]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Coaching_Rejected](
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_ID] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[User_LANID] [nvarchar](30) NULL,
	[SUP_ID] [nvarchar](20) NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_ID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Summary_CallerIssues] [nvarchar](max) NULL,
	[Coaching_Goal_Discussion] [nvarchar](4000) NULL,
	[CSE] [nvarchar](2) NULL,
	[Evaluator_ID] [nvarchar](20) NULL,
	[Program] [nvarchar](20) NULL,
	[Source] [nvarchar](30) NULL,
	[Oppor_Rein] [nvarchar](20) NULL,
	[Reject_reason] [nvarchar](40) NULL,
	[Date_Rejected] [datetime] NULL,
	[VerintFormName] [nvarchar) (50) NULL,
	[isCoachingMonitor] nvarchar(3)
) ON [PRIMARY]

GO


--**************************************************************************************************

--4. Create Table [EC].[Quality_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO




--**************************************************************************************************





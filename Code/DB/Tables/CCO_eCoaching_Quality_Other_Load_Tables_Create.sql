/*
CCO_eCoaching_Quality_Other_Load_Tables_Create(01).sql

Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************

1.[EC].[Quality_Other_Coaching_Stage]
2.[EC].[Quality_Other_Coaching_Rejected]
3.[EC].[Quality_Other_Coaching_Fact]
4.[EC].[Quality_Other_FileList]

**************************************************************

--Table creates

**************************************************************/

--1. Create Table [EC].[Quality_Other_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_Coaching_Stage](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](50) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[EMP_ID] [nvarchar](10) NULL,
	[EMP_LANID] [nvarchar](30) NULL,
	[EMP_Site] [nvarchar](30) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL
) ON [PRIMARY]

GO




--************************************


--2. Create Table [EC].[Quality_Other_Coaching_Rejected]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_Coaching_Rejected](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](50) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[EMP_ID] [nvarchar](10) NULL,
	[EMP_LANID] [nvarchar](30) NULL,
	[EMP_Site] [nvarchar](30) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Rejected_Reason] [nvarchar](200) NULL,
	[Rejected_Date] [datetime] NULL
) ON [PRIMARY]

GO




--************************************


--3. Create Table [EC].[Quality_Other_Coaching_Fact]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_Coaching_Fact](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](50) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[EMP_ID] [nvarchar](10) NULL,
	[EMP_LANID] [nvarchar](30) NULL,
	[EMP_Site] [nvarchar](30) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL
) ON [PRIMARY]

GO


--************************************


--4. Create Table [EC].[Quality_Other_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Other_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO









--**********************************************************************************


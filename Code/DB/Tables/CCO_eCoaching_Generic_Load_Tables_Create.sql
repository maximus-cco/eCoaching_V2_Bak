/*
CCO_eCoaching_Generic_Load_Tables_Create.sql(03).sql
Last Modified Date: 04/02/2018
Last Modified By: Susmitha Palacherla

version 03: Updated to document changes for feed encryption TFS 7854.
Marked fact table as obsolete

Version 02: Added columns to Generic_Coaching_Stage per TFS 7646 - 09/18/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************
1. Create Table [EC].[Generic_Coaching_Stage] 
2. Create Table [EC].[Generic_FileList]  
3. Create Table [EC].[Generic_Coaching_Rejected]
4. Create Table [EC].[Generic_Coaching_Fact] -- Obsolete with TFS 7854


**************************************************************

--Table creates

**************************************************************/

--1. Create Table [EC].[Generic_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [EC].[Generic_Coaching_Stage](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](30) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Name] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[CSR_LANID] [nvarchar](30) NULL,
	[CSR_EMPID] [nvarchar](10) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Module_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[isCSE] [bit] NULL,
	[Status_ID] [int] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[CoachingReason_ID] [int] NULL,
	[SubCoachingReason_ID] [int] NULL,
	[Value] [nvarchar](30) NULL,
	[EmailSent] [bit] NULL,
	[Emp_Role] [nvarchar](3) NULL,
	[Reject_Reason] [nvarchar](200) NULL
) ON [PRIMARY]

GO




--**************************************************************

--2. Create Table [EC].[Generic_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL
) ON [PRIMARY]

GO




--**************************************************************

--3. Create Table [EC].[Generic_Coaching_Rejected]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_Coaching_Rejected](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](30) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Name] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[CSR_LANID] [nvarchar](30) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Rejected_Reason] [nvarchar](200) NULL,
	[Rejected_Date] [datetime] NULL,
	[Module_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[isCSE] [bit] NULL,
	[Status_ID] [int] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[CoachingReason_ID] [int] NULL,
	[SubCoachingReason_ID] [int] NULL,
	[Value] [nvarchar](30) NULL,
	[CSR_EMPID] [nvarchar](10) NULL
              
) ON [PRIMARY]

GO



--**************************************************************

--4. Create Table [EC].[Generic_Coaching_Fact]-- Obsolete with TFS 7854

/*
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Generic_Coaching_Fact](
	[Report_ID] [int] NULL,
	[Report_Code] [nvarchar](20) NULL,
	[Form_Type] [nvarchar](20) NULL,
	[Source] [nvarchar](60) NULL,
	[Form_Status] [nvarchar](30) NULL,
	[Event_Date] [datetime] NULL,
	[Submitted_Date] [datetime] NULL,
	[Start_Date] [datetime] NULL,
	[Submitter_LANID] [nvarchar](30) NULL,
	[Submitter_Name] [nvarchar](30) NULL,
	[Submitter_Email] [nvarchar](50) NULL,
	[CSR_LANID] [nvarchar](30) NULL,
	[CSR_Site] [nvarchar](20) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
	[CSR_EMPID] [nvarchar](10) NULL,
	[Module_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[isCSE] [bit] NULL,
	[Status_ID] [int] NULL,
	[Submitter_ID] [nvarchar](10) NULL,
	[CoachingReason_ID] [int] NULL,
	[SubCoachingReason_ID] [int] NULL,
	[Value] [nvarchar](30) NULL

) ON [PRIMARY]

GO

*/
--**************************************************************


/*
CCO_eCoaching_Outliers_Load_Tables_Create(08).sql
Last Modified Date: 01/08/2024
Last Modified By: Susmitha Palacherla

Version 08: TFS 27523 - Dashboard to view the feed load history in the Admin Tool- 01/08/2024
Version 07: TFS 27135 - Add the Verint call id for eCL audio issues reported - 10/11/2023
Version 06: TFS 20677 -  AD island to AD AWS environment changes - 4/22/2021
Version 05: TFS 18833 -  Expand the site field size in feeds - 10/9/2020
Version 04: New process for short calls. TFS 14108 - 07/08/2019
Added new tables to support Short Calls handling
Added new column verint_id to staging table
Version 03: Updated to document changes for feed encryption TFS 7854.
Marked fact table as obsolete
Version 02: TFS 6625 - Updated field size for Site value to 30  in tables 1,3 and 4 - TFS 6625- 5/22/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************


1. Create Table [EC].[Outlier_Coaching_Stage] 
2. Create Table [EC].[OutLier_FileList]  
3. Create Table [EC].[Outlier_Coaching_Rejected]
4. Create Table [EC].[ShortCalls_Behavior]
5. Create Table [EC].[ShortCalls_Prescriptive_Actions]
6. Create Table  [EC].[ShortCalls_Behavior_Action_Link]
7. Create Table  [EC].[ShortCalls_Evaluations] 
8. Create Table [EC].[Audio_Issues_VerintIds]

**************************************************************

--Table Type list

**************************************************************


1. Create Table Type [EC].[SCSupReviewTableType]
2. Create Table Type [EC].[SCMgrReviewTableType] 




**************************************************************

--Table creates

**************************************************************/

--1. Create Table [EC].[Outlier_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Outlier_Coaching_Stage](
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
	[CSR_EMPID] [nvarchar](20) NULL,
	[CSR_Site] [nvarchar](60) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
	[RMgr_ID] [nvarchar](20) NULL,
	[CD1] [nvarchar](50) NULL,
	[CD2] [nvarchar](50) NULL,
	[Emp_Role] [nvarchar](3) NULL,
	[Reject_Reason] [nvarchar](200) NULL,
	[Emp_Active] [nvarchar](1) NULL,
	[Verint_ID] [nvarchar](600) NULL
) ON [PRIMARY]

GO


--**************************************************************

--2. Create Table [EC].[OutLier_FileList]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[OutLier_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL,
	[Category] [nvarchar](60) NULL,
	[Code] [nvarchar](10) NULL
) ON [PRIMARY]

GO




--**************************************************************

--3. Create Table [EC].[Outlier_Coaching_Rejected]

/****** Object:  Table [EC].[Outlier_Coaching_Rejected]    Script Date: 01/18/2014 13:31:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Outlier_Coaching_Rejected](
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
	[CSR_Site] [nvarchar](60) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](3000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Rejected_Reason] [nvarchar](200) NULL,
	[Rejected_Date] [datetime] NULL,
	[RMgr_ID] [nvarchar](20) NULL,
	[CD1] [nvarchar](50) NULL,
	[CD2] [nvarchar](50) NULL,
	[CSR_EMPID] [nvarchar](20) NULL
) ON [PRIMARY]

GO




--**************************************************************


--4a. Create Table [EC].[ShortCalls_Behavior]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ShortCalls_Behavior](
	[ID] [int] IDENTITY(101,1) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Valid] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [SC_Behavior_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--4b. Insert records to [EC].[ShortCalls_Behavior]

INSERT INTO [EC].[ShortCalls_Behavior]
           ([Description]
           ,[Valid]
           ,[Active])
     VALUES
           ('Calling Kudos Line',0,1),
		   ('Good Call',1,1),
		   ('Incorrect blind transfer',0,1),
		   ('Incorrect phone status (calls still coming in)',0,1),
		   ('Intentionally disconnecting calls',0,1),
		   ('Not following call flow (not opening a call)',0,1),
		 --  ('Not following call flow in CDB (not opening a call)',0,1),
		   ('Not following procedure for disconnect by caller (ghost calls, greeting 3x''s, template)',0,1),
		   ('Spanish Transfer',1,1),
		   ('SSA Transfer',1,1),
		   ('Technical Issue (CSR Error & Technical Error)',0,1),
		 --  ('Technical Issue CDB',0,1),
		   ('Valid Password Reset',1,1)
		
GO



--**************************************************************

--5a. Create Table [EC].[ShortCalls_Prescriptive_Actions]


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ShortCalls_Prescriptive_Actions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Action] [nvarchar](1000) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [SC_Action_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



--5b. Insert records to [EC].[ShortCalls_Prescriptive_Actions]


INSERT INTO [EC].[ShortCalls_Prescriptive_Actions]
           ([Action]
           ,[Active])
     VALUES
 ('Coach the CSR to Immediately notify Supervisor/LSA of Technical Issues',1),
 ('Coach to the behavior (Progressive disciplinary course details in coaching comments)',1),
 ('Inform IT or Telecom - Ticket Submitted',1),
 ('Inform LSA - Ticket Submitted',1),
 ('Issue verbal warning',1),
 ('Issue written warning  ',1),
 ('Start termination process',1)

GO



--**************************************************************

--6a. Create Table  [EC].[ShortCalls_Behavior_Action_Link]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ShortCalls_Behavior_Action_Link](
	[BehaviorId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BehaviorId] ASC,
	[ActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[ShortCalls_Behavior_Action_Link]  WITH NOCHECK ADD  CONSTRAINT [fkActionId] FOREIGN KEY([ActionId])
REFERENCES [EC].[ShortCalls_Prescriptive_Actions] ([ID])
GO

ALTER TABLE [EC].[ShortCalls_Behavior_Action_Link] CHECK CONSTRAINT [fkActionId]
GO

ALTER TABLE [EC].[ShortCalls_Behavior_Action_Link]  WITH NOCHECK ADD  CONSTRAINT [fkBehaviorId] FOREIGN KEY([BehaviorId])
REFERENCES [EC].[ShortCalls_Behavior] ([ID])
GO

ALTER TABLE [EC].[ShortCalls_Behavior_Action_Link] CHECK CONSTRAINT [fkBehaviorId]
GO





--6b. Insert records to  [EC].[ShortCalls_Behavior_Action_Link]


INSERT INTO [EC].[ShortCalls_Behavior_Action_Link]
           ([BehaviorId]
           ,[ActionId]
           ,[DisplayOrder]
           ,[Active])
VALUES
(101,2,1,1),
(101,5,2,1),
(101,6,3,1),
(101,7,4,1),
(103,6,1,1),
(103,7,2,1),
(104,2,1,1),
(104,5,2,1),
(104,6,3,1),
(104,7,4,1),
(105,6,1,1),
(105,7,2,1),
(106,2,1,1),
(106,5,2,1),
(106,6,3,1),
(106,7,4,1),
(107,2,1,1),
(107,5,2,1),
(107,6,3,1),
(107,7,4,1),
(110,1,1,1),
(110,4,2,1),
(110,3,3,1)
      
GO



--**************************************************************

--7. Create Table  [EC].[ShortCalls_Evaluations]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[ShortCalls_Evaluations](
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
	[MgrComments] [nvarchar](2000) NULL,
 CONSTRAINT [PK_CoachID_CallID] PRIMARY KEY CLUSTERED 
(
	[CoachingID] ASC,
	[VerintCallID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [EC].[ShortCalls_Evaluations]  WITH NOCHECK ADD  CONSTRAINT [fkShortCallsCoachingID] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log] ([CoachingID])
ON DELETE CASCADE
GO

ALTER TABLE [EC].[ShortCalls_Evaluations] CHECK CONSTRAINT [fkShortCallsCoachingID]
GO

--**************************************************************

--8. Create Table [EC].[Audio_Issues_VerintIds]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Audio_Issues_VerintIds](
	[CoachingID] [bigint] NOT NULL,
	[VerintIds] [nvarchar](600) NULL
) ON [PRIMARY]
GO

ALTER TABLE [EC].[Audio_Issues_VerintIds]  WITH NOCHECK ADD  CONSTRAINT [fkCoachingIDVerintIds] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log] ([CoachingID])
GO

ALTER TABLE [EC].[Audio_Issues_VerintIds] CHECK CONSTRAINT [fkCoachingIDVerintIds]
GO


**************************************************************

--Table Type creates

**************************************************************


--**************************************************************

--1. Create Table Type [EC].[SCSupReviewTableType]

CREATE TYPE [EC].[SCSupReviewTableType] AS TABLE(
	[VerintCallID] [nvarchar](30) NOT NULL,
	[Valid] [nvarchar](3) NULL,
	[BehaviorId] [int] NULL,
	[Action] [nvarchar](1000) NULL,
	[CoachingNotes] [nvarchar](4000) NULL,
	[LSAInformed] [nvarchar](3) NULL
)
GO


--**************************************************************

--2. Create Table Type [EC].[SCMgrReviewTableType]

CREATE TYPE [EC].[SCMgrReviewTableType] AS TABLE(
	[VerintCallID] [nvarchar](30) NOT NULL,
	[MgrAgreed] [nvarchar](3) NULL,
	[MgrComments] [nvarchar](2000) NULL
)
GO


--**************************************************************

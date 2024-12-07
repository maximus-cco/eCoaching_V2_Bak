/*
CCO_eCoaching_Quality_Now_Load_Tables_Create(05).sql

Last Modified Date: 01/08/2024
Last Modified By: Susmitha Palacherla

Version 05: TFS 27523 - Dashboard to view the feed load history in the Admin Tool- 01/08/2024
Version 04: TFS 21276 - Update QN Alt Channels compliance and mastery levels 
Version 03: TFS 20677 -  AD island to AD AWS environment changes - 4/22/2021
Version 02:Updated to change data type for Customer Temp Start and End to nvarchar. TFS 15058 - 08/07/2019
Version 01: Document Initial Revision - TFS 13332 - 03/19/2019


**************************************************************

--Table list

**************************************************************

1.[EC].[Quality_Now_Coaching_Stage]
2.[EC].[Quality_Now_Coaching_Rejected]
3.[EC].[Coaching_Log_Quality_Now_Evaluations]
4.[EC].[Quality_Now_FileList]


**************************************************************

--Table creates

**************************************************************/

--1. Create Table [EC].[Quality_Now_Coaching_Stage]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Now_Coaching_Stage](
	[QN_Batch_ID] [nvarchar](20) NOT NULL,
	[QN_Batch_Status] [nvarchar](20) NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[Eval_Site_ID] [int] NULL,
	[SUP_EMPID] [nvarchar](20) NULL,
	[MGR_EMPID] [nvarchar](20) NULL,
	[QN_Source] [nvarchar](30) NULL,
	[QN_Strengths_Opportunities] [nvarchar](2000) NULL,
	[Eval_ID] [nvarchar](20) NULL,
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
	[Emp_Role] [nvarchar](3) NULL,
	[Module] [int] NULL,
	[Reject_Reason] [nvarchar](200) NULL,
        [Channel] [nvarchar](30) NULL,
	[ActivityID] [nvarchar](30) NULL,
	[DCN] [nvarchar](20) NULL,
	[CaseNumber] [nvarchar](10) NULL,
	[Reason_For_Contact] [nvarchar](100) NULL,
	[Contact_Reason_Comment] [nvarchar](1024) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO





--************************************


--2. Create Table [EC].[Quality_Now_Coaching_Rejected]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Now_Coaching_Rejected](
	[QN_Batch_ID] [nvarchar](20) NOT NULL,
	[QN_Batch_Status] [nvarchar](20) NULL,
	[Eval_ID] [nvarchar](20) NULL,
	[Eval_Date] [datetime] NULL,
	[Eval_Site_ID] [int] NULL,
	[User_EMPID] [nvarchar](20) NULL,
	[Journal_ID] [nvarchar](30) NULL,
	[Call_Date] [datetime] NULL,
	[Source] [nvarchar](30) NULL,
	[VerintFormName] [nvarchar](50) NULL,
	[isCoachingMonitor] [nvarchar](3) NULL,
	[Reject_reason] [nvarchar](200) NULL,
	[Date_Rejected] [datetime] NULL
) ON [PRIMARY]

GO



--************************************


--3. Create Table [EC].[Coaching_Log_Quality_Now_Evaluations]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Quality_Now_Evaluations](
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
	[Customer_Temp_End] [nvarchar](30)NULL,
	[Customer_Temp_End_Comment] [nvarchar](2000) NULL,
	[Inserted_Date] [datetime] NULL,
	[Last_Updated_Date] [datetime] NULL,
	[Channel] [nvarchar](30) NULL,
	[ActivityID] [nvarchar](30) NULL,
	[DCN] [nvarchar](20) NULL,
	[CaseNumber] [nvarchar](10) NULL,
	[Reason_For_Contact] [nvarchar](100) NULL,
	[Contact_Reason_Comment] [nvarchar](1024) NULL
 CONSTRAINT [PK_QN_Evals] PRIMARY KEY CLUSTERED 
(
	[QNBatchID] ASC,
	[CoachingID] ASC,
	[Eval_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [EC].[Coaching_Log_Quality_Now_Evaluations] ADD  CONSTRAINT [df_Channel]  DEFAULT ('Unknown') FOR [Channel]
GO

ALTER TABLE [EC].[Coaching_Log_Quality_Now_Evaluations]  WITH NOCHECK ADD  CONSTRAINT [fkQNEvalCoachingID] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log] ([CoachingID])
ON DELETE CASCADE
GO

ALTER TABLE [EC].[Coaching_Log_Quality_Now_Evaluations] CHECK CONSTRAINT [fkQNEvalCoachingID]
GO



--************************************


--4. Create Table [EC].[Quality_Now_FileList]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Quality_Now_FileList](
	[File_SeqNum] [int] IDENTITY(1,1) NOT NULL,
	[File_Name] [nvarchar](260) NULL,
	[File_LoadDate] [datetime] NULL,
	[Count_Staged] [int] NULL,
	[Count_Loaded] [int] NULL,
	[Count_Rejected] [int] NULL,
	[Count_Rejected] [int] NULL,
	[Category] [nvarchar](60) NULL,
) ON [PRIMARY]

GO







--**********************************************************************************


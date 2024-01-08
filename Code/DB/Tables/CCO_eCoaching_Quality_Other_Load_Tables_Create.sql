/*
CCO_eCoaching_Quality_Other_Load_Tables_Create(09).sql
Last Modified Date: 01/08/2024
Last Modified By: Susmitha Palacherla

Version 09: TFS 27523 - Dashboard to view the feed load history in the Admin Tool- 01/08/2024
Version 08: TFS 21493 - Written Corr Bingo records in bingo feeds
Version 07: TFS 20677 -  AD island to AD AWS environment changes - 4/22/2021
Version 06: TFS 18833 -  Expand the site field size in feeds - 10/9/2020
Version 05: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 04: Updated to support QN Bingo eCoaching logs. TFS 15063 - 08/12/2019
version 03: Updated to document changes for feed encryption TFS 7854.
Marked fact table as obsolete
Version 02: Add table [EC].[NPN_Description] to Get NPN Description from table. TFS 5649 - 02/20/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************

1.[EC].[Quality_Other_Coaching_Stage]
2.[EC].[Quality_Other_Coaching_Rejected]
3.[EC].[Quality_Other_Coaching_Fact]-- Obsolete with TFS 7854
4.[EC].[Quality_Other_FileList]
5.[EC].[NPN_Description]
6.[EC].[Coaching_Log_Bingo]
7.[EC].[Bingo_Images]

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
	[EMP_Site] [nvarchar](60) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Reject_Reason] [nvarchar](200) NULL,
	[Competency] [nvarchar](30) NULL,
	[Note] [nvarchar](30) NULL,
	[BingoType] [nvarchar](30) NULL
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
	[EMP_Site] [nvarchar](60) NULL,
	[Program] [nvarchar](30) NULL,
	[CoachReason_Current_Coaching_Initiatives] [nvarchar](20) NULL,
	[TextDescription] [nvarchar](4000) NULL,
	[FileName] [nvarchar](260) NULL,
	[Rejected_Reason] [nvarchar](200) NULL,
	[Rejected_Date] [datetime] NULL
) ON [PRIMARY]

GO




--************************************


--3. Create Table [EC].[Quality_Other_Coaching_Fact]-- Obsolete with TFS 7854

/*
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
*/

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
	[Count_Rejected] [int] NULL,
	[Count_Rejected] [int] NULL,
	[Category] [nvarchar](60) NULL,
) ON [PRIMARY]

GO









--**********************************************************************************

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[NPN_Description](
	[NPNCode] [nvarchar](20) NOT NULL,
	[NPNDescription] [nvarchar](4000) NOT NULL
) ON [PRIMARY]

GO
--***************************

INSERT INTO [EC].[NPN_Description]
           ([NPNCode]
           ,[NPNDescription])
     VALUES
           ('#NPNFFM1',
'When completing an application, CSRs are required to ask consumers the question “Tell us if you’re getting help from one of these people.”  If the consumer indicates that they are receiving help from a Navigator, Certified Application Counselor, Agent/Broker, or non-Navigator assistance personnel, the CSR must enter the national producer number (NPN) in the appropriate field.

On this call a new application was started but the consumer was not asked if he or she had been assisted. Please make certain to ask this required question on future calls. #NPNFFM1'),
            ('#NPNFFM2',
'When completing an application, CSRs are required to ask consumers the question “Tell us if you’re getting help from one of these people.”  If the consumer indicates that they are receiving help from a Navigator, Certified Application Counselor, Agent/Broker, or non-Navigator assistance personnel, the CSR must enter the national producer number (NPN) in the appropriate field.

On this call a new application was started, the consumer indicated they had assistance, but the NPN was not entered in the appropriate field. Please make certain to enter the NPN information correctly on future calls. #NPNFFM2'),
			('#NPNFFM3',
'When updating an application, CSRs are required to ask consumers the question “Tell us if you’re getting help from one of these people.”  If the consumer indicates that they are receiving help from a Navigator, Certified Application Counselor, Agent/Broker, or non-Navigator assistance personnel, the CSR must enter the national producer number (NPN) in the appropriate field.

On this call the application was updated using Reporting a Life Change but the consumer was not asked if he or she had been assisted. Please make certain to ask this required question on future calls. #NPNFFM3'),
	        ('#NPNFFM4',
'When updating an application, CSRs are required to ask consumers the question “Tell us if you’re getting help from one of these people.”  If the consumer indicates that they are receiving help from a Navigator, Certified Application Counselor, Agent/Broker, or non-Navigator assistance personnel, the CSR must enter the national producer number (NPN) in the appropriate field.

On this call the application was updated using Reporting a Life Change and the consumer indicated they had assistance, but the NPN was not entered in the appropriate field. Please make certain to enter the NPN information correctly on future calls. #NPNFFM4'),
	        ('#NPNFFM5',
'When updating an application, CSRs are required to ask consumers the question “Tell us if you’re getting help from one of these people.”  If the consumer indicates that they are receiving help from a Navigator, Certified Application Counselor, Agent/Broker, or non-Navigator assistance personnel, the CSR must enter the national producer number (NPN) in the appropriate field.

On this call the application was updated using Reporting a Life Change. There was data in the application indicating the consumer was assisted. The consumer was not asked if he or she had been assisted in order to confirm the validity of the information in the application. Please make certain to ask this required question on future calls. #NPNFFM5')






--**********************************************************************************


--6.[EC].[Coaching_Log_Bingo]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Log_Bingo](
	[CoachingID] [bigint] NOT NULL,
	[Competency] [nvarchar](30) NOT NULL,
	[Note] [nvarchar](30) NULL,
	[Description] [nvarchar](4000) NULL,
	[CompImage] [nvarchar](100) NULL,
	[BingoType] [nvarchar](30) NULL,
	[Include] [bit] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [EC].[Coaching_Log_Bingo] ADD  CONSTRAINT [df_include]  DEFAULT ((1)) FOR [Include]
GO

ALTER TABLE [EC].[Coaching_Log_Bingo]  WITH NOCHECK ADD  CONSTRAINT [fkBingoCoachingID] FOREIGN KEY([CoachingID])
REFERENCES [EC].[Coaching_Log] ([CoachingID])
ON DELETE CASCADE
GO

ALTER TABLE [EC].[Coaching_Log_Bingo] CHECK CONSTRAINT [fkBingoCoachingID]
GO


--**********************************************************************************


--7.[EC].[Bingo_Images]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Bingo_Images](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[ImageDesc] [nvarchar](100) NOT NULL,
	[Competency] [nvarchar](30) NOT NULL,
	[BingoType][nvarchar](30) NULL
) ON [PRIMARY]

GO


INSERT INTO [EC].[Bingo_Images]
           ([ImageDesc]
           ,[Competency])
     VALUES
           	   ('<img border="20" src="cid:aa.png">','Accurate Arrow','QN'),
		   ('<img border="20" src="cid:al.png">','Active Listener','QN'),
           	   ('<img border="20" src="cid:cc.png">','Compassionate Communicator','QN'),
		   ('<img border="20" src="cid:nn.png">','Nimble Navigator','QN'),
		   ('<img border="20" src="cid:pp.png">','Privacy Protector','QN'),
		   ('<img border="20" src="cid:pr.png">','Process Pro','QN'),
		   ('<img border="20" src="cid:so.png">','Smooth Operator','QN'),
		   ('<img border="20" src="cid:aa_qm.png">','Accurate Arrow','QM'),
	   	   ('<img border="20" src="cid:cc_qm.png">','Compassionate Communicator','QM'),	
	   	   ('<img border="20" src="cid:mm_qm.png">','Message Master','QM'),
           	   ('<img border="20" src="cid:pp_qm.png">','Privacy Protector','QM'),
	   	   ('<img border="20" src="cid:pr_qm.png">','Process Pro','QM'),
   	   	   ('<img border="20" src="cid:rr_qm.png">','Resolution Rock Star','QM'),
	   	   ('<img border="20" src="cid:so_qm.png">','Smooth Operator','QM'),
    		   ('<img border="20" src="cid:wc.png">','Wild Card','QN'),
	   	   ('<img border="20" src="cid:wc_qm.png">','Wild Card','QM'),
                   ('<img border="20" src="cid:qc.png">','Quality Correspondent 1','QN'),
	   	   ('<img border="20" src="cid:qc.png">','Quality Correspondent 2','QN'),	
	   	   ('<img border="20" src="cid:qc.png">','Quality Correspondent 3','QN'),
           	   ('<img border="20" src="cid:qc.png">','Quality Correspondent 4','QN')
		  
GO





--**********************************************************************************


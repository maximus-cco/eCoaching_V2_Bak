/*
CCO_eCoaching_Surveys_Tables_Create(01).sql

Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************


1. CREATE TABLE Survey_DIM_Type
2. CREATE TABLE Survey_DIM_Question
3. CREATE TABLE Survey_DIM_Response
4. CREATE TABLE Survey_DIM_QAnswer
5. CREATE TABLE Survey_Response_Header
6. CREATE TABLE Survey_Response_Detail
7. CREATE TYPE ResponsesTableType



**************************************************************

--Table creates

**************************************************************/


-- 1. Create table Survey_DIM_Type
--a.

/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Survey_DIM_Type]') AND type in (N'U'))
DROP Table [EC].[Survey_DIM_Type]
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:     08/21/2015
--    Description:     Table to hold the diffrent type of Surveys that can exist.
--   Created as part of TFS 549 to set up the CSR Survey.
--    =====================================================================
CREATE TABLE [EC].[Survey_DIM_Type](
	[SurveyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[StartDate] [int] NOT NULL,
	[EndDate] [int] NOT NULL,
	[isActive] [bit] NOT NULL,
	[CSR] [bit] NOT NULL,
	[Supervisor] [bit] NOT NULL,
	[Quality] [bit] NOT NULL,
	[LSA] [bit] NOT NULL,
	[Training] [bit] NOT NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [SurveyTypeID] PRIMARY KEY CLUSTERED 
(
	[SurveyTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



--b.

INSERT INTO [EC].[Survey_DIM_Type]
                 ([Description] 
	,[StartDate] 
	,[EndDate] 
	,[isActive] 
	,[CSR] 
	,[Supervisor]
	,[Quality] 
	,[LSA]
	,[Training] 
	,[LastUpdateDate])
	VALUES
	( 'Employee Survey', 20150901, 99991231, 1,1,0,0,0,0, '2015-09-01 00:00:00.000')
   GO   


--******************************


--2.  Create table Survey_DIM_Question



--a.

/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Survey_DIM_Question]') AND type in (N'U'))
DROP Table [EC].[Survey_DIM_Question]
*/

 SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:     08/21/2015
--    Description:     Table to hold the diffrent Questions that can be used  in a Survey.
--   Created as part of TFS 549 to set up the CSR Survey.
--    =====================================================================

CREATE TABLE [EC].[Survey_DIM_Question](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[StartDate] [int] NULL,
	[EndDate] [int] NULL,
	[isHotTopic][bit] NULL,
	[isActive] [bit] NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [QuestionID] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



--b.

INSERT INTO [EC].[Survey_DIM_Question]
                  ([Description] 
  	,[DisplayOrder]
	,[StartDate] 
	,[EndDate] 
	,[isHotTopic]
	,[isActive] 
	,[LastUpdateDate])
	VALUES
	( N'Was the call played back for you during your last coaching session? (If applicable). | 
	 If no, what reason was provided?', 1, 20150901, 99991231,0, 1, '2015-09-01 00:00:00.000'),
	(N'Will you be able to apply the information from your last coaching session? |
	 If yes, how?  If no, why  not?', 2, 20150901, 99991231,0, 1, '2015-09-01 00:00:00.000'),
	(N'Did you find the coaching session valuable/effective? |
	If yes, what specifically.  If no, why not?', 3, 20150901, 99991231,0, 1, '2015-09-01 00:00:00.000'),
	('Please rate the effectiveness of the coaching notes provided in the eCL. |
	Please explain below.', 4, 20150901, 99991231,0, 1, '2015-09-01 00:00:00.000'),
	(N'Please rate your overall coaching experience. |
	Please explain below.', 5, 20150901, 99991231,0, 1, '2015-09-01 00:00:00.000')
	GO
	

--c.

SET IDENTITY_INSERT [EC].[Survey_DIM_Question] ON
GO


--d.

INSERT INTO [EC].[Survey_DIM_Question]
    ([QuestionID]
    ,[Description] 
    ,[DisplayOrder]
	,[StartDate] 
	,[EndDate] 
	,[isHotTopic]
	,[isActive] 
	,[LastUpdateDate])
	VALUES
	(-1, 'Unknown', 0, 20150901, 99991231,0,0, '2015-09-01 00:00:00.000')
GO


--e.

SET IDENTITY_INSERT [EC].[Survey_DIM_Question] OFF
GO


--******************************


-- 3. Create table Survey_DIM_Response

--a.
/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Survey_DIM_Response]') AND type in (N'U'))
DROP Table [EC].[Survey_DIM_Response]
*/

 SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:     08/21/2015
--    Description:     Table to hold the diffrent Responses possible for a Survey.
--   Created as part of TFS 549 to set up the CSR Survey.
--    =====================================================================

CREATE TABLE [EC].[Survey_DIM_Response](
	[ResponseID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
	[isActive] [bit] NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [ResponseID] PRIMARY KEY CLUSTERED 
(
	[ResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--b.

INSERT INTO [EC].[Survey_DIM_Response]
                 ([Value]
	,[isActive] 
	,[LastUpdateDate])
	VALUES
	( 'Yes', 1, '2015-09-01 00:00:00.000'),
	( 'No', 1, '2015-09-01 00:00:00.000'),
	( 'N/A', 1, '2015-09-01 00:00:00.000'),
	( '1 - Very Ineffective', 1 , '2015-09-01 00:00:00.000'),
	( '2 - Ineffective', 1, '2015-09-01 00:00:00.000'),
	( '3 - Neither', 1, '2015-09-01 00:00:00.000'),
	( '4 - Effective', 1, '2015-09-01 00:00:00.000'),
	( '5 - Very Effective', 1, '2015-09-01 00:00:00.000'),
	( '1 - Very Dissatisfied', 1 , '2015-09-01 00:00:00.000'),
	( '2 - Dissatisfied', 1, '2015-09-01 00:00:00.000'),
	( '4 - Satisfied', 1, '2015-09-01 00:00:00.000'),
	( '5 - Very Satisfied', 1, '2015-09-01 00:00:00.000')
GO


--c.

SET IDENTITY_INSERT [EC].[Survey_DIM_Response] ON
GO


--d.

INSERT INTO [EC].[Survey_DIM_Response]
    ([ResponseID]
	,[Value] 
	,[isActive] 
	,[LastUpdateDate])
	VALUES
	(-1, 'Not Applicable', 1, '2015-09-01 00:00:00.000')
GO

--e.

SET IDENTITY_INSERT [EC].[Survey_DIM_Response] OFF
GO



--******************************


--4.  Create table Survey_DIM_QAnswer

--a.
/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Survey_DIM_QAnswer]') AND type in (N'U'))
DROP Table [EC].[Survey_DIM_QAnswer]
*/


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:     08/21/2015
--    Description:     Table to hold all possible responses to a question for a specific survey Type.
--    Created as part of TFS 549 to set up the CSR Survey.
--    =====================================================================

CREATE TABLE [EC].[Survey_DIM_QAnswer](
	[SurveyTypeID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[QuestionNumber] [int] NOT NULL,
	[ResponseID] [int] NOT NULL,
	[ResponseValue] [nvarchar](50) NULL,
	[ResponseType] [nvarchar](100) NULL,
	[isHotTopic] [bit],
	[StartDate] [int] NULL,
	[EndDate] [int] NULL,
	[isActive] [bit] NULL,
	[LastUpdateDate] [datetime] NULL
) ON [PRIMARY]

GO


--b.

INSERT INTO [EC].[Survey_DIM_QAnswer]
	([SurveyTypeID] 
	,[QuestionID] 
	,[QuestionNumber] 
	,[ResponseID] 
	,[ResponseValue] 
	,[ResponseType] 
	,[isHotTopic] 
	,[StartDate] 
	,[EndDate] 
	,[isActive]  
	,[LastUpdateDate])
VALUES
(1,1,1,1,'Yes','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,1,1,2,'No','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,1,1,3,'N/A','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,2,2,1,'Yes','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,2,2,2,'No','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,3,3,1,'Yes','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,3,3,2,'No','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,4,4,4,'1 - Very Ineffective','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,4,4,5,'2 - Ineffective','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,4,4,6,'3 - Neither','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,4,4,7,'4 - Effective','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,4,4,8,'5 - Very Effective','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,5,5,9,'1 - Very Dissatisfied','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,5,5,10,'2 - Dissatisfied','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,5,5,6,'3 - Neither','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,5,5,11,'4 - Satisfied','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000'),
(1,5,5,12,'5 - Very Satisfied','Radio Button',0, 20150901, 99991231,1,'2015-09-01 00:00:00.000')
GO

--******************************


-- 5. Create table Survey_Response_Header
/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Survey_Response_Header]') AND type in (N'U'))
DROP Table [EC].[Survey_Response_Header]
*/


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Survey_Response_Header](
	[SurveyID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyTypeID] [int] NOT NULL,
	[CoachingID] [bigint] NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[EmpID] [nvarchar](10) NOT NULL,
	[EmpLanID] [nvarchar](30) NOT NULL,
	[SiteID] [int] NOT NULL,
	[SourceID] [int] NOT NULL,
                  [ModuleID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[MonthOfYear] [int] NOT NULL,
	[CalendarYear] [int] NOT NULL,
	[CSRComments] [nvarchar](4000) NULL,
	[EmailSent] [bit] NOT NULL,
	[CompletedDate] [datetime] NULL,
	[Status] [nvarchar](20) NULL,
	[InactivationDate] [datetime] NULL,
	[InactivationReason] [nvarchar](100) NULL,
                  [NotificationDate] [datetime] NULL,
 CONSTRAINT [SurveyID] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Survey_Response_Header] ADD  DEFAULT ((0)) FOR [EmailSent]
GO


--******************************


-- 6. Create table Survey_Response_Detail
/*
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[EC].[Survey_Response_Detail]') AND type in (N'U'))
DROP Table [EC].[Survey_response_Detail]
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Survey_Response_Detail](
	[SurveyID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[ResponseID] [int] NOT NULL,
	[UserComments] [nvarchar](4000) NULL,
 CONSTRAINT [SrvID_QnID_RespID] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC,
	[QuestionID] ASC,
	[ResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




--******************************

--7. Create User defined Data TYPE [EC].[ResponsesTableType] 

CREATE TYPE [EC].[ResponsesTableType] AS TABLE(
	[QuestionID] [int] NOT NULL,
	[ResponseID] [int] NOT NULL,
	[Comments] [nvarchar](4000) NULL
)
GO


--*****************************************


	    


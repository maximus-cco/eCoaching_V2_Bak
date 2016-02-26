/*
eCoaching_Surveys_Create(03).sql
Last Modified Date: 02/26/2016
Last Modified By: Susmitha Palacherla

Version 03: 02/26/2016
Additional update for TFS 2052.  Setup Survey Reminders 
Modified  procedure #10 sp_SelectSurvey4Reminder to use status of 
'open' in selection criteria

Version 02: 02/26/2016
Initial revision. TFS 2052.  Setup Survey Reminders 
Added column [NotificationDate] to Table Survey_Response_Header
Modified procedure #5 sp_UpdateSurveyMailSent to capture Notification date
Added new procedure #10 sp_SelectSurvey4Reminder to select surveys for reminders

Version 01: 09/25/2015
Initial revision. TFS 549. CSR Survey Setup.


***************Section 1 - Tables***************

1. CREATE TABLE Survey_DIM_Type
2. CREATE TABLE Survey_DIM_Question
3. CREATE TABLE Survey_DIM_Response
4. CREATE TABLE Survey_DIM_QAnswer
5. CREATE TABLE Survey_Response_Header
6. CREATE TABLE Survey_Response_Detail
7. CREATE TYPE ResponsesTableType

***************Section 2 - Functions**************

1.Create FUNCTION [EC].[fn_isHotTopicFromSurveyTypeID] 


****************Section 3 - Procedures***************


1. Create PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header]
2. Create PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header_Resend]
3. Create PROCEDURE [EC].[sp_Update_Survey_Response]
4. Create PROCEDURE [EC].[sp_SelectSurvey4Contact]
5. Create PROCEDURE [EC].[sp_UpdateSurveyMailSent]
6. Create PROCEDURE [EC].[sp_Select_Questions_For_Survey]
7. Create PROCEDURE [EC].[sp_Select_Responses_For_Survey]
8. Create PROCEDURE [EC].[sp_Select_Responses_By_Question] 
9. Create PROCEDURE [EC].[sp_Select_SurveyDetails_By_SurveyID]
10. Create PROCEDURE [EC].[sp_SelectSurvey4Reminder]


********************************************************************************
		Section 1 - Tables
**********************************************************************************/

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


/********************************************************************************
		Section 2 - Functions
**********************************************************************************/

--1. FUNCTION [EC].[fn_isHotTopicFromSurveyTypeID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_isHotTopicFromSurveyTypeID' 
)
   DROP FUNCTION [EC].[fn_isHotTopicFromSurveyTypeID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 09/29/2015
--	Description:	 
--  *  Given a Survey Type ID returns a bit to indicate whether or not 
--     there is an Active  Hot topic question associated with the Survey.
-- Created per during CSR survey setup per TFS 549
--	=============================================
CREATE FUNCTION [EC].[fn_isHotTopicFromSurveyTypeID] 
(
  @intSurveyTypeID INT
)
RETURNS BIT
AS
BEGIN
 
	 DECLARE @intHotTopicCount int,
	         @isHotTopic bit
	      
	         
		
SET @intHotTopicCount = (SELECT COUNT(*) FROM [EC].[Survey_DIM_QAnswer]
WHERE [isHotTopic] = 1 and [isActive] = 1
AND SurveyTypeID = @intSurveyTypeID)
	
	-- IF at least active Hot topic question found
	
IF @intHotTopicCount > 0

-- Return 1
BEGIN

		SET @isHotTopic = 1
END
	  
ELSE 	

-- Return 0

BEGIN

		SET @isHotTopic = 0
END


RETURN 	@isHotTopic

END --fn_isHotTopicFromSurveyTypeID

GO






/********************************************************************************
		Section 3 - Procedures
**********************************************************************************/

--1. Create PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Survey_Response_Header' 
)
   DROP  PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        8/21/2015
-- Checks for Completed eCLs in [EC].[Coaching_Log]table and generates a 
-- Survey Header record based on a randomly selected completed ecl
-- and inserts into [EC].[Survey_Response_Header]
-- This procedure checks to make sure that a survey has not been generated for the
-- calendar month for that employee.
-- After a survey is generated for an ecl, the coaching log is updated
-- in the Coaching_log to indicate that a Survey has been generated based on this ecl.
-- Created  per TFS 549 to setup CSR survey.
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header]
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @EndOfPeriod DATETIME
      DECLARE @StartOfPeriod DATETIME
      DECLARE @i INT
      DECLARE @j INT
      DECLARE @SurveyTypeID INT
      DECLARE @SurveyTypeID_Table table (idx INT Primary Key IDENTITY(1,1), SurveyTypeID INT)
	  DECLARE @numirows INT
      DECLARE @ModuleID INT
      DECLARE @Modules_Table table (idx INT Primary Key IDENTITY(1,1), ModuleID INT)
      DECLARE @numjrows INT




  SET @EndOfPeriod  = DATEADD(day, DATEDIFF(DD, 0, GetDate()),0) 
  -- For Start of Current Month
  --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate()),0) 
  -- For testing setting to beginning of year. 
  --SET @StartOfMonth = DATEADD(year, DATEDIFF(year, 0, GetDate()),0) 
  -- For n months in the past GetDate())-n
    --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate())-4,0) 
  SET @StartOfPeriod = DATEADD(day, DATEDIFF(DD, 0, GetDate())-7,0) 
 
 --PRINT @StartOfPeriod
 --PRINT @EndOfPeriod   
 
-- Populate SurveyTypeID_Table 
INSERT @SurveyTypeID_Table
SELECT DISTINCT SurveyTypeID FROM [EC].[Survey_DIM_Type]WHERE [isActive] = 1
  
  -- Enumerate the SurveyTypeID_Table
  -- For generating a Survey per Active Survey Type.
SET @i = 1
SET @numirows = (SELECT COUNT(*) FROM @SurveyTypeID_Table)
IF @numirows > 0
    WHILE (@i <= (SELECT MAX(idx) FROM @SurveyTypeID_Table))
    BEGIN
SET @SurveyTypeID = (SELECT [SurveyTypeID] FROM @SurveyTypeID_Table WHERE idx = @i)

-- Looping through and checking for Modules that need the Survey generated for the above Survey Type.

INSERT   @Modules_Table
SELECT DISTINCT X.ModuleID FROM
(
SELECT CASE WHEN [CSR]= 1 THEN 1 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Supervisor]= 1 THEN 2 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Quality]= 1 THEN 3 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [LSA]= 1 THEN 4 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Training]= 1 THEN 5 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID)X
WHERE X.ModuleID IS NOT NULL

 SET @j = 1
 SET @numjrows = (SELECT COUNT(*) FROM @Modules_Table)
IF @numjrows > 0

 WHILE (@j <= (SELECT MAX(idx) FROM @Modules_Table))
 
BEGIN
  SET @ModuleID = (SELECT [ModuleID] FROM @Modules_Table WHERE idx = @j)

--PRINT @ModuleID

 -- eCLs meeting criteria for Survey generation are first selected.
 -- Records for each employee are ordered by a new randomly generated ID.
 -- First row from the randomly ordered records is selected for each Employee.
 
 /*
 BEGIN 
  ;WITH SurveyPool AS
  (SELECT x.EmpID, x.CoachingID FROM
  (SELECT  CL.EMPID EmpID, CL.CoachingID CoachingID,ROW_NUMBER() OVER( PARTITION BY CL.EMPID
   ORDER BY NewID()) AS Rn 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN [EC].[Employee_Hierarchy]EH
  ON CL.EmpID = EH.Emp_ID
  WHERE Statusid = 1 -- Completed
  AND ModuleID = @ModuleID -- Each Module 
   AND SourceID <> 224 -- Verint-TQC
  AND isCSRAcknowledged = 1
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )x
 WHERE x.Rn=1)
*/



 BEGIN 
  ;WITH Selected AS
  (SELECT DISTINCT @SurveyTypeID SurveyTypeID, 
                   CL.CoachingID,
                   CL.Formname, 
                   CL.EmpID,
                   CL.EmpLanID,
                   CL.SiteID, 
                   CL.SourceID, 
                   CL.ModuleID,
                   CL.Submitteddate, 
                   DD.MonthOfYear, 
                   DD.CalendarYear 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN EC.DIM_Date DD
  ON DATEADD(dd, DATEDIFF(dd, 0, CL.CSRReviewAutoDate),0) = DD.Fulldate JOIN 
 (SELECT x.EmpID, x.CoachingID FROM
  (SELECT  CL.EMPID EmpID, CL.CoachingID CoachingID,ROW_NUMBER() OVER( PARTITION BY CL.EMPID
   ORDER BY NewID()) AS Rn 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN [EC].[Employee_Hierarchy]EH
  ON CL.EmpID = EH.Emp_ID
  WHERE Statusid = 1 -- Completed
  AND ModuleID = @ModuleID -- Each Module 
   AND SourceID <> 224 -- Verint-TQC
  AND isCSRAcknowledged = 1
  AND SurveySent = 0
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )x
 WHERE x.Rn=1)SP
 ON CL.CoachingID = SP.CoachingID
 AND CL.EmpID = SP.EmpID)
 
 
--SELECT * FROM Selected
-- Insert selected random completions for each Employee into Survey header.
-- Check that no Survey exists for current month and year.

-- SCL: Selecetd Coaching logs
---SP: Survey pool
-- SRH: Survey Response Header



   
INSERT INTO [EC].[Survey_Response_Header]
           ([SurveyTypeID]
           ,[CoachingID]
           ,[FormName]
           ,[EmpID]
           ,[EmpLanID]
           ,[SiteID]
           ,[SourceID]
           ,[ModuleID]
           ,[CreatedDate]
           ,[MonthOfYear]
           ,[CalendarYear]
           ,[Status]
         )
SELECT  SCL.SurveyTypeID [SurveyTypeID],
		SCL.CoachingID  [CoachingID],
		SCL.FormName    [FormName],
        SCL.EmpID       [EmpID],
        SCL.EmpLanID    [EmpLanID],
        SCL.SiteID      [SiteID],
        SCL.SourceID    [SourceID],
        SCL.ModuleID    [ModuleID],
        GETDATE()       [CreatedDate],
        SCL.MonthOfYear,
        SCL.CalendarYear,
        'Open'         [Status]
 FROM Selected SCL LEFT OUTER JOIN [EC].[Survey_Response_Header] SRH 
  ON SCL.EmpID = SRH.EmpID
  AND SCL.ModuleID = SRH.ModuleID
  AND SCL.MonthOfYear = SRH.MonthOfYear
  AND SCL.CalendarYear = SRH.CalendarYear 
  AND SCL.[SurveyTypeID]= SRH.[SurveyTypeID]
--WHERE SCL.ModuleID = @ModuleID
--AND SCL.SurveyTypeID = @SurveyTypeID
WHERE (SRH.[SurveyTypeID] IS NULL AND SRH.EmpID is NULL AND SRH.MonthOfYear IS NULL AND SRH.CalendarYear IS NULL)
OPTION (MAXDOP 1)
END

SET @j = @j + 1
END

SET @i = @i + 1
END



WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

BEGIN
UPDATE [EC].[Coaching_Log]
SET [SurveySent] = 1
FROM [EC].[Survey_Response_Header]SRH JOIN [EC].[Coaching_Log] CL
ON SRH.[CoachingID] = CL.[CoachingID]
AND SRH.[Formname] = CL.[Formname]
AND [SurveySent] = 0
OPTION (MAXDOP 1)
END

                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_InsertInto_Survey_Response_Header










GO





***************************************


--2. Create PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header_Resend]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Survey_Response_Header_Resend' 
)
   DROP  PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header_Resend] 
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        8/21/2015
-- Checks for Completed eCLs in [EC].[Coaching_Log]table and generates a 
-- Survey Header record and inserts into [EC].[Survey_Response_Header]
-- This procedure is used for resending a Survey, so it will regenerate a Survey 
-- even when a Survey has previously been generated in the same month.
-- After a survey is generated for an ecl, the coaching log is updated
-- in the Coaching_log to indicate that a Survey has been generated based on this ecl.
-- Created  per TFS 549 to setup CSR survey.
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header_Resend]
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
BEGIN TRY

      DECLARE @EndOfPeriod DATETIME
      DECLARE @StartOfPeriod DATETIME
      DECLARE @DMonth INT
      DECLARE @DYear INT
      DECLARE @i INT
      DECLARE @j INT
      DECLARE @SurveyTypeID INT
      DECLARE @SurveyTypeID_Table table (idx INT Primary Key IDENTITY(1,1), SurveyTypeID INT)
	  DECLARE @numirows INT
      DECLARE @ModuleID INT
      DECLARE @Modules_Table table (idx INT Primary Key IDENTITY(1,1), ModuleID INT)
      DECLARE @numjrows INT
    



  SET @EndOfPeriod  = DATEADD(day, DATEDIFF(DD, 0, GetDate()),0) 
  -- For Start of Current Month
  --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate()),0) 
  -- For testing setting to beginning of year. 
  --SET @StartOfMonth = DATEADD(year, DATEDIFF(year, 0, GetDate()),0) 
  -- For n months in the past GetDate())-n
    --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate())-4,0) 
  SET @StartOfPeriod = DATEADD(day, DATEDIFF(DD, 0, GetDate())-7,0) 
 
 --PRINT @StartOfPeriod
 --PRINT @EndOfPeriod 
   SET @DMonth = datepart(month,getdate())
   SET @DYear = datepart(year,getdate())  
 
-- Populate SurveyTypeID_Table 
INSERT @SurveyTypeID_Table
SELECT DISTINCT SurveyTypeID FROM [EC].[Survey_DIM_Type]WHERE [isActive] = 1
  
  -- Enumerate the SurveyTypeID_Table
  -- For generating a Survey per Active Survey Type.
SET @i = 1
SET @numirows = (SELECT COUNT(*) FROM @SurveyTypeID_Table)
IF @numirows > 0
    WHILE (@i <= (SELECT MAX(idx) FROM @SurveyTypeID_Table))
    BEGIN
SET @SurveyTypeID = (SELECT [SurveyTypeID] FROM @SurveyTypeID_Table WHERE idx = @i)

-- Looping through and checking for Modules that need the Survey generated for the above Survey Type.

INSERT   @Modules_Table
SELECT DISTINCT X.ModuleID FROM
(
SELECT CASE WHEN [CSR]= 1 THEN 1 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Supervisor]= 1 THEN 2 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Quality]= 1 THEN 3 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [LSA]= 1 THEN 4 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Training]= 1 THEN 5 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID)X
WHERE X.ModuleID IS NOT NULL

 SET @j = 1
 SET @numjrows = (SELECT COUNT(*) FROM @Modules_Table)
IF @numjrows > 0

 WHILE (@j <= (SELECT MAX(idx) FROM @Modules_Table))
 
BEGIN
  SET @ModuleID = (SELECT [ModuleID] FROM @Modules_Table WHERE idx = @j)

--PRINT @ModuleID

 -- eCLs meeting criteria for Survey generation are first selected.
 -- Records for each employee are ordered by a new randomly generated ID.
 -- First row from the randomly ordered records is selected for each Employee.
 
 /*
 BEGIN 
  ;WITH SurveyPool AS
  (SELECT x.EmpID, x.CoachingID FROM
  (SELECT  CL.EMPID EmpID, CL.CoachingID CoachingID,ROW_NUMBER() OVER( PARTITION BY CL.EMPID
   ORDER BY NewID()) AS Rn 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN [EC].[Employee_Hierarchy]EH
  ON CL.EmpID = EH.Emp_ID
  WHERE Statusid = 1 -- Completed
  AND ModuleID = @ModuleID -- Each Module 
   AND SourceID <> 224 -- Verint-TQC
  AND isCSRAcknowledged = 1
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )x
 WHERE x.Rn=1)
*/



 BEGIN 
  ;WITH Selected AS
  (SELECT DISTINCT @SurveyTypeID SurveyTypeID, 
                   CL.CoachingID,
                   CL.Formname, 
                   CL.EmpID,
                   CL.EmpLanID,
                   CL.SiteID, 
                   CL.SourceID, 
                   CL.ModuleID,
                   CL.Submitteddate, 
                   DD.MonthOfYear, 
                   DD.CalendarYear 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN EC.DIM_Date DD
  ON DATEADD(dd, DATEDIFF(dd, 0, CL.CSRReviewAutoDate),0) = DD.Fulldate JOIN 
 (SELECT x.EmpID, x.CoachingID FROM
  (SELECT  CL.EMPID EmpID, CL.CoachingID CoachingID,ROW_NUMBER() OVER( PARTITION BY CL.EMPID
   ORDER BY NewID()) AS Rn 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN [EC].[Employee_Hierarchy]EH
  ON CL.EmpID = EH.Emp_ID
  WHERE Statusid = 1 -- Completed
  AND ModuleID = @ModuleID -- Each Module 
   AND SourceID <> 224 -- Verint-TQC
  AND isCSRAcknowledged = 1
  AND SurveySent = 0
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )x
 WHERE x.Rn=1)SP
 ON CL.CoachingID = SP.CoachingID
 AND CL.EmpID = SP.EmpID)
 
 
--SELECT * FROM Selected
-- Insert selected random completions for each Employee into Survey header.
-- Check that no Survey exists for current month and year.

-- SCL: Selecetd Coaching logs
---SP: Survey pool
-- SRH: Survey Response Header



   
INSERT INTO [EC].[Survey_Response_Header]
           ([SurveyTypeID]
           ,[CoachingID]
           ,[FormName]
           ,[EmpID]
           ,[EmpLanID]
           ,[SiteID]
           ,[SourceID]
           ,[ModuleID]
           ,[CreatedDate]
           ,[MonthOfYear]
           ,[CalendarYear]
           ,[Status]
         )
SELECT  SCL.SurveyTypeID [SurveyTypeID],
		SCL.CoachingID  [CoachingID],
		SCL.FormName    [FormName],
        SCL.EmpID       [EmpID],
        SCL.EmpLanID    [EmpLanID],
        SCL.SiteID      [SiteID],
        SCL.SourceID    [SourceID],
        SCL.ModuleID    [ModuleID],
        GETDATE()       [CreatedDate],
        SCL.MonthOfYear,
        SCL.CalendarYear,
        'Open'         [Status]
 FROM Selected SCL JOIN 
 --[EC].[Survey_Response_Header] SRH 
 (SELECT [SurveyTypeID],[CalendarYear],[MonthOfYear],[ModuleID],[EmpID], COUNT(*)SCount
FROM [EC].[Survey_Response_Header]
WHERE MonthOfYear = @DMonth
AND CalendarYear = @DYear
AND SurveyTypeID = @SurveyTypeID
GROUP BY [SurveyTypeID],[CalendarYear],[MonthOfYear],[ModuleID],[EmpID]
Having COUNT(*)= 1
) SRH
  ON SCL.EmpID = SRH.EmpID
  AND SCL.ModuleID = SRH.ModuleID
  AND SCL.MonthOfYear = SRH.MonthOfYear
  AND SCL.CalendarYear = SRH.CalendarYear 
  AND SCL.[SurveyTypeID]= SRH.[SurveyTypeID]
OPTION (MAXDOP 1)
END

SET @j = @j + 1
END

SET @i = @i + 1
END



WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

BEGIN
UPDATE [EC].[Coaching_Log]
SET [SurveySent] = 1
FROM [EC].[Survey_Response_Header]SRH JOIN [EC].[Coaching_Log] CL
ON SRH.[CoachingID] = CL.[CoachingID]
AND SRH.[Formname] = CL.[Formname]
AND [SurveySent] = 0
OPTION (MAXDOP 1)
END

                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_InsertInto_Survey_Response_Header_Resend



GO




--*****************************************************************

--3. Create PROCEDURE [EC].[sp_Update_Survey_Response]



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Survey_Response' 
)
   DROP  PROCEDURE [EC].[sp_Update_Survey_Response] 
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------
-- MULTIPLE ASTERISKS (***) DESIGNATE SECTIONS OF THE STORED PROCEDURE TEMPLATE THAT SHOULD BE CUSTOMIZED
---------------------------------------------------------------------------------------------------------
-- REQUIRED PARAMETERS:
-- INPUT: @***sampleInputVariable varchar(35)***
-- OUTPUT: @returnCode int, @returnMessage varchar(100)
-- The following 2 statements need to be executed when re-creating this stored procedure:
-- drop procedure [EC].[sp_Update_Survey_Response]
-- go
CREATE PROCEDURE [EC].[sp_Update_Survey_Response] (
      @intSurveyID INT,
      @nvcFormName nvarchar(50),
      @tableSR ResponsesTableType READONLY,
      @nvcUserComments Nvarchar(max),
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
@returnCode int OUTPUT,
@returnMessage varchar(100) OUTPUT
)
as
   declare @storedProcedureName varchar(80)
   declare @transactionCount int
   set @transactionCount = @@trancount
   set @returnCode = 0
   set @returnMessage = 'ok'
   -- If already in transaction, don't start another
   if @@trancount > 0
   begin
      save transaction currentTransaction
   end
   else
   begin
      begin transaction currentTransaction
   end
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   set @storedProcedureName = '2sp_Update_Survey_Response'
-------------------------------------------------------------------------------------
-- Notes: set @returnCode and @returnMessage as appropriate
--        @returnCode defaults to '0',  @returnMessage defaults to 'ok'
--        IMPORTANT: do NOT place "return" statements in this custom code section
--        IF no severe error occurs,
--           @returnCode and @returnMessage will contain the values set by you
--        IF this procedure is not nested within another procedure,
--           you can force a rollback of the transaction
--              by setting @returnCode to a negative number
-------------------------------------------------------------------------------------
-- sample: select * from table where column = @sampleInputVariable
-- sample: update table set column = @sampleInputVariable where column = someValue
-- sample: insert into table (column1, column2) values (value1, value2)
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SET NOCOUNT ON;


DECLARE @dtmDate datetime;

SET @dtmDate  = GETDATE()                          

INSERT INTO [EC].[Survey_Response_Detail]
            ([SurveyID],[QuestionID],[ResponseID],[UserComments])
            SELECT @intSurveyID,QuestionID, ResponseID, Comments
             FROM @tableSR 
          
             
WAITFOR DELAY '00:00:00:02'  -- Wait for 5 ms
    --PRINT 'STEP1'

     UPDATE [EC].[Survey_Response_Header]
        SET [CSRComments]= @nvcUserComments
           ,[Status]= 'Completed'
           ,[CompletedDate]= @dtmDate
           WHERE [SurveyID]= @intSurveyID
           AND [FormName]= @nvcFormName

-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   if @@error <> 0
   begin
      set @returnCode = @@error
      set @returnMessage = 'Error in stored procedure ' + @storedProcedureName
      rollback transaction currentTransaction
      return -1
   end
   --  We were NOT already in a transaction so one was started
   --  Therefore safely commit this transaction
   if @transactionCount = 0
   begin
      if @returnCode >= 0
      begin
         commit transaction
      end
      else -- custom code set the return code as negative, causing rollback
      begin
         rollback transaction currentTransaction
      end
   end
   -- if return message was not changed from default, do so now
   if @returnMessage = 'ok'
   begin
      set @returnMessage = @storedProcedureName + ' completed successfully'
   end
return 0
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED



GO







--*****************************************************************

--4. Create PROCEDURE [EC].[sp_SelectSurvey4Contact] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectSurvey4Contact' 
)
   DROP  PROCEDURE [EC].[sp_SelectSurvey4Contact] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:		       Susmitha Palacherla
--	Create Date:	   8/21/2015
--	Description: 	   This procedure queries db for newly added Survey records to send out notification.
--  Created  per TFS 549 to setup CSR survey.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectSurvey4Contact]
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormMail nvarchar (30)

--Set @strFormMail = 'jourdain.augustin@gdit.com'
 
SET @nvcSQL = 'SELECT   SRH.SurveyID	SurveyID	
		,SRH.FormName	FormName
		,SRH.Status		Status
		,eh.Emp_Email	EmpEmail
		,eh.Emp_Name	EmpName
		,SRH.CreatedDate	CreatedDate
		,CONVERT(VARCHAR(10), DATEADD(dd,5,SRH.CreatedDate) , 101) ExpiryDate
		,SRH.EmailSent	EmailSent
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Survey_Response_Header] SRH WITH (NOLOCK)
ON eh.Emp_ID = SRH.EmpID
WHERE SRH.EmailSent = ''False''
Order By SRH.SurveyID'
--and [strCSREmail] = '''+@strFormMail+'''
EXEC (@nvcSQL)	
	    
END --sp_SelectSurvey4Contact




GO



--*****************************************************************

--5. Create PROCEDURE [EC].[sp_UpdateSurveyMailSent] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateSurveyMailSent' 
)
   DROP  PROCEDURE [EC].[sp_UpdateSurveyMailSent] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      08/27/15
--    Description:      This procedure updates EmailSent column to "True" for records from Survey mail script. 
--    Last Update:      02/26/2016 - Modified per tfs 2502 to capture Notification Date to support Reminder initiative.
--    
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateSurveyMailSent]
(
      @nvcSurveyID nvarchar(30)
 
)
AS
BEGIN
DECLARE
@SentValue nvarchar(30),
@intSurveyID int

SET @SentValue = 1
SET @intSurveyID = CAST(@nvcSurveyID as INT)
   
  	UPDATE [EC].[Survey_Response_Header]
	   SET EmailSent = @SentValue
          ,NotificationDate = GetDate() 
	WHERE SurveyID = @intSurveyID
	
END --sp_UpdateSurveyMailSent



GO






--*****************************************************************

--6. Create PROCEDURE  [EC].[sp_Select_Questions_For_Survey] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Questions_For_Survey' 
)
   DROP  PROCEDURE [EC].[sp_Select_Questions_For_Survey] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: This procedure returns a list of Questions and their display order 
-- to be displayed in the UI.
-- TFS 549 - CSR Survey Setup - 09/24/2015
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Questions_For_Survey] 
@intSurveyID INT

AS
BEGIN
	DECLARE	
	@intSurveyTypeID INT,
	@nvcSQL nvarchar(max)
	
SET @intSurveyTypeID = (SELECT [SurveyTypeID] FROM [EC].[Survey_Response_Header]
WHERE [SurveyID] = @intSurveyID)


SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1 AND QA.[SurveyTypeID] = '''+CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  ORDER BY [DisplayOrder]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Questions_For_Survey






GO





--*****************************************************************

--7. Create PROCEDURE [EC].[sp_Select_Responses_For_Survey] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Responses_For_Survey' 
)
   DROP  PROCEDURE [EC].[sp_Select_Responses_For_Survey] 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: This procedure returns a list of all Active Responses and their Ids.
-- TFS 549 - CSR Survey Setup - 09/24/2015
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Responses_For_Survey] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)
	

SET @nvcSQL = 'SELECT [ResponseID],[Value]
			  FROM [EC].[Survey_DIM_Response]
			  WHERE [isActive]= 1'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Responses_For_Survey


GO

--*****************************************************************


--8. Create PROCEDURE [EC].[sp_Select_Responses_By_Question] 



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Responses_By_Question' 
)
   DROP  PROCEDURE [EC].[sp_Select_Responses_By_Question] 
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: This procedure returns a list of Questions Ids and all their possible Responses and their display order 
-- to be displayed in the UI.
-- TFS 549 - CSR Survey Setup - 09/24/2015
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Responses_By_Question] 


AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)
	


SET @nvcSQL = 'SELECT [QuestionID],[ResponseID],[ResponseValue]
			  FROM [EC].[Survey_DIM_QAnswer]
			  ORDER BY [QuestionID]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Responses_By_Question


GO





--*****************************************************************

--9. Create PROCEDURE [EC].[sp_Select_SurveyDetails_By_SurveyID]



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_SurveyDetails_By_SurveyID' 
)
   DROP  PROCEDURE [EC].[sp_Select_SurveyDetails_By_SurveyID] 
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: Given a survey ID this procedure returns the details of the Survey like
-- the Employee ID, eCL Form Name and whether or not a Hot Topic question is associated with this Survey.
-- TFS 549 - CSR Survey Setup - 09/24/2015
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_SurveyDetails_By_SurveyID] 
@intSurveyID INT

AS
BEGIN
	DECLARE	
	@intSurveyTypeID INT,
	@hasHotTopic BIT,
	@nvcSQL nvarchar(max)
	
SET @intSurveyTypeID = (SELECT [SurveyTypeID] FROM [EC].[Survey_Response_Header]
WHERE [SurveyID] = @intSurveyID)
	
SET @hasHotTopic = (SELECT [EC].[fn_isHotTopicFromSurveyTypeID] (@intSurveyTypeID))


SET @nvcSQL = 'SELECT SRH.[EmpID],SRH.[FormName],SRH.[Status],'+CONVERT(NVARCHAR,@hasHotTopic )+' hasHotTopic
			  FROM [EC].[Survey_Response_Header]SRH
			  WHERE [SurveyID] = '+CONVERT(NVARCHAR,@intSurveyID)+''
			 


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SurveyDetails_By_SurveyID

GO




--*****************************************************************


--10. Create PROCEDURE [EC].[sp_SelectSurvey4Reminder]


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectSurvey4Reminder' 
)
   DROP PROCEDURE [EC].[sp_SelectSurvey4Reminder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:		       Susmitha Palacherla
--	Create Date:	   2/25/2016
--	Description: This procedure queries db for surveys active after 48 hrs to send reminders.
--  Created  per TFS 2052 to setup reminders for CSR survey.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectSurvey4Reminder]
AS

BEGIN
DECLARE	
@intHrs int,
@nvcSQL nvarchar(max)


SET @intHrs = 48 
 
SET @nvcSQL = 'SELECT   SRH.SurveyID	SurveyID	
		,SRH.FormName	FormName
		,SRH.Status		Status
		,eh.Emp_Email	EmpEmail
		,eh.Emp_Name	EmpName
		,SRH.CreatedDate	CreatedDate
		,CONVERT(VARCHAR(10), DATEADD(dd,5,SRH.CreatedDate) , 101) ExpiryDate
		,SRH.EmailSent	EmailSent
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Survey_Response_Header] SRH WITH (NOLOCK)
ON eh.Emp_ID = SRH.EmpID
WHERE  SRH.[Status]= ''Open''
AND DATEDIFF(HH,SRH.[NotificationDate],GetDate()) > '''+CONVERT(VARCHAR,@intHrs)+''' 
Order By SRH.SurveyID'

EXEC (@nvcSQL)	
	    
END --sp_SelectSurvey4Reminder
GO

--*****************************************************************


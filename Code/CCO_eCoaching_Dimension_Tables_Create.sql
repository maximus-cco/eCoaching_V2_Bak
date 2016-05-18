/*
eCoaching_Dimension_Tables_Create(04).sql
Last Modified Date: 04/15/2016
Last Modified By: Susmitha Palacherla

Version 04: 
1. Modified to add Table #15 to support HR access control from table per TFS 2332
   04/15/2016

Version 03: 
1. Modified to add changes made to support Training module per SCR 14512 and any 
   missed changes for LSA and Quality Modules.
   04/15/2015

Version 02: 
1. Modified to add additional tables to support the Phase II Modular design.
   08/29/2014

Version 01: 
1. Initial Revision 
    04/03/2014

Summary

Tables
1. [EC].[DIM_Date]
2. [EC].[DIM_Site]
3. [EC].[DIM_Source]
4. [DIM_Status]
5. [DIM_Coaching_Reason]
6. [DIM_Sub_Coaching_Reason]
7. [EC].[DIM_Module]
8. [EC].[Employee_Selection]
9. [EC].[Module_Submission]
10. [EC].[DIM_Program]
11. [EC].[Coaching_Reason_Selection]
12. [EC].[CallID_Selection]
13. [EC].[Email_Notifications]
14. [EC].[DIM_Behavior]
15. [EC].[HR_Access]

Procedures
1. [EC].[sp_Dim_Date_Add_Date_Range]
2. [EC].[sp_Dim_Date_Add_Unknown_Row]

*/


 --Details

**************************************************************
--Tables
**************************************************************

--1. Create Table  [EC].[DIM_Date]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Date](
	[DateKey] [int] NOT NULL,
	[FullDate] [datetime] NULL,
	[DateName] [nvarchar](11) NULL,
	[DayOfWeek] [int] NULL,
	[DayNameOfWeek] [nvarchar](10) NULL,
	[DayOfMonth] [int] NULL,
	[WeekOfYear] [int] NULL,
	[MonthName] [nvarchar](10) NULL,
	[MonthOfYear] [int] NULL,
	[CalendarQuarter] [int] NULL,
	[CalendarYear] [int] NULL,
	[CalendarYearMonth] [nvarchar](7) NULL,
	[CalendarYYYYQQ] [nvarchar](7) NULL,
 CONSTRAINT [PK_Dim_Date] PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

****************************************************************************************

--2. Create Table [EC].[DIM_Site]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Site](
	[SiteID] [int] IDENTITY(1,1) NOT NULL,
	[City] [nvarchar](20) NOT NULL,
	[State] [nvarchar](20) NULL,
	[StateCity] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Site_ID] PRIMARY KEY CLUSTERED 
(
	[SiteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


****************************************************************************************

--3. Create Table [EC].[DIM_Source]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Source](
	[SourceID] [int] NOT NULL,
	[CoachingSource] [nvarchar](100) NOT NULL,
	[SubCoachingSource] [nvarchar](100) NOT NULL,
	[isActive] [bit] NULL,
	[CSR] [bit] NULL,
	[Supervisor] [bit] NULL,
	[Quality] [bit] NULL,
	[LSA] [bit] NULL,
	[Training] [bit] NULL,
 CONSTRAINT [Source_ID] PRIMARY KEY CLUSTERED 
(
	[SourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[DIM_Source] ADD  DEFAULT ((1)) FOR [isActive]
GO

ALTER TABLE [EC].[DIM_Source] ADD  DEFAULT ((0)) FOR [CSR]
GO

ALTER TABLE [EC].[DIM_Source] ADD  DEFAULT ((0)) FOR [Supervisor]
GO

ALTER TABLE [EC].[DIM_Source] ADD  DEFAULT ((0)) FOR [Quality]
GO

ALTER TABLE [EC].[DIM_Source] ADD  DEFAULT ((0)) FOR [LSA]
GO

ALTER TABLE [EC].[DIM_Source] ADD  DEFAULT ((0)) FOR [Training]
GO


****************************************************************************************

--4. Create Table  [DIM_Status]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](100) NOT NULL,
 CONSTRAINT [Status_ID] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




****************************************************************************************

--5. Create Table [DIM_Coaching_Reason]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Coaching_Reason](
	[CoachingReasonID] [int] IDENTITY(1,1) NOT NULL,
	[CoachingReason] [nvarchar](100) NOT NULL,
 CONSTRAINT [Coaching_Reason_ID] PRIMARY KEY CLUSTERED 
(
	[CoachingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




****************************************************************************************

--6. Create Table [DIM_Sub_Coaching_Reason]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Sub_Coaching_Reason](
	[SubCoachingReasonID] [int] IDENTITY(1,1) NOT NULL,
	[SubCoachingReason] [nvarchar](200) NOT NULL,
 CONSTRAINT [Sub_Coaching_Reason_ID] PRIMARY KEY CLUSTERED 
(
	[SubCoachingReasonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



****************************************************************************************

--7. Create Table [EC].[DIM_Module]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Module](
	[ModuleID] [int] IDENTITY(1,1) NOT NULL,
	[Module] [nvarchar](30) NOT NULL,
	[BySite] [bit] NULL,
	[isActive] [bit] NULL,
	[ByProgram] [bit] NULL,
	[ByBehavior] [bit] NULL,
 CONSTRAINT [Module_ID] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


****************************************************************************************


--8. Create Table [EC].[Employee_Selection]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Employee_Selection](
	[Job_Code] [nvarchar](50) NOT NULL,
	[Job_Code_Description] [nvarchar](50) NULL,
	[isCSR] [bit] NULL,
	[isSupervisor] [bit] NULL,
	[isQuality] [bit] NULL,
	[isLSA] [bit] NULL,
	[isTraining] [bit] NULL
) ON [PRIMARY]

GO

****************************************************************************************

--9. Create Table [EC].[Module_Submission]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Module_Submission](
	[Job_Code] [nvarchar](50) NOT NULL,
	[Job_Code_Description] [nvarchar](50) NULL,
	[CSR] [bit] NULL,
	[Supervisor] [bit] NULL,
	[Quality] [bit] NULL,
	[LSA] [bit] NULL,
	[Training] [bit] NULL
) ON [PRIMARY]

GO



****************************************************************************************

--10. Create Table [EC].[DIM_Program]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Program](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[Program] [nvarchar](30) NOT NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [ProgramID_ID] PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




****************************************************************************************

--11. Create Table [EC].[Coaching_Reason_Selection]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Coaching_Reason_Selection](
	[CoachingReasonID] [int] NOT NULL,
	[CoachingReason] [nvarchar](200) NOT NULL,
	[SubCoachingReasonID] [int] NOT NULL,
	[SubCoachingReason] [nvarchar](200) NOT NULL,
	[isActive] [bit] NULL,
	[Direct] [bit] NULL,
	[Indirect] [bit] NULL,
	[isOpportunity] [bit] NULL,
	[isReinforcement] [bit] NULL,
	[CSR] [bit] NULL,
	[Quality] [bit] NULL,
	[Supervisor] [bit] NULL,
	[splReason] [bit] NULL,
	[splReasonPrty] [int] NULL,
	[LSA] [bit] NULL,
	[Training] [bit] NULL
) ON [PRIMARY]

GO

****************************************************************************************

--12. Create Table [EC].[CallID_Selection]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[CallID_Selection](
	[CallIdType] [nvarchar](50) NOT NULL,
	[Format] [nvarchar](50) NULL,
	[CSR] [bit] NULL,
	[Supervisor] [bit] NULL,
	[Quality] [bit] NULL,
	[LSA] [bit] NULL,
	[Training] [bit] NULL
) ON [PRIMARY]

GO



****************************************************************************************

--13. Create Table [EC].[Email_Notifications]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Email_Notifications](
	[Module] [nvarchar](30) NULL,
	[Submission] [nvarchar](30) NULL,
	[Source] [nvarchar](30) NULL,
	[SubSource] [nvarchar](100) NULL,
	[isCSE] [bit] NULL,
	[Status] [nvarchar](100) NULL,
	[Recipient] [nvarchar](100) NULL,
	[Subject] [nvarchar](200) NULL,
	[Body] [nvarchar](2000) NULL,
	[isCCRecipient] [bit] NULL,
	[CCRecipient] [nvarchar](100) NULL
) ON [PRIMARY]

GO




****************************************************************************************

--14. Create Table [EC].[DIM_Behavior]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[DIM_Behavior](
	[BehaviorID] [int] IDENTITY(1,1) NOT NULL,
	[Behavior] [nvarchar](30) NOT NULL,
 CONSTRAINT [BehaviorID] PRIMARY KEY CLUSTERED 
(
	[BehaviorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




****************************************************************************************

--15. Create Table [EC].[HR_Access]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[HR_Access](
	[Job_Code] [nvarchar](50) NOT NULL,
	[Job_Code_Description] [nvarchar](50) NULL,
	[NewSubmissions] [bit] NULL,
	[MyDashboard] [bit] NULL,
	[MySubmissions] [bit] NULL,
	[HistDashboard] [bit] NULL,
	[DisplayWarnings] [bit] NULL
	
) ON [PRIMARY]

GO


****************************************************************************************



****************************************************************************************

--16. Create Table



****************************************************************************************



**************************************************************

--Procedures

**************************************************************

--1. Create SP  [EC].[sp_Dim_Date_Add_Date_Range]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dim_Date_Add_Date_Range' 
)
   DROP PROCEDURE [EC].[sp_Dim_Date_Add_Date_Range]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		          Susmitha Palacherla
-- CREATE date:         01/22/2014
-- Modified by:         
-- Last modified date:  
-- Description:	
--   Given a begin and end date, populate table 
-- AC.Dim_Date for the given date range.
--   This is adapted from code found on 01/03/2012 at the 
-- following URL:  
--   http://arcanecode.com/2009/11/18/populating-a-kimball-date-dimension/
--   The following comments are from the original post at that 
-- URL:
-- A few notes, this code does nothing to the existing table, no deletes
-- are triggered before hand. Because the DateKey is uniquely indexed,
-- it will simply produce errors if you attempt to insert duplicates.
-- You can however adjust the Begin/End dates and rerun to safely add
-- new dates to the table every year.
--
-- If the begin date is after the end date, no errors occur but nothing
-- happens as the while loop never executes.
-- =============================================
CREATE PROCEDURE [EC].[sp_Dim_Date_Add_Date_Range]
  @intBeginDate INT,
  @intEndDate INT
AS
BEGIN

  SET NOCOUNT ON -- turn off all the 1 row inserted messages

  -- Hold our dates
  DECLARE @BeginDate DATETIME
  DECLARE @EndDate DATETIME
  
  SET @BeginDate = EC.fn_dtYYYYMMDD_to_Datetime(@intBeginDate)
  SET @EndDate   = EC.fn_dtYYYYMMDD_to_Datetime(@intEndDate)

  -- Holds a flag so we can determine if the date is the last day of month
  DECLARE @LastDayOfMon CHAR(1)

  -- Number of months to add to the date to get the current Fiscal date
  DECLARE @FiscalYearMonthsOffset INT   

  -- These two counters are used in our loop.
  DECLARE @DateCounter DATETIME    --Current date in loop
  DECLARE @FiscalCounter DATETIME  --Fiscal Year Date in loop

  -- Set this to the number of months to add to the current date to get
  -- the beginning of the Fiscal year. For example, if the Fiscal year
  -- begins July 1, put a 6 there.
  -- Negative values are also allowed, thus if your 2010 Fiscal year
  -- begins in July of 2009, put a -6.
  SET @FiscalYearMonthsOffset = 6

  -- Start the counter at the begin date
  SET @DateCounter = @BeginDate

  WHILE @DateCounter <= @EndDate
  BEGIN
  -- Calculate the current Fiscal date as an offset of
  -- the current date in the loop
  SET @FiscalCounter = DATEADD(m, @FiscalYearMonthsOffset, @DateCounter)

  -- Set value for IsLastMonthDay
  IF MONTH(@DateCounter) = MONTH(DATEADD(d, 1, @DateCounter))
  SET @LastDayOfMon = 'N'
  ELSE
  SET @LastDayOfMon = 'Y'  

  -- add a record into the date dimension table for this date
  INSERT INTO EC.DIM_Date
    (
      [DateKey]
    , [FullDate]
    , [DateName]
    , [DayOfWeek]
    , [DayNameOfWeek]
    , [DayOfMonth]
    , [WeekOfYear]
    , [MonthName]
    , [MonthOfYear]
    , [CalendarQuarter]
    , [CalendarYear]
    , [CalendarYearMonth]
    , [CalendarYYYYQQ]
       )

  VALUES  (
    ( YEAR(@DateCounter) * 10000 ) + ( MONTH(@DateCounter) * 100 )
      + DAY(@DateCounter)  --DateKey
    , @DateCounter -- FullDate
    , CAST(DATEPART(mm, @DateCounter) AS NVARCHAR(2)) + '/'
      + CAST(DATEPART(dd, @DateCounter) AS NVARCHAR(2))  + '/'
      + CAST(YEAR(@DateCounter) AS NVARCHAR(4)) -- Modified DateName to match table
--  Below is [DateName] as downloaded:    
--    , CAST(YEAR(@DateCounter) AS CHAR(4)) + '/'
--      + RIGHT('00' + RTRIM(CAST(DATEPART(mm, @DateCounter) AS CHAR(2))), 2) + '/'
--      + RIGHT('00' + RTRIM(CAST(DATEPART(dd, @DateCounter) AS CHAR(2))), 2) --DateName
    , DATEPART(dw, @DateCounter) --DayOfWeek
    , DATENAME(dw, @DateCounter) --DayNameOfWeek
    , DATENAME(dd, @DateCounter) --DayOfMonth
    , DATENAME(ww, @DateCounter) --WeekOfYear
    , DATENAME(mm, @DateCounter) --MonthName
    , MONTH(@DateCounter) --MonthOfYear
    , DATENAME(qq, @DateCounter) --CalendarQuarter
    , YEAR(@DateCounter) --CalendarYear
    , CAST(YEAR(@DateCounter) AS CHAR(4)) + '-'
      + RIGHT('00' + RTRIM(CAST(DATEPART(mm, @DateCounter) AS CHAR(2))), 2) --CalendarYearMonth
    , CAST(YEAR(@DateCounter) AS CHAR(4)) + 'Q' + DATENAME(qq, @DateCounter) --CalendarYYYYQQ
    )

    -- Increment the date counter for next pass thru the loop
    SET @DateCounter = DATEADD(d, 1, @DateCounter)
  END
  
END  -- sp_Dim_Date_Add_Date_Range

GO

******************************************************************

--2. Create SP  [EC].[sp_Dim_Date_Add_Unknown_Row]

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dim_Date_Add_Unknown_Row' 
)
   DROP PROCEDURE [EC].[sp_Dim_Date_Add_Unknown_Row]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		         Susmitha Palacherla
-- ALTER date:        01/22/2014
-- Modified by:         
-- Last modified date:  
-- Description:	
--   Populate a row for an unknown value in dimension table
-- AC.Dim_Date.
--   This is adapted from AJ Adams' code file named 
-- "ACSchemaTableDDL.sql", dated 03/28/2011, and archived in 
-- Version Manager at "cms\BCC Performance Mgmt\Alternate 
-- Channels Scorecard\03_Load\SQL", VM revision # 1.0. 
-- =============================================
CREATE PROCEDURE [EC].[sp_Dim_Date_Add_Unknown_Row]
AS
BEGIN

  DELETE FROM EC.DIM_Date
  WHERE DateKey = -1

  INSERT INTO EC.Dim_Date (
    [DateKey],
	  [FullDate],
	  [DateName],
	  [DayOfWeek],
	  [DayNameOfWeek],
	  [DayOfMonth],
	  [WeekOfYear],
	  [MonthName],
	  [MonthOfYear],
	  [CalendarQuarter],
	  [CalendarYear],
	  [CalendarYearMonth],
	  [CalendarYYYYQQ]
	)
  VALUES(-1, '1900-01-01 00:00:00.000', '1/1/1900',  1, 'Monday', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

END  -- sp_Dim_Date_Add_Unknown_Row
GO

**********************************************************************************************************
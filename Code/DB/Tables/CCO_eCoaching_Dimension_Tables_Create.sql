/*
CCO_eCoaching_Dimension_Tables_Create(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************



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




**************************************************************

--Table creates

**************************************************************/


 

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

--****************************************************************************************

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


--****************************************************************************************

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


--****************************************************************************************

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




--****************************************************************************************

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




--****************************************************************************************

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



--****************************************************************************************

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


--****************************************************************************************


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

--****************************************************************************************

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



--****************************************************************************************

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




--****************************************************************************************

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

--****************************************************************************************

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



--****************************************************************************************

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




--****************************************************************************************

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




--****************************************************************************************

/*
File: eCoaching_EmployeeHierarchy_Load_Tables_Create(02).sql 
Last Modified Date: 3/22/2017
Last Modified By: Susmitha Palacherla

Version 02: Updated to support reused numeric part of Employee ID per TFS 6011 - 03/21/2017
Added table 8. [EC].[Employee_Ids_With_Prefixes]

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


**************************************************************

--Table list

**************************************************************


1. [EC].[Employee_Hierarchy_Stage] 
2. [EC].[Employee_Hierarchy]
3. [EC].[EmpID_To_SupID_Stage]
4. [EC].[EmployeeID_To_LanID]
5. [EC].[CSR_Hierarchy]
6. [EC].[HR_Hierarchy_Stage]
7. [EC].[HR_Access]-- Obsolete
8. [EC].[Employee_Ids_With_Prefixes]

**************************************************************

--Table creates

**************************************************************/



-- 1. Table [EC].[Employee_Hierarchy_Stage] 
-- =============================================
-- Author: Susmitha Palacherla
-- Create Date: 12/02/2013
-- Description: Used to stage Automated Employee File from Peoplesoft.
-- Last Modified Date:
-- Last Modified By: 

-- =============================================

/****** Object:  Table [EC].[Employee_Hierarchy_Stage]    Script Date: 03/12/2014 17:50:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Employee_Hierarchy_Stage](
	[Emp_ID] [nvarchar](10) NOT NULL,
	[Emp_Name] [nvarchar](70) NULL,
	[Emp_Email] [nvarchar](50) NULL,
	[Emp_Site] [nvarchar](50) NULL,
	[Emp_Job_Code] [nvarchar](20) NULL,
	[Emp_Job_Description] [nvarchar](50) NULL,
	[Emp_LanID] [nvarchar](30) NULL,
	[Emp_Program] [nvarchar](20) NULL,
	[Sup_Emp_ID] [nvarchar](10) NULL,
	[Sup_Name] [nvarchar](70) NULL,
	[Sup_Email] [nvarchar](50) NULL,
	[Sup_Job_Code] [nvarchar](50) NULL,
	[Sup_Job_Description] [nvarchar](50) NULL,
	[Sup_LanID] [nvarchar](30) NULL,
	[Mgr_Emp_ID] [nvarchar](10) NULL,
	[Mgr_Name] [nvarchar](70) NULL,
	[Mgr_Email] [nvarchar](50) NULL,
	[Mgr_Job_Code] [nvarchar](50) NULL,
	[Mgr_Job_Description] [nvarchar](50) NULL,
	[Mgr_LanID] [nvarchar](30) NULL,
	[Start_Date] [datetime] NULL,
	[Active] [nvarchar](1) NULL
) ON [PRIMARY]

GO




**********************************************************************
-- 2. Table  [EC].[Employee_Hierarchy]
-- =============================================
-- Author: Susmitha Palacherla
-- Create Date: 12/02/2013
-- Description: Used to store the Employee Information to be used by the Coaching application.
-- Last Modified Date:
-- Last Modified By: 

-- =============================================


/****** Object:  Table [EC].[Employee_Hierarchy]    Script Date: 03/12/2014 17:51:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Employee_Hierarchy](
	[Emp_ID] [nvarchar](10) NOT NULL,
	[Emp_Name] [nvarchar](70) NULL,
	[Emp_Email] [nvarchar](50) NULL,
	[Emp_LanID] [nvarchar](30) NULL,
	[Emp_Site] [nvarchar](50) NULL,
	[Emp_Job_Code] [nvarchar](50) NULL,
	[Emp_Job_Description] [nvarchar](50) NULL,
	[Emp_Program] [nvarchar](20) NULL,
	[Sup_ID] [nvarchar](10) NULL,
	[Sup_Name] [nvarchar](70) NULL,
	[Sup_Email] [nvarchar](50) NULL,
	[Sup_LanID] [nvarchar](20) NULL,
	[Sup_Job_Code] [nvarchar](50) NULL,
	[Sup_Job_Description] [nvarchar](50) NULL,
	[Mgr_ID] [nvarchar](10) NULL,
	[Mgr_Name] [nvarchar](70) NULL,
	[Mgr_Email] [nvarchar](50) NULL,
	[Mgr_LanID] [nvarchar](20) NULL,
	[Mgr_Job_Code] [nvarchar](50) NULL,
	[Mgr_Job_Description] [nvarchar](50) NULL,
	[Start_Date] [nvarchar](10) NULL,
	[End_Date] [nvarchar](10) NULL,
	[Active] [nvarchar](1) NULL,
 CONSTRAINT [PK_Emp_ID] PRIMARY KEY CLUSTERED 
(
	[Emp_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [EC].[Employee_Hierarchy] ADD  CONSTRAINT [DF__Employee___End_D__03317E3D]  DEFAULT ((99991231)) FOR [End_Date]
GO






/*********************************************************/

-- 3. Table  [EC].[EmpID_To_SupID_Stage]
-- =============================================
-- Author: Susmitha Palacherla
-- Create Date: 12/02/2013
-- Description: Used to stage the Employee Sup Information from WFM.
-- Last Modified Date:
-- Last Modified By: 

-- =============================================


/****** Object:  Table [EC].[EmpID_To_SupID_Stage]    Script Date: 03/12/2014 17:55:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[EmpID_To_SupID_Stage](
	[Emp_ID] [nvarchar](20) NOT NULL,
	[Emp_Name] [nvarchar](50) NULL,
	[Emp_Job_Code] [nvarchar](5) NULL,
	[Emp_Site_Code] [nvarchar](20) NULL,
	[Sup_ID] [nvarchar](20) NULL,
	[Emp_Program] [nvarchar](20) NULL
) ON [PRIMARY]

GO





/*********************************************************/

-- 4. Table  [EC].[EmployeeID_To_LanID]
-- =============================================
-- Author: Susmitha Palacherla
-- Create Date: 0202/2014
-- Description: Used to store Employee ID to lan ID links
-- Last Modified Date:
-- Last Modified By: 

-- =============================================


/****** Object:  Table [EC].[EmployeeID_To_LanID]    Script Date: 03/12/2014 17:56:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[EmployeeID_To_LanID](
	[EmpID] [nvarchar](20) NOT NULL,
	[StartDate] [int] NOT NULL,
	[EndDate] [int] NOT NULL,
	[LanID] [nvarchar](30) NOT NULL,
	[DatetimeInserted] [datetime] NOT NULL,
	[DatetimeLastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_EmployeeID_To_LanID] PRIMARY KEY CLUSTERED 
(
	[LanID] ASC,
	[StartDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/*********************************************************/

-- 5. Table  [EC].[CSR_Hierarchy]
-- =============================================
-- Author: Susmitha Palacherla
-- Create Date: 02/02/2014
-- Description: Used to store CSR-SUP-MGR Hierarchy
-- Last Modified Date:
-- Last Modified By: 

-- =============================================



/****** Object:  Table [EC].[CSR_Hierarchy]    Script Date: 03/12/2014 18:00:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[CSR_Hierarchy](
	[EmpID] [nvarchar](10) NOT NULL,
	[SupID] [nvarchar](10) NULL,
	[MgrID] [nvarchar](10) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_CSR_ID] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO





/*********************************************************/



--6. Create Table [EC].[HR_Hierarchy_Stage]

-- =============================================
-- Author: Susmitha Palacherla
-- Create Date: 04/12/2016
-- Description: Used to stage HR employee records
-- Last Modified Date:
-- Last Modified By: 

-- =============================================


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[HR_Hierarchy_Stage](
	[Emp_ID] [nvarchar](10) NOT NULL,
	[Emp_Name] [nvarchar](70) NULL,
	[Emp_Email] [nvarchar](50) NULL,
	[Emp_Site] [nvarchar](50) NULL,
	[Emp_Job_Code] [nvarchar](20) NULL,
	[Emp_Job_Description] [nvarchar](50) NULL,
	[Emp_LanID] [nvarchar](30) NULL,
	[Emp_Program] [nvarchar](20) NULL,
	[Sup_Emp_ID] [nvarchar](10) NULL,
	[Sup_Name] [nvarchar](70) NULL,
	[Sup_Email] [nvarchar](50) NULL,
	[Sup_Job_Code] [nvarchar](50) NULL,
	[Sup_Job_Description] [nvarchar](50) NULL,
	[Sup_LanID] [nvarchar](30) NULL,
	[Mgr_Emp_ID] [nvarchar](10) NULL,
	[Mgr_Name] [nvarchar](70) NULL,
	[Mgr_Email] [nvarchar](50) NULL,
	[Mgr_Job_Code] [nvarchar](50) NULL,
	[Mgr_Job_Description] [nvarchar](50) NULL,
	[Mgr_LanID] [nvarchar](30) NULL,
	[Start_Date] [datetime] NULL,
	[Active] [nvarchar](1) NULL
) ON [PRIMARY]

GO

--*****************************************************

--7. Create Table CREATE TABLE [EC].[HR_Access]-- Obsolete

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



--3. Insert records into TABLE [EC].[HR_Access]
INSERT INTO [EC].[HR_Access]
           ([Job_Code]
           ,[Job_Code_Description]
           ,[NewSubmissions]
           ,[MyDashboard]
           ,[MySubmissions]
           ,[HistDashboard]
           ,[DisplayWarnings])
     VALUES
           ('WHER12', 'Analyst, HR Compliance',0,0,0,1,1),
           ('WHER13', 'Sr Analyst, HR Compliance',0,0,0,1,1),
           ('WHER14', 'Princ Analyst, HR Compliance',0,0,0,1,1),
           ('WHHR02', 'Assistant, HR',0,0,0,1,1),
           ('WHHR12', 'Business Partner, HR',0,0,0,1,1),
           ('WHHR13', 'Sr Business Partner, HR',0,0,0,1,1),
           ('WHHR14', 'Principal Business Partner, HR',0,0,0,1,1),
           ('WHHR50', 'Manager, HR',0,0,0,1,1),
           ('WHHR60', 'Sr Manager, HR',0,0,0,1,1),
           ('WHHR70', 'Director, HR',0,0,0,1,1)
GO



--******************************************************


--8. Create table [EC].[Employee_Ids_With_Prefixes]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EC].[Employee_Ids_With_Prefixes](
	[Emp_ID] [nvarchar](10) NOT NULL,
	[Emp_Name] [nvarchar](70) NULL,
	[Emp_LanID] [nvarchar](30) NULL,
	[Start_Date] [datetime] NULL,
        [Inserted_Date][datetime] NULL
	) ON [PRIMARY]

GO

--******************************************************
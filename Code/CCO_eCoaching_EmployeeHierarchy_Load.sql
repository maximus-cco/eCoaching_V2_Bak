/*
File: eCoaching_PS_Employee_Hierarchy_Load.sql(01)
Date: 04/09/2014

Version 01, 04/09/2014
Initial Revision for new database


To install, run section of the file as necessary

List of Tables:
1. [EC].[Employee_Hierarchy_Stage] 
2. [EC].[Employee_Hierarchy]
3. [EC].[EmpID_To_SupID_Stage]
4. [EC].[EmployeeID_To_LanID]
5. [EC].[CSR_Hierarchy]
 

List of Procedures:
1. [EC].[sp_Update_Employee_Hierarchy_Stage] 
2. [EC].[sp_Populate_Employee_Hierarchy] 
3. [EC].[sp_Update_EmployeeID_To_LanID] 
4. [EC].[sp_Update_CSR_Hierarchy] 
5. [EC].[sp_InactivateCoachingLogsForTerms] 
 

*/


/*****************************************************/
/*  TABLES  */
/*****************************************************/

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
-- Create Date: 0202/2014
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


/*****************************************************/
/*  STORED PROCEDURES  */
/*****************************************************/

--1. PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Employee_Hierarchy_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage]
GO

/****** Object:  StoredProcedure [EC].[sp_Update_Employee_Hierarchy_Stage]    Script Date: 03/12/2014 18:09:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 12/2/2013
-- Description:	Performs the following actions.
-- Deletes records with missing Employee IDs
-- Removes Alpha characters from first 2 positions of Emp_ID, Sup_EMP_ID, Mgr_Emp_ID
-- Upadtes CSR Sup ID values with the SUP from WFM
-- Deletes records with Missing SUP IDs
-- Populates Supervisor attributes
-- Populates Manager attributes
-- Last update: 03/05/2014
-- Updated per redesign
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage] 
AS
BEGIN

BEGIN
DELETE FROM [EC].[Employee_Hierarchy_Stage]
WHERE EMP_ID = ' ' or  EMP_ID is NULL
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
-- Removes Alpha characters from first 2 positions of Emp_ID, Sup_EMP_ID, Mgr_Emp_ID

BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Emp_ID]=[EC].[RemoveAlphaCharacters]([Emp_ID]),
    [Sup_EMP_ID]=[EC].[RemoveAlphaCharacters]([Sup_EMP_ID]),
    [Mgr_Emp_ID]=[EC].[RemoveAlphaCharacters]([Mgr_Emp_ID]),
    [Emp_LanID]= REPLACE([Emp_LanID], '#',''),
    [Emp_Email]= REPLACE([Emp_Email], '#','')
OPTION (MAXDOP 1)
END  
    
    
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Set Sup_Emp_ID  and Program for CSrs from WFM
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Sup_Emp_ID] = [Sup_ID],
[Emp_Program]= 
CASE WHEN WFMSUP.[Emp_Program]like 'FFM%'
THEN 'Marketplace' ELSE 'Medicare' END
FROM [EC].[EmpID_To_SupID_Stage] WFMSUP JOIN [EC].[Employee_Hierarchy_Stage]INFO
ON LTRIM(WFMSUP.Emp_ID) = LTRIM(INFO.Emp_ID)
WHERE INFO.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Update Mgr_Emp_ID to be Supervisor's supervisor
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET Mgr_Emp_ID =[EC].[fn_strMgrEmpIDFromEmpID] (Emp_ID)
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- This will ensure that all users with missing sup id and mgr id will not be in the Employee_Hierarchy table.
BEGIN
DELETE FROM [EC].[Employee_Hierarchy_Stage]
WHERE [Sup_Emp_ID] = ' ' or  [Sup_Emp_ID] is NULL or [Mgr_Emp_ID] = ' ' or  [Mgr_Emp_ID] is NULL
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms



-- Populates Supervisor attributes
BEGIN 
UPDATE Emp
    SET [Sup_Name]= Sup.[Emp_Name],
    [Sup_Email]= Sup.[Emp_Email],
    [Sup_Job_Code]= Sup.[Emp_Job_Code],
    [Sup_Job_Description]= Sup.[Emp_Job_Description],
    [Sup_LanID]= Sup.[Emp_LanID]
   FROM [EC].[Employee_Hierarchy_Stage] as Emp Join [EC].[Employee_Hierarchy_Stage]as Sup
    ON LTRIM(Emp.[Sup_Emp_ID])= LTRIM(Sup.[EMP_ID])
OPTION (MAXDOP 1)
 END
 
 WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Populates Manager attributes
BEGIN    
 UPDATE Emp
    SET [Mgr_Name]= Mgr.[Emp_Name],
    [Mgr_Email]= Mgr.[Emp_Email],
    [Mgr_Job_Code]= Mgr.[Emp_Job_Code],
    [Mgr_Job_Description]= Mgr.[Emp_Job_Description],
    [Mgr_LanID]= Mgr.[Emp_LanID]
    FROM [EC].[Employee_Hierarchy_Stage] as Emp Join [EC].[Employee_Hierarchy_Stage]as Mgr
    ON LTRIM(Emp.[Mgr_Emp_ID])= LTRIM(Mgr.[EMP_ID])
OPTION (MAXDOP 1)
END

END  -- [EC].[sp_Update_Employee_Hierarchy_Stage]
GO








/*****************************************************/



--2. PROCEDURE  [EC].[sp_Populate_Employee_Hierarchy] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Populate_Employee_Hierarchy' 
)
   DROP PROCEDURE [EC].[sp_Populate_Employee_Hierarchy]
GO

/****** Object:  StoredProcedure [EC].[sp_Populate_Employee_Hierarchy]    Script Date: 12/03/2013 10:33:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 07/25/2013
-- Description:	Performs the following actions.
-- Updates existing records and Inserts New records from the Staging table.
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 02/28/2014
-- updated to add start date for redesign project
-- =============================================
CREATE PROCEDURE [EC].[sp_Populate_Employee_Hierarchy] 
AS
BEGIN


-- Assigns End_Date to Inactive Records
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active in ('T', 'D')
	AND H.END_DATE= '99991231'
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Assigns Open Ended End_Date for Rehire records
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = '99991231'
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active not in ('T', 'D')
	AND H.END_DATE  <> '99991231'
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
	
-- Updates Existing Records
BEGIN
	UPDATE [EC].[Employee_Hierarchy]
	   SET [Emp_Email] = S.Emp_Email
		  ,[Emp_LanID] = S.Emp_LanID
		  ,[Emp_Site] =  [EC].[fn_strSiteNameFromSiteLocation](S.Emp_Site)
		  ,[Emp_Job_Code] = S.Emp_Job_Code
		  ,[Emp_Job_Description] = S.Emp_Job_Description
		  ,[Emp_Program] = S.Emp_Program
		  ,[Sup_ID] = S.Sup_EMP_ID
		  ,[Sup_Name] = S.Sup_Name 
		  ,[Sup_Email] = S.Sup_Email
		  ,[Sup_LanID] = S.Sup_LanID
		  ,[Sup_Job_Code] = S.Sup_Job_Code 
		  ,[Sup_Job_Description] = S.Sup_Job_Description
		  ,[Mgr_ID] = S.Mgr_EMP_ID 
		  ,[Mgr_Name] = S.Mgr_Name
		  ,[Mgr_Email] = S.Mgr_Email
		  ,[Mgr_LanID] = S.Mgr_LanID
		  ,[Mgr_Job_Code] = S.Mgr_Job_Code 
		  ,[Mgr_Job_Description] = S.Mgr_Job_Description
		  ,[Start_Date] = CONVERT(nvarchar(8),S.[Start_Date],112)
		  ,[Active] = S.Active
	 FROM [EC].[Employee_Hierarchy]H JOIN [EC].[Employee_Hierarchy_Stage]S
	 ON H.[Emp_ID] = S.[EMP_ID]
	 WHERE H.[Emp_ID] is NOT NULL
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts New Records
BEGIN
	INSERT INTO [EC].[Employee_Hierarchy]
			  ([Emp_ID]
			   ,[Emp_Name]
			   ,[Emp_Email]
			   ,[Emp_LanID]
			   ,[Emp_Site]
			   ,[Emp_Job_Code]
			   ,[Emp_Job_Description]
			   ,[Emp_program]
			   ,[Sup_ID]
			   ,[Sup_Name]
			   ,[Sup_Email]
			   ,[Sup_LanID]
			   ,[Sup_Job_Code]
			   ,[Sup_Job_Description]
			   ,[Mgr_ID]
			   ,[Mgr_Name]
			   ,[Mgr_Email]
			   ,[Mgr_LanID]
			   ,[Mgr_Job_Code]
			   ,[Mgr_Job_Description]
			   ,[Start_Date]
			   ,[Active]
			  )
							 SELECT S.[Emp_ID]
							  ,S.[Emp_Name]
							  ,S.[Emp_Email]
							  ,S.[Emp_LanID]
							  ,[EC].[fn_strSiteNameFromSiteLocation](S.[Emp_Site])
							  ,S.[Emp_Job_Code]
							  ,S.[Emp_Job_Description]
							  ,S.[Emp_Program]
							  ,S.[Sup_Emp_ID]
							  ,S.[Sup_Name]
							  ,S.[Sup_Email]
							  ,S.[Sup_LanID]
							  ,S.[Sup_Job_Code]
							  ,S.[Sup_Job_Description]
							  ,S.[Mgr_Emp_ID]
							  ,S.[Mgr_Name]
							  ,S.[Mgr_Email]
							  ,S.[Mgr_LanID]
							  ,S.[Mgr_Job_Code]
							  ,S.[Mgr_Job_Description]
							  ,CONVERT(nvarchar(8),S.[Start_Date],112)
							  ,S.[Active]
						  FROM [EC].[Employee_Hierarchy_Stage]S Left outer Join [EC].[Employee_Hierarchy]H
						  ON S.Emp_ID = H.Emp_ID
						  WHERE (H.EMP_ID IS NULL and S.Emp_ID <> '')

OPTION (MAXDOP 1)
END


END --sp_Populate_Employee_Hierarchy
GO







/*****************************************************/


--3. PROCEDURE  [EC].[sp_Update_EmployeeID_To_LanID] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_EmployeeID_To_LanID' 
)
   DROP PROCEDURE [EC].[sp_Update_EmployeeID_To_LanID]
GO

/****** Object:  StoredProcedure [EC].[sp_Update_EmployeeID_To_LanID]    Script Date: 03/12/2014 18:14:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 02/03/2014
-- Description:	Performs the following actions.
-- Adds an End Date to an Employee ID to lan ID combination that is different from the existing record.
-- Inserts new records for the changed and new combinations.
-- Last Modified By: 
-- Last Modified Date: 

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_EmployeeID_To_LanID] 
AS
BEGIN

DECLARE @dtNow DATETIME
SET @dtNow = GETDATE()


-- Assigns End_Date to an Employee ID to Lan ID link that should no longer exist
BEGIN
  UPDATE [EC].[EmployeeID_To_LanID]
  SET [EndDate] = CONVERT(nvarchar(10),@dtNow,112),
  [DatetimeLastUpdated]= @dtNow
  FROM [EC].[Employee_Hierarchy]EH JOIN [EC].[EmployeeID_To_LanID]LAN
  ON EH.[Emp_LanID]= LAN.[LanID]
  AND EH.[Emp_ID]= LAN.[EmpID]
  WHERE LAN.[EndDate] = '99991231'
  AND EH.[Active]in ('T', 'D')
OPTION (MAXDOP 1)
END

PRINT N'STEP1'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

    
-- Inserts links for new Employee ID to lan ID pair

BEGIN
INSERT INTO [EC].[EmployeeID_To_LanID]
			   ([EmpID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LanID]
			   ,[DatetimeInserted]
			   ,[DatetimeLastUpdated])
			   
		(SELECT
			   Emp_ID,
			   Start_Date,
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH LEFT OUTER JOIN [EC].[EmployeeID_To_LanID]LAN
			   ON EH.[Emp_LanID]= LAN.[LanID]
			   AND EH.[Emp_ID]= LAN.[EmpID]
			   WHERE LAN.[EmpID]IS NULL AND LAN.[LanID]IS NULL
			   AND EH.[Emp_LanID] IS NOT NULL
			   AND EH.[ACTIVE] NOT IN ('T','D'))
OPTION (MAXDOP 1)
END

PRINT N'STEP2'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts a new link for changed Employee ID to lan ID pair

BEGIN
--DECLARE @dtNow DATETIME
--SET @dtNow = GETDATE()
INSERT INTO [EC].[EmployeeID_To_LanID]
			   ([EmpID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LanID]
			   ,[DatetimeInserted]
			   ,[DatetimeLastUpdated])
			   
		(SELECT
			   Emp_ID,
			   --CONVERT(nvarchar(10),@dtNow,112),
			   Start_Date,
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH LEFT OUTER JOIN [EC].[EmployeeID_To_LanID]LAN
			   ON EH.[Emp_LanID]= LAN.[LanID]
			   AND EH.[Emp_ID]= LAN.[EmpID]
			   WHERE LAN.[EmpID]IS NULL 
			   AND EH.[Emp_LanID] IS NOT NULL
			   AND EH.[ACTIVE] NOT IN ('T','D'))
			OPTION (MAXDOP 1)
END
	
	
PRINT N'STEP3'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Inserts a new link for a rehired Employee using the same lanid

BEGIN
--DECLARE @dtNow DATETIME
--SET @dtNow = GETDATE()
INSERT INTO [EC].[EmployeeID_To_LanID]
			   ([EmpID]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LanID]
			   ,[DatetimeInserted]
			   ,[DatetimeLastUpdated])
			   
		(SELECT
			   Emp_ID,
			   --CONVERT(nvarchar(10),@dtNow,112),
			   Start_Date,
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH JOIN [EC].[EmployeeID_To_LanID]LAN
			   ON EH.[Emp_LanID]= LAN.[LanID]
			   AND EH.[Emp_ID]= LAN.[EmpID]
			   WHERE LAN.[EndDate]<>99991231
			   AND EH.[Emp_LanID] IS NOT NULL
			   AND EH.[ACTIVE] NOT IN ('T','D'))
			OPTION (MAXDOP 1)
END
	
	
PRINT N'STEP4'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


BEGIN
	
	;With Overlaps (OverlaplanId, BaselanId) 
As 
( 
	Select Overlap.lanId, Base.lanId 
	From [EC].[EmployeeID_To_LanID] As Base 
	Inner Join [EC].[EmployeeID_To_LanID] As Overlap On Overlap.LanID = Base.lanid
	Where (Overlap.StartDate > Base.StartDate) 
	  And (Overlap.StartDate < Base.EndDate) 
) 
--select lan.[EmpID]
--      ,lan.[StartDate]
--      ,lan.[EndDate]
--      ,lan.[LanID]
--       from [eCoachingDev].[EC].[EmployeeID_To_LanID]lan join Overlaps o
--on lan.LanID = o.BaselanId


--This below sql will help us update the overlap rows to assign startdate of next row -1 to previous row
Update Base
set EndDate = [EC].[fn_intDatetime_to_YYYYMMDD](DATEADD(DAY,-1,CONVERT(datetime,convert(char(8),Overlap.StartDate))))
	From [EC].[EmployeeID_To_LanID] As Base 
	Inner Join [EC].[EmployeeID_To_LanID] As Overlap On Overlap.LanID = Base.lanid
	Where (Overlap.StartDate > Base.StartDate) 
	  And (Overlap.StartDate < Base.EndDate) 
END	
PRINT N'STEP5'

END --sp_Update_EmployeeID_To_LanID
GO



/*****************************************************/




--4. PROCEDURE  [EC].[sp_Update_CSR_Hierarchy] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_CSR_Hierarchy' 
)
   DROP PROCEDURE [EC].[sp_Update_CSR_Hierarchy]
GO

/****** Object:  StoredProcedure [EC].[sp_Update_CSR_Hierarchy]    Script Date: 03/12/2014 18:17:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 01/20/2014
-- Description:	Performs the following actions.
-- Adds an End Date to an Employee record with a Hierarchy change.
-- Inserts a new row for the Upadted Hierarchy.
-- Last Modified By: 
-- Last Modified Date: 

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_CSR_Hierarchy] 
AS
BEGIN


-- Assigns End_Date to CSR records with changed Hierarchy.
BEGIN
UPDATE [EC].[CSR_Hierarchy]
SET [EndDate] = DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0)
FROM [EC].[Employee_Hierarchy]EH JOIN [EC].[CSR_Hierarchy]CH
ON EH.[Emp_ID]= CH.[EmpID]
WHERE (EH.[Sup_ID]<> CH.[SupID]OR EH.[Mgr_ID]<> CH.[MgrID])
AND (EH.[Sup_ID]IS NOT NULL AND EH.[Mgr_ID] IS NOT NULL)
AND CH.[EndDate] = '9999-12-31 00:00:00.000'
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inserts new rows for CSRs with changed Hierarchy.
BEGIN
;
With LatestRecord as
(Select [EmpID], max([EndDate])as LEnd_Date from [EC].[CSR_Hierarchy]
 GROUP BY [EmpID])
INSERT INTO [EC].[CSR_Hierarchy]
           ([EmpID]
           ,[SupID]
           ,[MgrID]
           ,[StartDate]
           ,[EndDate]
            )
SELECT distinct EH.[Emp_ID]
,EH.[Sup_ID]
,EH.[Mgr_ID]
, DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0)
,'9999-12-31 00:00:00.000'
FROM [EC].[Employee_Hierarchy]EH  JOIN
(SELECT C.* FROM [EC].[CSR_Hierarchy] C JOIN  LatestRecord L
ON C. EMPID =L.EMPID WHERE L.LEnd_Date <> '9999-12-31 00:00:00.000') AS CH
on EH.Emp_ID = CH.EmpID
where EH.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
AND (EH.[Sup_ID]<> CH.[SupID]OR EH.[Mgr_ID]<> CH.[MgrID])
AND (EH.[Sup_ID]IS NOT NULL AND EH.[Mgr_ID] IS NOT NULL)
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts New CSR records 

BEGIN
INSERT INTO [EC].[CSR_Hierarchy]
           ([EmpID]
           ,[SupID]
           ,[MgrID]
           ,[StartDate]
           ,[EndDate] )
SELECT EH.[Emp_ID]
,EH.[Sup_ID]
,EH.[Mgr_ID]
, DATEADD(dd, DATEDIFF(dd, 0, GETDATE()), 0)
,'9999-12-31 00:00:00.000'
FROM [EC].[Employee_Hierarchy]EH LEFT OUTER JOIN [EC].[CSR_Hierarchy]CH
ON EH.[Emp_ID]= CH.[EmpID]
WHERE CH.[EmpID]IS NULL
AND EH.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


END --sp_Update_CSR_Hierarchy

GO


/*****************************************************/

--5. PROCEDURE  [EC].[sp_InactivateCoachingLogsForTerms] 

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InactivateCoachingLogsForTerms' 
)
   DROP PROCEDURE [EC].[sp_InactivateCoachingLogsForTerms]
GO

/****** Object:  StoredProcedure [EC].[sp_InactivateCoachingLogsForTerms]    Script Date: 03/12/2014 18:17:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    04/09/2014
-- Description:	Inactivate Coaching logs for Termed Employees
-- Last Modified Date: 
-- Last Updated By: 

-- =============================================
CREATE PROCEDURE [EC].[sp_InactivateCoachingLogsForTerms] 
AS
BEGIN

-- Inactivate Coaching logs for Termed Employees

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[Employee_Hierarchy]H
ON C.[CSR] = H.[Emp_LanID]
AND C.[CSRID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND C.[StatusID] not in (1,2)
OPTION (MAXDOP 1)
END

END  -- [EC].[sp_InactivateCoachingLogsForTerms]
GO




/*****************************************************/






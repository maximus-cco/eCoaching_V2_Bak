/*
File: eCoaching_PS_Employee_Hierarchy_Load.sql (10)
Date: 09/30/2015


Version 10, 09/30/2015
Updated sp [EC].[sp_InactivateCoachingLogsForTerms] (#5) to
add Inactivations for Survey records per TFS 549.

Version 09, 09/03/2015
Updated sp [EC].[sp_Update_Employee_Hierarchy_Stage (#1) to
trim leading and trailing spaces in Employee and Supervisor Ids from eWFM and PeopleSoft before 
using in Employee Hierarchy table per TFS 641.

Version 08, 01/26/15
Additional updates to sp (#5) to inactivate ecls for employees in EA status and those not arriving in ewfm feed  per SCR 14072.

Version 07, 01/16/15
Updates to sp (#5) to inactivate ecls for employees in EA status and those not arriving in ewfm feed  per SCR 14072.

Version 06, 11/11/2014
Additional Updates to sp (#2) to handle apostrophes in name and email addresses for sups and mgrs per SCR 13759.

Version 05, 11/6/2014
Updated sp (#2) to handle apostrophes in name and email addresses per SCR 13759.

Version 04, 10/27/2014
Updated  procedure (#5) sp_InactivateCoachingLogsForTerms to 
Add statement to Inactivate Expired Warning logs per SCR 13624.

Version 03, 08/29/2014
Updated impacted procedures to support the Phase II Modular design.


Version 02, 07/28/2014
Updated the follwing code modules per SCR 12983 to change and or fix the update logic.

1. PROCEDURE [EC].[sp_Populate_Employee_Hierarchy] 
2. PROCEDURE [EC].[sp_Update_EmployeeID_To_LanID] 

 

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
-- Removes leading and Trailing spaces from emp and Sup Ids from eWFM and Employee Hierarchy staging tables.
-- Updates CSR Sup ID values with the SUP from WFM
-- Deletes records with Missing SUP IDs
-- Populates Supervisor attributes
-- Populates Manager attributes
-- Last update: 09/03/2015
-- Updated per TFS 641 to trim leading and trailing spaces in Employee and Supervisor Ids 
-- from eWFM and PeopleSoft before using in Employee Hierarchy table.
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Employee_Hierarchy_Stage] 
AS
BEGIN

-- Delete records where Employee ID is a missing or a blank.
BEGIN
DELETE FROM [EC].[Employee_Hierarchy_Stage]
WHERE EMP_ID = ' ' or  EMP_ID is NULL
OPTION (MAXDOP 1)
END
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms


-- Removes Alpha characters from first 2 positions of Emp_ID, Sup_EMP_ID, Mgr_Emp_ID
-- and removes all leading and trailing spaces.
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Emp_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Emp_ID])),' ','')),
    [Sup_EMP_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Sup_EMP_ID])),' ','')),
    [Mgr_Emp_ID]= [EC].[RemoveAlphaCharacters](REPLACE(LTRIM(RTRIM([Mgr_Emp_ID])),' ','')),
    [Emp_LanID]= REPLACE([Emp_LanID], '#',''),
    [Emp_Email]= REPLACE([Emp_Email], '#','')
OPTION (MAXDOP 1)
END  
 WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms



-- Remove leading and trailing spaces from Emp and Sup Ids from EWFM.
BEGIN
UPDATE [EC].[EmpID_To_SupID_Stage]
SET [Emp_ID]= REPLACE(LTRIM(RTRIM([Emp_ID])),' ',''),
   [Sup_ID]= REPLACE(LTRIM(RTRIM([Sup_ID])),' ','')
END
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms


    
-- Set Sup_Emp_ID  and Program for CSRs from WFM
BEGIN
UPDATE [EC].[Employee_Hierarchy_Stage]
SET [Sup_Emp_ID] = [Sup_ID],
[Emp_Program]= 
CASE WHEN WFMSUP.[Emp_Program]like 'FFM%'
THEN 'Marketplace' ELSE 'Medicare' END
FROM [EC].[EmpID_To_SupID_Stage] WFMSUP JOIN [EC].[Employee_Hierarchy_Stage]INFO
ON WFMSUP.Emp_ID = INFO.Emp_ID
WHERE INFO.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
OPTION (MAXDOP 1)
END
WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms


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
    ON Emp.[Sup_Emp_ID]= Sup.[EMP_ID]
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
    ON Emp.[Mgr_Emp_ID]= Mgr.[EMP_ID]
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
-- Last Modified Date:11/6/2014
-- updated per SCR 13759 to handle apostrophes in names and email addresses.
-- =============================================
ALTER PROCEDURE [EC].[sp_Populate_Employee_Hierarchy] 
AS
BEGIN


 --Assigns End_Date to Inactive Records with status change in feed
 
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active in ('T', 'D')
	AND H.END_DATE= '99991231'
OPTION (MAXDOP 1)
END


-- Assigns End_Date to Inactive Records that stop arriving in feed
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	,[Active] = 'T'
	 WHERE END_DATE = '99991231' AND Active = 'A'
	 AND Emp_ID <> '999999'
	 AND EMP_ID NOT IN
	(SELECT Emp_ID FROM [EC].[Employee_Hierarchy_Stage])

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Assigns Open Ended End_Date for Rehire records
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [Active]= S.Active
	,[Start_Date] = S.Start_Date
	,[END_DATE] = '99991231'
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
	   SET [Emp_Name] = Replace(S.[Emp_Name],'''', '')
	      ,[Emp_Email] = Replace(S.[Emp_Email],'''','''''')
		  ,[Emp_LanID] = S.Emp_LanID
		  ,[Emp_Site] =  [EC].[fn_strSiteNameFromSiteLocation](S.Emp_Site)
		  ,[Emp_Job_Code] = S.Emp_Job_Code
		  ,[Emp_Job_Description] = S.Emp_Job_Description
		  ,[Emp_Program] = S.Emp_Program
		  ,[Sup_ID] = S.Sup_EMP_ID
		  ,[Sup_Name] = Replace(S.[Sup_Name],'''', '')
		  ,[Sup_Email] = Replace(S.[Sup_Email],'''','''''')
		  ,[Sup_LanID] = S.Sup_LanID
		  ,[Sup_Job_Code] = S.Sup_Job_Code 
		  ,[Sup_Job_Description] = S.Sup_Job_Description
		  ,[Mgr_ID] = S.Mgr_EMP_ID 
		  ,[Mgr_Name] = Replace(S.[Mgr_Name],'''', '')
		  ,[Mgr_Email] = Replace(S.[Mgr_Email],'''','''''')
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
						      ,Replace(S.[Emp_Name],'''', '')
                              ,Replace(S.[Emp_Email],'''','''''')
							  ,S.[Emp_LanID]
							  ,[EC].[fn_strSiteNameFromSiteLocation](S.[Emp_Site])
							  ,S.[Emp_Job_Code]
							  ,S.[Emp_Job_Description]
							  ,S.[Emp_Program]
							  ,S.[Sup_Emp_ID]
							  ,Replace(S.[Sup_Name],'''', '')
							  ,Replace(S.[Sup_Email],'''','''''')
							  ,S.[Sup_LanID]
							  ,S.[Sup_Job_Code]
							  ,S.[Sup_Job_Description]
							  ,S.[Mgr_Emp_ID]
							  ,Replace(S.[Mgr_Name],'''', '')
							  ,Replace(S.[Mgr_Email],'''','''''')
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
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 07/25/2014
-- Modified to fix logic per SCR 12983.

-- =============================================
CREATE PROCEDURE [EC].[sp_Update_EmployeeID_To_LanID] 
AS
BEGIN

DECLARE @dtNow DATETIME
SET @dtNow = GETDATE()

  
  
  -- Assigns End_Date to an Employee ID to Lan ID link for Termed Users
  

BEGIN
  ;WITH OpenRecords AS
  (SELECT * FROM [EC].[EmployeeID_To_LanID]LAN
   WHERE EndDate = 99991231)
  
	  UPDATE LAN
	  SET [EndDate] = [End_Date],
	  [DatetimeLastUpdated]= @dtNow
	  FROM [EC].[Employee_Hierarchy]EH 
	  JOIN OpenRecords LAN
	  ON EH.[Emp_ID]= LAN.[EmpID]
	  WHERE LAN.[EndDate] = '99991231'
	  AND EH.[Active]in ('T', 'D')
OPTION (MAXDOP 1)
END


PRINT N'STEP1'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Inserts links for new Employee IDs 

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
			   FROM [EC].[Employee_Hierarchy]EH WHERE EH.[ACTIVE] NOT IN ('T','D')
			   AND NOT EXISTS
			   (SELECT EMPID FROM [EC].[EmployeeID_To_LanID]LAN
			   WHERE EH.[Emp_ID]= LAN.[EmpID]))
			
OPTION (MAXDOP 1)
END


PRINT N'STEP2'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms  

  
-- Inserts links for new Employee IDs to Lan ID Pair

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
			   CONVERT(nvarchar(10),@dtNow,112),
			   End_Date,
			   Emp_LanID,
			   @dtNow ,
			   @dtNow 
			   FROM [EC].[Employee_Hierarchy]EH LEFT OUTER JOIN [EC].[EmployeeID_To_LanID]LAN
			   ON EH.[Emp_LanID]= LAN.[LanID]
			   AND EH.[Emp_ID]= LAN.[EmpID]
			   WHERE LAN.[LanID]IS NULL
			   AND EH.[Emp_LanID] IS NOT NULL
			   AND EH.[ACTIVE] NOT IN ('T','D'))
OPTION (MAXDOP 1)
END

PRINT N'STEP3'
WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

    

-- Inserts a new link for a rehired Employee using the same lanid

BEGIN
 ;WITH OpenRecords AS
    (SELECT * FROM [EC].[EmployeeID_To_LanID]LAN
     WHERE EndDate = 99991231)
   
   
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
			   FROM [EC].[Employee_Hierarchy]EH WHERE EH.[ACTIVE] NOT IN ('T','D', 'L', 'P')
			   AND EMP_ID NOT IN
			   (SELECT EMP_ID FROM OpenRecords LAN
			   WHERE EH.[Emp_ID]= LAN.[EmpID]))


OPTION (MAXDOP 1)
END

PRINT N'STEP4'
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

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 01/20/2014
-- Description:	Performs the following actions.
-- Adds an End Date to an Employee record with a Hierarchy change.
-- Inserts a new row for the Updated Hierarchy.
-- Last Modified Date: 08/21/2014
-- Last Modified By: Susmitha Palacherla
-- Modified to remove the condition to insert and update records for CSRS only. 
-- This will support the Modul approcah being implemented to support non CSR ecls.

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
--where EH.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
WHERE (EH.[Sup_ID]<> CH.[SupID]OR EH.[Mgr_ID]<> CH.[MgrID])
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
--AND EH.[Emp_Job_Code]in ('WACS01','WACS02','WACS03')
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

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    04/09/2014
-- Description:	Inactivate Coaching logs for Termed Employees.
-- Last Modified: 09/04/2015
-- Last Modified By: Susmitha Palacherla
-- Modified to Inactivate Surveys for termed Employees and Expired Surveys.
-- and Expired Surveys per TFS 549.
-- Surveys expire 5 days from Creation date.
-- =============================================
CREATE PROCEDURE [EC].[sp_InactivateCoachingLogsForTerms] 
AS
BEGIN

 DECLARE @EWFMSiteCount INT
 
 -- Inactivate Warnings logs for Termed Employees

BEGIN
UPDATE [EC].[Warning_Log]
SET [StatusID] = 2
FROM [EC].[Warning_Log] W JOIN [EC].[Employee_Hierarchy]H
ON W.[EmpLanID] = H.[Emp_LanID]
AND W.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND W.[StatusID] <> 2
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inactivate Surveys for Termed Employees

BEGIN
UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'Employee Not Active'
FROM [EC].[Survey_Response_Header]SH  JOIN [EC].[Employee_Hierarchy]H
ON SH.[EmpLanID] = H.[Emp_LanID]
AND SH.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND SH.[Status] <> 'Inactive'
AND [InactivationReason] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


 -- Inactivate Expired Survey records (5 days after creation date)

BEGIN
UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'Survey Expired'
WHERE DATEDIFF(DAY, [CreatedDate],  GETDATE())>= 5
AND [Status] <> 'Inactive'
AND [InactivationReason] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms



-- Inactivate Coaching logs for Termed Employees

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[Employee_Hierarchy]H
ON C.[EmpLanID] = H.[Emp_LanID]
AND C.[EmpID] = H.[Emp_ID]
WHERE CAST(H.[End_Date] AS DATETIME)< GetDate()
AND H.[Active] in ('T','D')
AND H.[End_Date]<> '99991231'
AND C.[StatusID] not in (1,2)
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inactivate Coaching logs for Employees on Extended Absence

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C JOIN [EC].[EmpID_To_SupID_Stage]H
ON C.[EmpLanID] = H.[Emp_LanID]
AND C.[EmpID] = LTRIM(H.[Emp_ID])
WHERE H.[Emp_Status]= 'EA'
AND H.[Emp_LanID] IS NOT NULL
AND C.[StatusID] not in (1,2)
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Inactivate Coaching logs for CSRs and Sup Module eCLs for Employees not arriving in eWFM feed.

SET @EWFMSiteCount = (SELECT count(DISTINCT Emp_Site_Code) FROM [EC].[EmpID_To_SupID_Stage])
IF @EWFMSiteCount >= 14
BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Coaching_Log] C LEFT OUTER JOIN [EC].[EmpID_To_SupID_Stage] S
ON C.EMPID = LTRIM(S.EMP_ID)
WHERE C.[StatusID] not in (1,2)
AND C.[ModuleID]  in (1,2)
AND S.EMP_ID IS NULL
OPTION (MAXDOP 1)
END


END  -- [EC].[sp_InactivateCoachingLogsForTerms]




GO









/*****************************************************/






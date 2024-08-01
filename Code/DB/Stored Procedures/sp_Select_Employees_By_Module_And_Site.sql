SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/15/2018
--	Description: *	This procedure takes a ModuleID and SiteID and returns Employees.
--  Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/30/2018 
--  Fix ambiguous column reference during employee selection in submission page. TFS 21223 - 5/11/2021
--  Updated to Support Team Submission. TFS 23273 - 06/07/2022
--  Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--  Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER  PROCEDURE [EC].[sp_Select_Employees_By_Module_And_Site] 
@intModuleIDin INT, @intSiteIDin INT = -1, @nvcUserEmpIDin  nvarchar(10)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcModulein nvarchar(30),
@nvcEmpJobCode nvarchar(20),
@nvcisSub nvarchar(1),
@NewLineChar nvarchar(2),
@dtmDate datetime,
@conditionalsite nvarchar(100),
@conditionalsub nvarchar(100),
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(1000),
@nvcSQL02 nvarchar(1000),
@nvcSQL03 nvarchar(1000),
@nvcSQL04 nvarchar(1000);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

SET @NewLineChar = CHAR(13) + CHAR(10);
SET @nvcModulein = (SELECT Replace([Module],' ','') FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin);
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy WHERE Emp_ID = @nvcUserEmpIDin);

SET @conditionalsite = '';

/*
-1 All Sites
-3 Sub Sites
-4 Maximus Sites
*/

IF @intSiteIDin NOT IN (-1,-3,-4)
BEGIN
	SET @conditionalsite = @conditionalsite + ' AND [s].[SiteID] =   '''+CONVERT(NVARCHAR,@intSiteIDin)+'''';
END

IF @intSiteIDin = -3

BEGIN
	SET @conditionalsite = @conditionalsite + ' AND [s].[isSub] = 1';
END

IF @intSiteIDin = -4

BEGIN
	SET @conditionalsite = @conditionalsite + ' AND [s].[isSub] = 0' ;
END


IF @intModuleIDin  IN (3,4) 
SET @conditionalsub = 'AND EH.isSub = ''N'''
ELSE
SET @conditionalsub = '';

-- General Selection of employees based on Job codes flagged in Employee Selection table.

SET @nvcSQL01 = 'SELECT EH.Emp_ID
				,VEH.[Emp_Name] 
				,VEH.[Sup_ID]
				,VEH.[Sup_Name]
				,VEH.[Mgr_ID]
				,VEH.[Mgr_Name]
 FROM [EC].[View_Employee_Hierarchy] VEH  WITH (NOLOCK)  JOIN  [EC].[Employee_Hierarchy]EH WITH (NOLOCK) 
 ON VEH.[Emp_ID]= EH.[Emp_ID] JOIN [EC].[Employee_Selection]
 ON EH.[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code] JOIN [EC].[DIM_Site]S
 ON S.City = EH.Emp_Site
WHERE [EC].[Employee_Selection].[is'+ @nvcModulein + '] = 1 ' + @NewLineChar +
 @conditionalsite+ ' ' + 
 @conditionalsub + ' ' + '
AND VEH.[Emp_ID] <> '''+ @nvcUserEmpIDin + ''''


-- Conditional Filter to restrtict Training staff with specific job codes to submit only for certain job codes.

SET @nvcSQL02 = ' AND VEH.[Emp_Job_Code] NOT IN (''WTTR12'', ''WTTR13'', ''WTID13'')' 


-- Generic  Filter for all scenarios.

SET @nvcSQL03 = ' AND [End_Date] = ''99991231''
AND VEH.[Emp_LanID]is not NULL and VEH.[Sup_LanID] is not NULL and VEH.[Mgr_LanID]is not NULL
ORDER BY VEH.[Emp_Name] ASC'


IF @nvcEmpJobCode IN ('WTTR12', 'WTTR13', 'WTID13') 

SET @nvcSQL = @nvcSQL01 + @nvcSQL02 + @nvcSQL03 

ELSE
SET @nvcSQL = @nvcSQL01 + @nvcSQL03

--Print @nvcSQL

EXEC (@nvcSQL)	

CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_Select_Employees_By_Module_And_Site

GO



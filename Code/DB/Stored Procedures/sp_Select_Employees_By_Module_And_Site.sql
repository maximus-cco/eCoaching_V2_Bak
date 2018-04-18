/*
sp_Select_Employees_By_Module_And_Site(01).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Employees_By_Module_And_Site' 
)
   DROP PROCEDURE [EC].[sp_Select_Employees_By_Module_And_Site]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/15/2018
--	Description: *	This procedure takes a ModuleID and SiteID and returns Employees.
--  Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Employees_By_Module_And_Site] 
@intModuleIDin INT, @intSiteIDin INT = -1


AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcModulein nvarchar(30),
@nvcSitein nvarchar(30),
@dtmDate datetime,
@nvcSQL nvarchar(max),
@nvcSQL01 nvarchar(1000),
@nvcSQL02 nvarchar(1000),
@nvcSQL03 nvarchar(1000),
@nvcSQL04 nvarchar(1000)

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]



SET @nvcModulein = (SELECT Module FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)
--SET @nvcSitein = (SELECT City FROM [EC].[DIM_Site] WHERE [SiteID] = @intSiteIDin)

-- General Selection of employees based on Job codes flagged in Employee Selection table.

SET @nvcSQL = 'SELECT EH.Emp_ID
				,VEH.[Emp_Name] 
 FROM [EC].[View_Employee_Hierarchy] VEH  WITH (NOLOCK)  JOIN  [EC].[Employee_Hierarchy]EH WITH (NOLOCK) 
 ON VEH.[Emp_ID]= EH.[Emp_ID] JOIN [EC].[Employee_Selection]
 ON EH.[Emp_Job_Code]= [EC].[Employee_Selection].[Job_Code] JOIN [EC].[DIM_Site]S
 ON S.City = EH.Emp_Site
WHERE [EC].[Employee_Selection].[is'+ @nvcModulein + '] = 1
AND  (S.SiteID =('''+CONVERT(NVARCHAR,@intSiteIDin)+''') or '''+ CONVERT(NVARCHAR,@intSiteIDin) + ''' = -1)
AND [Emp_Job_Code] NOT IN (''WTTR12'', ''WTTR13'', ''WTID13'') 
AND [End_Date] = ''99991231''
AND VEH.[Emp_LanID]is not NULL and VEH.[Sup_LanID] is not NULL and VEH.[Mgr_LanID]is not NULL
ORDER BY VEH.[Emp_Name] ASC'

--Print @nvcSQL

EXEC (@nvcSQL)	

CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_Select_Employees_By_Module

GO




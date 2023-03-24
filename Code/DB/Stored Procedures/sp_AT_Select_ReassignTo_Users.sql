SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/28/2016
--	Description: *	This procedure selects the list of users that an ECL
-- can be reassigned to. users at the same level and site as the original owner. 
-- Last Updated By: 
-- Initial revision per TFS 1709 - 4/28/2016
-- Updated to add Employees in Leave status for Reassignment and 
-- added Active check for reassigned to supervisors and managers per TFS 3441 - 09/07/2016
--  Modified to support Encryption of sensitive data - Open key and use employee View for emp attributes. TFS 7856 - 12/01/2017
-- Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
-- Modified during changes to QN Workflow. TFS 22187 - 09/20/2021
-- Modified to support cross site access for Virtual East Managers. TFS 23378 - 10/29/2021 
-- Modified to add ability to search by FormName . TFS 25229 - 08/29/2022
-- Modified to expand Reassign To Supervisor list. TFS 26216 - 03/20/2023
--	=====================================================================
CREATE OR ALTER   PROCEDURE [EC].[sp_AT_Select_ReassignTo_Users] 
@intSiteIDin INT

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strSelectedSite nvarchar(50),
@strConditionalSupSite nvarchar(100),
@strConditionalMgrSite nvarchar(100),
@NewLineChar nvarchar(2);

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];


SET @strSelectedSite = (SELECT [City] FROM [EC].[DIM_Site] WHERE [SiteID] = @intSiteIDin);
SET @NewLineChar = CHAR(13) + CHAR(10);

SET @strConditionalSupSite = '';
SET @strConditionalMgrSite = '';
IF @intSiteIDin <> -1

BEGIN
SET @strConditionalSupSite  = N'AND vehSup.emp_site =  '''+@strSelectedSite+''' ';
SET @strConditionalMgrSite  = N'AND vehMgr.emp_site =  '''+@strSelectedSite+''' ';
END



SET @nvcSQL = N'SELECT DISTINCT eh.SUP_ID UserID, vehSup.Emp_Name UserName, vehSup.Emp_Site UserSite
FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh
ON cl.EmpID = eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] veh
ON eh.Emp_ID = veh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] vehSup
ON eh.Sup_ID = [vehSup].[Emp_ID] 
WHERE ((cl.ModuleID <> 2 AND cl.StatusId IN (6,8,10,11,12)) OR (cl.ModuleID = 2 AND cl.StatusId = 5)) ' +  @NewLineChar 
+ @strConditionalSupSite +  @NewLineChar 
+' AND vehSup.Emp_Name is NOT NULL 
AND eh.Active NOT IN (''T'',''D'')


UNION

SELECT DISTINCT eh.MGR_ID UserID, vehMgr.Emp_Name UserName, vehMgr.Emp_Site UserSite
FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh
ON cl.EmpID = eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy]veh
ON eh.Emp_ID = veh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] vehMgr
ON eh.Mgr_ID = [vehMgr].[Emp_ID] 
WHERE ((cl.ModuleID <> 2 AND cl.StatusId = 5) OR (cl.ModuleID = 2 AND cl.StatusId = 7)) ' +  @NewLineChar 
+ @strConditionalMgrSite +  @NewLineChar 
+ ' AND  vehMgr.Emp_Name is NOT NULL
AND eh.Active NOT IN (''T'',''D'')
Order By UserName' 

--PRINT @nvcSQL		
EXEC (@nvcSQL)

CLOSE SYMMETRIC KEY [CoachingKey]  
End --sp_AT_Select_ReassignTo_Users
GO



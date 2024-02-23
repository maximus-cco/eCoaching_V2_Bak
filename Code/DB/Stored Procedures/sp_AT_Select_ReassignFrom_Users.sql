SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/28/2016
--	Description: *	This procedure selects the list of users that currently have 
--  ecls assigned to them. Same module and site as the logged in user performing the reassign.
-- Last Updated By: 
-- Initial revision per TFS 1709 - 4/28/2016
-- Updated to add Employees in Leave status for Reassignment and 
-- removed Active check for reassigned and review managers per TFS 3441 - 09/07/2016
-- Modified to support additional Modules per TFS 8793 - 11/16/2017
-- Modified to support Encryption of sensitive data - Open key and use employee View for emp attributes. TFS 7856 - 12/01/2017
-- Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
-- Modified during changes to QN Workflow. TFS 22187 - 09/20/2021
-- Modified to support cross site access for Virtual East Managers. TFS 23378 - 10/29/2021 
-- Modified to remove uncommented debug stm. TFS 23919 - 01/26/2022
-- Modified to add ability to search by FormName . TFS 25229 - 08/29/2022
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_ReassignFrom_Users] 
@strRequesterin nvarchar(30), @intModuleIdin INT, @intStatusIdin INT
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcRequesterID nvarchar(10),
@intRequesterSiteID int,
@strATAdminUser nvarchar(10),
@strATSubAdmin nvarchar(10),
@strConditionalSite nvarchar(100),
@strConditionalStatus nvarchar(100),
@dtmDate datetime,
@NewLineChar nvarchar(2);


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

SET @dtmDate  = GETDATE();   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate);
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@nvcRequesterID);
SET @strATAdminUser = EC.fn_strCheckIfATSysAdmin(@nvcRequesterID) ;
SET @strATSubAdmin = (SELECT CASE WHEN EXISTS ( SELECT 1 FROM [EC].[AT_User_Role_Link] WHERE [UserId] = @nvcRequesterID AND [RoleId] = 120) THEN 'YES' ELSE 'NO'END );
SET @NewLineChar = CHAR(13) + CHAR(10);



-- Check for a specific Status or All possible Statuses dpending on Status param passed. 
-- StatusID param value of -2 indicates All

SET @strConditionalStatus = '';
IF @intStatusIdin = -2

BEGIN
SET @strConditionalStatus = N'AND cl.StatusId IN (5,6,7,8,10,11,12) '
END

ELSE

BEGIN
SET @strConditionalStatus = N'AND cl.StatusId = '''+CONVERT(NVARCHAR,@intStatusIdin)+''' '
END



-- For non Admins limit records to user site.
-- Site restiction does not apply to Admins.
		
SET @strConditionalSite = ' '
IF @strATAdminUser <> 'YES' AND @strATSubAdmin <> 'YES'

BEGIN
	SET @strConditionalSite = N'AND (cl.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' )'
END			 


IF @strATSubAdmin = 'YES'

BEGIN
	SET @strConditionalSite = N'AND eh.isSub = ''Y'''
END	

-- Final results are the combined results from these 3 data sets.

-- 1a. Non reassigned and Non LCS eCLs Sups
-- UNION
-- 1b. Non reassigned and Non LCS eCLs Mgrs
-- UNION
-- 2. Reassigned ecls
-- UNION
-- 3. Non reassigned LCS ecls



SET @nvcSQL = N'SELECT DISTINCT eh.SUP_ID UserID, veh.SUP_Name UserName, seh.IsSub
FROM [EC].[View_Employee_Hierarchy] veh JOIN [EC].[Employee_Hierarchy] eh
ON veh.Emp_ID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] seh
ON eh.Sup_ID = seh.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+''' '+  @NewLineChar 
+ @strConditionalStatus +  @NewLineChar 
+' AND ((cl.ModuleID <> 2 AND cl.StatusId IN (6,8,10,11,12)) OR (cl.ModuleID = 2 AND cl.StatusId = 5))
 AND ISNULL(CL.strReportCode,'' '') NOT LIKE''LCS%''
 AND CL.ReassignCount = 0 '  +  @NewLineChar 
+ @strConditionalSite  +  @NewLineChar 
+ ' AND eh.SUP_ID <> '''+@nvcRequesterID+'''
AND veh.SUP_Name is NOT NULL
AND eh.Active NOT IN  (''T'',''D'')

UNION 

SELECT DISTINCT eh.MGR_ID UserID, veh.MGR_Name UserName, meh.IsSub
FROM [EC].[View_Employee_Hierarchy] veh JOIN [EC].[Employee_Hierarchy] eh
ON veh.Emp_ID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] meh
ON eh.Mgr_ID = meh.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+''' ' +  @NewLineChar 
+ @strConditionalStatus +  @NewLineChar 
+' AND ((cl.ModuleID <> 2 AND cl.StatusId = 5) OR (cl.ModuleID = 2 AND cl.StatusId = 7))
 AND ISNULL(CL.strReportCode,'' '') NOT LIKE''LCS%''
 AND CL.ReassignCount = 0 '  +  @NewLineChar 
+ @strConditionalSite  +  @NewLineChar 
+ ' AND eh.MGR_ID <> '''+@nvcRequesterID+'''
AND veh.MGR_Name is NOT NULL
AND eh.Active NOT IN  (''T'',''D'')

UNION


SELECT DISTINCT rm.Emp_ID UserID, vrm.Emp_Name UserName, rm.isSub
FROM [EC].[View_Employee_Hierarchy]vrm JOIN [EC].[Employee_Hierarchy] rm 
ON vrm.Emp_ID = rm.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.ReassignedToID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+''' ' +  @NewLineChar 
+ @strConditionalStatus +  @NewLineChar 
+ ' AND cl.ReassignedToID is not NULL 
AND (cl.ReassignCount < 2 and cl.ReassignCount <> 0)
AND (vrm.Emp_Name is NOT NULL AND vrm.Emp_Name <> ''Unknown'')' +  @NewLineChar 
+ @strConditionalSite +  @NewLineChar 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' ' +  @NewLineChar +
'AND eh.Active NOT IN  (''T'',''D'')

UNION 

SELECT DISTINCT rm.Emp_ID UserID, vrm.Emp_Name UserName, rm.isSub
FROM [EC].[View_Employee_Hierarchy]vrm JOIN [EC].[Employee_Hierarchy] rm
ON vrm.Emp_ID = rm.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.MgrID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+''' ' +  @NewLineChar 
+ @strConditionalStatus +  @NewLineChar 
+ ' AND cl.MgrID is not NULL
AND cl.strReportCode like ''LCS%''
AND CL.ReassignCount = 0
AND (vrm.Emp_Name is NOT NULL AND vrm.Emp_Name <> ''Unknown'')' +  @NewLineChar 
+ @strConditionalSite +  @NewLineChar 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' ' +  @NewLineChar +
'AND eh.Active NOT IN  (''T'',''D'')
Order By UserName'

--PRINT @nvcSQL	
EXEC (@nvcSQL)
CLOSE SYMMETRIC KEY [CoachingKey]  

End --sp_AT_Select_ReassignFrom_Users
GO



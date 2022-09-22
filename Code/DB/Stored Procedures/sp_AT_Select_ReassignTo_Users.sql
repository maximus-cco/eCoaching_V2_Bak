
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
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_ReassignTo_Users] 
@strFormName nvarchar(50) = NULL,
@strRequesterin nvarchar(30),
@strFromUserIdin nvarchar(10)= NULL, 
@intModuleIdin INT,
@intStatusIdin INT

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcRequesterID nvarchar(10),
@intFromUserSiteID int,
@strConditionalStatus nvarchar(100),
@dtmDate datetime,
@NewLineChar nvarchar(2);

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];


SET @dtmDate  = GETDATE();   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate);
SET @intFromUserSiteID = EC.fn_intSiteIDFromEmpID(@strFromUserIdin);
SET @NewLineChar = CHAR(13) + CHAR(10);

-- Lookup the Module and Status when searched by Formname

IF COALESCE(@strFormName,'') <> '' 
BEGIN

SET @intModuleIdin = (SELECT ModuleID from EC.Coaching_log WHERE FormName = @strFormName);
SET @intStatusIdin = (SELECT StatusID from EC.Coaching_log WHERE FormName = @strFormName);

END

SET @strConditionalStatus = '';
IF @intStatusIdin = -2

BEGIN
SET @strConditionalStatus = N'AND cl.StatusId IN (5,6,7,8,10,11,12) '
END

ELSE

BEGIN
SET @strConditionalStatus = N'AND cl.StatusId = '''+CONVERT(NVARCHAR,@intStatusIdin)+''' '
END


SET @nvcSQL = N'SELECT DISTINCT eh.SUP_ID UserID, veh.SUP_Name UserName
FROM [EC].[View_Employee_Hierarchy] veh JOIN [EC].[Employee_Hierarchy] eh
ON veh.Emp_ID = eh.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+''' ' +  @NewLineChar 
+ @strConditionalStatus +  @NewLineChar 
+' AND ((cl.ModuleID <> 2 AND cl.StatusId IN (6,8,10,11,12)) OR (cl.ModuleID = 2 AND cl.StatusId = 5))
 AND (cl.SiteID = '''+CONVERT(NVARCHAR,@intFromUserSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' ) 
AND eh.SUP_ID <> '''+@nvcRequesterID+''' AND eh.SUP_ID <> '''+@strFromUserIdin+'''
AND veh.Sup_Name is NOT NULL 
AND eh.Active NOT IN (''T'',''D'')


UNION

SELECT DISTINCT eh.MGR_ID UserID, veh.MGR_Name UserName
FROM [EC].[View_Employee_Hierarchy] veh JOIN [EC].[Employee_Hierarchy] eh
ON veh.Emp_ID = eh.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+''' ' +  @NewLineChar 
+ @strConditionalStatus +  @NewLineChar 
+' AND ((cl.ModuleID <> 2 AND cl.StatusId = 5) OR (cl.ModuleID = 2 AND cl.StatusId = 7))
 AND (cl.SiteID = '''+CONVERT(NVARCHAR,@intFromUserSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' ) 
AND eh.MGR_ID <> '''+@nvcRequesterID+''' AND eh.MGR_ID <> '''+@strFromUserIdin+'''
AND  veh.Mgr_Name is NOT NULL
AND eh.Active NOT IN (''T'',''D'')
Order By UserName' 

--PRINT @nvcSQL		
EXEC (@nvcSQL)

CLOSE SYMMETRIC KEY [CoachingKey]  
End --sp_AT_Select_ReassignTo_Users
GO


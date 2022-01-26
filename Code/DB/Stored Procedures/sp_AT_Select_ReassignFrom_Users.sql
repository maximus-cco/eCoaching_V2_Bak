
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_ReassignFrom_Users' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_ReassignFrom_Users]
GO



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
@strConditionalSelect nvarchar(100),
@strConditionalSite nvarchar(100),
@strConditionalRestrict nvarchar(100),
@dtmDate datetime,
@NewLineChar nvarchar(2)


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]

SET @dtmDate  = GETDATE()   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate)
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@nvcRequesterID)
SET @strATAdminUser = EC.fn_strCheckIfATSysAdmin(@nvcRequesterID) 
SET @NewLineChar = CHAR(13) + CHAR(10)

IF ((@intStatusIdin IN (6,8,10,11,12) AND @intModuleIdin NOT in (-1,2))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalSelect = N'SELECT DISTINCT eh.SUP_ID UserID, veh.SUP_Name UserName '
SET @strConditionalRestrict = N'AND eh.SUP_ID <> '''+@nvcRequesterID+''' ' 
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin NOT in (-1,2))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalSelect = N'SELECT DISTINCT eh.MGR_ID UserID, veh.MGR_Name UserName '
SET @strConditionalRestrict = N' AND eh.MGR_ID <> '''+@nvcRequesterID+''''
END
		
SET @strConditionalSite = ' '
IF @strATAdminUser <> 'YES'

BEGIN
	SET @strConditionalSite = N'AND (cl.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' )'
END			 

-- Non reassigned and Non LCS eCLs
-- UNION
-- Reassigned ecls
-- UNION
-- Non reassigned LCS ecls

SET @nvcSQL = @strConditionalSelect +
'FROM [EC].[View_Employee_Hierarchy] veh JOIN [EC].[Employee_Hierarchy] eh
ON veh.Emp_ID = eh.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND CL.ReassignCount = 0
AND NOT (CL.statusid = 5 AND ISNULL(CL.strReportCode,'' '') like ''LCS%'') '  +  @NewLineChar 
+ @strConditionalSite  +  @NewLineChar 
+ @strConditionalRestrict  +  @NewLineChar 
+ 'AND (veh.SUP_Name is NOT NULL AND veh.MGR_Name is NOT NULL)
AND eh.Active NOT IN  (''T'',''D'')

UNION 


SELECT DISTINCT rm.Emp_ID UserID, vrm.Emp_Name UserName
FROM [EC].[View_Employee_Hierarchy]vrm JOIN [EC].[Employee_Hierarchy] rm 
ON vrm.Emp_ID = rm.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.ReassignedToID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND cl.ReassignedToID is not NULL 
AND (cl.ReassignCount < 2 and cl.ReassignCount <> 0)
AND (vrm.Emp_Name is NOT NULL AND vrm.Emp_Name <> ''Unknown'')' +  @NewLineChar 
+ @strConditionalSite +  @NewLineChar 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' ' +  @NewLineChar +
'AND eh.Active NOT IN  (''T'',''D'')

UNION 

SELECT DISTINCT rm.Emp_ID UserID, vrm.Emp_Name UserName
FROM [EC].[View_Employee_Hierarchy]vrm JOIN [EC].[Employee_Hierarchy] rm
ON vrm.Emp_ID = rm.Emp_ID JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.MgrID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND cl.MgrID is not NULL
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




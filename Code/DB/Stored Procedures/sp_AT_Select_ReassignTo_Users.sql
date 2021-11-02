
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_ReassignTo_Users' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_ReassignTo_Users]
GO

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
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_ReassignTo_Users] 
@strRequesterin nvarchar(30),@strFromUserIdin nvarchar(10), @intModuleIdin INT, @intStatusIdin INT
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@nvcRequesterID nvarchar(10),
@intRequesterSiteID int,
@intFromUserSiteID int,
@strSelect nvarchar(1000),
@dtmDate datetime,
@NewLineChar nvarchar(2)

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]



SET @dtmDate  = GETDATE()   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate)
SET @intFromUserSiteID = EC.fn_intSiteIDFromEmpID(@strFromUserIdin)
SET @NewLineChar = CHAR(13) + CHAR(10)

IF ((@intStatusIdin IN (6,8,10, 11,12) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))


BEGIN
SET @nvcSQL = N'SELECT DISTINCT sh.EMP_ID UserID, vsh.Emp_Name UserName
FROM [EC].[Employee_Hierarchy]eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy]sh
ON eh.SUP_ID = sh.EMP_ID JOIN [EC].[View_Employee_Hierarchy] vsh
ON sh.Emp_ID = vsh.Emp_ID 
WHERE (cl.SiteID = '''+CONVERT(NVARCHAR,@intFromUserSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' )
AND (vsh.Emp_Name is NOT NULL AND vsh.Emp_Name <> ''Unknown'')
AND eh.SUP_ID <> '''+@strFromUserIdin+''' 
AND eh.Active NOT IN (''T'',''D'')
AND sh.Active = ''A''
Order By UserName'
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN

SET @nvcSQL = N'SELECT DISTINCT mh.EMP_ID UserID, vmh.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy]mh
ON eh.MGR_ID = mh.EMP_ID JOIN [EC].[View_Employee_Hierarchy] vmh
ON mh.Emp_ID = vmh.Emp_ID 
WHERE (cl.SiteID = '''+CONVERT(NVARCHAR,@intFromUserSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' )
AND (vmh.Emp_Name is NOT NULL AND vmh.Emp_Name <> ''Unknown'')
AND eh.MGR_ID <> '''+@strFromUserIdin+'''
AND eh.Active NOT IN (''T'',''D'')
AND mh.Active = ''A''
Order By UserName'
END
			 

PRINT @nvcSQL		
EXEC (@nvcSQL)

CLOSE SYMMETRIC KEY [CoachingKey]  
End --sp_AT_Select_ReassignTo_Users
GO



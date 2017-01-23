/*
sp_AT_Select_ReassignFrom_Users(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_ReassignFrom_Users] 
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
@dtmDate datetime

SET @dtmDate  = GETDATE()   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate)
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@nvcRequesterID)
SET @strATAdminUser = EC.fn_strCheckIfATSysAdmin(@nvcRequesterID) 

IF ((@intStatusIdin IN (6,8) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 5 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalSelect = N'SELECT DISTINCT eh.SUP_ID UserID, eh.SUP_Name UserName '
SET @strConditionalRestrict = N'AND eh.SUP_ID <> '''+@nvcRequesterID+''' ' 
END

ELSE IF 
((@intStatusIdin = 5 AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin = 7 AND @intModuleIdin = 2))

BEGIN
SET @strConditionalSelect = N'SELECT DISTINCT eh.MGR_ID UserID, eh.MGR_Name UserName '
SET @strConditionalRestrict = N'AND eh.MGR_ID <> '''+@nvcRequesterID+''''
END
		
SET @strConditionalSite = ' '
IF @strATAdminUser <> 'YES'

BEGIN
	SET @strConditionalSite = ' AND cl.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' '
END			 

-- Non reassigned and Non LCS eCLs
-- UNION
-- Reassigned ecls
-- UNION
-- Non reassigned LCS ecls

SET @nvcSQL = @strConditionalSelect +
'FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ' +
' ON cl.EmpID = eh.Emp_ID 
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND CL.ReassignCount = 0
AND NOT (CL.statusid = 5 AND ISNULL(CL.strReportCode,'' '') like ''LCS%'')'
+ @strConditionalSite 
+ @strConditionalRestrict
+ 'AND (eh.SUP_Name is NOT NULL AND eh.MGR_Name is NOT NULL)
AND eh.Active NOT IN  (''T'',''D'')

UNION 


SELECT DISTINCT rm.Emp_ID UserID, rm.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] rm JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.ReassignedToID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND cl.ReassignedToID is not NULL 
AND (cl.ReassignCount < 2 and cl.ReassignCount <> 0)
AND (rm.Emp_Name is NOT NULL AND rm.Emp_Name <> ''Unknown'')'
+ @strConditionalSite 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' 
AND eh.Active NOT IN  (''T'',''D'')

UNION 

SELECT DISTINCT rm.Emp_ID UserID, rm.Emp_Name UserName
FROM [EC].[Employee_Hierarchy] rm JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
ON cl.MgrID = rm.Emp_ID JOIN [EC].[Employee_Hierarchy] eh
ON eh.Emp_ID = cl.EmpID
WHERE cl.ModuleID = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
AND cl.StatusId= '''+CONVERT(NVARCHAR,@intStatusIdin)+'''
AND cl.MgrID is not NULL
AND cl.strReportCode like ''LCS%''
AND CL.ReassignCount = 0
AND (rm.Emp_Name is NOT NULL AND rm.Emp_Name <> ''Unknown'')'
+ @strConditionalSite 
+ 'AND rm.Emp_ID <> '''+@nvcRequesterID+''' 
AND eh.Active NOT IN  (''T'',''D'')
Order By UserName'

--PRINT @nvcSQL		
EXEC (@nvcSQL)


End --sp_AT_Select_ReassignFrom_Users


GO


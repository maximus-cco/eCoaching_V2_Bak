SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Coaching or Warning logs 
--  in the appropriate Status for the Action for the selected Employee.
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--  Updated to add Employees in Leave status for Reassignment per TFS 3441 - 09/07/2016
--  Modified to support Encryption of sensitive data (Open key and use employee View for emp attributes. TFS 7856 - 10/23/2017
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
-- Modified during changes to QN Workflow. TFS 22187 - 09/20/2021
-- Modified to add ability to search by FormName . TFS 25229 - 08/29/2022
-- Modified to expand Reassign To Supervisor list. TFS 26216 - 03/20/2023
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Logs_Reassign] 
@strTypein nvarchar(10) = NULL,
@istrOwnerin nvarchar(10) = NULL,
@intStatusIdin INT = NULL, 
@intModuleIdin INT = NULL,
@strFormName nvarchar(50) = NULL,
@strRequesterin nvarchar(30)

AS

BEGIN
DECLARE	
@strConditionalWhere nvarchar(200) = '',
@nvcSQL nvarchar(max),
@nvcConditionalStatus nvarchar(100),
@strOwnerSite nvarchar(50),
@nvcRequesterID nvarchar(10),
@intRequesterSiteID int,
@strATAdminUser nvarchar(10),
@strATSubAdmin nvarchar(10),
@strConditionalSite nvarchar(100),
@dtmDate datetime,
@NewLineChar nvarchar(2);

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];



SET @strOwnerSite =  (SELECT Emp_Site from EC.Employee_Hierarchy WHERE EMP_ID = @istrOwnerin);

SET @dtmDate  = GETDATE();   
SET @nvcRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterin,@dtmDate);
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@nvcRequesterID);
SET @strATAdminUser = EC.fn_strCheckIfATSysAdmin(@nvcRequesterID) ;
SET @strATSubAdmin = (SELECT CASE WHEN EXISTS ( SELECT 1 FROM [EC].[AT_User_Role_Link] WHERE [UserId] = @nvcRequesterID AND [RoleId] = 120) THEN 'YES' ELSE 'NO'END );
SET @NewLineChar = CHAR(13) + CHAR(10);

--print @strATAdminUser
--print @strATSubAdmin


-- For non Admins limit records to user site or hierarchy
-- Site restiction does not apply to Admins.

SET @strConditionalSite = ' '
IF @strATAdminUser <> 'YES' AND @strATSubAdmin <> 'YES'

BEGIN
	SET @strConditionalSite = @strConditionalSite + N'AND (cfact.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+''' OR eh.Mgr_ID = '''+@nvcRequesterID+''' )'
END			 

--print 'coachingadmin' + @strConditionalSite
-- If logged in user is a Sub Admin only return logs belonging to Subs.
IF @strATSubAdmin = 'YES'

BEGIN
	SET @strConditionalSite = @strConditionalSite + N'AND eh.isSub = ''Y'''
END

--print 'subadmin'  +  @strConditionalSite

-- When searched by Formname
-- Lookup the Module and Status, and Reassigned From 

IF COALESCE(@strFormName,'') <> '' 
BEGIN
--print 'formname ' + COALESCE(@strFormName,'')


SET @intModuleIdin = (SELECT ModuleID from EC.Coaching_log WHERE FormName = @strFormName);
SET @intStatusIdin = (SELECT StatusID from EC.Coaching_log WHERE FormName = @strFormName);
SET @istrOwnerin = (SELECT CASE 
WHEN cl.ReassignCount = 1 and ISNULL(cl.ReassignedToID, '') <> '' THEN cl.ReassignedToID
WHEN cl.strReportCode like 'LCS%' AND cl.ReassignCount = 0 THEN cl.MgrID
WHEN (cl.ModuleID <> 2 AND cl.StatusId IN (6,8,10,11,12)) OR (cl.ModuleID = 2 AND cl.StatusId = 5) AND cl.ReassignCount = 0 THEN eh.Sup_ID
WHEN (cl.ModuleID <> 2 AND cl.StatusId = 5) OR (cl.ModuleID = 2 AND cl.StatusId = 7) AND cl.ReassignCount = 0 THEN eh.Mgr_ID END 
FROM EC.Coaching_Log cl  INNER JOIN EC.Employee_Hierarchy eh
ON cl.EmpID = eh.Emp_ID
WHERE cl.Formname = @strFormName);
--print @istrOwnerin 

SET @strOwnerSite =  (SELECT Emp_Site from EC.Employee_Hierarchy WHERE EMP_ID = @istrOwnerin);
--print @strOwnerSite 


SET @nvcSQL = 'SELECT cfact.CoachingID,  
        cfact.FormName strFormName,
		veh.Emp_Name	strEmpName,
		veh.Sup_Name	strSupName,
	    CASE
		 WHEN cfact.[strReportCode] like ''LCS%'' AND cfact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](cfact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE veh.Mgr_Name END strMgrName,
		 sh.Emp_Name strSubmitter,
		s.Status,
		cfact.SubmittedDate strCreatedDate,
		''' + @istrOwnerin + ''' strReassignFrom,
		[EC].[fn_strEmpNameFromEmpID](''' + @istrOwnerin + ''') strReassignFromName,
		[EC].[fn_strEmpEmailFromEmpID](''' + @istrOwnerin + ''') strReassignFromEmail,
		''' + @strOwnerSite + ''' strReviewerSite,
		[EC].[fn_intSiteIDFromSite](''' + @strOwnerSite + ''') intReviewerSiteID,
		veh.isSub
     FROM [EC].[Coaching_Log]cfact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh
	 ON [cfact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[View_Employee_Hierarchy] veh
     ON VEH.Emp_ID = Eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] sh
	 ON [cfact].[SubmitterID] = [sh].[Emp_ID]JOIN [EC].[DIM_Status] s
	 ON [cfact].[StatusID] = [s].[StatusID] 
	WHERE eh.Active NOT IN  (''T'',''D'') 
	AND cfact.ReassignCount < 2
AND	cfact.StatusID IN (5,6,7,8,10,11,12)'
	+ @strConditionalSite +
	' AND cfact.[Formname] = ''' + @strFormName + '''';
END


-- When searched by Other Criteria

IF COALESCE(@strFormName,'') = '' AND @intStatusIdin  IS NOT NULL AND @intModuleIdin IS NOT NULL 
BEGIN

IF ((@intStatusIdin IN (6,8,10,11,12) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin in (5) AND @intModuleIdin = 2))

BEGIN
SET @strConditionalWhere = @strConditionalWhere + ' WHERE EH.Sup_ID = '''+@istrOwnerin+''' '
END

ELSE IF 
((@intStatusIdin in (5) AND @intModuleIdin IN (1,3,4,5))
OR (@intStatusIdin in (7)AND @intModuleIdin = 2))

BEGIN
SET @strConditionalWhere = @strConditionalWhere + ' WHERE EH.Mgr_ID = '''+@istrOwnerin+''' '
END

ELSE IF 
@intStatusIdin = -2 AND @intModuleIdin <> 2


BEGIN
SET @strConditionalWhere = @strConditionalWhere + ' WHERE (fact.statusid IN (6,7,8,10,11,12) AND (EH.Sup_ID = '''+@istrOwnerin+''') OR (fact.statusid = 5 AND EH.Mgr_ID = '''+@istrOwnerin+''')) '
END

ELSE IF 
@intStatusIdin = -2 AND @intModuleIdin = 2

BEGIN
SET @strConditionalWhere = @strConditionalWhere + ' WHERE ((fact.statusid = 5 AND EH.Sup_ID = '''+@istrOwnerin+''') OR (fact.statusid = 7 AND EH.Mgr_ID = '''+@istrOwnerin+''')) '
END


IF @intStatusIdin  = -2 -- All Statuses
BEGIN
SET @nvcConditionalStatus =  ' AND cfact.StatusId IN (5,6,7,8,10,11,12) '
END

ELSE 
BEGIN
SET @nvcConditionalStatus = ' AND cfact.StatusId = '''+CONVERT(NVARCHAR,@intStatusIdin)+''''
END

-- Check for 3 scenarios
--1. Original hierarchy owner
--2. Reassigned owner
--3. Review owner for LCS

SET @nvcSQL = 'SELECT cfact.CoachingID,  
        cfact.FormName strFormName,
		veh.Emp_Name	strEmpName,
		veh.Sup_Name	strSupName,
	    CASE
		 WHEN cfact.[strReportCode] like ''LCS%'' AND cfact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](cfact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE veh.Mgr_Name END strMgrName,
		 sh.Emp_Name strSubmitter,
		s.Status,
		cfact.SubmittedDate strCreatedDate,
	   ''' + @istrOwnerin + ''' strReassignFrom,
	   [EC].[fn_strEmpNameFromEmpID](''' + @istrOwnerin + ''') strReassignFromName,
		[EC].[fn_strEmpEmailFromEmpID](''' + @istrOwnerin + ''') strReassignFromEmail,
		''' + @strOwnerSite + ''' strReviewerSite,
		[EC].[fn_intSiteIDFromSite](''' + @strOwnerSite + ''') intReviewerSiteID
		,veh.isSub
     FROM [EC].[Coaching_Log]cfact WITH(NOLOCK) JOIN 
     
     (SELECT fact.CoachingID
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] eh
	 ON [Fact].[EMPID] = [eh].[Emp_ID]
	 AND NOT(fact.statusid = 5 AND ISNULL(fact.strReportCode,'' '') LIKE ''LCS%'')'
	 + @strConditionalWhere +
	 'AND fact.ReassignCount = 0
	
	
     UNION
     
     SELECT fact.CoachingID 
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] rm
	 ON [Fact].[ReassignedToID] = [rm].[Emp_ID]
	 WHERE rm.Emp_ID = '''+@istrOwnerin+''' 
	 AND (fact.ReassignCount < 2 and fact.ReassignCount <> 0)
	 AND fact.ReassignedToID is not NULL
	 
	 
     UNION
     
     SELECT fact.CoachingID 
     FROM [EC].[Coaching_Log]fact WITH(NOLOCK) JOIN [EC].[Employee_Hierarchy] rm
	 ON [Fact].[MgrID] = [rm].[Emp_ID]
	 WHERE rm.Emp_ID = '''+@istrOwnerin+''' 
	 AND fact.strReportCode like ''LCS%''
	 AND fact.ReassignCount = 0
	 )Selected 
	 
	 ON Selected.CoachingID = cfact.CoachingID JOIN [EC].[Employee_Hierarchy] eh
	 ON [cfact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[View_Employee_Hierarchy] veh
     ON VEH.Emp_ID = Eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] sh
	 ON [cfact].[SubmitterID] = [sh].[Emp_ID]JOIN [EC].[DIM_Status] s
	 ON [cfact].[StatusID] = [s].[StatusID]
	 
	WHERE 1 = 1 '
	+ @nvcConditionalStatus +
	' AND cfact.Moduleid = '''+CONVERT(NVARCHAR,@intModuleIdin)+'''
  	AND eh.Active NOT IN  (''T'',''D'') 
   ORDER BY cfact.FormName DESC';

END
   
--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Logs_Reassign
GO



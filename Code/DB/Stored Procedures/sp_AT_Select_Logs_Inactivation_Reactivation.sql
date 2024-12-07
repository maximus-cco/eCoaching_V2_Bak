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
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/2/12016
--  Updated to allow for Inactivation of completed logs from admin tool - TFS 7152 - 06/30/2017
--  Modified to support Encryption of sensitive data - Open key and use employee View for emp attributes. TFS 7856 - 10/23/2017
--  Modified to add ability to search by FormName . TFS 25229 - 08/29/2022
--  Modified to support Reactivation by Managers. TFS 25961- 12/16/2022
--  Modified to only display latest last known status when Reactivating log. TFS 26048 - 01/20/2023
--  Search by multiple log names. 09/08/2023
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Logs_Inactivation_Reactivation] 

@strRequesterLanId nvarchar(30),
@strTypein nvarchar(10) = NULL, 
@strActionin nvarchar(10), 
@strEmployeein nvarchar(10) = NULL,
@intModuleIdin INT = NULL, 
@strFormName nvarchar(max) = NULL

AS

BEGIN
DECLARE	
@nvcTableName nvarchar(1000),
@nvcWhere nvarchar(300),
@strRequesterID nvarchar(10),
@strATCoachAdminUser nvarchar(10),
@strATSubAdmin nvarchar(10),
@intRequesterSiteID int,
@dtmDate datetime,
@strID nvarchar(30),
@nvcSQL nvarchar(max);



OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];


SET @dtmDate  = GETDATE();   
SET @strRequesterID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate);
SET @intRequesterSiteID = EC.fn_intSiteIDFromEmpID(@strRequesterID);
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@strRequesterID);
SET @strATSubAdmin = (SELECT CASE WHEN EXISTS ( SELECT 1 FROM [EC].[AT_User_Role_Link] WHERE [UserId] = @strRequesterID AND [RoleId] = 120) THEN 'YES' ELSE 'NO'END );

-- Determine the ID column and table to pull from depending o Coaching or Warning log

IF @strTypein = N'Coaching' 
SET @strID = 'Fact.CoachingID LogID, '
ELSE 
SET @strID = 'Fact.WarningID LogID, '

IF @strTypein = N'Coaching' AND @strActionin = 'Inactivate'
SET @nvcTableName = ' FROM [EC].[Coaching_Log] Fact WITH(NOLOCK) '

IF @strTypein = N'Warning' AND @strActionin = 'Inactivate'
SET @nvcTableName = ' FROM [EC].[Warning_Log] Fact WITH(NOLOCK) '


IF @strTypein = N'Coaching' AND @strActionin = 'Reactivate'
SET @nvcTableName = ',Aud.LastKnownStatus, [EC].[fn_strStatusFromStatusID](Aud.LastKnownStatus)LKStatus
 FROM [EC].[Coaching_Log] Fact WITH(NOLOCK) JOIN (
Select a.* FROM
 [EC].[AT_Coaching_Inactivate_Reactivate_Audit] a  JOIN
 (Select CoachingID, MAX([ActionTimestamp]) as latest
 FROM  [EC].[AT_Coaching_Inactivate_Reactivate_Audit] 
 WHERE LastKnownStatus <> 2
 GROUP BY CoachingID) l
 ON a.CoachingID = l.CoachingID and a.ActionTimestamp = l.latest
 WHERE a.LastKnownStatus <> 2
 ) Aud
 ON Aud.FormName = Fact.Formname '

IF @strTypein = N'Warning' AND @strActionin = 'Reactivate'
SET @nvcTableName = ',Aud.LastKnownStatus, [EC].[fn_strStatusFromStatusID](Aud.LastKnownStatus)LKStatus 
 FROM [EC].[Warning_Log] Fact WITH(NOLOCK) JOIN (
Select a.* FROM
 [EC].[AT_Warning_Inactivate_Reactivate_Audit] a  JOIN
 (Select WarningID, MAX([ActionTimestamp]) as latest
 FROM  [EC].[AT_Warning_Inactivate_Reactivate_Audit] 
 WHERE LastKnownStatus <> 2
 GROUP BY WarningID) l
 ON a.WarningID = l.WarningID and a.ActionTimestamp = l.latest
 WHERE a.LastKnownStatus <> 2
 ) Aud
 ON Aud.FormName = Fact.Formname '

 -- Status filter logic
 -- If Action is Reactivation: 
-- Display Inactive logs

IF @strActionin = N'Reactivate'
SET @nvcWhere = ' WHERE Fact.StatusID = 2 '
ELSE 

-- If Action is Inactivation and Coaching
-- For non Coaching Admins display all logs that are not Inactive or completed

IF @strTypein = N'Coaching' AND @strActionin = 'Inactivate' AND @strATCoachAdminUser = 'NO'
SET @nvcWhere = ' WHERE Fact.StatusID NOT IN (1,2) '
ELSE 

-- For Coaching Admins and Inactivation

 IF @strTypein = N'Coaching'  AND @strActionin = 'Inactivate' AND @strATCoachAdminUser = 'YES'
 --Special conditions for Coaching  
--Display  Completed logs submitted in the last 3 months in addition to the other Active status logs
SET @nvcWhere = ' WHERE (Fact.StatusID not in (1,2) 
				 OR (Fact.StatusID = 1 AND Fact.SubmittedDate > DATEADD(MM,-3, GETDATE()))) '


-- For warnings display all Active logs
IF @strTypein = N'Warning'  AND @strActionin = 'Inactivate'
	BEGIN
	SET @nvcWhere = ' WHERE Fact.StatusID <> 2 ';
	END


-- If Formname is not passed, then apply other Filters
-- If Formname is passed then Filter for that Form name only

-- to be safe
DROP TABLE IF EXISTS #LogNames;

IF COALESCE(@strFormName,'') = ''
BEGIN
SET @nvcWhere = @nvcWhere  + ' AND [Fact].EmpID =  ''' + @strEmployeein  + '''
                               AND [Fact].[ModuleId] = ''' + CONVERT(nvarchar,@intModuleIdin) + '''' 
END
-- search by log name(s)
ELSE 
BEGIN
-- multiple log names search
IF @strActionin = N'Inactivate' 
BEGIN
-- split log names and insert into temp table #LogNames
CREATE TABLE #LogNames (LogName NVARCHAR(max));
INSERT INTO #LogNames (LogName)
    SELECT TRIM(value) FROM STRING_SPLIT(@strFormName, ',');
-- update where statement
SET @nvcWhere = @nvcWhere + ' AND [Fact].[Formname] IN (SELECT LogName FROM #LogNames) '
END
-- Reactivate, single log name search
ELSE
BEGIN
SET @nvcWhere = @nvcWhere  + ' AND [Fact].[Formname] = ''' + @strFormName   + ''''
END


--Restriction for Non Coaching Admins and non Sub Admins
IF  @strATCoachAdminUser = 'NO' AND @strATSubAdmin = 'NO'

SET @nvcWhere = @nvcWhere  + ' AND 
			 (Fact.SiteID = '''+CONVERT(NVARCHAR,@intRequesterSiteID)+'''
		      OR
			 (veh.Sup_ID =  '''+@strRequesterId+'''  OR veh.Mgr_ID = '''+@strRequesterId+''' ))'
END 

IF @strATSubAdmin = 'YES'

BEGIN
	SET @nvcWhere = @nvcWhere  +  N'AND veh.isSub = ''Y'''
END
-- end search by log name(s)

 SET @nvcSQL = 'SELECT DISTINCT '+@strID+' 
        fact.FormName strFormName,
		veh.Emp_Site strEmpSite,
		veh.Emp_Name	strEmpName,
		veh.Sup_Name	strSupName,
	    CASE
		 WHEN  fact.[strReportCode] like ''LCS%'' AND fact.[MgrID] <> eh.[Mgr_ID]
		 THEN [EC].[fn_strEmpNameFromEmpID](fact.[MgrID])+ '' (Assigned Reviewer)''
		 ELSE veh.Mgr_Name END strMgrName,
		sh.Emp_Name strSubmitter,
		s.Status,
		Fact.SubmittedDate strCreatedDate '
  +  @nvcTableName +
 'JOIN [EC].[Employee_Hierarchy] eh
	 ON [Fact].[EMPID] = [eh].[Emp_ID] JOIN [EC].[View_Employee_Hierarchy] veh
     ON VEH.Emp_ID = Eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] sh
	 ON [Fact].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s
	 ON [Fact].[StatusID] = [s].[StatusID] '+
 @nvcWhere +
 ' ORDER BY Fact.FormName DESC'


--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Logs_Inactivation_Reactivation

GO



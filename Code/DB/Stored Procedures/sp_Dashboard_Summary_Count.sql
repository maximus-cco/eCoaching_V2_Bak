SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/22/2018
--  Description: Retrieves Count of Logs based on user Job Role.
--  on the MyDashboard Page.
--  Initial Revision created during MyDashboard redesign.  TFS 7137 - 05/22/2018
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to display MyFollowup for CSRs. TFS 15621 - 09/17/2019
--  Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--  Removed references to SrMgr Role. TFS 18062 - 08/18/2020
--  Modified to exclude QN Logs. TFS 22187 - 08/03/2021
--  Modified logic for My Teams Pending dashboard counts. TFS 23868 - 01/05/2022
--  Modified to Remove Warnings for Sub-contractors. TFS 28080 - 05/01/2024
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--  Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Dashboard_Summary_Count] 
@nvcEmpID nvarchar(10)

AS

BEGIN
DECLARE	
@nvcEmpRole nvarchar(40),
@isSub nvarchar(1),
@bitMyPending bit,
@bitMyFollowup bit,
@bitMyCompleted bit,
@bitMyTeamPending bit,
@bitMyTeamCompleted bit,
@bitMyTeamWarning bit,
@bitMySubmission bit,
@intMyPendingCoaching int,
@intMyPendingWarning int,
@intMyPending int,
@intMyFollowup int,
@intMyCompleted int,
@intMyTeamPending int,
@intMyTeamCompleted int,
@intMyTeamWarning int,
@intMySubmission int,
@SelectList nvarchar(2000),
@nvcSQL nvarchar(max)



OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcEmpID);
SET @isSub  = (SELECT isSub FROM EC.Employee_Hierarchy WHERE Emp_ID = @nvcEmpID);

SET @bitMyPending = (SELECT [MyPending] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyFollowup = (SELECT [MyFollowup] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyCompleted = (SELECT [MyCompleted] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyTeamPending = (SELECT [MyTeamPending] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyTeamCompleted = (SELECT [MyTeamcompleted] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyTeamWarning = (SELECT [MyTeamWarning] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMySubmission = (SELECT [MySubmission] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);

SET @SelectList = '';
print @nvcEmpRole;

IF @bitMyPending = 1
BEGIN

IF @nvcEmpRole in ('CSR','ISG', 'ARC', 'Employee')
BEGIN
SET @intMyPendingCoaching = (SELECT COALESCE(COUNT(cl.CoachingID),0)
                 FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON cl.EmpID = eh.Emp_ID
                 WHERE cl.[SourceID] NOT IN (235, 236)
				 AND cl.EmpID = @nvcEmpID  AND StatusID in (3,4));


SET @intMyPendingWarning = (SELECT COALESCE(COUNT(wl.WarningID),0)
                 FROM EC.Warning_Log wl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON wl.EmpID = eh.Emp_ID
                 WHERE wl.EmpID = @nvcEmpID AND StatusID = 4
				 AND eh.isSub = 'N');

SET @intMyPending = @intMyPendingCoaching + @intMyPendingWarning;

END


IF @nvcEmpRole  = 'Supervisor'
BEGIN
SET @intMyPendingCoaching = (SELECT COUNT(cl.CoachingID)
                 FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON cl.EmpID = eh.Emp_ID
                 WHERE  cl.[SourceID] NOT IN (235, 236) AND 
				 ((cl.EmpID = @nvcEmpID  AND StatusID in (3,4))
				 OR (cl.ReassignCount= 0 AND eh.Sup_ID = @nvcEmpID  AND StatusID in (3,6,8,10)) 
				 OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = @nvcEmpID AND  StatusID in (3,6,8,10))));

SET @intMyPendingWarning = (SELECT COALESCE(COUNT(wl.WarningID),0)
                 FROM EC.Warning_Log wl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON wl.EmpID = eh.Emp_ID
                 WHERE wl.EmpID = @nvcEmpID AND StatusID = 4
				 AND eh.isSub = 'N');

SET @intMyPending = @intMyPendingCoaching + @intMyPendingWarning;
			
END

IF @nvcEmpRole = 'Manager'
BEGIN
SET @intMyPendingCoaching = (SELECT COUNT(cl.CoachingID)
                 FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON cl.EmpID = eh.Emp_ID
                 WHERE cl.[SourceID] NOT IN (235, 236) AND
				 ((cl.EmpID = @nvcEmpID  AND StatusID in (3,4))
			    OR (ISNULL([cl].[strReportCode], ' ') NOT LIKE 'LCS%' AND ISNULL([cl].[strReportCode], ' ') NOT LIKE 'BQ%' AND cl.ReassignCount= 0 AND eh.Sup_ID = @nvcEmpID  AND cl.[StatusID] in (3,5,6,8,10) 
			     OR (ISNULL([cl].[strReportCode], ' ') NOT LIKE 'LCS%' AND cl.ReassignCount= 0 AND  eh.Mgr_ID =  @nvcEmpID  AND cl.[StatusID] in (5,7,9)) 
			     OR ([cl].[strReportCode] LIKE 'LCS%' AND [ReassignCount] = 0 AND cl.[MgrID] = @nvcEmpID AND [cl].[StatusID]= 5) )
			     OR (cl.ReassignCount <> 0 AND cl.ReassignedToID =  @nvcEmpID AND  cl.[StatusID] in (5,7,9))))

SET @intMyPendingWarning = (SELECT COALESCE(COUNT(wl.WarningID),0)
                 FROM EC.Warning_Log wl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON wl.EmpID = eh.Emp_ID
                 WHERE wl.EmpID = @nvcEmpID  AND StatusID = 4
				 AND eh.isSub = 'N');

SET @intMyPending = @intMyPendingCoaching + @intMyPendingWarning;

END

SET @SelectList = @SelectList + ' UNION
SELECT ''My Pending'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyPending)+ ''' AS LogCount';
END


IF @bitMyFollowup = 1

BEGIN
SET @intMyFollowup = (SELECT COUNT(CoachingID) FROM EC.Coaching_Log WITH (NOLOCK)
                       WHERE [SourceID] NOT IN (235, 236) 
					   AND EmpID = @nvcEmpID  AND StatusID = 10 AND EmpID <> '999999');

SET @SelectList = @SelectList + ' UNION
SELECT ''My Follow-up'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyFollowup)+ ''' AS LogCount ';
END




IF @bitMyCompleted = 1

BEGIN
SET @intMyCompleted = (SELECT COUNT(CoachingID) FROM EC.Coaching_Log WITH (NOLOCK)
                       WHERE [SourceID] NOT IN (235, 236) 
					   AND EmpID = @nvcEmpID  AND StatusID = 1 AND EmpID <> '999999');

SET @SelectList = @SelectList + ' UNION
SELECT ''My Completed'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyCompleted)+ ''' AS LogCount ';
END



IF @bitMyTeamPending = 1
BEGIN
SET @intMyTeamPending = (SELECT COUNT(cl.CoachingID)
						 FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
						 ON cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s
						 ON cl.StatusID = s.StatusID 
						 WHERE cl.[SourceID] NOT IN (235, 236) 
						 AND s.Status like 'Pending%'
						 AND (eh.Sup_ID = @nvcEmpID OR eh.Mgr_ID = @nvcEmpID OR eh.SrMgrLvl1_ID = @nvcEmpID OR eh.SrMgrLvl2_ID = @nvcEmpID));


SET @SelectList = @SelectList + ' UNION
SELECT ''My Team''''s Pending'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyTeamPending)+ ''' AS LogCount';
END


IF @bitMyTeamCompleted = 1
BEGIN
SET @intMyTeamCompleted = (SELECT COUNT(cl.CoachingID)
						   FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
						   ON cl.EmpID = eh.Emp_ID 
						   WHERE cl.[SourceID] NOT IN (235, 236) 
						   AND cl.StatusID = 1
						   AND (eh.Sup_ID = @nvcEmpID OR eh.Mgr_ID = @nvcEmpID OR eh.SrMgrLvl1_ID = @nvcEmpID OR eh.SrMgrLvl2_ID = @nvcEmpID));
						  


SET @SelectList = @SelectList + ' UNION
SELECT ''My Team''''s Completed'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyTeamCompleted)+ ''' AS LogCount';
END


IF @bitMyTeamWarning = 1 
BEGIN
SET @intMyTeamWarning = (SELECT COUNT(wl.WarningID)
					 FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log] wl WITH (NOLOCK)
					 ON wl.EmpID = eh.Emp_ID 
					 WHERE wl.StatusID <> 2
					 AND wl.siteID <> -1
					 AND eh.isSub = 'N'
					 AND (eh.Sup_ID = @nvcEmpID OR eh.Mgr_ID = @nvcEmpID OR eh.SrMgrLvl1_ID = @nvcEmpID OR eh.SrMgrLvl2_ID = @nvcEmpID)); 


SET @SelectList = @SelectList + ' UNION
SELECT ''My Team''''s Warnings'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyTeamWarning)+ ''' AS LogCount ';
END


IF @bitMySubmission = 1
BEGIN
SET @intMySubmission = (SELECT COUNT(CoachingID) FROM EC.Coaching_Log WITH (NOLOCK)
						WHERE SubmitterID = @nvcEmpID
						AND SubmitterID <> '999999'
						AND [SourceID] NOT IN (235, 236) 
						AND StatusID <> 2);


SET @SelectList = @SelectList + ' UNION
SELECT ''My Submissions'' AS CountType, '''+ CONVERT(NVARCHAR,@intMySubmission)+ ''' AS LogCount ';
END

  SET @nvcSQL = 
' WITH TempMain 
AS 
(
  SELECT DISTINCT x.CountType, x.LogCount 
  FROM 
  (
SELECT ''Count Type'' AS CountType, '''+ CONVERT(NVARCHAR,0)+ ''' AS LogCount '
+ @SelectList + ' ) x 
),
CountDisplay
AS 
(
SELECT CountType, SortOrder FROM 
(SELECT CASE WHEN [MyPending] = 1 THEN ''My Pending'' ELSE NULL END CountType, 01 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT CASE WHEN [MyFollowup] = 1 THEN ''My Follow-up'' ELSE NULL END CountType, 02 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
 SELECT	CASE WHEN [MyCompleted] = 1 THEN ''My Completed'' ELSE NULL END CountType, 05 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MyTeamPending] = 1 THEN ''My Team''''s Pending'' ELSE NULL END CountType, 03 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MyTeamcompleted] = 1 THEN ''My Team''''s Completed'' ELSE NULL END CountType, 04 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT CASE WHEN [MyTeamWarning] = 1 AND '''+@isSub+ ''' = ''N'' THEN ''My Team''''s Warnings'' ELSE NULL END CountType, 06 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MySubmission]= 1 THEN ''My Submissions'' ELSE NULL END CountType, 07 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ ''') Display 
WHERE CountType IS NOT NULL
 )

SELECT ct.CountType, ISNULL(LogCount, 0)LogCount 
FROM CountDisplay ct LEFT JOIN TempMain tm
ON ct.[CountType] =tm.CountType
ORDER BY ct.SortOrder'
	
EXEC (@nvcSQL)	
--PRINT @nvcSQL
	
-- Close Symmetric key
END -- sp_Dashboard_Summary_Count
GO



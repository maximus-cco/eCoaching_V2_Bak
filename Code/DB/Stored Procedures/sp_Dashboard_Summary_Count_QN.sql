
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dashboard_Summary_Count_QN' 
)
   DROP PROCEDURE [EC].[sp_Dashboard_Summary_Count_QN]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/3/2021
--  Description: Retrieves Count of QN Logs based on user Job Role.
--  on the MyDashboard Page.
--  Initial Revision. Quality Now workflow enhancement - TFS 22187 - 8/3/2021
--  Modified logic for My Teams Pending dashboard counts. TFS 23868 - 01/05/2022
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Dashboard_Summary_Count_QN] 
@nvcEmpID nvarchar(10)

AS

BEGIN
DECLARE	
@nvcEmpRole nvarchar(40),

@bitMyCompletedQN bit,
@bitMySubmissionQN bit,
@bitMyPendingQN bit,
@bitMyPendingFollowupPrepQN bit,
@bitMyPendingFollowupCoachQN bit,
@bitMyTeamPendingQN bit,
@bitMyTeamCompletedQN bit,

@intMyCompletedQN int,
@intMySubmissionQN int,
@intMyPendingQN int,
@intMyPendingFollowupPrepQN int,
@intMyPendingFollowupCoachQN int,
@intMyTeamPendingQN int,
@intMyTeamCompletedQN int,

@SelectList nvarchar(2000),
@nvcSQL nvarchar(max);




OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @nvcEmpRole = (SELECT [EC].[fn_strGetUserRole](@nvcEmpID));


SET @bitMyCompletedQN = (SELECT [MyCompletedQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMySubmissionQN = (SELECT [MySubmissionQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyPendingQN = (SELECT [MyPendingQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyPendingFollowupPrepQN = (SELECT [MyPendingFollowupPrepQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyPendingFollowupCoachQN = (SELECT [MyPendingFollowupCoachQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyTeamPendingQN = (SELECT [MyTeamPendingQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);
SET @bitMyTeamCompletedQN = (SELECT [MyTeamcompletedQN] FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = @nvcEmpRole);


 

SET @SelectList = '' 

IF @bitMyPendingQN = 1
BEGIN

IF @nvcEmpRole in ('CSR', 'ARC', 'Employee')
BEGIN
SET @intMyPendingQN = (SELECT COALESCE(COUNT(cl.CoachingID),0)
                 FROM EC.Coaching_Log cl 
                 WHERE cl.EmpID = @nvcEmpID  
				 AND StatusID in (4,13)
				 AND SourceID IN (235));
SET @SelectList = @SelectList + ' UNION
SELECT ''My Pending'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyPendingQN)+ ''' AS LogCount'
END


IF @nvcEmpRole  = 'Supervisor'
BEGIN
SET @intMyPendingQN = (SELECT COUNT(cl.CoachingID)
                 FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON cl.EmpID = eh.Emp_ID
                 WHERE ((cl.ReassignCount= 0 AND eh.Sup_ID = @nvcEmpID  AND StatusID = 6) 
				 OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = @nvcEmpID AND  StatusID = 6))
				 AND SourceID IN (235));

SET @SelectList = @SelectList + ' UNION
SELECT ''My Pending Review'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyPendingQN)+ ''' AS LogCount'		
END

END

--print @SelectList;

IF @bitMyPendingFollowupPrepQN = 1

BEGIN
SET @intMyPendingFollowupPrepQN = (SELECT COUNT(cl.CoachingID)
                 FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON cl.EmpID = eh.Emp_ID
                 WHERE ((cl.ReassignCount= 0 AND eh.Sup_ID = @nvcEmpID  AND StatusID = 11) 
				 OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = @nvcEmpID AND  StatusID = 11))
				 AND SourceID IN (235));

SET @SelectList = @SelectList + ' UNION
SELECT ''My Pending Follow-Up Preparation'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyPendingFollowupPrepQN)+ ''' AS LogCount '
END


IF @bitMyPendingFollowupCoachQN = 1

BEGIN
SET @intMyPendingFollowupCoachQN = (SELECT COUNT(cl.CoachingID)
                 FROM EC.Coaching_Log cl WITH (NOLOCK) JOIN EC.Employee_Hierarchy eh WITH (NOLOCK)
				 ON cl.EmpID = eh.Emp_ID
                 WHERE ((cl.ReassignCount= 0 AND eh.Sup_ID = @nvcEmpID  AND StatusID = 12) 
				 OR (cl.ReassignCount <> 0 AND cl.ReassignedToID = @nvcEmpID AND  StatusID = 12))
				 AND SourceID IN (235));

SET @SelectList = @SelectList + ' UNION
SELECT ''My Pending Follow-Up Coaching'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyPendingFollowupCoachQN)+ ''' AS LogCount '
END



IF @bitMyCompletedQN = 1

BEGIN
SET @intMyCompletedQN = (SELECT COUNT(CoachingID) FROM EC.Coaching_Log WITH (NOLOCK)
                       WHERE EmpID = @nvcEmpID  AND SourceID IN (235,236)
					   AND StatusID = 1 AND EmpID <> '999999');

SET @SelectList = @SelectList + ' UNION
SELECT ''My Completed'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyCompletedQN)+ ''' AS LogCount '
END



IF @bitMyTeamPendingQN = 1
BEGIN
SET @intMyTeamPendingQN = (SELECT COUNT(cl.CoachingID)
						 FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
						 ON cl.EmpID = eh.Emp_ID  
						 WHERE cl.StatusID NOT IN (1,2)
						 AND SourceID IN (235)
						 AND (eh.Sup_ID = @nvcEmpID OR eh.Mgr_ID = @nvcEmpID OR eh.SrMgrLvl1_ID = @nvcEmpID OR eh.SrMgrLvl2_ID = @nvcEmpID))


SET @SelectList = @SelectList + ' UNION
SELECT ''My Team''''s Pending'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyTeamPendingQN)+ ''' AS LogCount'
END


IF @bitMyTeamCompletedQN = 1
BEGIN
SET @intMyTeamCompletedQN = (SELECT COUNT(cl.CoachingID)
						   FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH (NOLOCK)
						   ON cl.EmpID = eh.Emp_ID 
						   WHERE cl.StatusID = 1
						   AND SourceID IN (235,236)
						   AND (eh.Sup_ID = @nvcEmpID OR eh.Mgr_ID = @nvcEmpID OR eh.SrMgrLvl1_ID = @nvcEmpID OR eh.SrMgrLvl2_ID = @nvcEmpID))
						  


SET @SelectList = @SelectList + ' UNION
SELECT ''My Team''''s Completed'' AS CountType, '''+ CONVERT(NVARCHAR,@intMyTeamCompletedQN)+ ''' AS LogCount'
END


IF @bitMySubmissionQN = 1
BEGIN
SET @intMySubmissionQN = (SELECT COUNT(CoachingID) FROM EC.Coaching_Log WITH (NOLOCK)
						WHERE SubmitterID = @nvcEmpID AND SubmitterID <> '999999'
						AND SourceID IN (235,236)
						AND StatusID <> 2)


SET @SelectList = @SelectList + ' UNION
SELECT ''My Submissions'' AS CountType, '''+ CONVERT(NVARCHAR,@intMySubmissionQN)+ ''' AS LogCount '
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
(SELECT CASE WHEN [MyPendingQN] = 1 THEN 
CASE '''+ @nvcEmpRole+ ''' WHEN ''Supervisor'' THEN ''My Pending Review'' ELSE ''My Pending'' END
ELSE NULL END CountType, 01 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT CASE WHEN [MyPendingFollowupPrepQN] = 1 THEN ''My Pending Follow-up Preparation'' ELSE NULL END CountType, 02 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
 SELECT	CASE WHEN [MyPendingFollowupCoachQN] = 1 THEN ''My Pending Follow-up Coaching'' ELSE NULL END CountType, 03 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MyTeamPendingQN] = 1 THEN ''My Team''''s Pending'' ELSE NULL END CountType, 04 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MyTeamcompletedQN] = 1 THEN ''My Team''''s Completed'' ELSE NULL END CountType, 05 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MyCompletedQN] = 1 THEN ''My Completed'' ELSE NULL END CountType, 06 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ '''
UNION
SELECT	CASE WHEN [MySubmissionQN]= 1 THEN ''My Submissions'' ELSE NULL END CountType, 07 SortOrder
FROM [EC].[UI_Dashboard_Summary_Display] WHERE [RoleName] = '''+ @nvcEmpRole+ ''') Display 
WHERE CountType IS NOT NULL
 )

SELECT ct.CountType, ISNULL(LogCount, 0)LogCount 
FROM CountDisplay ct LEFT JOIN TempMain tm
ON ct.[CountType] = tm.CountType
ORDER BY ct.SortOrder'



	
EXEC (@nvcSQL)	
--PRINT @nvcSQL
	
-- Close Symmetric key
END -- sp_Dashboard_Summary_Count_QN

GO




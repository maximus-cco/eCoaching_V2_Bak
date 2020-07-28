IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Pending_CoachingByWeek' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of Pending Coaching logs for selected month
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek] 
@strEMPSRMGRin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime

AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max),
  @strSrMgrEmpID nvarchar(10),
  @strSDate nvarchar(8),
  @strEDate nvarchar(8),
  @intStatusID INT,
  @whereStatus nvarchar(200);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
	
SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @nvcSQL = '
WITH PendingByWeeks 
AS 
-- First CTE query
(
  SELECT x.WeekNum, x.Status
  FROM 
  (
    SELECT * 
	FROM 
    (
	  SELECT FullDate, datediff(week, dateadd(month, datediff(month, 0, FullDate), 0), FullDate) + 1 WeekNum
      FROM EC.DIM_Date
      WHERE convert(varchar(8), Datekey) >= ''' + @strSDate + ''' 
	    AND convert(varchar(8), Datekey) <= ''' + @strEDate + ''' 
	) AS Dates,

    (
	  SELECT Status from EC.DIM_Status
      WHERE StatusId IN (3, 4, 5, 6, 7)
	) Pending
  ) x GROUP BY x.WeekNum, x.Status
), 

-- Second CTE query
Selected 
AS
(
  SELECT cl.CoachingID, cl.submitteddate, datediff(week, dateadd(month, datediff(month, 0, [cl].[SubmittedDate]), 0), [cl].[SubmittedDate]) + 1 WeekNum, s.Status
  FROM [EC].[Employee_Hierarchy] eh 
  JOIN [EC].[Coaching_Log]cl ON eh.Emp_ID = cl.EmpID 
  JOIN [EC].[DIM_Status]s ON cl.StatusID = s.StatusID 
  WHERE convert(varchar(8), [cl].[SubmittedDate], 112) >= ''' + @strSDate + ''' 
    AND convert(varchar(8), [cl].[SubmittedDate], 112) <= ''' + @strEDate + '''
    AND cl.StatusId IN (3, 4, 5, 6, 7)
    AND cl.ModuleID IN (1, 2)
    AND (eh.SrMgrLvl1_ID = ''' + @strSrMgrEmpID + ''' OR eh.SrMgrLvl2_ID = ''' + @strSrMgrEmpID + ''' OR eh.SrMgrLvl3_ID = ''' + @strSrMgrEmpID + ''')
    AND ''' + @strSrMgrEmpID + ''' <> ''999999''
) 
  
-- Select from the above 2 CTEs
SELECT PendingByWeeks.WeekNum, PendingByWeeks.Status, Count(Selected.CoachingID) LogCount
FROM PendingByWeeks 
LEFT OUTER JOIN Selected ON PendingByWeeks.WeekNum = Selected.WeekNum AND PendingByWeeks.Status = Selected.Status
GROUP BY PendingByWeeks.WeekNum, PendingByWeeks.Status 
ORDER BY PendingByWeeks.WeekNum, PendingByWeeks.Status';

--Print @nvcSQL	  
Exec (@nvcSQL) 

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 

END --sp_SelectFrom_SRMGR_Pending_CoachingByWeek
GO
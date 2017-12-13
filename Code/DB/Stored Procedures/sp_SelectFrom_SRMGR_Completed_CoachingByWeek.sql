IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Completed_CoachingByWeek' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of completed Coaching logs for selected month
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek] 
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

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()));

SET @nvcSQL = 'WITH CompletedByWeeks 
AS 
-- First CTE query
(
    Select x.WeekNum, x.Value
    FROM 
	(
	    SELECT * 
		FROM 
        (
		    SELECT FullDate, datediff(week, dateadd(month, datediff(month, 0, FullDate), 0), FullDate) + 1 WeekNum
            FROM EC.DIM_Date
            WHERE convert(varchar(8),Datekey) >= '''+@strSDate+''' 
	          AND convert(varchar(8),Datekey) <= '''+@strEDate+''' 
		) AS Dates,
        (
            SELECT Distinct Value from EC.Coaching_Log_Reason
            WHERE Value in (''Met goal'', ''Did not meet goal'', ''Opportunity'', ''Reinforcement'') 
		) AS ReasonValues
	) x
    GROUP BY x.WeekNum, x.Value
), 

-- Second CTE query
Selected 
AS
(
    SELECT cl.CoachingID,  cl.CSRReviewAutoDate, datediff(week, dateadd(month, datediff(month, 0, [cl].[CSRReviewAutoDate]), 0), [cl].[CSRReviewAutoDate]) + 1 WeekNum, clr.Value
    FROM [EC].[Employee_Hierarchy] eh 
	JOIN [EC].[Coaching_Log]cl ON eh.Emp_ID = cl.EmpID 
	JOIN [EC].[Coaching_Log_Reason]clr ON cl.CoachingID = clr.CoachingID 
    WHERE convert(varchar(8), [cl].[CSRReviewAutoDate], 112) >= '''+@strSDate+''' 
	  AND convert(varchar(8), [cl].[CSRReviewAutoDate], 112) <= '''+@strEDate+'''
      AND cl.StatusId = 1
      AND cl.ModuleID in (1,2)
      AND (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
      AND '''+@strSrMgrEmpID+''' <> ''999999''
)

-- Select from the above 2 CTEs  
SELECT CompletedByWeeks.WeekNum, CompletedByWeeks.Value, Count(Selected.CoachingID)LogCount
FROM CompletedByWeeks 
LEFT OUTER JOIN Selected ON CompletedByWeeks.WeekNum = Selected.WeekNum AND CompletedByWeeks.Value = Selected.Value
GROUP BY CompletedByWeeks.WeekNum, CompletedByWeeks.Value 
ORDER BY CompletedByWeeks.WeekNum, CompletedByWeeks.Value'

Exec (@nvcSQL) 

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	

END --sp_SelectFrom_SRMGR_Completed_CoachingByWeek
GO
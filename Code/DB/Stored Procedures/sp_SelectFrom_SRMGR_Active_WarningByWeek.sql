/*
sp_SelectFrom_SRMGR_Active_WarningByWeek(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_Active_WarningByWeek' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Count of Active Warning logs for selected month
--  that fall under the logged in Sr Mgr.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek] 
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
	@whereStatus nvarchar(200) 
	
SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

PRINT @strSDate
PRINT @strEDate

SET @strSrMgrEmpID = (SELECT [EC].[fn_nvcGetEmpIdFromLanId] (@strEMPSRMGRin, GETDATE()))

SET @nvcSQL = 'WITH ReasonsByWeeks AS 
(
Select x.WeekNum, x.CoachingReason
 FROM (SELECT * FROM 
  (Select FullDate,
datediff(week, dateadd(month, datediff(month, 0, FullDate), 0), FullDate) +1 WeekNum
FROM EC.DIM_Date
WHERE convert(varchar(8),Datekey) >= '''+@strSDate+''' 
	AND convert(varchar(8),Datekey) <= '''+@strEDate+''' )Dates,
 (Select CoachingReason from EC.DIM_Coaching_Reason
Where CoachingReasonID in (28,29,30))Reasons)x
GROUP BY x.WeekNum, x.CoachingReason
), Selected AS
 (SELECT wl.warningID,  wl.submitteddate, datediff(week, dateadd(month, datediff(month, 0, [wl].[SubmittedDate]), 0), [wl].[SubmittedDate]) +1 WeekNum, dcr.CoachingReason
  FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Warning_Log]wl
  ON eh.Emp_ID = wl.EmpID JOIN [EC].[Warning_Log_Reason]wlr 
  ON wl.WarningID = wlr.WarningID JOIN EC.DIM_Coaching_Reason dcr 
  ON dcr.CoachingReasonID = wlr.CoachingReasonID
  WHERE convert(varchar(8),[wl].[SubmittedDate],112) >= '''+@strSDate+''' 
	AND convert(varchar(8),[wl].[SubmittedDate],112) <= '''+@strEDate+'''
  AND wl.Active = 1
  AND wl.StatusID = 1
  AND wl.ModuleID in (1,2)
  AND (eh.SrMgrLvl1_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl2_ID = '''+@strSrMgrEmpID+''' OR eh.SrMgrLvl3_ID = '''+@strSrMgrEmpID+''')
  AND '''+@strSrMgrEmpID+''' <> ''999999''
  AND wlr.CoachingReasonID in (28,29,30)) 
  
  Select ReasonsByWeeks.WeekNum, ReasonsByWeeks.CoachingReason, Count(Selected.WarningID)LogCount
  From ReasonsByWeeks LEFT OUTER JOIN Selected
  ON ReasonsByWeeks.WeekNum = Selected.WeekNum
   AND ReasonsByWeeks.CoachingReason = Selected.CoachingReason
  GROUP BY ReasonsByWeeks.WeekNum, ReasonsByWeeks.CoachingReason 
  ORDER BY ReasonsByWeeks.WeekNum, ReasonsByWeeks.CoachingReason '

  

--Print @nvcSQL	  
Exec (@nvcSQL) 
END --sp_SelectFrom_SRMGR_Active_WarningByWeek



GO


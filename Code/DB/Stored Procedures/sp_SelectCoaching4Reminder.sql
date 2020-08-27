/*
Last Modified Date: 08/08/2020
Last Modified By: Susmitha Palacherla

Version 02: Updated to support WAH return to Site - TFS 18255 - 08/26/2020
Version 01: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019

*/
IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectCoaching4Reminder' 
)
   DROP PROCEDURE [EC].[sp_SelectCoaching4Reminder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:		       Susmitha Palacherla
--	Create Date:	   02/09/2016
--	Description: 	   This procedure queries db for Failed Quality and LCSAT records that are past 
--  the Coaching SLA and sends Reminders to Supervisors and or Managers.
--  Initial revision per TFS Change request 1710 - 02/09/2016
--  Updated to limit to 2 reminders per status per TFS 2145 - 3/2/2016
--  Updated to replace Hierarchy mgr with Review mgr for LCS Mgr recipients per TFS 2182 - 3/8/2016
--  Modified per TFS 4353 to update recipients for reassigned logs - 10/21/2016
--  Modified per TFS 7646 to add reminders for DTT logs - 09/14/2017
--  Modified per TFS 8597 to modify DTT reminders to use Notification date - 10/12/2017
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--  Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
-- Updated to support WAH return to Site - TFS 18255 - 08/26/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4Reminder]
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max),
  @nvcSQL1 nvarchar(max),
  @nvcSQL2 nvarchar(max),
  @nvcSQL3 nvarchar(max),
  @nvcSQL4 nvarchar(max),
  @intHrs1 int,
  @intHrs2 int;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

-- Variables used for the diferent reminder periods.
-- Quality and DTT reminders are set at 48 hrs
-- OMR reminders are set at 72 hrs
SET @intHrs1 = 48;
SET @intHrs2 = 72;
SET @nvcSQL1 = '
;WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID 
    ,x.numID 
    ,x.strEmpID 
    ,x.strStatus 
    ,x.strSubCoachingSource
    ,x.strvalue 
    ,x.strMgr
    ,x.Remind 
    ,x.RemindCC 
    ,x.NotificationDate	
    ,x.ReminderSent	
    ,x.ReminderDate	
    ,x.ReminderCount   
    ,x.ReassignDate   
    ,x.ReassignCount
    ,x.ReassignToID
	,x.LogType
FROM 
-- Verint-GDIT Logs
  (  
    SELECT cl.CoachingID numID	
      ,cl.FormName strFormID
      ,cl.EmpID strEmpID
      ,s.Status strStatus
      ,so.SubCoachingSource strSubCoachingSource
      ,clr.value strValue
      ,ISNULL(cl.MgrID,''999999'') strMgr
      ,cl.NotificationDate NotificationDate
      ,cl.ReminderSent ReminderSent
      ,cl.ReminderDate ReminderDate
      ,cl.ReminderCount ReminderCount
      ,cl.ReassignDate ReassignDate 
      ,cl.ReassignCount ReassignCount
      ,cl.ReassignedToID ReassignToID
      ,CASE
         WHEN (ReminderSent = ''False'' AND DATEDIFF(HH, ISNULL([ReassignDate], [NotificationDate]), GetDate()) >  ''' + CONVERT(VARCHAR, @intHrs1) + ''' ) THEN ''Sup''
         WHEN (ReminderSent = ''True'' AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) >''' + CONVERT(VARCHAR, @intHrs1) + ''' ) THEN ''Sup''
         ELSE ''NA'' 
       END Remind
      ,CASE
         WHEN (ReminderSent = ''False'' AND DATEDIFF(HH, ISNULL([ReassignDate], [NotificationDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''' ) THEN ''Mgr''
         WHEN (ReminderSent = ''True'' AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''' ) THEN ''Mgr/SrMgr''
         ELSE ''NA'' 
       END RemindCC,
	   1 LogType
    FROM [EC].[Coaching_Log] cl WITH (NOLOCK)
    JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.coachingid = clr.coachingid 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID
    WHERE cl.Statusid = 6
      AND cl.SourceID = 223
      AND cl.EmailSent = ''True''
      AND clr.Value = ''Did not meet goal''
      AND (
	        (ReminderSent = ''False'' AND DATEDIFF(HH, ISNULL([ReassignDate], [NotificationDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''')
	        OR (ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''')
          )
';

-- LCS OMR Logs
SET @nvcSQL2 = ' 
    UNION 
    SELECT cl.CoachingID numID	
      ,cl.FormName strFormID
      ,cl.EmpID strEmpID
      ,s.Status strStatus
      ,so.SubCoachingSource strSubCoachingSource
      ,clr.value strValue
      ,ISNULL(cl.MgrID, ''999999'') strMgr
      ,cl.NotificationDate NotificationDate
      ,cl.ReminderSent ReminderSent
      ,cl.ReminderDate ReminderDate
      ,cl.ReminderCount ReminderCount
      ,cl.ReassignDate ReassignDate 
      ,cl.ReassignCount ReassignCount
      ,cl.ReassignedToID ReassignToID
      ,CASE
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 5 AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''ReviewMgr''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 5 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2)+''') THEN ''ReviewMgr''
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 6 AND DATEDIFF(HH, ISNULL([ReassignDate], [MgrReviewAutoDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Sup''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 6 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Sup''
         ELSE ''NA'' 
       END Remind
      ,CASE
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 5 AND DATEDIFF(HH, ISNULL([ReassignDate], [NotificationDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''ReviewSrMgr''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 5 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''ReviewSrMgr''
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 6 AND DATEDIFF(HH, ISNULL([ReassignDate],[MgrReviewAutoDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Mgr''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 6 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Mgr/SrMgr''
         ELSE ''NA'' 
       END RemindCC,
	   1 LogType
    FROM  [EC].[Coaching_Log] cl WITH (NOLOCK)
    JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.coachingid = clr.coachingid 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID
    WHERE clr.SubCoachingreasonID = 34 
      AND (
	        (cl.Statusid = 5 AND clr.Value   = ''Research Required'') 
			OR (cl.Statusid = 6 AND clr.Value   = ''Opportunity'')
          )
      AND cl.EmailSent = ''True''
      AND (
	        (ReminderSent = ''False'' AND cl.Statusid = 5 AND DATEDIFF(HH, ISNULL([ReassignDate], [NotificationDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''')
			OR (ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate], [ReminderDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''')
			OR (ReminderSent = ''False'' AND cl.Statusid = 6 AND DATEDIFF(HH, ISNULL([ReassignDate], [MgrReviewAutoDate]), GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''')
          )
  UNION
  -- WAH Return To Site Logs
      SELECT cl.CoachingID numID	
      ,cl.FormName strFormID
      ,cl.EmpID strEmpID
      ,s.Status strStatus
      ,''WAH-RTS'' strSubCoachingSource /* Adjusted to address Employee in mailbody */
      ,clr.value strValue
      ,ISNULL(cl.MgrID, ''999999'') strMgr
      ,cl.NotificationDate NotificationDate
      ,cl.ReminderSent ReminderSent
      ,cl.ReminderDate ReminderDate
      ,cl.ReminderCount ReminderCount
      ,cl.ReassignDate ReassignDate 
      ,cl.ReassignCount ReassignCount
      ,cl.ReassignedToID ReassignToID
      ,CASE
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.SubmittedDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Emp''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.ReminderDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Emp''
         ELSE ''NA'' 
       END Remind
      ,CASE
          WHEN (ReminderSent = ''False'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.SubmittedDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Sup''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.ReminderDate,GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''') THEN ''Sup/Mgr''
         ELSE ''NA'' 
       END RemindCC,
	   1 LogType
    FROM  [EC].[Coaching_Log] cl WITH (NOLOCK)
    JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.coachingid = clr.coachingid 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID
       WHERE clr.CoachingReasonID = 63 AND clr.SubCoachingreasonID IN (277, 278, 279, 280)
      AND cl.StatusID = 4
      AND cl.EmailSent = ''True''
      AND (
	 	   (ReminderSent = ''False'' AND DATEDIFF(HH, cl.SubmittedDate,GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''')
			OR (ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, cl.ReminderDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs2) + ''')
          )
';

--DTT Logs
SET @nvcSQL3 = ' 
    UNION 
    SELECT cl.CoachingID numID	
      ,cl.FormName strFormID
      ,cl.EmpID strEmpID
      ,s.Status strStatus
      ,so.SubCoachingSource strSubCoachingSource
      ,clr.value strValue
      ,ISNULL(cl.MgrID,''999999'') strMgr
      ,cl.NotificationDate NotificationDate
      ,cl.ReminderSent ReminderSent
      ,cl.ReminderDate ReminderDate
      ,cl.ReminderCount ReminderCount
      ,cl.ReassignDate ReassignDate 
      ,cl.ReassignCount ReassignCount
      ,cl.ReassignedToID ReassignToID
      ,CASE
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.NotificationDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Emp''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.ReminderDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Emp''
         ELSE ''NA'' 
       END Remind
      ,CASE
         WHEN (ReminderSent = ''False'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.NotificationDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Sup''
         WHEN (ReminderSent = ''True'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.ReminderDate,GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Sup/Mgr''
         ELSE ''NA'' 
       END RemindCC,
	  1 LogType
    FROM  [EC].[Coaching_Log] cl WITH (NOLOCK)
    JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.coachingid = clr.coachingid 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID
    WHERE clr.CoachingreasonID = 3
      AND clr.SubCoachingreasonID = 242
      AND cl.Statusid = 4 
      AND cl.NotificationDate IS NOT NULL
      AND (
	        (ReminderSent = ''False'' AND DATEDIFF(HH, cl.NotificationDate,GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''')
			OR (ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, cl.ReminderDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''')
      )
	  -- Warning Logs
	  UNION 
SELECT wl.WarningID numID	
      ,wl.FormName strFormID
      ,wl.EmpID strEmpID
      ,s.Status strStatus
      ,so.SubCoachingSource strSubCoachingSource
      ,wlr.value strValue
      ,ISNULL(wl.MgrID,''999999'') strMgr
      ,wl.SubmittedDate NotificationDate
      ,wl.ReminderSent ReminderSent
      ,wl.ReminderDate ReminderDate
      ,wl.ReminderCount ReminderCount
      ,NULL ReassignDate 
      ,0 ReassignCount
      ,NULL ReassignToID
      ,CASE
         WHEN (wl.ReminderSent = ''False'' AND wl.Statusid = 4 AND DATEDIFF(HH, wl.SubmittedDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Emp''
         WHEN (wl.ReminderSent = ''True'' AND wl.Statusid = 4 AND DATEDIFF(HH, wl.ReminderDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Emp''
         ELSE ''NA'' 
       END Remind
      ,CASE
         WHEN (wl.ReminderSent = ''False'' AND wl.Statusid = 4 AND DATEDIFF(HH, wl.SubmittedDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Sup/Mgr''
         WHEN (ReminderSent = ''True'' AND wl.Statusid = 4 AND DATEDIFF(HH, wl.ReminderDate,GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''') THEN ''Sup/Mgr''
         ELSE ''NA'' 
       END RemindCC,
	  2 LogType
    FROM  [EC].[Warning_Log] wl WITH (NOLOCK)
    JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK) ON wl.WarningID = wlr.WarningID 
    JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
    JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID
    WHERE wl.Statusid = 4 
     AND (
	        (ReminderSent = ''False'' AND DATEDIFF(HH, wl.SubmittedDate,GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''')
		OR (ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, wl.ReminderDate, GetDate()) > ''' + CONVERT(VARCHAR, @intHrs1) + ''')
        )
	  
';

SET @nvcSQL4 = '
  ) x )
  SELECT 
    numid CoachingID
    ,strFormID
    ,strStatus
    ,strSubCoachingSource
    ,strValue
    ,CASE 
	   WHEN (Remind = ''Emp'') THEN veh.Emp_Email
       WHEN ( ReassignCount = 0  AND Remind = ''Sup'') THEN veh.Sup_Email
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND Remind = ''Sup'') THEN [EC].[fn_strEmpEmailFromEmpID](ReassignToID)		
       WHEN ( ReassignCount = 0  AND Remind = ''Mgr'') THEN veh.Mgr_Email
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND Remind = ''Mgr'') THEN [EC].[fn_strEmpEmailFromEmpID](ReassignToID)	
       WHEN ( ReassignCount = 0  AND Remind = ''ReviewMgr'') THEN [EC].[fn_strEmpEmailFromEmpID](strMgr)
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND Remind = ''ReviewMgr'') THEN [EC].[fn_strEmpEmailFromEmpID](ReassignToID)		
       ELSE '''' 
	 END strToEmail
    ,CASE 
	   WHEN (RemindCC = ''Sup'') THEN veh.Sup_Email
       WHEN  (RemindCC = ''Sup/Mgr'') THEN veh.Sup_Email + '';'' + veh.Mgr_Email
       WHEN ( ReassignCount = 0  AND RemindCC = ''Mgr'') THEN veh.Mgr_Email	
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND RemindCC = ''Mgr'') THEN [EC].[fn_strSupEmailFromEmpID](ReassignToID)
       WHEN ( ReassignCount = 0  AND RemindCC = ''SrMgr'') THEN [EC].[fn_strEmpEmailFromEmpID](eh.SrMgrLvl1_ID)
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND RemindCC = ''SrMgr'') THEN [EC].[fn_strMgrEmailFromEmpID](ReassignToID)
       WHEN ( ReassignCount = 0  AND RemindCC = ''ReviewSrMgr'') THEN [EC].[fn_strSupEmailFromEmpID](strMgr)
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND RemindCC = ''ReviewSrMgr'') THEN [EC].[fn_strSupEmailFromEmpID](ReassignToID)
       WHEN ( ReassignCount = 0  AND RemindCC = ''Mgr/SrMgr'') THEN veh.Mgr_Email + '';'' + [EC].[fn_strEmpEmailFromEmpID](eh.SrMgrLvl1_ID)
       WHEN ( ReassignCount <> 0 AND ReassignToID IS NOT NULL AND RemindCC = ''Mgr/SrMgr'') THEN [EC].[fn_strSupEmailFromEmpID](ReassignToID) + '';'' + [EC].[fn_strMgrEmailFromEmpID](ReassignToID)
       ELSE '''' 
	 END strCCEmail
    ,NotificationDate	
    ,ReminderSent	
    ,ReminderDate	
    ,ReminderCount   
    ,ReassignDate
	,LogType
  FROM TempMain T
  JOIN [EC].[Employee_Hierarchy] eh ON T.strEmpID = eh.Emp_ID
  JOIN [EC].[View_Employee_Hierarchy] veh ON eh.Emp_ID = veh.Emp_ID
  WHERE veh.emp_Email IS NOT NULL 
    OR veh.Emp_Email <> '''' 
	OR veh.Sup_Email IS NOT NULL 
	OR veh.Sup_Email <> '''' 
	OR veh.Mgr_Email IS NOT NULL 
	OR veh.Mgr_Email <> ''''
  ORDER BY NotificationDate desc
';
        
SET @nvcSQL = @nvcSQL1 + @nvcSQL2 + @nvcSQL3 + @nvcSQL4
EXEC (@nvcSQL)	
PRINT @nvcSQL
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	 
	    
END --sp_SelectCoaching4Reminder
GO



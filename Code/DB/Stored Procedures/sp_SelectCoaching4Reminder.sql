/*
sp_SelectCoaching4Reminder(02).sql
Last Modified Date: 09/14/2017
Last Modified By: Susmitha Palacherla


Version 02: Added reminders for DTT logs - TFS 7646  - 09/14/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectCoaching4Reminder' 
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
@intHrs2 int

-- Variables used for the diferent reminder periods.
-- Quality and DTT reminders are set at 48 hrs
-- OMR reminders are set at 72 hrs

SET @intHrs1 = 48 
SET @intHrs2 = 72

SET @nvcSQL1 = ';WITH TempMain AS 
        (select DISTINCT x.strFormID 
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
FROM 
	
-- Verint-GDIT Logs

(SELECT   cl.CoachingID	numID	
		,cl.FormName	strFormID
		,cl.EmpID strEmpID
		,s.Status strStatus
		,so.SubCoachingSource strSubCoachingSource
		,clr.value strValue
		,ISNULL(cl.MgrID,''999999'') strMgr
		,cl.NotificationDate	NotificationDate
		,cl.ReminderSent	ReminderSent
		,cl.ReminderDate	ReminderDate
		,cl.ReminderCount   ReminderCount
		,cl.ReassignDate    ReassignDate 
		,cl.ReassignCount   ReassignCount
		,cl.ReassignedToID    ReassignToID
		, CASE
		WHEN (ReminderSent = ''False'' AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]),GetDate()) >  '''+CONVERT(VARCHAR,@intHrs1)+''' ) THEN ''Sup''
		WHEN (ReminderSent = ''True'' AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) >'''+CONVERT(VARCHAR,@intHrs1)+''' )THEN ''Sup''
		ELSE ''NA'' END Remind
		,CASE
		WHEN (ReminderSent = ''False'' AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''' ) THEN ''Mgr''
		WHEN (ReminderSent = ''True'' AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''' )THEN ''Mgr/SrMgr''
		ELSE ''NA'' END RemindCC
FROM  [EC].[Coaching_Log] cl WITH (NOLOCK)
 JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
 ON cl.coachingid = clr.coachingid JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID
WHERE cl.Statusid = 6
AND cl.SourceID = 223
AND cl.EmailSent = ''True''
AND clr.Value   = ''Did not meet goal''
AND ((ReminderSent = ''False'' AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''' )OR
(ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''' ))'

-- LCS OMR Logs

SET @nvcSQL2 = ' UNION 
SELECT   cl.CoachingID	numID	
			,cl.FormName	strFormID
		,cl.EmpID strEmpID
		,s.Status strStatus
		,so.SubCoachingSource strSubCoachingSource
		,clr.value strValue
		,ISNULL(cl.MgrID,''999999'') strMgr
		,cl.NotificationDate	NotificationDate
		,cl.ReminderSent	ReminderSent
		,cl.ReminderDate	ReminderDate
		,cl.ReminderCount   ReminderCount
		,cl.ReassignDate    ReassignDate 
		,cl.ReassignCount   ReassignCount
		,cl.ReassignedToID    ReassignToID
		, CASE
		WHEN (ReminderSent = ''False'' AND cl.Statusid = 5 AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''') THEN ''ReviewMgr''
		WHEN (ReminderSent = ''True'' AND cl.Statusid = 5 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')THEN ''ReviewMgr''
		WHEN (ReminderSent = ''False'' AND cl.Statusid = 6 AND DATEDIFF(HH, ISNULL([ReassignDate],[MgrReviewAutoDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')THEN ''Sup''
		WHEN (ReminderSent = ''True'' AND cl.Statusid = 6 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')THEN ''Sup''
		ELSE ''NA'' END Remind
	  , CASE
		WHEN (ReminderSent = ''False'' AND cl.Statusid = 5 AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''') THEN ''ReviewSrMgr''
		WHEN (ReminderSent = ''True'' AND cl.Statusid = 5 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')THEN ''ReviewSrMgr''
		WHEN (ReminderSent = ''False'' AND cl.Statusid = 6 AND DATEDIFF(HH, ISNULL([ReassignDate],[MgrReviewAutoDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')THEN ''Mgr''
		WHEN (ReminderSent = ''True'' AND cl.Statusid = 6 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')THEN ''Mgr/SrMgr''
		ELSE ''NA'' END RemindCC
FROM  [EC].[Coaching_Log] cl WITH (NOLOCK)
 JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
 ON cl.coachingid = clr.coachingid JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID
WHERE clr.SubCoachingreasonID = 34 
AND ((cl.Statusid = 5 AND clr.Value   = ''Research Required'') OR 
(cl.Statusid = 6 AND clr.Value   = ''Opportunity''))
AND cl.EmailSent = ''True''
AND ((ReminderSent = ''False'' AND cl.Statusid = 5 AND DATEDIFF(HH, ISNULL([ReassignDate],[NotificationDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')OR
(ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, [EC].[fnGetMaxDateTime]([ReassignDate],[ReminderDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+''')OR
(ReminderSent = ''False'' AND cl.Statusid = 6 AND DATEDIFF(HH, ISNULL([ReassignDate],[MgrReviewAutoDate]),GetDate()) > '''+CONVERT(VARCHAR,@intHrs2)+'''))'

--DTT Logs

SET @nvcSQL3 = ' UNION 
SELECT   cl.CoachingID	numID	
		,cl.FormName	strFormID
		,cl.EmpID strEmpID
		,s.Status strStatus
		,so.SubCoachingSource strSubCoachingSource
		,clr.value strValue
		,ISNULL(cl.MgrID,''999999'') strMgr
		,cl.NotificationDate	NotificationDate
		,cl.ReminderSent	ReminderSent
		,cl.ReminderDate	ReminderDate
		,cl.ReminderCount   ReminderCount
		,cl.ReassignDate    ReassignDate 
		,cl.ReassignCount   ReassignCount
		,cl.ReassignedToID    ReassignToID
		, CASE
		WHEN (ReminderSent = ''False'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.SupReviewedAutoDate,GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''') THEN ''Emp''
		WHEN (ReminderSent = ''True'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.ReminderDate,GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''')THEN ''Emp''
		ELSE ''NA'' END Remind
	  , CASE
		WHEN (ReminderSent = ''False'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.SupReviewedAutoDate,GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''') THEN ''Sup''
		WHEN (ReminderSent = ''True'' AND cl.Statusid = 4 AND DATEDIFF(HH, cl.ReminderDate,GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''')THEN ''Sup/Mgr''
		ELSE ''NA'' END RemindCC
FROM  [EC].[Coaching_Log] cl WITH (NOLOCK)
 JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK)
 ON cl.coachingid = clr.coachingid JOIN [EC].[DIM_Status] s
ON cl.StatusID = s.StatusID JOIN [EC].[DIM_Source] so
ON cl.SourceID = so.SourceID
WHERE clr.CoachingreasonID = 3
AND clr.SubCoachingreasonID = 242
AND cl.Statusid = 4 
AND cl.SupReviewedAutoDate is not NULL
AND ((ReminderSent = ''False'' AND DATEDIFF(HH, cl.SupReviewedAutoDate,GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+''')OR
(ReminderSent = ''True'' AND [ReminderCount] < 2 AND DATEDIFF(HH, cl.ReminderDate,GetDate()) > '''+CONVERT(VARCHAR,@intHrs1)+'''))'


SET @nvcSQL4 = 
 ' ) x )SELECT 
         numid CoachingID
        ,strFormID
		,strStatus
		,strSubCoachingSource
		,strValue
		,CASE WHEN (Remind = ''Emp'') THEN eh.Emp_Email
		     WHEN ( ReassignCount = 0  AND Remind = ''Sup'') THEN eh.Sup_Email
			 WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND Remind = ''Sup'') THEN [EC].[fn_strEmpEmailFromEmpID](ReassignToID)		
		     WHEN ( ReassignCount = 0  AND Remind = ''Mgr'') THEN eh.Mgr_Email
		     WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND Remind = ''Mgr'') THEN [EC].[fn_strEmpEmailFromEmpID](ReassignToID)	
		     WHEN ( ReassignCount = 0  AND Remind = ''ReviewMgr'') THEN [EC].[fn_strEmpEmailFromEmpID](strMgr)
		     WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND Remind = ''ReviewMgr'') THEN [EC].[fn_strEmpEmailFromEmpID](ReassignToID)		
		      ELSE '''' END strToEmail
		,CASE WHEN (RemindCC = ''Sup'') THEN eh.Sup_Email
		     WHEN  (RemindCC = ''Sup/Mgr'') THEN eh.Sup_Email + '';'' + eh.Mgr_Email
		     WHEN ( ReassignCount = 0  AND RemindCC = ''Mgr'') THEN eh.Mgr_Email	
			 WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND RemindCC = ''Mgr'') THEN [EC].[fn_strSupEmailFromEmpID](ReassignToID)
		     WHEN ( ReassignCount = 0  AND RemindCC = ''SrMgr'') THEN [EC].[fn_strEmpEmailFromEmpID](eh.SrMgrLvl1_ID)
		     WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND RemindCC = ''SrMgr'') THEN [EC].[fn_strMgrEmailFromEmpID](ReassignToID)
		     WHEN ( ReassignCount = 0  AND RemindCC = ''ReviewSrMgr'') THEN [EC].[fn_strSupEmailFromEmpID](strMgr)
		     WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND RemindCC = ''ReviewSrMgr'') THEN [EC].[fn_strSupEmailFromEmpID](ReassignToID)
		     WHEN ( ReassignCount = 0  AND RemindCC = ''Mgr/SrMgr'') THEN eh.Mgr_Email + '';'' +[EC].[fn_strEmpEmailFromEmpID](eh.SrMgrLvl1_ID)
		     WHEN ( ReassignCount <> 0 AND ReassignToID is not NULL AND RemindCC = ''Mgr/SrMgr'') THEN [EC].[fn_strSupEmailFromEmpID](ReassignToID) + '';'' + [EC].[fn_strMgrEmailFromEmpID](ReassignToID)
		      ELSE '''' END strCCEmail
		 ,NotificationDate	
		,ReminderSent	
		,ReminderDate	
		,ReminderCount   
		,ReassignDate
	   	FROM TempMain T JOIN [EC].[Employee_Hierarchy] eh 
	   	ON T.strEmpID  = eh.Emp_ID
	   	WHERE (eh.emp_Email is not NULL or eh.Emp_Email <> '''' OR eh.Sup_Email is not NULL OR eh.Sup_Email <> '''' OR eh.Mgr_Email is not NULL OR eh.Mgr_Email <> '''')
	   	ORDER BY NotificationDate desc'

        
SET @nvcSQL = @nvcSQL1 +   @nvcSQL2 +   @nvcSQL3 +   @nvcSQL4
EXEC (@nvcSQL)	
	    
--print @nvcsql  
	    
END --sp_SelectCoaching4Reminder






GO



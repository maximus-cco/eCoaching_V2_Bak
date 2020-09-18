/*
sp_SelectReviewFrom_Coaching_Log(21).sql
Last Modified Date: 09/15/2020
Last Modified By: Susmitha Palacherla

Version 21: Changes to suppport Incentives Data Discrepancy feed - TFS 18154 - 09/15/2020
Version 20: Updated to add SrMgr details to return. TFS 18062 - 08/13/2020
Version 19: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
Version 18: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 17: Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  09/09/2019
Version 16: Modified to incorporate ATT AP% Attendance feeds. TFS 15095 - 08/26/2019
Version 15: Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/5/2019
Version 14: Modified to support separate MSR feed source. TFS 14401 - 05/14/2019
Version 13: Modified to add ConfirmedCSE. TFS 14049 - 04/26/2019
Version 12: Modified to incorporate Quality Now. TFS 13332 - 03/19/2019
Version 11: Modified to support OTA Report. TFS 12591 - 11/26/2018
Version 10: New PBH Feed - TFS 11451 - 7/30/2018
Version 09 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018
Version 08: Modified to support additional Modules per TFS 8793 - 11/16/2017
Version 07: Modified to use LEFT Join on Submitter table for unknown Submitters - TFS 7541 - 09/19/2017
Version 06: New OTH DTT - TFS 7646 - 9/1/2017
Version 05: Updated to incorporate HNC and ICC Reports per TFS 7174 - 07/24/2017
Version 04: Updated to support MSR and MSRS Feeds. TFS 6147 - 06/02/2017
Version 03: New Breaks BRN and BRL feeds - TFS 6145 - 4/13/2017
Version 02: New quality NPN feed - TFS 5309 - 2/3/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Coaching Log attributes for given Form Name.
--  SQL split into 3 parts to overcome sql string size restriction.
--  Last Updated By: Susmitha Palacherla
--  Last 5 Change Descriptions shown.
--  Updated to incorporate a follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
--  Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
--  Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--  Updated to add SrMgr details to return. TFS 18062 - 08/13/2020
--  Changes to suppport Incentives Data Discrepancy feed - TFS 18154 - 09/15/2020
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log] @intLogId BIGINT
AS

BEGIN

DECLARE	

  @nvcSQL nvarchar(max)= '',
  @nvcSQL1 nvarchar(max)= '',
  @nvcSQL2 nvarchar(max)= '',
  @nvcSQL3 nvarchar(max)= '',
  @nvcEmpID nvarchar(10),
  @nvcMgrID nvarchar(10);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcEmpID = (SELECT [EmpID] From [EC].[Coaching_Log] WHERE [CoachingID] = @intLogId);	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID);

SET @nvcSQL1 = @nvcSQL1 +  N'
SELECT cl.CoachingID numID,
  cl.FormName strFormID,
  cl.ModuleID,
  m.Module,
  sc.CoachingSource	strFormType,
  cl.StatusId strStatusID,
  s.Status strFormStatus,
  --CASE WHEN cc.WAH_RTS IS NOT NULL THEN NULL ELSE cl.EventDate END EventDate,
  --CASE WHEN cc.WAH_RTS IS NOT NULL THEN COALESCE(cl.EventDate, cl.CoachingDate)  ELSE  cl.CoachingDate END CoachingDate,
  cl.EventDate,
  cl.CoachingDate,
  cl.SubmitterID strSubmitterID,
  cl.SupID strCLSupID,
  cl.MgrID strCLMgrID,
  vehSubmitter.Emp_LanID strSubmitter,		
  vehSubmitter.Emp_Name strSubmitterName,
  vehSubmitter.Emp_Email strSubmitterEmail,	
  cl.EmpID strEmpID,		
  veh.Emp_LanID strEmpLanID,
  veh.Emp_Name strEmpName,
  veh.Emp_Email strEmpEmail,
  st.City strEmpSite,
  eh.Sup_ID strEmpSupID,
  veh.Sup_LanID strEmpSup,
  veh.Sup_Name strEmpSupName,
  veh.Sup_Email strEmpSupEmail,
  CASE 
    WHEN (cl.[statusId] IN (6, 8, 10) AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[statusId] = 5 AND cl.[ModuleID] = 2 AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[Review_SupID] IS NOT NULL AND cl.[Review_SupID] = cl.[ReassignedToID] AND cl.[FollowupSupID] IS NULL AND [ReassignCount]= 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_SupID])
	     WHEN (cl.[FollowupSupID] IS NOT NULL AND cl.[FollowupSupID] = cl.[ReassignedToID] AND [ReassignCount]= 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[FollowupSupID])
    ELSE ''NA''
  END strReassignedSupName,	
  eh.Mgr_ID strEmpMgrID,
  CASE 
    WHEN cl.[strReportCode] LIKE ''LCS%'' THEN [EC].[fn_strEmpLanIDFromEmpID](cl.[MgrID])
    ELSE veh.Mgr_LanID 
  END strEmpMgr,
  CASE
    WHEN cl.[strReportCode] LIKE ''LCS%'' AND cl.[MgrID] <> ''' + @nvcMgrID + ''' THEN [EC].[fn_strEmpNameFromEmpID](cl.[MgrID]) + '' (Assigned Reviewer)''
    ELSE veh.Mgr_Name 
  END strEmpMgrName,
  veh.Mgr_Email strEmpMgrEmail,
  CASE 
    WHEN (cl.[statusId] = 5  AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[statusId] = 7  AND cl.[ModuleID] = 2 AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[Review_MgrID] IS NOT NULL AND cl.[Review_MgrID] = cl.[ReassignedToID] AND [ReassignCount] = 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_MgrID])
    ELSE ''NA''
  END strReassignedMgrName,
  veh.SrMgrLvl1_ID strEmpSrMgrLvl1ID,
  veh.SrMgrLvl1_Name strEmpSrMgrLvl1Name,
  veh.SrMgrLvl1_LanID strEmpSrMgrLvl1LanID,
  veh.SrMgrLvl2_ID strEmpSrMgrLvl2ID,
  veh.SrMgrLvl2_Name strEmpSrMgrLvl2Name,
  veh.SrMgrLvl2_LanID strEmpSrMgrLvl2LanID,
  veh.SrMgrLvl3_ID strEmpSrMgrLvl3ID,
  veh.SrMgrLvl3_Name strEmpSrMgrLvl3Name,
  veh.SrMgrLvl3_LanID strEmpSrMgrLvl3LanID,
  ';
	
SET @nvcSQL2 = @nvcSQL2 + N'
  CASE WHEN cl.[Review_SupID] IS NOT NULL THEN vehSup.Emp_Name
    ELSE cl.[Review_SupID] END strReviewSupervisor,
    CASE WHEN cl.[Review_MgrID] IS NOT NULL THEN vehMgr.Emp_Name
    ELSE cl.[Review_MgrID] END strReviewManager,
  cl.ReassignedToID,
  cl.sourceid,
  sc.SubCoachingSource strSource,
  CASE 
    WHEN sc.SubCoachingSource in (''Verint-GDIT'', ''Verint-TQC'', ''LimeSurvey'', ''IQS'', ''Verint-GDIT Supervisor'') THEN 1 
	ELSE 0 
  END isIQS,
   CASE 
    WHEN sc.SubCoachingSource in (''Verint-CCO'', ''Verint-CCO Supervisor'') THEN 1 
	ELSE 0 
  END isIQSQN,
  cl.QNBatchID strQNBatchID,
  cl.QNStrengthsOpportunities  strQNStrengthsOpportunities,
  CASE 
    WHEN sc.SubCoachingSource = ''Coach the coach'' THEN 1 
	ELSE 0 
  END isCTC,
  cl.isUCID isUCID,
  cl.UCID strUCID,
  cl.isVerintID	isVerintMonitor,
  cl.VerintID strVerintID,
  cl.VerintFormName VerintFormName,
  cl.isCoachingMonitor isCoachingMonitor,
  cl.isAvokeID isBehaviorAnalyticsMonitor,
  cl.AvokeID strBehaviorAnalyticsID,
  cl.isNGDActivityID isNGDActivityID,
  cl.NGDActivityID strNGDActivityID,
  CASE WHEN (cc.CSE = ''Opportunity'' AND cl.strReportCode IS NOT NULL) THEN 1 ELSE 0 END "Customer Service Escalation",
  CASE WHEN (cc.CCI IS NOT NULL AND cl.strReportCode IS NOT NULL) THEN 1 ELSE 0 END "Current Coaching Initiative",
  CASE WHEN (cc.OMR IS NOT NULL AND cc.LCS IS NULL AND cc.SDR IS NULL AND cc.ODT IS NULL AND cl.strReportCode IS NOT NULL) THEN 1 ELSE 0 END "OMR / Exceptions",
  CASE WHEN (cc.ETSOAE IS NOT NULL AND cl.strReportCode LIKE ''OAE%'') THEN 1 ELSE 0 END "ETS / OAE",
  CASE WHEN (cc.ETSOAS IS NOT NULL AND cl.strReportCode LIKE ''OAS%'') THEN 1 ELSE 0 END "ETS / OAS",
  CASE WHEN (cc.ETSHNC IS NOT NULL AND cl.strReportCode LIKE ''HNC%'') THEN 1 ELSE 0 END "ETS / HNC",
  CASE WHEN (cc.ETSICC IS NOT NULL AND cl.strReportCode LIKE ''ICC%'') THEN 1 ELSE 0 END "ETS / ICC",
  CASE WHEN (cc.OMRBRN IS NOT NULL AND cl.strReportCode LIKE ''BRN%'') THEN 1 ELSE 0 END "OMR / BRN",
  CASE WHEN (cc.OMRBRL IS NOT NULL AND cl.strReportCode LIKE ''BRL%'') THEN 1 ELSE 0 END "OMR / BRL",
  CASE WHEN (cc.OMRPBH IS NOT NULL AND cl.strReportCode LIKE ''PBH%'') THEN 1 ELSE 0 END "OMR / PBH",
  CASE WHEN (cc.OMRIAE IS NOT NULL AND cl.strReportCode LIKE ''IAE2%'') THEN 1 ELSE 0 END "OMR / IAE",
  CASE WHEN (cc.OMRIAE IS NOT NULL AND cl.strReportCode LIKE ''IAEF%'') THEN 1 ELSE 0 END "OMR / IAEF",
  CASE WHEN (cc.OMRIAT IS NOT NULL AND cl.strReportCode LIKE ''IAT%'') THEN 1 ELSE 0 END "OMR / IAT",
  CASE WHEN (cc.OMRISQ IS NOT NULL AND cl.strReportCode LIKE ''ISQ%'') THEN 1 ELSE 0 END "OMR / ISQ",
   CASE WHEN (cc.OMRIDD IS NOT NULL AND cl.strReportCode LIKE ''IDD%'') THEN 1 ELSE 0 END "OMR / IDD",
   CASE WHEN (cc.LCS IS NOT NULL AND cl.strReportCode LIKE ''LCS%'') THEN 1 ELSE 0 END "LCS",
  CASE WHEN (cc.SDR IS NOT NULL AND cl.strReportCode LIKE ''SDR%'') THEN 1 ELSE 0 END "Training / SDR",
  CASE WHEN (cc.ODT IS NOT NULL AND cl.strReportCode LIKE ''ODT%'') THEN 1 ELSE 0 END "Training / ODT",
  CASE WHEN (cc.CTC IS NOT NULL AND cl.strReportCode LIKE ''CTC%'') THEN 1 ELSE 0 END "Quality / CTC",
  CASE WHEN (cc.HFC IS NOT NULL AND cl.strReportCode LIKE ''HFC%'') THEN 1 ELSE 0 END "Quality / HFC",
  CASE WHEN (cc.KUD IS NOT NULL AND cl.strReportCode LIKE ''KUD%'') THEN 1 ELSE 0 END "Quality / KUD",
  CASE WHEN (cc.OTA IS NOT NULL AND cl.strReportCode LIKE ''OTA%'') THEN 1 ELSE 0 END "Quality / OTA",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''NPN%'') THEN 1 ELSE 0 END "Quality / NPN",
  CASE WHEN (cc.SEA IS NOT NULL AND cl.strReportCode LIKE ''SEA%'') THEN 1 ELSE 0 END "OTH / SEA",
  CASE WHEN (cc.DTT IS NOT NULL AND cl.strReportCode LIKE ''DTT%'') THEN 1 ELSE 0 END "OTH / DTT",
  CASE WHEN (cc.ATTAP IS NOT NULL AND cl.strReportCode LIKE ''APW%'') THEN 1 ELSE 0 END "OTH / APW",
  CASE WHEN (cc.ATTAP IS NOT NULL AND cl.strReportCode LIKE ''APS%'') THEN 1 ELSE 0 END "OTH / APS",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''MSR2%'') THEN 1 ELSE 0 END "PSC / MSR",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''MSRS%'') THEN 1 ELSE 0 END "PSC / MSRS",
  CASE WHEN (cc.QNB IS NOT NULL AND cl.strReportCode LIKE ''BQN2%'') THEN 1 ELSE 0 END "Quality / BQN",
  CASE WHEN (cc.QNB IS NOT NULL AND cl.strReportCode LIKE ''BQNS%'') THEN 1 ELSE 0 END "Quality / BQNS",
   CASE WHEN (cc.QMB IS NOT NULL AND cl.strReportCode LIKE ''BQM2%'') THEN 1 ELSE 0 END "Quality / BQM",
  CASE WHEN (cc.QMB IS NOT NULL AND cl.strReportCode LIKE ''BQMS%'') THEN 1 ELSE 0 END "Quality / BQMS",
  cc.WAH_RTS, 
  cl.Description txtDescription,
  cl.CoachingNotes txtCoachingNotes,
  cl.isVerified,
  cl.SubmittedDate,
  cl.StartDate,
  cl.SupReviewedAutoDate,
  cl.isCSE SubmittedCSE,
  cl.ConfirmedCSE ConfirmedCSE,
  cl.MgrReviewManualDate,
  cl.MgrReviewAutoDate,
  cl.MgrNotes txtMgrNotes,
  cl.isCSRAcknowledged,
  CASE WHEN (cl.[Review_SupID] IS NOT NULL AND cl.[Review_SupID] <> '''') THEN 1
    ELSE 0 END isSupAcknowledged,
  cl.isCoachingRequired,
  cl.CSRReviewAutoDate,
  cl.CSRComments txtCSRComments,
  cl.IsFollowupRequired,
  cl.FollowupDueDate,
  cl.FollowupActualDate,
  cl.SupFollowupAutoDate,
  cl.SupFollowupCoachingNotes,
   CASE WHEN cl.[FollowupSupID] IS NOT NULL THEN [EC].[fn_strEmpNameFromEmpID](cl.[FollowupSupID])
    ELSE cl.[FollowupSupID] END strFollowupSupervisor,
  cl.IsEmpFollowupAcknowledged,
  cl.EmpAckFollowupAutoDate,
  cl.EmpAckFollowupComments,
  ''Coaching'' strLogType
FROM [EC].[Coaching_Log] cl ';
	    
SET @nvcSQL3 = @nvcSQL3 + N' JOIN 
(
  SELECT ccl.FormName,
    MAX(CASE WHEN [cr].[CoachingReason] = ''Customer Service Escalation'' THEN [clr].[Value] ELSE NULL END)	CSE,
    MAX(CASE WHEN [cr].[CoachingReason] = ''Current Coaching Initiative'' THEN [clr].[Value] ELSE NULL END)	CCI,
    MAX(CASE WHEN [cr].[CoachingReason] = ''OMR / Exceptions'' THEN [clr].[Value] ELSE NULL END) OMR,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 120 THEN [clr].[Value] ELSE NULL END) ETSOAE,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 121 THEN [clr].[Value] ELSE NULL END) ETSOAS,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 240 THEN [clr].[Value] ELSE NULL END) ETSHNC,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 241 THEN [clr].[Value] ELSE NULL END) ETSICC,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 29 THEN [clr].[Value] ELSE NULL END) OMRIAE,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 231 THEN [clr].[Value] ELSE NULL END) OMRIAT,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 238 THEN [clr].[Value] ELSE NULL END) OMRBRN,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 239 THEN [clr].[Value] ELSE NULL END) OMRBRL,
	MAX(CASE WHEN [clr].[SubCoachingReasonID] = 245 THEN [clr].[Value] ELSE NULL END) OMRPBH,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 34 THEN [clr].[Value] ELSE NULL END) LCS,
	MAX(CASE WHEN [clr].[SubCoachingReasonID] = 23 THEN [clr].[Value] ELSE NULL END) OMRISQ,
	MAX(CASE WHEN [clr].[SubCoachingReasonID] = 281 THEN [clr].[Value] ELSE NULL END) OMRIDD,
	MAX(CASE WHEN [clr].[SubCoachingReasonID] = 232 THEN [clr].[Value] ELSE NULL END) SDR,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 233 THEN [clr].[Value] ELSE NULL END) ODT,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 73 THEN [clr].[Value] ELSE NULL END) CTC,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 12 THEN [clr].[Value] ELSE NULL END) HFC,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 11 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END) KUD,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 10 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END) OTA,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 10 AND [clr].[SubCoachingReasonID] = 250) THEN [clr].[Value] ELSE NULL END) QNB,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 10 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END) QMB,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END)	SEA,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 242) THEN [clr].[Value] ELSE NULL END) DTT,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 252) THEN [clr].[Value] ELSE NULL END) ATTAP,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 5 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END)	NPN_PSC,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 63) THEN [clr].[Value] ELSE NULL END)	WAH_RTS
  FROM [EC].[Coaching_Log_Reason] clr,
    [EC].[DIM_Coaching_Reason] cr,
	[EC].[Coaching_Log] ccl 
  WHERE [ccl].[CoachingID] = ''' + CONVERT(NVARCHAR, @intLogId) + '''
    AND [clr].[CoachingReasonID] = [cr].[CoachingReasonID]
    AND [ccl].[CoachingID] = [clr].[CoachingID] 
  GROUP BY ccl.FormName 
) cc ON [cl].[FormName] = [cc].[FormName]
JOIN [EC].[Employee_Hierarchy] eh ON [cl].[EMPID] = [eh].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) ON [veh].[Emp_ID] = [eh].[Emp_ID]
LEFT JOIN [EC].[View_Employee_Hierarchy] vehSubmitter WITH (NOLOCK) ON [cl].[SubmitterID] = [vehSubmitter].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehSup WITH (NOLOCK) ON ISNULL([cl].[Review_SupID], ''999999'') = [vehSup].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehMgr WITH (NOLOCK) ON ISNULL([cl].[Review_MgrID], ''999999'') = [vehMgr].[Emp_ID]
JOIN [EC].[DIM_Status] s ON [cl].[StatusID] = [s].[StatusID] 
JOIN [EC].[DIM_Source] sc ON [cl].[SourceID] = [sc].[SourceID] 
JOIN [EC].[DIM_Site] st ON [cl].[SiteID] = [st].[SiteID] 
JOIN [EC].[DIM_Module] m ON [cl].[ModuleID] = [m].[ModuleID]
ORDER BY [cl].[FormName]';
		
SET @nvcSQL =  @nvcSQL + @nvcSQL1 +  @nvcSQL2 +  @nvcSQL3;
EXEC (@nvcSQL);

--PRINT (@nvcSQL);
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectReviewFrom_Coaching_Log
GO



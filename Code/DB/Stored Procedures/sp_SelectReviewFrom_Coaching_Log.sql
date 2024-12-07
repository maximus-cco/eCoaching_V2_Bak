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
--  Changes to support AED feed. TFS 19502  - 11/30/2020
--  Updated to support QN Alt Channels compliance and mastery levels. TFS 21276 - 5/19/2021
--  Updated to support Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--  Changes to support SUR feed. TFS 23347  - 03/25/2022
--  Changes to suppport AUD feed- TFS 26432  - 04/03/2023
--  Updated to return Verint ID Strings for Aud feed records. TFS 27135 - 10/2/2023
-- Changes to suppport NGD feed- TFS 27396  - 11/24/2023
-- Updated to support QN Rewards eCoaching logs. TFS 27851 - 03/21/2024
-- Modified to suppport Motivate and Increase CSR Level Promotions Feed. TFS 28262 - 06/12/2024
-- Changes to support ASR Feed. TFS 28298 - 06/26/2024
--	=====================================================================

CREATE  OR ALTER PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log] @intLogId BIGINT
AS

BEGIN

DECLARE	

  @nvcSQL nvarchar(max)= '',
  @nvcSQL1 nvarchar(max)= '',
  @nvcSQL2 nvarchar(max)= '',
  @nvcSQL3 nvarchar(max)= '',
  @nvcSQL4 nvarchar(1000)= '',
  @nvcEmpID nvarchar(10),
  @nvcMgrID nvarchar(10),
  @cpathtext nvarchar(2000);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcEmpID = (SELECT [EmpID] From [EC].[Coaching_Log] WHERE [CoachingID] = @intLogId);	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID);
SET @cpathtext = 'Meet with your supervisor to discuss interest in promotional opportunities. Use the following resources for more information about the various CCO career pathways, to hone your knowledge and professional skills, and to stay informed about available job opportunities:<br>
            <a href=''''https://maximus365.sharepoint.com/sites/CCO/Resources/CCO_Career_Path''''target=''''_blank''''>CSR Career Path Home</a><br>
			<a href=''''https://maximus365.sharepoint.com/sites/CCO/Connection/Lists/Jobs/currentpostings.aspx?viewpath=%2Fsites%2FCCO%2FConnection%2FLists%2FJobs%2Fcurrentpostings%2Easpx''''target=''''_blank''''>CCO Jobs Page</a>'

--PRINT @cpathtext;

SET @nvcSQL1 = @nvcSQL1 +  N'
SELECT cl.CoachingID numID,
  cl.FormName strFormID,
  cl.ModuleID,
  m.Module,
  sc.CoachingSource	strFormType,
  cl.StatusId strStatusID,
  s.Status strFormStatus,
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
    WHEN (cl.[statusId] IN (6, 8, 10,11,12) AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
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
    WHEN sc.SubCoachingSource in (''Verint-CCO'') THEN 1 
	ELSE 0 
  END isIQSQN,
     CASE 
    WHEN sc.SubCoachingSource in (''Verint-CCO Supervisor'') THEN 1 
	ELSE 0 
  END isIQSQNS,
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
  CASE WHEN (cc.OMRAUD IS NOT NULL AND cl.strReportCode LIKE ''AUD%'') THEN 1 ELSE 0 END "OMR / AUD",
  CASE WHEN (cc.OMRNGD IS NOT NULL AND cl.strReportCode LIKE ''NGD%'') THEN 1 ELSE 0 END "OMR / NGD",
   CASE WHEN (cc.LCS IS NOT NULL AND cl.strReportCode LIKE ''LCS%'') THEN 1 ELSE 0 END "LCS",
  CASE WHEN (cc.SDR IS NOT NULL AND cl.strReportCode LIKE ''SDR%'') THEN 1 ELSE 0 END "Training / SDR",
  CASE WHEN (cc.ODT IS NOT NULL AND cl.strReportCode LIKE ''ODT%'') THEN 1 ELSE 0 END "Training / ODT",
  CASE WHEN (cc.CTC IS NOT NULL AND cl.strReportCode LIKE ''CTC%'') THEN 1 ELSE 0 END "Quality / CTC",
  CASE WHEN (cc.HFC IS NOT NULL AND cl.strReportCode LIKE ''HFC%'') THEN 1 ELSE 0 END "Quality / HFC",
  CASE WHEN (cc.KUD IS NOT NULL AND cl.strReportCode LIKE ''KUD%'') THEN 1 ELSE 0 END "Quality / KUD",
  CASE WHEN (cc.OTA IS NOT NULL AND cl.strReportCode LIKE ''OTA%'') THEN 1 ELSE 0 END "Quality / OTA",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''NPN%'') THEN 1 ELSE 0 END "Quality / NPN",
  CASE WHEN (cc.SUR IS NOT NULL AND cl.strReportCode LIKE ''SUR%'') THEN 1 ELSE 0 END "OTH / SUR",
  CASE WHEN (cc.SEA IS NOT NULL AND cl.strReportCode LIKE ''SEA%'') THEN 1 ELSE 0 END "OTH / SEA",
  CASE WHEN (cc.DTT IS NOT NULL AND cl.strReportCode LIKE ''DTT%'') THEN 1 ELSE 0 END "OTH / DTT",
  CASE WHEN (cc.ATTAP IS NOT NULL AND cl.strReportCode LIKE ''APW%'') THEN 1 ELSE 0 END "OTH / APW",
  CASE WHEN (cc.ATTAP IS NOT NULL AND cl.strReportCode LIKE ''APS%'') THEN 1 ELSE 0 END "OTH / APS",
  CASE WHEN (cc.AED IS NOT NULL AND cl.strReportCode LIKE ''AED%'') THEN 1 ELSE 0 END "OTH / AED",
  CASE WHEN (cc.CPATH IS NOT NULL AND cl.strReportCode LIKE ''CPATH%'') THEN 1 ELSE 0 END "OTH / CPATH",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''MSR2%'') THEN 1 ELSE 0 END "PSC / MSR",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''MSRS%'') THEN 1 ELSE 0 END "PSC / MSRS",
  CASE WHEN (cc.QNB IS NOT NULL AND cl.strReportCode LIKE ''BQN2%'') THEN 1 ELSE 0 END "Quality / BQN",
  CASE WHEN (cc.QNB IS NOT NULL AND cl.strReportCode LIKE ''BQNS%'') THEN 1 ELSE 0 END "Quality / BQNS",
  CASE WHEN (cc.QMB IS NOT NULL AND cl.strReportCode LIKE ''BQM2%'') THEN 1 ELSE 0 END "Quality / BQM",
  CASE WHEN (cc.QMB IS NOT NULL AND cl.strReportCode LIKE ''BQMS%'') THEN 1 ELSE 0 END "Quality / BQMS",
  CASE WHEN (cc.QMB IS NOT NULL AND cl.strReportCode LIKE ''BQM2%'') THEN 1 ELSE 0 END "Quality / BQM",
  CASE WHEN (cc.QMB IS NOT NULL AND cl.strReportCode LIKE ''BQMS%'') THEN 1 ELSE 0 END "Quality / BQMS",
  CASE WHEN (cc.QOR IS NOT NULL AND cl.strReportCode LIKE ''QR%'') THEN 1 ELSE 0 END "Quality / QOR",
  CASE WHEN (cc.ASR_HOLD IS NOT NULL ) THEN 1 ELSE 0 END "ASR / Hold",
  CASE WHEN (cc.ASR_TRANSFER IS NOT NULL ) THEN 1 ELSE 0 END "ASR / Transfer",
  CASE WHEN (cc.ASR_AHT IS NOT NULL ) THEN 1 ELSE 0 END "ASR / AHT",
  CASE WHEN (cc.ASR_ACW IS NOT NULL ) THEN 1 ELSE 0 END "ASR / ACW",
  CASE WHEN (cc.ASR_Chat IS NOT NULL ) THEN 1 ELSE 0 END "ASR / Chat",
  cc.WAH_RTS,
  CASE WHEN cl.strReportCode LIKE ''CPATH%'' THEN cl.Description + ''<br>''  + '''+@cpathtext+'''  ELSE cl.Description END txtDescription,
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
  cl.SupFollowupReviewCoachingNotes,
  cl.PFDCompletedDate,
  ''Coaching'' strLogType,
  cc.strStaticText  strStaticText,
 ''Verint ID: '' + REPLACE(av.VerintIds, '' |'', '','') AudVerintIds,
 qor.[CompetencyImage] strQORCompetency
FROM [EC].[Coaching_Log] cl  WITH (NOLOCK) ';
	    
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
	MAX(CASE WHEN [clr].[SubCoachingReasonID] = 314 THEN [clr].[Value] ELSE NULL END) OMRAUD,
	MAX(CASE WHEN [clr].[SubCoachingReasonID] = 315 THEN [clr].[Value] ELSE NULL END) OMRNGD,
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
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 282) THEN [clr].[Value] ELSE NULL END) AED,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 252) THEN [clr].[Value] ELSE NULL END) ATTAP,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 5 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END)	NPN_PSC,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 5 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END)	SUR,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 63) THEN [clr].[Value] ELSE NULL END)	WAH_RTS,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 10 AND [clr].[SubCoachingReasonID] = 326) THEN [clr].[Value] ELSE NULL END) QOR,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 25 AND [clr].[SubCoachingReasonID] = 327) THEN [clr].[Value] ELSE NULL END) CPATH,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 55 AND [clr].[SubCoachingReasonID] = 230) THEN [clr].[Value] ELSE NULL END) ASR_HOLD,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 55 AND [clr].[SubCoachingReasonID] = 328) THEN [clr].[Value] ELSE NULL END) ASR_TRANSFER,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 55 AND [clr].[SubCoachingReasonID] = 329) THEN [clr].[Value] ELSE NULL END) ASR_AHT,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 55 AND [clr].[SubCoachingReasonID] = 330) THEN [clr].[Value] ELSE NULL END) ASR_ACW,
	MAX(CASE WHEN ([CLR].[CoachingreasonID] = 55 AND [clr].[SubCoachingReasonID] = 331) THEN [clr].[Value] ELSE NULL END) ASR_Chat,
	CASE WHEN ccl.SourceID = 238 AND ccl.StrReportCode iS NULL THEN NULL ELSE [EC].[fn_strCoachingLogStatictext]([ccl].[CoachingID]) END strStaticText
  FROM [EC].[Coaching_Log_Reason] clr  WITH (NOLOCK),
    [EC].[DIM_Coaching_Reason] cr,
	[EC].[Coaching_Log] ccl  WITH (NOLOCK) 
  WHERE [ccl].[CoachingID] = ''' + CONVERT(NVARCHAR, @intLogId) + '''
    AND [clr].[CoachingReasonID] = [cr].[CoachingReasonID]
    AND [ccl].[CoachingID] = [clr].[CoachingID] 
  GROUP BY ccl.FormName, ccl.CoachingID, ccl.sourceid, ccl.strreportcode
) cc ON [cl].[FormName] = [cc].[FormName]
JOIN [EC].[Employee_Hierarchy] eh  WITH (NOLOCK) ON [cl].[EMPID] = [eh].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) ON [veh].[Emp_ID] = [eh].[Emp_ID]
LEFT JOIN [EC].[View_Employee_Hierarchy] vehSubmitter WITH (NOLOCK) ON [cl].[SubmitterID] = [vehSubmitter].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehSup WITH (NOLOCK) ON ISNULL([cl].[Review_SupID], ''999999'') = [vehSup].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehMgr WITH (NOLOCK) ON ISNULL([cl].[Review_MgrID], ''999999'') = [vehMgr].[Emp_ID]
JOIN [EC].[DIM_Status] s ON [cl].[StatusID] = [s].[StatusID] 
JOIN [EC].[DIM_Source] sc ON [cl].[SourceID] = [sc].[SourceID] 
JOIN [EC].[DIM_Site] st ON [cl].[SiteID] = [st].[SiteID] 
JOIN [EC].[DIM_Module] m ON [cl].[ModuleID] = [m].[ModuleID]
LEFT JOIN [EC].[Audio_Issues_VerintIds] av ON av.[CoachingID] = cl.[CoachingID]  
LEFT JOIN [EC].[Coaching_Log_QNORewards]qor ON qor.[CoachingID] = cl.[CoachingID]  
ORDER BY [cl].[FormName]';


SET @nvcSQL4 = @nvcSQL4 +  N'
WITH ids AS
(
SELECT value FROM [EC].[Coaching_Log] cl  WITH (NOLOCK)
CROSS APPLY string_split([SupFollowupReviewMonitoredLogs], ''|'')
WHERE coachingid = ''' + CONVERT(NVARCHAR, @intLogId) + '''
 )
 SELECT i.value as QNLinkedID, cl.formname as QNLinkedFormName
FROM ids i INNER JOIN[EC].[Coaching_Log] cl  WITH (NOLOCK)
 on i.value = cl.CoachingID '
		
SET @nvcSQL =  @nvcSQL + @nvcSQL1 +  @nvcSQL2 +  @nvcSQL3;
EXEC (@nvcSQL);
EXEC (@nvcSQL4);

--PRINT (@nvcSQL);
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectReviewFrom_Coaching_Log
GO



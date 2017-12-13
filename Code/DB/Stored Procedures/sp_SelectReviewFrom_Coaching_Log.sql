/*
sp_SelectReviewFrom_Coaching_Log(08).sql

Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla

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
--  1. TFS 1877 to support OMR Low CSAT logs should be viewable by hierarchy manger - 2/17/2016
--  2. TFS 1914 to support  OMR Short Calls feed with Manager Review - 2/17/2016
--  3. TFS 1732 to support SDR Training feed - 3/2/2016
--  4. TFS 2283 to support ODT Training feed - 3/22/2016
--  5. TFS 1709 to support Reassigned sups and Mgrs - 5/6/2016
--  6. TFS 2268 to support CTC Quality Other feed - 6/23/2016
--  7. TFS 3179 & 3186 to add support HFC & KUD Quality Other feeds - 7/15/2016
--  8. TFS 3677 to update Quality\KUD Flag - 8/18/2016
--  9. TFS 3972 to ADD SEA flag - 9/15/2016
-- 10. TFS 3758 Shared coaching sub-reasons may cause unexpected display issue in user interface - 10/14/2016
-- 11. TFS 3757 Include Yes/No value to coaching monitor question - 10/27/2016
-- 12. TFS 5309 NPN Load.  - 02/01/2017
-- 13. TFS 6145 BRN and BRL Feeds - 4/12/2017
-- 14. TFS 6147 Updated to support MSR and MSRS Feeds - 06/02/2017
-- 15. Modified to incorporate HNC and ICC Feed - TFS 7174 - 07/21/2017
-- 16. Modified to incorporate DTT feed - TFS 7646 - 09/01/2017
-- 17. Modified to use LEFT Join on Submitter table for unknown Submitters - TFS 7541 - 09/19/2017
-- 18. Modified to support additional Modules per TFS 8793 - 11/16/2017
-- TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log] @strFormIDin nvarchar(50)
AS

BEGIN

DECLARE	

  @nvcSQL nvarchar(max),
  @nvcSQL1 nvarchar(max),
  @nvcSQL2 nvarchar(max),
  @nvcSQL3 nvarchar(max),
  @nvcEmpID nvarchar(10),
  @nvcMgrID nvarchar(10);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcEmpID = (SELECT [EmpID] From [EC].[Coaching_Log] WHERE [FormName] = @strFormIDin)	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID)

SET @nvcSQL1 = '
SELECT cl.CoachingID numID,
  cl.FormName strFormID,
  m.Module,
  sc.CoachingSource	strFormType,
  s.Status strFormStatus,
  cl.EventDate EventDate,
  cl.CoachingDate CoachingDate,
  cl.SubmitterID strSubmitterID,
  cl.SupID strCLSupID,
  cl.MgrID strCLMgrID,
  vehSubmitter.Emp_LanID strSubmitter,		
  vehSubmitter.Emp_Name strSubmitterName,
  vehSubmitter.Emp_Email strSubmitterEmail,	
  cl.EmpID strEmpID,		
  veh.Emp_LanID strEmpLanID,
  veh.Emp_Name strCSRName,
  veh.Emp_Email strCSREmail,
  st.City strCSRSite,
  eh.Sup_ID strCSRSupID,
  veh.Sup_LanID strCSRSup,
  veh.Sup_Name strCSRSupName,
  veh.Sup_Email strCSRSupEmail,
  CASE 
    WHEN (cl.[statusId] IN (6, 8) AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[statusId] = 5 AND cl.[ModuleID] = 2 AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[Review_SupID] IS NOT NULL AND cl.[Review_SupID] = cl.[ReassignedToID] AND [ReassignCount]= 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_SupID])
    ELSE ''NA''
  END strReassignedSupName,	
  eh.Mgr_ID strCSRMgrID,
  CASE 
    WHEN cl.[strReportCode] LIKE ''LCS%'' THEN [EC].[fn_strEmpLanIDFromEmpID](cl.[MgrID])
    ELSE veh.Mgr_LanID 
  END strCSRMgr,
  CASE
    WHEN cl.[strReportCode] LIKE ''LCS%'' AND cl.[MgrID] <> ''' + @nvcMgrID + ''' THEN [EC].[fn_strEmpNameFromEmpID](cl.[MgrID]) + '' (Assigned Reviewer)''
    ELSE veh.Mgr_Name 
  END strCSRMgrName,
  veh.Mgr_Email strCSRMgrEmail,
  CASE 
    WHEN (cl.[statusId] = 5  AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[statusId] = 7  AND cl.[ModuleID] = 2 AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[Review_MgrID] IS NOT NULL AND cl.[Review_MgrID] = cl.[ReassignedToID] AND [ReassignCount] = 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_MgrID])
    ELSE ''NA''
  END strReassignedMgrName,';
	
SET @nvcSQL2 = '
  CASE
    WHEN cl.[Review_SupID] IS NOT NULL THEN ISNULL(vehSup.Emp_Name, ''Unknown'')
    ELSE ISNULL(vehMgr.Emp_Name, ''Unknown'')
  END strReviewer,
  cl.ReassignedToID,
  sc.SubCoachingSource strSource,
  CASE 
    WHEN sc.SubCoachingSource in (''Verint-GDIT'', ''Verint-TQC'', ''LimeSurvey'', ''IQS'', ''Verint-GDIT Supervisor'') THEN 1 
	ELSE 0 
  END isIQS,
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
  CASE WHEN (cc.OMRIAE IS NOT NULL AND cl.strReportCode LIKE ''IAE%'') THEN 1 ELSE 0 END "OMR / IAE",
  CASE WHEN (cc.OMRIAT IS NOT NULL AND cl.strReportCode LIKE ''IAT%'') THEN 1 ELSE 0 END "OMR / IAT",
  CASE WHEN (cc.OMRISQ IS NOT NULL AND cl.strReportCode LIKE ''ISQ%'') THEN 1 ELSE 0 END "OMR / ISQ",
  CASE WHEN (cc.LCS IS NOT NULL AND cl.strReportCode LIKE ''LCS%'') THEN 1 ELSE 0 END "LCS",
  CASE WHEN (cc.SDR IS NOT NULL AND cl.strReportCode LIKE ''SDR%'') THEN 1 ELSE 0 END "Training / SDR",
  CASE WHEN (cc.ODT IS NOT NULL AND cl.strReportCode LIKE ''ODT%'') THEN 1 ELSE 0 END "Training / ODT",
  CASE WHEN (cc.CTC IS NOT NULL AND cl.strReportCode LIKE ''CTC%'') THEN 1 ELSE 0 END "Quality / CTC",
  CASE WHEN (cc.HFC IS NOT NULL AND cl.strReportCode LIKE ''HFC%'') THEN 1 ELSE 0 END "Quality / HFC",
  CASE WHEN (cc.KUD IS NOT NULL AND cl.strReportCode LIKE ''KUD%'') THEN 1 ELSE 0 END "Quality / KUD",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''NPN%'') THEN 1 ELSE 0 END "Quality / NPN",
  CASE WHEN (cc.SEA IS NOT NULL AND cl.strReportCode LIKE ''SEA%'') THEN 1 ELSE 0 END "OTH / SEA",
  CASE WHEN (cc.DTT IS NOT NULL AND cl.strReportCode LIKE ''DTT%'') THEN 1 ELSE 0 END "OTH / DTT",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''MSR2%'') THEN 1 ELSE 0 END "PSC / MSR",
  CASE WHEN (cc.NPN_PSC IS NOT NULL AND cl.strReportCode LIKE ''MSRS%'') THEN 1 ELSE 0 END "PSC / MSRS",
  cl.Description txtDescription,
  cl.CoachingNotes txtCoachingNotes,
  cl.isVerified,
  cl.SubmittedDate,
  cl.StartDate,
  cl.SupReviewedAutoDate,
  cl.isCSE,
  cl.MgrReviewManualDate,
  cl.MgrReviewAutoDate,
  cl.MgrNotes txtMgrNotes,
  cl.isCSRAcknowledged,
  cl.isCoachingRequired,
  cl.CSRReviewAutoDate,
  cl.CSRComments txtCSRComments
FROM [EC].[Coaching_Log] cl ';
	    
SET @nvcSQL3 = '
JOIN 
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
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 34 THEN [clr].[Value] ELSE NULL END) LCS,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 23 THEN [clr].[Value] ELSE NULL END) OMRISQ,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 232 THEN [clr].[Value] ELSE NULL END) SDR,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 233 THEN [clr].[Value] ELSE NULL END) ODT,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 73 THEN [clr].[Value] ELSE NULL END) CTC,
    MAX(CASE WHEN [clr].[SubCoachingReasonID] = 12 THEN [clr].[Value] ELSE NULL END) HFC,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 11 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END) KUD,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END)	SEA,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 3 AND [clr].[SubCoachingReasonID] = 242) THEN [clr].[Value] ELSE NULL END) DTT,
    MAX(CASE WHEN ([CLR].[CoachingreasonID] = 5 AND [clr].[SubCoachingReasonID] = 42) THEN [clr].[Value] ELSE NULL END)	NPN_PSC
  FROM [EC].[Coaching_Log_Reason] clr,
    [EC].[DIM_Coaching_Reason] cr,
	[EC].[Coaching_Log] ccl 
  WHERE [ccl].[FormName] = ''' + @strFormIDin + '''
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
		
SET @nvcSQL =  @nvcSQL1 +  @nvcSQL2 +  @nvcSQL3;
EXEC (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectReviewFrom_Coaching_Log
GO
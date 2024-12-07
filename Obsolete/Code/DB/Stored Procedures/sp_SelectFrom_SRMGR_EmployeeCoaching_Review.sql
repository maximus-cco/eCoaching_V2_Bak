/*
sp_SelectFrom_SRMGR_EmployeeCoaching_Review(02).sql
Last Modified Date: 11/27/2017
Last Modified By: Susmitha Palacherla

Version 02:  Modified to support additional Modules per TFS 8793 - 11/16/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeCoaching_Review' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Review Details for Coaching log selected.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--  Modified to support additional Modules per TFS 8793 - 11/16/2017
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeCoaching_Review] @intFormIDin BIGINT
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

SET @nvcEmpID = (SELECT [EmpID] From [EC].[Coaching_Log] WHERE [CoachingID]= @intFormIDin);	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID);

SET @nvcSQL = '
SELECT DISTINCT cl.CoachingID numID,
  cl.FormName strFormID,
  sc.CoachingSource	strFormType,
  sc.SubCoachingSource strSource,
  s.Status strFormStatus,
  cl.SubmittedDate SubmittedDate,
  cl.CoachingDate CoachingDate,
  cl.EventDate EventDate,
  vehs.Emp_Name strSubmitterName,
  veh.Emp_Name strCSRName,
  st.City strCSRSite,
  veh.Sup_Name strCSRSupName,
  
  CASE 
    WHEN (cl.[statusId] IN (6,8) AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[statusId]= 5 AND cl.[ModuleID] = 2 AND cl.[ReassignedToID]is NOT NULL and [ReassignCount]<> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[Review_SupID]is NOT NULL and cl.[Review_SupID] = cl.[ReassignedToID] and [ReassignCount]= 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_SupID])
      ELSE ''NA''
  END strReassignedSupName,	
  
  CASE
    WHEN cl.[Review_SupID] IS NOT NULL THEN ISNULL(vehSup.Emp_Name,''Unknown'')
    ELSE ''NA'' 
  END strReviewSup,
  
  CASE
    WHEN cl.[strReportCode] LIKE ''LCS%'' AND cl.[MgrID] <> ''' + @nvcMgrID + '''
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[MgrID]) + '' (Assigned Reviewer)''
	  ELSE veh.Mgr_Name 
  END strCSRMgrName,
  
  CASE 
    WHEN (cl.[statusId] = 5  AND cl.[ModuleID] NOT IN (-1, 2) AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[statusId] = 7  AND cl.[ModuleID] = 2 AND cl.[ReassignedToID] IS NOT NULL AND [ReassignCount] <> 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[ReassignedToID])
    WHEN (cl.[Review_MgrID] IS NOT NULL AND cl.[Review_MgrID] = cl.[ReassignedToID] AND [ReassignCount] = 0)
      THEN [EC].[fn_strEmpNameFromEmpID](cl.[Review_MgrID])
      ELSE ''NA''
  END strReassignedMgrName, 
  
  CASE
    WHEN cl.[Review_MgrID] IS NOT NULL 
	  THEN ISNULL(vehMgr.Emp_Name,''Unknown'')
	  ELSE ''NA'' 
  END strReviewMgr,
  
  CASE WHEN sc.SubCoachingSource IN (''Verint-GDIT'', ''Verint-TQC'', ''LimeSurvey'', ''IQS'', ''Verint-GDIT Supervisor'')
    THEN 1 ELSE 0 
  END isIQS,
  
  CASE WHEN sc.SubCoachingSource = ''Coach the coach''
    THEN 1 ELSE 0 
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
  cl.Description txtDescription,
  cl.CoachingNotes txtCoachingNotes,
  cl.SubmittedDate,
  cl.SupReviewedAutoDate,
  cl.isCSE,
  cl.MgrReviewManualDate,
  cl.MgrReviewAutoDate,
  cl.MgrNotes txtMgrNotes,
  cl.CSRReviewAutoDate,
  cl.CSRComments txtCSRComments,
  [EC].[fn_strCoachingReasonFromCoachingID](cl.CoachingID) strCoachingReason,
  [EC].[fn_strSubCoachingReasonFromCoachingID](cl.CoachingID)strSubCoachingReason,
  [EC].[fn_strValueFromCoachingID](cl.CoachingID)strValue
FROM [EC].[Coaching_Log] cl 
JOIN [EC].[Coaching_Log_Reason] clr ON [cl].[CoachingID] = [clr].[CoachingID] 
JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) ON [cl].[EMPID] = [veh].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON [cl].[SubmitterID] = [vehs].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehSup WITH (NOLOCK) ON ISNULL([cl].[Review_SupID],''999999'') = [vehSup].[Emp_ID] 
JOIN [EC].[View_Employee_Hierarchy] vehMgr WITH (NOLOCK) ON ISNULL([cl].[Review_MgrID],''999999'') = [vehMgr].[Emp_ID]
JOIN [EC].[DIM_Status] s ON [cl].[StatusID] = [s].[StatusID] 
JOIN [EC].[DIM_Source] sc ON [cl].[SourceID] = [sc].[SourceID] 
JOIN [EC].[DIM_Site] st ON [cl].[SiteID] = [st].[SiteID] 
JOIN [EC].[DIM_Module] m ON [cl].[ModuleID] = [m].[ModuleID] 
WHERE [cl].[CoachingID] = ''' + CONVERT(NVARCHAR(20), @intFormIDin) + '''';

EXEC (@nvcSQL)
Print @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 
	    
END --sp_SelectFrom_SRMGR_EmployeeCoaching_Review
GO
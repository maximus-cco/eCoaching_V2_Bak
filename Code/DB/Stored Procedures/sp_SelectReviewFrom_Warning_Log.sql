/*
sp_SelectReviewFrom_Warning_Log(04).sql
Last Modified Date: 12/3/2019
Last Modified By: Susmitha Palacherla

Version 03: Updated to Incorporate static text from database. TFS 15803 - 12/3/2019
Version 03: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
Version 02 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

*/



IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Warning_Log' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/08/2014
--	Description: 	This procedure displays the Warning Log attributes for given Form Name. 
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date: 07/10/2015
--  Updated per SCR 14966 to add Hierarchy IDs to the select list.
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--  Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--  Updated to support changes to warnings workflow. TFS 15803 - 12/3/2019
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log] @intLogId BIGINT
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT wl.WarningID numID,
  wl.FormName strFormID,
  wl.ModuleID,
  m.Module,
  ''Direct'' strFormType,
  wl.StatusId,
  sta.Status strFormStatus,
  wl.WarningGivenDate	EventDate,
  wl.SubmitterID strSubmitterID,
  wl.SupID strCLSupID,
  wl.MgrID strCLMgrID,
  wl.EmpID strEmpID,	
  vehSubmitter.Emp_LanID strSubmitter,		
  vehSubmitter.Emp_Name strSubmitterName,
  vehSubmitter.Emp_Email strSubmitterEmail,			
  veh.Emp_LanID strEmpLanID,
  veh.Emp_Name strEmpName,
  veh.Emp_Email strEmpEmail,
  st.City strEmpSite,
  eh.Sup_ID strEmpSupID,
  veh.Sup_LanID strEmpSup,
  veh.Sup_Name strEmpSupName,
  veh.Sup_Email strEmpSupEmail,
  eh.Mgr_ID strEmpMgrID,
  veh.Mgr_LanID strEmpMgr,
  veh.Mgr_Name strEmpMgrName,
  veh.Mgr_Email strEmpMgrEmail,
  ''Warning'' strSource,
  wl.SubmittedDate,
  ''Warning'' strLogType,
 CASE WHEN ww.FC_ATTT IS NOT NULL THEN 1 ELSE 0 END "FC / ATTT",
 CASE WHEN ww.FC_ATTH IS NOT NULL THEN 1 ELSE 0 END "FC/ ATTH",
 ww.strStaticText
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh ON veh.Emp_ID = eh.Emp_ID
JOIN [EC].[Warning_Log] wl ON [wl].[EMPID] = [eh].[Emp_ID]
JOIN [EC].[View_Employee_Hierarchy] vehSubmitter WITH (NOLOCK) ON [wl].[SubmitterID] = [vehSubmitter].[Emp_ID]
JOIN [EC].[DIM_Module] m ON [wl].[ModuleID] = [m].[ModuleID]
JOIN [EC].[DIM_Site] st ON [wl].[SiteID] = [st].[SiteID]
JOIN [EC].[DIM_Status] sta ON [wl].[StatusID] = [sta].[StatusID]
JOIN (
  SELECT wwl.FormName,
    MAX(CASE WHEN [wlr].[CoachingReasonID] = 60 AND  [wlr].[SubCoachingReasonID] = 254 THEN [wlr].[Value] ELSE NULL END) FC_ATTT,
	MAX(CASE WHEN [wlr].[CoachingReasonID] = 60 AND  [wlr].[SubCoachingReasonID] = 253 THEN [wlr].[Value] ELSE NULL END) FC_ATTH,
	[EC].[fn_strWarningLogStatictext]([wwl].[WarningID]) strStaticText
     FROM [EC].[Warning_Log_Reason] wlr JOIN [EC].[Warning_Log] wwl 
     ON wwl.WarningID = wlr.WarningID
     WHERE [wwl].[WarningID] = ''' + CONVERT(NVARCHAR, @intLogId) + '''
  GROUP BY wwl.FormName, wwl.WarningID 
) ww ON [wl].[FormName] = [ww].[FormName]
WHERE [wl].[warningId] = ''' + CONVERT(NVARCHAR, @intLogId ) + '''
ORDER BY [wl].[FormName]';

EXEC (@nvcSQL)
Print (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectReviewFrom_Warning_Log


GO




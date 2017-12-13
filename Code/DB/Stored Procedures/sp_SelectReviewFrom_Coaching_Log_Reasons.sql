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
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log] @strFormIDin nvarchar(50)
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT wl.WarningID numID,
  wl.FormName strFormID,
  m.Module,
  ''Direct'' strFormType,
  ''Completed'' strFormStatus,
  wl.WarningGivenDate	EventDate,
  wl.SubmitterID strSubmitterID,
  wl.SupID strCLSupID,
  wl.MgrID strCLMgrID,
  wl.EmpID strEmpID,	
  vehSubmitter.Emp_LanID strSubmitter,		
  vehSubmitter.Emp_Name strSubmitterName,
  vehSubmitter.Emp_Email strSubmitterEmail,			
  veh.Emp_LanID strEmpLanID,
  veh.Emp_Name strCSRName,
  veh.Emp_Email strCSREmail,
  st.City strCSRSite,
  eh.Sup_ID strCSRSupID,
  veh.Sup_LanID strCSRSup,
  veh.Sup_Name strCSRSupName,
  veh.Sup_Email strCSRSupEmail,
  eh.Mgr_ID strCSRMgrID,
  veh.Mgr_LanID strCSRMgr,
  veh.Mgr_Name strCSRMgrName,
  veh.Mgr_Email strCSRMgrEmail,
  ''Warning'' strSource,
  wl.SubmittedDate
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh ON veh.Emp_ID = eh.Emp_ID
JOIN [EC].[Warning_Log] wl ON [wl].[EMPID] = [eh].[Emp_ID]
JOIN [EC].[View_Employee_Hierarchy] vehSubmitter WITH (NOLOCK) ON [wl].[SubmitterID] = [vehSubmitter].[Emp_ID]
JOIN [EC].[DIM_Module] m ON [wl].[ModuleID] = [m].[ModuleID]
JOIN [EC].[DIM_Site] st ON [wl].[SiteID] = [st].[SiteID]
WHERE [wl].[FormName] = ''' + @strFormIDin + '''
ORDER BY [wl].[FormName]';

EXEC (@nvcSQL)
Print (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];
	    
END --sp_SelectReviewFrom_Warning_Log
GO
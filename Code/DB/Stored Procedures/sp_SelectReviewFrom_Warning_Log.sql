/*
sp_SelectReviewFrom_Warning_Log(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Warning_Log' 
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
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 07/10/2015
-- Updated per SCR 14966 to add Hierarchy IDs to the select list.
--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log] @strFormIDin nvarchar(50)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

 
  SET @nvcSQL = 'SELECT wl.WarningID 	numID,
		wl.FormName	strFormID,
		m.Module,
		''Direct''	strFormType,
		''Completed''	strFormStatus,
		wl.WarningGivenDate	EventDate,
		wl.SubmitterID strSubmitterID,
		wl.SupID strCLSupID,
		wl.MgrID strCLMgrID,
		wl.EmpID strEmpID,	
		sh.Emp_LanID	strSubmitter,		
		sh.Emp_Name	strSubmitterName,
		sh.Emp_Email	strSubmitterEmail,			
		wl.EmpLanID	strEmpLanID,
		eh.Emp_Name	strCSRName,
		eh.Emp_Email	strCSREmail,
		st.City	strCSRSite,
		eh.Sup_ID strCSRSupID,
		eh.Sup_LanID	strCSRSup,
		eh.Sup_Name	strCSRSupName,
		eh.Sup_Email	strCSRSupEmail,
		eh.Mgr_ID strCSRMgrID,
		eh.Mgr_LanID	strCSRMgr,
		eh.Mgr_Name	strCSRMgrName,
		eh.Mgr_Email	strCSRMgrEmail,
		''Warning''	strSource,
		wl.SubmittedDate
		FROM [EC].[Employee_Hierarchy] eh join [EC].[Warning_Log] wl 
	    ON [wl].[EMPID] = [eh].[Emp_ID]JOIN [EC].[Employee_Hierarchy] sh
	    ON [wl].[SubmitterID] = [sh].[Emp_ID]JOIN [EC].[DIM_Module] m
	    ON [wl].[ModuleID] = [m].[ModuleID]JOIN [EC].[DIM_Site] st
	    ON [wl].[SiteID] = [st].[SiteID]
	 	Where [wl].[FormName] = '''+@strFormIDin+'''
Order By [wl].[FormName]'
		

EXEC (@nvcSQL)
--Print (@nvcSQL)

	    
END --sp_SelectReviewFrom_Warning_Log






GO


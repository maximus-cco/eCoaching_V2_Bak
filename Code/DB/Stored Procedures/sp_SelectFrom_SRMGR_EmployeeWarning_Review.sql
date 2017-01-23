/*
sp_SelectFrom_SRMGR_EmployeeWarning_Review(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_SRMGR_EmployeeWarning_Review' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/01/2016
--	Description: *	This procedure returns the Review Details for Warning log selected.
--  Last Updated By: 
--  Created per TFS 3027 to implement dashboard for Sr Managers - 11/01/2016
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_SRMGR_EmployeeWarning_Review] @intFormIDin nvarchar(50)
AS

BEGIN
DEClARE	

@nvcSQL nvarchar(max),
@nvcEmpID nvarchar(10),
@nvcMgrID nvarchar(10)


SET @nvcEmpID = (SELECT [EmpID] From [EC].[warning_Log] WHERE [FormName]= @intFormIDin)	 
SET @nvcMgrID = (SELECT [Mgr_ID] From [EC].[Employee_Hierarchy] WHERE [Emp_ID] = @nvcEmpID)

  SET @nvcSQL = 'SELECT DISTINCT wl.warningID 	numID,
		wl.FormName	strFormID,
		''Direct''	strFormType,
		''Completed''	strFormStatus,
		sc.SubCoachingSource	strSource,
		wl.SubmittedDate	SubmittedDate,
		wl.WarningGivenDate	warningDate,
		sh.Emp_Name	strSubmitterName,
		eh.Emp_Name	strCSRName,
		st.City	strCSRSite,
		eh.Sup_Name strCSRSupName,
        eh.Mgr_Name strCSRMgrName,	  
       	[EC].[fn_strCoachingReasonFromwarningID](wl.warningID) strCoachingReason,
		[EC].[fn_strSubCoachingReasonFromwarningID](wl.warningID)strSubCoachingReason,
		[EC].[fn_strValueFromwarningID](wl.warningID)strValue
	    FROM  [EC].[warning_Log] wl JOIN  [EC].[warning_Log_Reason] wlr
	    ON [wl].[warningID] = [wlr].[warningID] JOIN  [EC].[Employee_Hierarchy] eh
	    ON [wl].[EMPID] = [eh].[Emp_ID] JOIN [EC].[Employee_Hierarchy] sh
	    ON [wl].[SubmitterID] = [sh].[Emp_ID] JOIN [EC].[DIM_Status] s
	    ON [wl].[StatusID] = [s].[StatusID] JOIN [EC].[DIM_Source] sc
        ON [wl].[SourceID] = [sc].[SourceID] JOIN [EC].[DIM_Site] st
	    ON [wl].[SiteID] = [st].[SiteID] JOIN [EC].[DIM_Module] m ON [wl].[ModuleID] = [m].[ModuleID]
	     Where [wl].[WarningID] = '''+CONVERT(NVARCHAR(20),@intFormIDin) + ''''
		

EXEC (@nvcSQL)
--Print (@nvcSQL)
	    
END --sp_SelectFrom_SRMGR_EmployeeWarning_Review


GO


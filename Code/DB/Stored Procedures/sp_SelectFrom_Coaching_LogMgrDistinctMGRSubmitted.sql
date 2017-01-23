/*
sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 04/16/2015
-- Modified during dashboard redesign SCR 14422.
-- 1. To Replace old style joins.
-- 2. Added All Managers to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

SET @strFormStatus = 'Inactive'
SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 
'SELECT X.MGRText, X.MGRValue FROM
(SELECT ''All Managers'' MGRText, ''%'' MGRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Mgr_Name	MGRText, eh.Mgr_Name MGRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+''' 
and s.Status <> '''+@strFormStatus+'''
and eh.Mgr_Name is NOT NULL
and sh.Emp_ID <> ''999999'') X
Order By X.Sortorder, X.MgrText'

		
EXEC (@nvcSQL)	

End -- sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted


GO


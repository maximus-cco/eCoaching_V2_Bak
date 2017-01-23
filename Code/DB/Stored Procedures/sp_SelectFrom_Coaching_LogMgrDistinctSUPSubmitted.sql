/*
sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted]
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
-- 2. Added All Supervisors to the return.
-- 3. Lan ID association by date.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Inactive'
Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = 'SELECT X.SUPText, X.SUPValue FROM
(SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.SUP_Name	SUPText, eh.SUP_Name SUPValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh ON
cl.SubmitterID = sh.EMP_ID JOIN [EC].[DIM_Status] s ON
cl.StatusID = s.StatusID
where sh.Emp_ID = '''+@nvcMGRID+'''
and s.Status <> '''+@strFormStatus+'''
and eh.SUP_Name is NOT NULL
and sh.Emp_ID  <> ''999999'') X
Order By X.Sortorder, X.SUPText'

		
EXEC (@nvcSQL)	

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted



GO


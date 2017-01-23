/*
sp_SelectFrom_Coaching_LogMgrDistinctCSR(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
-- Last Updated By: Susmitha Palacherla
-- Last Modified Date: 08/25/2015
-- Modified per TFS 599 to fix typo for 'All Employees'
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSR] @strCSRMGRin nvarchar(30)
AS


BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@strFormStatus2 nvarchar(30),
@strFormStatus3 nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime

Set @strFormStatus = 'Pending Manager Review'
Set @strFormStatus2 = 'Pending Supervisor Review'
Set @strFormStatus3 = 'Pending Acknowledgement'
Set @dtmDate  = GETDATE()   
Set @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)


SET @nvcSQL =  'SELECT X.EmpText, X.EmpValue FROM
(SELECT ''All Employees'' EmpText, ''%'' EmpValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	EmpText, eh.Emp_Name EmplValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[DIM_Status] s ON 
cl.StatusID = s.StatusID 
where (([eh].[Mgr_ID] =   '''+@nvcMGRID+''' and [S].[Status] = '''+@strFormStatus+''')
 OR ([eh].[Sup_ID] =   '''+@nvcMGRID+''' and ([S].[Status] = '''+@strFormStatus2+''' or [S].[Status] = '''+@strFormStatus3+''')))
and eh.Emp_Name is NOT NULL
and ([eh].[Mgr_ID] <> ''999999'' AND [eh].[Sup_ID] <> ''999999'')) X
ORDER BY X.Sortorder, X.EmpText'
		
		
EXEC (@nvcSQL)
--PRINT @nvcSQL
	

End --sp_SelectFrom_Coaching_LogMgrDistinctCSR



GO


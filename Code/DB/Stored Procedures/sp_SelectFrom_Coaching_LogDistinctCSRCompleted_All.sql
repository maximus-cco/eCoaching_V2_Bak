/*
sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of all Employees who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--   Created during SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All] 


AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT X.CSRText, X.CSRValue FROM
(SELECT ''All Employees'' CSRText, ''%'' CSRValue, 01 Sortorder From [EC].[Employee_Hierarchy]
UNION
SELECT DISTINCT eh.Emp_Name	CSRText, cl.EmpID CSRValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID 
where cl.StatusID <> 2
and cl.EmpID is not NULL
) X
Order By X.Sortorder, X.CSRText'

		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All



GO


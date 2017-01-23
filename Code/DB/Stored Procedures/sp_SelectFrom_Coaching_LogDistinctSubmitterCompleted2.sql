/*
sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	03/10/2015
--  Description: Populates the Submitter values in the dashboard filter dropdown.
--  Created as part of SCR 14422 for the dashboard redesign.
-- Last Modified Date: 05/28/2015
-- Modified to add unknown as a constant per SCr 14893 Round 2 perf improvement.
-- 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)

-- UNION of 3 separate selects for ordering.
-- Wild card value followed by regular data followed by unknown values.

SET @nvcSQL = 'SELECT X.SubmitterText, X.SubmitterValue FROM
(SELECT ''All Submitters'' SubmitterText, ''%'' SubmitterValue, 01 Sortorder 
UNION
SELECT DISTINCT sh.Emp_Name	SubmitterText, cl.SubmitterID SubmitterValue, 02 Sortorder
FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON
cl.EmpID = eh.Emp_ID JOIN [EC].[Employee_Hierarchy] sh  ON
cl.SubmitterID = sh.Emp_ID
where cl.SubmitterID is not NULL 
and cl.SubmitterID  <> ''999999''
and cl.StatusID <> 2
UNION
SELECT ''Unknown'' SubmitterText, ''999999'' SubmitterValue, 03 Sortorder
)X
ORDER BY X.Sortorder, X.SubmitterText'


--Print @nvcSQL
EXEC (@nvcSQL)	


End --sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2




GO


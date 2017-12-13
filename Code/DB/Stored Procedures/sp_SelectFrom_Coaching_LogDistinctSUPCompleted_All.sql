IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of all Supervisors who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--  Created during SCR 14893 Round 2 Performance improvements.
--  TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @nvcSQL = '
SELECT X.SUPText, X.SUPValue 
FROM (
       SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder
       UNION
       SELECT DISTINCT veh.Sup_Name	SUPText, eh.Sup_ID SUPValue, 02 Sortorder
       FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	   JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	   JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
       WHERE cl.StatusID <> 2 AND veh.Sup_Name IS NOT NULL AND eh.Sup_ID <> ''999999'' 
) X
ORDER BY X.Sortorder, X.SUPText'

EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

END --sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All
GO
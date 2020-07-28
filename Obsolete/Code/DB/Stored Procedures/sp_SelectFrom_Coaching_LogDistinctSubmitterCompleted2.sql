IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2' 
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
--  Last Modified Date: 05/28/2015
--  Modified to add unknown as a constant per SCr 14893 Round 2 perf improvement.
--  TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2] 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

-- UNION of 3 separate selects for ordering.
-- Wild card value followed by regular data followed by unknown values.

SET @nvcSQL = '
SELECT X.SubmitterText, X.SubmitterValue 
FROM (
       SELECT ''All Submitters'' SubmitterText, ''%'' SubmitterValue, 01 Sortorder 
       UNION
       SELECT DISTINCT veh.Emp_Name SubmitterText, cl.SubmitterID SubmitterValue, 02 Sortorder
       FROM [EC].[Employee_Hierarchy] eh
	   JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	   JOIN [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) ON cl.SubmitterID = veh.Emp_ID
       WHERE cl.SubmitterID IS NOT NULL AND cl.SubmitterID  <> ''999999'' AND cl.StatusID <> 2
       UNION
       SELECT ''Unknown'' SubmitterText, ''999999'' SubmitterValue, 03 Sortorder
) X
ORDER BY X.Sortorder, X.SubmitterText'

--Print @nvcSQL
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	

End --sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2
GO
IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/10/2015
--	Description: *	This procedure selects a list of Employees at a selected site who have completed or pending 
--  eCoaching records to display in the Historical dashboard filter dropdown.
--  Created during SCR 14893 Round 2 Performance improvements.
--  TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site] 
@strCSRSitein nvarchar(30)

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @nvcSQL = '
SELECT X.CSRText, X.CSRValue 
FROM (
       SELECT ''All Employees'' CSRText, ''%'' CSRValue, 01 Sortorder
       UNION
       SELECT DISTINCT veh.Emp_Name	CSRText, cl.EmpID CSRValue, 02 Sortorder
       FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	   JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = veh.Emp_ID 
       WHERE cl.StatusID <> 2 
	     AND cl.EmpID IS NOT NULL 
		 AND CONVERT(nvarchar,cl.SiteID) = '''+@strCSRSitein+'''
) X
ORDER BY X.Sortorder, X.CSRText'
		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	

End --sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site
GO
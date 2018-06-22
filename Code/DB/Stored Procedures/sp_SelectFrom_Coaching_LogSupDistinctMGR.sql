IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogSupDistinctMGR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct supervisors from e-Coaching records to display on dashboard for filter. 
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date: 04/16/2015
--  Modified during dashboard redesign SCR 14422.
--    1. To Replace old style joins.
--    2. Added All Managers to the return
--    3. Lan ID association by date
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--  My Dashboard move to new architecture. TFS 7137 - 06/01/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogSupDistinctMGR] @strCSRSUPIDin nvarchar(10)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @nvcSQL = '
SELECT X.MGRText AS Name, X.MGRValue AS ID
FROM
(
    SELECT ''All Managers'' MGRText, ''-1'' MGRValue, 01 Sortorder
    UNION
    SELECT DISTINCT veh.Mgr_Name MGRText, eh.Mgr_ID MGRValue, 02 Sortorder
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
    JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[Employee_Hierarchy] sh ON cl.SubmitterID = sh.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID
    WHERE sh.Emp_ID = '''+ @strCSRSUPIDin +'''
      AND cl.StatusID <> 2
      AND veh.Mgr_Name IS NOT NULL
      AND sh.Emp_ID <> ''999999''
) X
ORDER BY X.Sortorder, X.MgrText';
		
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	

END --sp_SelectFrom_Coaching_LogSupDistinctMGR




GO



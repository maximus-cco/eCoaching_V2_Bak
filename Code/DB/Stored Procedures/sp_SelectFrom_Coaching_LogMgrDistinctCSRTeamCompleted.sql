IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/11
--	Description: *	This procedure selects the distinct CSRs from e-Coaching records to display on dashboard for filter. 
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date: 04/16/2015
--  Modified during dashboard redesign SCR 14422.
--    1. To Replace old style joins.
--    2. Added All Employees to the return.
--    3. Lan ID association by date.
--  TFS 7856 encryption/decryption - emp name
--  My Dashboard move to new architecture. TFS 7137 - 06/01/2018
--  Allow senior managers to review logs. TFS 18062- 08/14/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted] 

@strCSRMGRIDin nvarchar(10)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)



-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];



SET @nvcSQL = '
SELECT X.EmpText, X.EmpValue 
FROM
(
    SELECT ''All Employees'' EmpText, ''-1'' EmpValue, 01 Sortorder
    UNION
    SELECT DISTINCT veh.Emp_Name EmpText, veh.Emp_ID EmplValue, 02 Sortorder
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
    WHERE (eh.[Mgr_ID] = '''+ @strCSRMGRIDin +''' OR eh.[SrMgrLvl1_ID] = '''+ @strCSRMGRIDin +''' OR eh.[SrMgrLvl2_ID] = '''+ @strCSRMGRIDin +''' OR eh.[SrMgrLvl3_ID] = '''+ @strCSRMGRIDin +''')
	AND [cl].[StatusID] = 1 AND veh.Emp_Name IS NOT NULL AND eh.[Mgr_ID] <> ''999999''
) X
ORDER BY X.Sortorder, X.EmpText'
		
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];

End --sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted


GO



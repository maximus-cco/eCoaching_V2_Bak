IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam]
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
--    2. Added All Supervisors to the return.
--    3. Lan ID association by date.
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--  My Dashboard move to new architecture. TFS 7137 - 06/01/2018
--  Allow senior managers to review logs. TFS 18062- 08/14/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam] 
@strCSRMGRIDin nvarchar(10)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];



SET @nvcSQL = '
SELECT X.SUPText, X.SUPValue
FROM
(
    SELECT ''All Supervisors'' SUPText, ''-1'' SUPValue, 01 Sortorder
    UNION
    SELECT DISTINCT sveh.Emp_Name SUPText, eh.SUP_ID SUPValue, 02 Sortorder
    FROM [EC].[Employee_Hierarchy] eh JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) 
	ON cl.EmpID = eh.Emp_ID JOIN [EC].[View_Employee_Hierarchy] sveh WITH (NOLOCK)
	ON eh.Sup_ID = sveh.Emp_ID JOIN [EC].[DIM_Status] s
	ON cl.StatusID = s.StatusID
    WHERE (eh.[Mgr_ID] = '''+ @strCSRMGRIDin +''' OR eh.[SrMgrLvl1_ID] = '''+ @strCSRMGRIDin +''' OR eh.[SrMgrLvl2_ID] = '''+ @strCSRMGRIDin +''' OR eh.[SrMgrLvl3_ID] = '''+ @strCSRMGRIDin +''')
      AND S.Status like ''Pending%''
      AND sveh.Emp_Name is NOT NULL
      AND eh.Mgr_ID <> ''999999''
) X
ORDER BY X.Sortorder, X.SUPText';
		
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];

End --sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam


GO



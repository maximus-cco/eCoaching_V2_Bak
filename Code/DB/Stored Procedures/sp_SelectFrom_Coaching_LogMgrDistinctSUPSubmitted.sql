IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted' 
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
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date: 04/16/2015
--  Modified during dashboard redesign SCR 14422.
--    1. To Replace old style joins.
--    2. Added All Supervisors to the return.
--    3. Lan ID association by date.
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted] 
@strCSRMGRin nvarchar(30)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcMGRID Nvarchar(10),
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strFormStatus = 'Inactive'
SET @dtmDate  = GETDATE()   
SET @nvcMGRID = EC.fn_nvcGetEmpIdFromLanID(@strCSRMGRin,@dtmDate)

SET @nvcSQL = '
SELECT X.SUPText, X.SUPValue 
FROM
(
    SELECT ''All Supervisors'' SUPText, ''%'' SUPValue, 01 Sortorder
    UNION
    SELECT DISTINCT veh.SUP_Name SUPText, veh.SUP_Name SUPValue, 02 Sortorder
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = veh.Emp_ID 
	JOIN [EC].[Employee_Hierarchy] sh ON cl.SubmitterID = sh.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID
    WHERE sh.Emp_ID = '''+@nvcMGRID+'''
      AND s.Status <> '''+@strFormStatus+'''
      AND veh.SUP_Name IS NOT NULL
      AND sh.Emp_ID  <> ''999999''
) X
ORDER BY X.Sortorder, X.SUPText';
		
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

END --sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted
GO
IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	11/16/2011
--	Description: This procedure selects the pending and completed records from the Coaching_Log table 
--  and displays on the My submissions manager dashboard where the logged in manager is the ecl submitter. 
--  Last Updated By: Susmitha Palacherla
--  Last Modified Date:04/16/2015
--  Modified during dashboard redesign SCR 14422.
--    1. To Replace old style joins.
--    2. Lan ID association by date.
--  TFS 7856 encryption/decryption - emp name
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR] 
@strUserin nvarchar(30),
@strCSRin nvarchar(30), 
@strCSRSupin nvarchar(30),
@strCSRMgrin nvarchar(30), 
@strStatusin nvarchar(30) 

AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max),
@strFormStatus nvarchar(30),
@nvcSubmitterID Nvarchar(10),
@dtmDate datetime;

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @strFormStatus = 'Inactive'
SET @dtmDate  = GETDATE()   
SET @nvcSubmitterID  = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate)
 
SET @nvcSQL = '
SELECT  cl.[FormName] strFormID,
		s.[Status]	strFormStatus,
		veh.[Emp_Name]	strCSRName,
		veh.[Sup_Name]	strCSRSupName,
		veh.[Mgr_Name]	strCSRMgrName,
		cl.[SubmittedDate] SubmittedDate
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON cl.EmpID = veh.Emp_ID 
JOIN [EC].[Employee_Hierarchy] sh ON cl.SubmitterID = sh.EMP_ID 
JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID
WHERE sh.Emp_ID = '''+@nvcSubmitterID+''' 
  AND veh.[Emp_Name] LIKE '''+@strCSRin+'''
  AND veh.[Sup_Name] LIKE '''+@strCSRSupin+'''
  AND veh.[Mgr_Name] LIKE '''+@strCSRMgrin+'''
  AND s.[Status] LIKE '''+@strStatusin+'''
  AND s.[Status] <> '''+@strFormStatus+'''
  AND sh.Emp_ID <> ''999999''
ORDER BY cl.[SubmittedDate] DESC'
		
EXEC (@nvcSQL)	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    	    
END --sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR
GO
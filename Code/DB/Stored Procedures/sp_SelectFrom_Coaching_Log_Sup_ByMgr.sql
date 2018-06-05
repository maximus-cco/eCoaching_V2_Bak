/*
sp_SelectFrom_Coaching_Log_Sup_ByMgr(01).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during hist dashboard redesign.  TFS 7138 - 04/30/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Sup_ByMgr' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Sup_ByMgr]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/23/2018
--	Description: *	This procedure selects a list of all Employees who have identified 
--  as Supervisors during log submisison.
-- This Procedure is only looking for Managers of non Inactive logs.
-- Created during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--	=====================================================================
CREATE  PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Sup_ByMgr] 
@nvcMgrID nvarchar(10)

AS

BEGIN
DECLARE	
@mgrwhere nvarchar(200),
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

SET @mgrwhere = ''
IF @nvcMgrID <> '-1'


BEGIN
	SET @mgrwhere = @mgrwhere + ' AND [sh].[Sup_Id] =  '''+ @nvcMgrID + ''''
END


SET @nvcSQL = '
SELECT   X.SupervisorId, X.Supervisor
FROM (
       SELECT ''-1'' SupervisorId, ''All Supervisors'' Supervisor,  01 Sortorder
       UNION
       SELECT DISTINCT sh.Emp_Id SupervisorId, vsh.Emp_Name Supervisor,  02 Sortorder
       FROM [EC].[Coaching_Log] cl WITH(NOLOCK)  JOIN  [EC].[Employee_Hierarchy] eh
	   ON cl.[EmpId] = eh.[Emp_Id] JOIN  [EC].[Employee_Hierarchy] sh 
	   ON eh.[Sup_Id] = sh.[Emp_Id] JOIN  [EC].[View_Employee_Hierarchy] vsh WITH (NOLOCK) 
	   ON sh.[Emp_Id] = vsh.[Emp_Id] 
	   JOIN [EC].[Employee_Hierarchy] mh 
	   ON sh.[Sup_Id] = mh.[Emp_Id]
	   WHERE cl.StatusID <> 2 ' +
	   @mgrwhere + ' ' + '
	     AND vsh.Emp_Name IS NOT NULL 
		 AND sh.Emp_Id  <> ''999999''
) X
ORDER BY X.Sortorder, X.Supervisor'
		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

End --sp_SelectFrom_Coaching_Log_Sup_ByMgr
GO




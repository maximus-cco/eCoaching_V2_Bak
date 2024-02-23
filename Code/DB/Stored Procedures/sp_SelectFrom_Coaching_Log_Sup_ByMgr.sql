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
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Sup_ByMgr] 
@nvcMgrID nvarchar(10), @intSiteID INT

AS

BEGIN
DECLARE	
@conditionalwhere nvarchar(200),
@NewLineChar nvarchar(2),
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @NewLineChar = CHAR(13) + CHAR(10);

SET @conditionalwhere = '';
/*
-1 All Sites
-3 Sub Sites
-4 Maximus Sites
*/

IF @intSiteID NOT IN (-1,-3,-4)
BEGIN
	SET @conditionalwhere = @conditionalwhere + ' AND [cl].[SiteID] =   '''+CONVERT(NVARCHAR,@intSiteID)+'''';
END

IF @intSiteID = -3

BEGIN
	SET @conditionalwhere = @conditionalwhere + ' AND [eh].[isSub] =   ''Y''' ;
END

IF @intSiteID = -4

BEGIN
	SET @conditionalwhere = @conditionalwhere + ' AND [eh].[isSub] =   ''N''' ;
END


IF @nvcMgrID <> '-1'

BEGIN
	SET @conditionalwhere = @conditionalwhere + @NewLineChar + ' AND [sh].[Sup_Id] =  '''+ @nvcMgrID + '''';
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
	   @conditionalwhere + ' ' + '
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



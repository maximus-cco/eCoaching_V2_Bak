SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/23/2018
--	Description: *	This procedure selects a list of all Employees who have identified 
--  as Managers during log submisison.
-- This Procedure is only looking for Managers of non Inactive logs.
-- Created during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Mgr_BySite] 
@intSiteID INT

AS

BEGIN
DECLARE	
@conditionalwhere nvarchar(200),
@NewLineChar nvarchar(2),
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];

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

SET @nvcSQL = '
SELECT   X.ManagerId, X.Manager
FROM (
       SELECT ''-1'' ManagerId, ''All Managers'' Manager,  01 Sortorder
       UNION
       SELECT DISTINCT eh.Mgr_Id ManagerId, veh.Mgr_Name Manager,  02 Sortorder
       FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN  [EC].[Employee_Hierarchy] eh 
	   ON cl.[EmpId] = eh.[Emp_Id] JOIN  [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	   ON eh.[EMP_ID] = veh.[EMP_ID]
	   WHERE cl.StatusID <> 2 ' +
	   @conditionalwhere + ' ' + '
	     AND veh.Mgr_Name IS NOT NULL 
		 AND eh.Mgr_ID  <> ''999999''
) X
ORDER BY X.Sortorder, X.Manager'
		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

End --sp_SelectFrom_Coaching_Log_Mgr_BySite
GO



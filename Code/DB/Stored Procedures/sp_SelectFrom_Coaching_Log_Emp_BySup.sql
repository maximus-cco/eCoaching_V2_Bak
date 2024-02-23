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
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Emp_BySup] 
@nvcSupID nvarchar(10), @intEmpActive int, @intSiteID INT, @nvcMgrID nvarchar(10)

AS

BEGIN
DECLARE	
@where nvarchar(200),
@NewLineChar nvarchar(2),
@nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @NewLineChar = CHAR(13) + CHAR(10)

SET @where = ''

/*
-1 All Sites
-3 Sub Sites
-4 Maximus Sites
*/

IF @intSiteID NOT IN (-1,-3,-4)
BEGIN
	SET @where = @where + ' AND [cl].[SiteID] =   '''+CONVERT(NVARCHAR,@intSiteID)+'''';
END

IF @intSiteID = -3

BEGIN
	SET @where = @where + ' AND [eh].[isSub] =   ''Y''' ;
END

IF @intSiteID = -4

BEGIN
	SET @where = @where + ' AND [eh].[isSub] =   ''N''' ;
END

IF @nvcMgrID <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Mgr_Id] =  '''+ @nvcMgrID + ''''
END


IF @nvcSupID <> '-1'
BEGIN
	SET @where = @where + @NewLineChar + ' AND [eh].[Sup_Id] =  '''+ @nvcSupID + ''''
END

-- 1 for Active 2 for Inactive 3 for All

IF @intEmpActive  <> 3
BEGIN
    IF @intEmpActive = 1
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] NOT IN (''T'',''D'')'
	ELSE
	SET @where = @where + @NewLineChar + ' AND [eh].[Active] IN (''T'',''D'')'
END

SET @nvcSQL = '
SELECT   X.EmployeeId, X.Employee
FROM (
       SELECT ''-1'' EmployeeId, ''All Employees'' Employee,  01 Sortorder
       UNION
       SELECT DISTINCT eh.Emp_ID EmployeeId, veh.Emp_Name Employee,  02 Sortorder
       FROM [EC].[Coaching_Log] cl WITH(NOLOCK) JOIN  [EC].[Employee_Hierarchy] eh 
	   ON cl.[EMPID] = eh.[EMP_ID] JOIN  [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK) 
	   ON eh.[EMP_ID] = veh.[EMP_ID] JOIN [EC].[DIM_Site]S
       ON S.City = EH.Emp_Site
	   WHERE cl.StatusID <> 2 ' +
	   @where + ' ' + '
	     AND veh.Emp_Name IS NOT NULL 
		 AND cl.EmpID  <> ''999999''
) X
ORDER BY X.Sortorder, X.Employee'
		
EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 

End --sp_SelectFrom_Coaching_Log_Emp_BySup
GO



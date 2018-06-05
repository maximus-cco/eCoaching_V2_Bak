/*
sp_SelectFrom_Coaching_Log_Emp_BySup(01).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision created during hist dashboard redesign.  TFS 7138 - 04/30/2018

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_Emp_BySup' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Emp_BySup]
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
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_Emp_BySup] 
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

IF @nvcMgrID <> '-1'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_Id] =  '''+ @nvcMgrID + ''''
END


IF @nvcSupID <> '-1'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_Id] =  '''+ @nvcSupID + ''''
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
	   WHERE cl.StatusID <> 2 
	   AND  (S.SiteID =('''+CONVERT(NVARCHAR,@intSiteID)+''') or '''+ CONVERT(NVARCHAR,@intSiteID) + ''' = -1)' +
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




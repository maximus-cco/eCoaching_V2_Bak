IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectCSRsbyLocation' 
)
   DROP PROCEDURE [EC].[sp_SelectCSRsbyLocation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	12/13/13
--	Description: 	This procedure selects the CSRs from a table by location
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCSRsbyLocation] 
(
  @strCSRSitein nvarchar(30)
)
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max),
  @strEDate nvarchar(8),
  @strRole1 nvarchar(30),
  @strRole2 nvarchar(30),
  @strRole3 nvarchar(30),
  @strRole4 nvarchar(30);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @strEDate = '99991231';
SET @strRole1 = 'WACS01';
SET @strRole2 = 'WACS02';
SET @strRole3 = 'WACS03';
SET @strRole4 = '%Engineer%';

SET @nvcSQL = '
SELECT veh.Emp_Name + '' ('' + veh.Emp_LanID + '') '' + Emp_Job_Description AS FrontRow1
  ,veh.Emp_Name + ''$'' + veh.Emp_Email + ''$'' + veh.Emp_LanID + ''$'' + veh.Sup_Name + ''$'' + veh.Sup_Email + ''$'' + veh.Sup_LanID + ''$'' + Sup_Job_Description + ''$'' + veh.Mgr_Name + ''$'' + veh.Mgr_Email + ''$'' + veh.Mgr_LanID + ''$'' + Mgr_Job_Description AS BackRow1
  ,Emp_Site
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON veh.Emp_ID = eh.Emp_ID
WHERE (Emp_Job_Code LIKE ''' + @strRole1 + ''' OR Emp_Job_Code LIKE ''' + @strRole2 + ''' OR Emp_Job_Code LIKE ''' + @strRole3 + ''' OR Emp_Job_Description LIKE ''' + @strRole4+''') 
  AND End_Date = ''99991231''
  AND Emp_Site = ''' + @strCSRSitein + '''
  AND veh.Emp_LanID IS NOT NULL 
  AND veh.Sup_LanID IS NOT NULL 
  AND veh.Mgr_LanID IS NOT NULL
ORDER BY Emp_Site ASC, veh.Emp_Name ASC';

EXEC (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	
	    
END -- sp_SelectCSRsbyLocation
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Module(s) for the logged in user. 
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
--  Modified to support Encryption of sensitive data - Open key. TFS 7856 - 10/23/2017
--  Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Modules_By_LanID] 
@nvcEmpLanIDin nvarchar(30),@strTypein nvarchar(10)= NULL

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@strATWarnAdminUser nvarchar(10),
	@strATCoachAdminUser nvarchar(10),
	@strATSubAdmin nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@dtmDate datetime

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)

--print @nvcEmpID
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)

--print @nvcEmpJobCode

SET @strATWarnAdminUser = EC.fn_strCheckIfATWarningAdmin(@nvcEmpID) 
--print @strATWarnAdminUser

SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@nvcEmpID) 
--print @strATCoachAdminUser

SET @strATSubAdmin = (SELECT CASE WHEN EXISTS ( SELECT 1 FROM [EC].[AT_User_Role_Link] WHERE [UserId] = @nvcEmpID AND [RoleId] = 120) THEN 'YES' ELSE 'NO'END );
--print @strATSubAdmin

IF @strATSubAdmin  = 'YES'
SET @nvcSQL = 'SELECT DISTINCT ModuleId, Module 
			   FROM [EC].[DIM_Module]
			   WHERE [isActive] = 1 AND [isSub] = 1
			   ORDER BY Module'

 ELSE IF ((@nvcEmpID = '999999')  
   OR (@strATWarnAdminUser = 'YES' AND @strATCoachAdminUser = 'YES')
   OR (@strTypein is NULL AND @strATCoachAdminUser = 'YES')
   OR (@strTypein = 'Coaching' AND @strATCoachAdminUser = 'YES')
   OR (@strTypein = 'Warning' AND @strATWarnAdminUser = 'YES'))

SET @nvcSQL = 'SELECT DISTINCT ModuleId, Module 
			   FROM [EC].[DIM_Module]
			   WHERE [isActive] = 1
			   ORDER BY Module'
			   
ELSE

SET @nvcSQL = 'SELECT ModuleId, Module 
			   FROM [EC].[AT_Module_Access]
			   WHERE [JobCode]= '''+@nvcEmpJobCode+'''
			   AND [isActive]=1
			   ORDER BY Module'

--Print @nvcSQL

EXEC (@nvcSQL)	

CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Modules_By_LanID
GO



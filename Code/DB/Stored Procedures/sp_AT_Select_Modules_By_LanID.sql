/*
sp_AT_Select_Modules_By_LanID(02).sql
Last Modified Date: 10/23/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Modules_By_LanID' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Modules_By_LanID]
GO
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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Modules_By_LanID] 
@nvcEmpLanIDin nvarchar(30),@strTypein nvarchar(10)= NULL

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@strATWarnAdminUser nvarchar(10),
	@strATCoachAdminUser nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@dtmDate datetime

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)
SET @strATWarnAdminUser = EC.fn_strCheckIfATWarningAdmin(@nvcEmpID) 
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@nvcEmpID) 


IF ((@strATWarnAdminUser = 'YES' AND @strATCoachAdminUser = 'YES')
   OR (@strTypein is NULL AND @strATCoachAdminUser = 'YES')
   OR (@strTypein = 'Coaching' AND @strATCoachAdminUser = 'YES')
   OR (@strTypein = 'Warning' AND @strATWarnAdminUser = 'YES'))

SET @nvcSQL = 'SELECT DISTINCT ModuleId, Module 
			   FROM [EC].[AT_Module_Access]
			   WHERE [isActive]=1
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
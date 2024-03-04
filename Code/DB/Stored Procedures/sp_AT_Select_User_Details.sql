SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:	Susmitha Palacherla
--	Create Date: 01/18/2018
--	Description: Given a UserLanID and returns the User Details for Active users. 
--  Revision History:    
--  Initial Revision. Created to replace embedded sql in UI code during encryption of sensitive data. TFS 7856. 01/18/2018
--  Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_User_Details]
@userLanId nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
    @dtmDate datetime,
	@strATCoachAdminUser nvarchar(10),
    @strATSubAdmin nvarchar(10);

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]

SET @dtmDate  = GETDATE();  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@userLanId,@dtmDate);
SET @strATCoachAdminUser = EC.fn_strCheckIfATCoachingAdmin(@nvcEmpID);
SET @strATSubAdmin = (SELECT CASE WHEN EXISTS ( SELECT 1 FROM [EC].[AT_User_Role_Link] WHERE [UserId] = @nvcEmpID  AND [RoleId] = 120) THEN 'YES' ELSE 'NO'END );

SET @nvcSQL = 'SELECT [UserId]
					  ,CONVERT(nvarchar(30),DecryptByKey(UserLanID)) AS [UserLanID]
                      ,CONVERT(nvarchar(50),DecryptByKey(UserName))[UserName]
                      ,[EmpJobCode]
                      ,u.[Active]
					  ,eh.[isSub]
					  ,s.[SiteID]
					  ,'''+@strATCoachAdminUser+''' isSysAdmin
					  ,'''+@strATSubAdmin+''' isSubAdmin
               FROM [EC].[AT_User] u INNER JOIN [EC].[Employee_Hierarchy]eh
			   ON u.[UserId] = eh.[Emp_Id] LEFT JOIN EC.DIM_SITE s 
			   ON eh.[Emp_Site] = s.[City]
		       WHERE u.UserID = '''+@nvcEmpID+'''
			   AND u.Active = 1'

--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_User_Details

GO



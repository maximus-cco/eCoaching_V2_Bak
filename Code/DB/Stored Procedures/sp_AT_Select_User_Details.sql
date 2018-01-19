/*
sp_AT_Select_User_Details(01).sql
Last Modified Date: 01/18/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_User_Details' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_User_Details]
GO


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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_User_Details]
@userLanId nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
    @dtmDate datetime

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@userLanId,@dtmDate)

SET @nvcSQL = 'SELECT [UserId]
					  ,CONVERT(nvarchar(30),DecryptByKey(UserLanID)) AS [UserLanID]
                      ,CONVERT(nvarchar(50),DecryptByKey(UserName))[UserName]
                      ,[EmpJobCode]
                      ,[Active]
               FROM [EC].[AT_User]u 
		       WHERE u.UserID = '''+@nvcEmpID+'''
			   AND u.Active = 1'

--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_User_Details





GO


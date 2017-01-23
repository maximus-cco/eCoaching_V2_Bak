/*
sp_AT_Select_Roles_By_User(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Select_Roles_By_User' 
)
   DROP PROCEDURE [EC].[sp_AT_Select_Roles_By_User]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/21/2016
--	Description: *	This procedure returns the list of Role(s) for the logged in user. 
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/27/12016
 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Select_Roles_By_User] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)


SET @nvcSQL = 'SELECT U.[UserId], [RoleDescription]
FROM [EC].[AT_User] U JOIN [EC].[AT_User_Role_Link] URL
ON U.[UserId]= URL.[UserId]JOIN [EC].[AT_ROLE]R ON
R.[RoleId]= URL.[RoleId]
WHERE U.[UserId]= '''+@nvcEmpID+''''

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Select_Roles_By_User


GO


/*
fn_strCheckIfATWarningAdmin(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strCheckIfATWarningAdmin' 
)
   DROP FUNCTION [EC].[fn_strCheckIfATWarningAdmin]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Susmitha Palacherla
-- Create date:  5/6/2016
-- Description:	Given an Employee ID returns if the user is aWarning Admin
-- Last Modified By:
-- Revision History:
--  Created per TFS 1709 - Initial setup of admin tool - 05/06/2016

-- =============================================
CREATE FUNCTION [EC].[fn_strCheckIfATWarningAdmin] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
	@intCountAdminRoles int,
	@strWarnAdmin nvarchar(10)
	
		 

 SET @intCountAdminRoles = (SELECT Count(r.[RoleId])
FROM [EC].[AT_Role]r JOIN [EC].[AT_User_Role_Link] ur
ON r.RoleId = ur.RoleId JOIN [EC].[AT_User]u 
ON u.UserId = ur.UserId 
WHERE r.IsSysAdmin = 1
AND r.RoleDescription like 'Warn%'
AND u.UserID = @strEmpID )
  
  IF     @intCountAdminRoles > 0
  SET    @strWarnAdmin = N'YES'
  ELSE
  SET    @strWarnAdmin = N'NO'
  
  RETURN   @strWarnAdmin
  
END --fn_strCheckIfATWarningAdmin






GO


/*
fn_strCheckIfATCoachingAdmin(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strCheckIfATCoachingAdmin' 
)
   DROP FUNCTION [EC].[fn_strCheckIfATCoachingAdmin]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Susmitha Palacherla
-- Create date:  5/6/2016
-- Description:	Given an Employee ID returns if the user is a Coaching Admin
-- Last Modified By:
-- Revision History:
--  Created per TFS 1709 - Initial setup of admin tool - 05/06/2016

-- =============================================
CREATE FUNCTION [EC].[fn_strCheckIfATCoachingAdmin] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 
	@intCountAdminRoles int,
	@strCoachAdmin nvarchar(10)
	
		 

 SET @intCountAdminRoles = (SELECT Count(r.[RoleId])
FROM [EC].[AT_Role]r JOIN [EC].[AT_User_Role_Link] ur
ON r.RoleId = ur.RoleId JOIN [EC].[AT_User]u 
ON u.UserId = ur.UserId 
WHERE r.IsSysAdmin = 1
AND r.RoleDescription like 'Coach%'
AND u.UserID = @strEmpID )
  
  IF     @intCountAdminRoles > 0
  SET    @strCoachAdmin = N'YES'
  ELSE
  SET    @strCoachAdmin = N'NO'
  
  RETURN   @strCoachAdmin
  
END --fn_strCheckIfATCoachingAdmin






GO


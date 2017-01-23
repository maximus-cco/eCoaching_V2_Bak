/*
sp_AT_Check_Entitlements(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Check_Entitlements' 
)
   DROP PROCEDURE [EC].[sp_AT_Check_Entitlements]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/22/2016
--	Description: *	This procedure returns the list of Entitlements 
--  within the eCoaching admin tool for a given user.
--  Last Modified By: 
--  Last Modified date: 
--  Revision History:
--  Initial Revision. Admin tool setup, TFS 1709- 4/2/12016
 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_AT_Check_Entitlements] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
    @dtmDate datetime

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)



 


SET @nvcSQL = 'SELECT DISTINCT [EntitlementId], [EntitlementDescription]
               FROM [EC].[AT_Entitlement]
               WHERE [EntitlementId] IN (
					 SELECT DISTINCT([EntitlementId]) 
                     FROM [EC].[AT_Role_Entitlement_Link]
		             WHERE [RoleId] IN (
                            SELECT DISTINCT([RoleId]) 
                            FROM [EC].[AT_User_Role_Link] ur 
		                    JOIN [EC].[AT_User]u ON u.UserId = ur.UserId 
		                     WHERE u.UserID = '''+@nvcEmpID+'''))'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_AT_Check_Entitlements

GO


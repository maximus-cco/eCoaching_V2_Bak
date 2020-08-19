/*
fn_strCheckIf_ACLRole(02).sql
Last Modified Date: 8/18/2020
Last Modified By: Susmitha Palacherla

Revision 02: Removed references to SrMgr. TFS 18062 - 08/18/2020
Initial Revision. Created during Mydashboard move to new architecture - TFS 7137 - 05/16/2018 

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strCheckIf_ACLRole' 
)
   DROP FUNCTION [EC].[fn_strCheckIf_ACLRole]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	=============================================
-- Author:		Susmitha Palacherla
-- Create date:  5/15/2018
-- Description:	Given an Employee ID and ACLRole returns 0 or 1 based on whether the 
-- user has an record in ACL table with given ACLRole.
-- Last Modified By:
-- Revision History:
-- Initial Revision. Created during Mydashboard move to new architecture - TFS 7137 - 05/15/2018 
-- Removed references to SrMgr. TFS 18062 - 08/18/2020
--	=============================================
CREATE FUNCTION [EC].[fn_strCheckIf_ACLRole] 
(
@nvcEmpID Nvarchar(10), @RoleCheck nvarchar(10)
)
RETURNS bit
AS
BEGIN
 


	 DECLARE @nvcEmpLanID nvarchar(30),
	         @intACLRowID int,
	         @nvcACLRole bit
	
	
	SET @nvcEmpLanID = (SELECT [EC].[fn_strEmpLanIDFromEmpID](@nvcEmpID))

	IF @RoleCheck = 'ARC'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'ARC'
						  AND [End_Date] = 99991231)

IF @RoleCheck = 'ECL'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'ECL'
						  AND [End_Date] = 99991231)

	IF @RoleCheck = 'DIR'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'DIR'
						  AND [End_Date] = 99991231)

	
IF @intACLRowID IS NOT NULL 
SET  @nvcACLRole = 1
ELSE
SET  @nvcACLRole = 0

RETURN 	@nvcACLRole

END --fn_strCheckIf_ACLRole

GO




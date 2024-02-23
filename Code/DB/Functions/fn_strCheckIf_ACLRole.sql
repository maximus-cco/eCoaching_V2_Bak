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
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=============================================
CREATE OR ALTER FUNCTION [EC].[fn_strCheckIf_ACLRole] 
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

	IF @RoleCheck = 'PM'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'PM'
						  AND [End_Date] = 99991231)
						  
	IF @RoleCheck = 'PMA'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'PMA'
						  AND [End_Date] = 99991231)

	IF @RoleCheck = 'DIRPM'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'DIRPM'
						  AND [End_Date] = 99991231)
						  
	IF @RoleCheck = 'DIRPMA'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'DIRPMA'
						  AND [End_Date] = 99991231)

	IF @RoleCheck = 'QAM'
	SET @intACLRowID = (SELECT [Row_ID] FROM [EC].[Historical_Dashboard_ACL]
						  WHERE CONVERT(nvarchar(30),DecryptByKey(User_LanID))= @nvcEmpLanID 
						  AND [Role] = 'QAM'
						  AND [End_Date] = 99991231)
	
IF @intACLRowID IS NOT NULL 
SET  @nvcACLRole = 1
ELSE
SET  @nvcACLRole = 0

RETURN 	@nvcACLRole

END --fn_strCheckIf_ACLRole

GO



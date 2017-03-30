/*
sp_rptModulesByRole(02).sql
Last Modified Date: 03/23/2017
Last Modified By: Susmitha Palacherla

Version 02: Additional Update. TFS 5621. Updated parameter name for lanID - 03/23/2017

Version 01: Document Initial Revision - Lili -  TFS 5621 - 03/09/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptModulesByRole' 
)
   DROP PROCEDURE [EC].[sp_rptModulesByRole]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/14/2017
--	Description: Selects list of Modules based on Role of logged in User.
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 - 03/14/2017
--  Updated parameter to @LanID - TFS 5621 - 03/23/2017
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptModulesByRole] 
(
@LanID nvarchar(30)= null,
 ------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   @returnCode int OUTPUT,
   @returnMessage varchar(80) OUTPUT
)
AS
   DECLARE @storedProcedureName varchar(80)
   DECLARE @transactionCount int

   SET @transactionCount = @@TRANCOUNT
   SET @returnCode = 0

   --Only start a transaction if one has not already been started
   IF @transactionCount = 0
   BEGIN
      BEGIN TRANSACTION currentTransaction
   END
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   SET @storedProcedureName = OBJECT_NAME(@@PROCID)
   SET @returnMessage = @storedProcedureName + ' completed successfully'
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
SET NOCOUNT ON

DECLARE	

	@nvcEmpID nvarchar(10),
	@intRoleID nvarchar(30),
	@dtmDate datetime

IF @LanID = '211palasu'
BEGIN
SET @LanID = 'susmitha.palacherla'
END	

SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@LanID,@dtmDate)


 SELECT DISTINCT ModuleID, CASE WHEN [ModuleID] = -1 THEN 'All' ELSE [Module] END AS Module
               FROM [EC].[DIM_Module]
               WHERE [ModuleId] IN (
   -- To display the 'All' option for SysAdmins only
                
       SELECT  DISTINCT -1 as [ModuleID] 
                     FROM [EC].[AT_Role_Module_Link]
		             WHERE [RoleId] IN (
                            SELECT DISTINCT(ur.[RoleId]) 
                            FROM [EC].[AT_User_Role_Link] ur 
		                    JOIN [EC].[AT_User]u ON u.UserId = ur.UserId 
		                    JOIN [EC].[AT_Role] r ON ur.RoleId = r.RoleId
		                     WHERE u.UserID = @nvcEmpID
		                     AND R.IsSysAdmin=1)
UNION        

-- To display the individual Module list for Role code

					 SELECT DISTINCT([ModuleID]) 
                     FROM [EC].[AT_Role_Module_Link]
		             WHERE [RoleId] IN (
                            SELECT DISTINCT([RoleId]) 
                            FROM [EC].[AT_User_Role_Link] ur 
		                    JOIN [EC].[AT_User]u ON u.UserId = ur.UserId 
		                     WHERE u.UserID = @nvcEmpID))
		                    

	    
-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
ENDPROC:
--  Commit or Rollback Transaction Only If We were NOT already in a Transaction
IF @transactionCount = 0
BEGIN
	IF @returnCode = 0
	BEGIN
		-- Commit Transaction
		commit transaction currentTransaction
	END
	ELSE 
	BEGIN
		-- Rollback Transaction
		rollback transaction currentTransaction
	END
END

PRINT STR(@returnCode) + ' ' + @returnMessage
RETURN @returnCode

-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------





GO



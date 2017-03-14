SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id('[EC].[sp_rptGetModules]') and OBJECTPROPERTY(id, 'IsProcedure') = 1)
drop procedure EC.sp_rptGetModules
GO

/***************************************************************** 
sp_rptGetModules
Description:
	Returns a list of modules for the specified user.

Tables:


Input Parameters:

Resultset:
	
 *****************************************************************/

CREATE  PROCEDURE [EC].[sp_rptGetModules]
(
   @JobCode varchar(10),
 --@userEmployeeId	varchar(20),
 
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
  --For now, return all modules
  SELECT -1 AS ModuleId, 'All' As ModuleName
  UNION
  SELECT ModuleID AS ModuleId, Module AS ModuleName from EC.DIM_Module 
  WHERE isActive = 1

  --SELECT dm.ModuleID AS ModuleId, modules.ModuleName
  --FROM  
  -- (SELECT job_code, CSR, supervisor, quality, lsa, training FROM ec.Module_Submission) ms
  --UNPIVOT
  --(Access FOR ModuleName IN (csr, supervisor, quality, lsa, training)) AS modules 
  --JOIN EC.DIM_Module dm ON dm.Module = modules.ModuleName 
  --WHERE Job_Code = @JobCode
  --AND Access =1

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


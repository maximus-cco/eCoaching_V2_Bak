/*
sp_rptCoachingEmployeesBySiteAndModule(01).sql
Last Modified Date: 01/18/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptCoachingEmployeesBySiteAndModule' 
)
   DROP PROCEDURE [EC].[sp_rptCoachingEmployeesBySiteAndModule]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	01/19/2018
--	Description: Selects list of Employees having Coaching logs for selected site and module combination
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - Encryption of sensitive data.TFS 7856 - 01/19/2018
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptCoachingEmployeesBySiteAndModule] 
(
@intModulein INT= NULL,
@intSitein INT = NULL,
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



-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 

	

SELECT s.EmpID, s.EmpName
FROM (Select '-1' as EmpID, 'All' as EmpName
UNION
SELECT DISTINCT CL.EmpID EmpID, CONVERT(nvarchar(70),DecryptByKey(Emp_Name)) AS EmpName 
FROM  EC.Coaching_Log AS cl JOIN  EC.Employee_Hierarchy eh
ON cl.EmpID = eh.Emp_ID
WHERE  (cl.ModuleID =(@intModulein) or @intModulein = -1) 
and  (cl.SiteID =(@intSitein) or @intSitein = -1) 
)as S
ORDER BY CASE WHEN EmpID = '-1' THEN 0 ELSE 1 END, EmpName


 
  -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey] 
	    
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



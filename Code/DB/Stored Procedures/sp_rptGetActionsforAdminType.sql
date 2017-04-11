/*
sp_rptGetActionsforAdminType(01).sql
Last Modified Date: 04/11/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - Suzy Palacherla -  TFS 5621 - 04/11/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptGetActionsforAdminType' 
)
   DROP PROCEDURE [EC].[sp_rptGetActionsforAdminType]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2017
--	Description: Displays the list of Admin Actions for Selected Type
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 - 4/10/2017
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptGetActionsforAdminType] 
(
@strTypein nvarchar(10),

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

-- Create a temp table to hold all Coaching admin activity logs for selected period

CREATE TABLE #CoachingActions ([Action] nvarchar(30))

-- Insert all actions available for Coaching logs into temp table

IF @strTypein in ('Coaching', 'All')

BEGIN

INSERT INTO #CoachingActions([Action])
(
SELECT 'All' AS [Action]

UNION

SELECT DISTINCT [Action]
FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]

UNION

SELECT 'Reassign' AS [Action]
FROM [EC].[AT_Coaching_Reassign_Audit]
)

END

-- Create a temp table to hold all Warning admin activity logs for selected period

CREATE TABLE #WarningActions([Action] nvarchar(30))

-- Insert all actions available for Warning logs into temp table

IF @strTypein in ('Warning', 'All')

BEGIN

INSERT INTO #WarningActions ([Action])
(
SELECT 'All' AS [Action]

UNION

SELECT DISTINCT [Action]
FROM [EC].[AT_Warning_Inactivate_Reactivate_Audit]
)
END

-- Display all actions available for coaching logs

IF @strTypein = 'Coaching'
BEGIN
SELECT DISTINCT [Action] FROM #CoachingActions
END

-- Display all actions available for warning logs

IF @strTypein = 'Warning'
BEGIN
SELECT DISTINCT [Action] FROM #WarningActions
END

-- Display all actions available for coaching and warning logs

IF @strTypein = 'All'

BEGIN 
SELECT s.[Action] FROM
(SELECT DISTINCT [Action]FROM #CoachingActions
UNION
SELECT DISTINCT [Action] FROM #WarningActions
)s
ORDER BY CASE WHEN [Action] = 'All' 
THEN 0 ELSE 1 END 
END

  -- Drop the temp tables
  
  DROP TABLE #CoachingActions
  DROP TABLE #WarningActions
	    
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



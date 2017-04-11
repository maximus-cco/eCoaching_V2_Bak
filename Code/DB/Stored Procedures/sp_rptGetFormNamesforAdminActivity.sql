/*
sp_rptGetFormNamesforAdminActivity(01).sql
Last Modified Date: 04/11/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - Suzy Palacherla -  TFS 5621 - 4/11/2017

*/



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptGetFormNamesforAdminActivity' 
)
   DROP PROCEDURE [EC].[sp_rptGetFormNamesforAdminActivity]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2017
--	Description: Displays the list of form names for selected admin activity criteria
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 - 4/10/2017
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptGetFormNamesforAdminActivity] 
(
@strTypein nvarchar(10),
@strActivityin nvarchar(20),
@strSDatein datetime,
@strEDatein datetime,

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
@strSDate nvarchar(10),
@strEDate nvarchar(10)

SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)

-- Create a temp table to hold all Coaching admin activity form names

CREATE TABLE #CoachingForms ([Form Name] nvarchar(50), [Action] nvarchar(30))


-- Insert all available form names from coaching audit table into temp table

IF @strTypein in ('Coaching', 'All')

BEGIN

INSERT INTO #CoachingForms ([Form Name],[Action])
(
SELECT DISTINCT cira.FormName AS [Form Name], [Action]
FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]cira JOIN [EC].[Coaching_Log]cl
ON cira.CoachingID = cl.CoachingID 
WHERE convert(varchar(8), ActionTimestamp,112) >= @strSDate
AND convert(varchar(8),ActionTimestamp,112) <= @strEDate

UNION

SELECT DISTINCT cra.FormName AS [Form Name], 'Reassign' AS [Action]
FROM [EC].[AT_Coaching_Reassign_Audit]cra JOIN [EC].[Coaching_Log]cl
ON cra.CoachingID = cl.CoachingID 
WHERE convert(varchar(8),ActionTimestamp,112) >= @strSDate
AND convert(varchar(8),ActionTimestamp,112) <= @strEDate
)

END

-- Create a temp table to hold all warning admin activity form names

CREATE TABLE #WarningForms ([Form Name] nvarchar(50), [Action] nvarchar(30))

IF @strTypein in ('Warning', 'All')


-- Insert all available form names from warning audit table into temp table

BEGIN

INSERT INTO #WarningForms ([Form Name],[Action])
(
SELECT DISTINCT wira.FormName AS [Form Name], [Action]
FROM [EC].[AT_Warning_Inactivate_Reactivate_Audit]wira JOIN [EC].[Warning_Log]wl
ON wira.WarningID = wl.WarningID 
WHERE convert(varchar(8), ActionTimestamp,112) >= @strSDate
AND convert(varchar(8),ActionTimestamp,112) <= @strEDate
)
END

-- Display all selected form names for coaching audit logs

IF @strTypein = 'Coaching'

SELECT DISTINCT s.[Form Name] FROM
(SELECT 'All' AS [Form Name]
UNION
SELECT DISTINCT [Form Name] FROM #CoachingForms
WHERE ([Action] =(@strActivityin) or @strActivityin = 'All'))s
ORDER BY [Form Name]


-- Display all selected form names for warning audit logs

IF @strTypein = 'Warning'
SELECT DISTINCT s.[Form Name] FROM
(SELECT 'All' AS [Form Name]
UNION
SELECT DISTINCT [Form Name] FROM #WarningForms
WHERE ([Action] =(@strActivityin) or @strActivityin = 'All'))s
ORDER BY [Form Name]

-- Display all selected form names for coaching and warning audit logs

IF @strTypein = 'All'

SELECT DISTINCT s.[Form Name] FROM
(SELECT 'All' AS [Form Name]
UNION
SELECT DISTINCT [Form Name] FROM #CoachingForms
UNION
SELECT DISTINCT [Form Name] FROM #WarningForms
)s
ORDER BY [Form Name]

  -- Drop the temp tables
  
  DROP TABLE #CoachingForms
  DROP TABLE #WarningForms 
	    
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



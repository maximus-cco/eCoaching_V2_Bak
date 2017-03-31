/*
sp_rptHierarchySummary(02).sql
Last Modified Date: 03/31/2017
Last Modified By: Susmitha Palacherla

Version 02: Added Site filter - TFS 5621 - 03/31/2017

Version 01: Document Initial Revision - Suzy Palacherla -  TFS 5621 - 03/29/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_rptHierarchySummary' 
)
   DROP PROCEDURE [EC].[sp_rptHierarchySummary]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2017
--	Description: Displays the hierarchy for a given employee at a give site.
--  Last Modified: 
--  Last Modified By:
--  Revision History:
--  Initial Revision - TFS 5621 - 03/31/2017

 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptHierarchySummary] 
(
@strEmpSitein nvarchar(20),
@strEmpin nvarchar(10),


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

       SELECT  eh.Emp_ID AS [Employee ID]
          ,CASE 
               WHEN eh.Emp_Job_Code IN ('WACS01', 'WACS02', 'WACS03') THEN 'CSR'
               WHEN eh.Emp_Job_Code = 'WACS40' THEN 'Supervisor'
               WHEN eh.Emp_Job_Code IN ('WACQ02', 'WACQ12', 'WACQ03')THEN 'Quality'
               WHEN eh.Emp_Job_Code IN ('WIHD01', 'WIHD02', 'WIHD03', 'WIHD04')THEN 'LSA'
               WHEN eh.Emp_Job_Code IN ('WTID13', 'WTTI02', 'WTTR12', 'WTTR13') THEN 'Training'
               ELSE 'NA' END AS [Module Name]
              ,eh.Emp_Name AS [Employee Name]
              ,ISNULL(eh.Emp_Site,'Unknown') AS [Site]
              ,ISNULL(eh.Emp_Job_Code,'-') AS [Employee Job Code]
              ,ISNULL(eh.Emp_Job_Description,'-') AS [Employee Job Description]
              ,ISNULL(eh.Emp_Program,'NA') AS [Program]
			  ,ISNULL(eh.Sup_ID,'-') AS [Supervisor Employee ID]
			  ,ISNULL(eh.Sup_Name,'-')  AS [Supervisor Name]
			  ,ISNULL(eh.Sup_Job_Code,'-') AS [Supervisor Job Code]
              ,ISNULL(eh.Sup_Job_Description, '-') AS [Supervisor Job Description]
			  ,ISNULL(eh.Mgr_ID,'-') AS [Manager Employee ID]
			  ,ISNULL(eh.Mgr_Name,'-')  AS [Manager Name]
			  ,ISNULL(eh.Mgr_Job_Code,'-') AS [Manager Job Code]
              ,ISNULL(eh.Mgr_Job_Description, '-') AS [Manager Job Description]
		      ,ISNULL(eh.Start_Date,'-')AS [Start Date]
		      ,ISNULL(eh.End_Date,'-') AS [End Date]
		      ,eh.Active AS [Status]
        FROM [EC].[Employee_Hierarchy] eh 
		WHERE ([eh].[Emp_ID]= (@strEmpin)or @strEmpin = '-1')
		       AND ([eh].[Emp_Site] = (@strEmpSitein)or @strEmpSitein = 'All')
        ORDER BY eh.Emp_Name

	    
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






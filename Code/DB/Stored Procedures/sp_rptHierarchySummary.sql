DROP PROCEDURE IF EXISTS [EC].[sp_rptHierarchySummary]; 
GO

/******************************************************************************* 
--	Author:			  Susmitha Palacherla
--	Create Date:	  3/27/2017
--	Description:      Displays the hierarchy for a given employee.
--  Last Modified:    07/12/2023
--  Last Modified By: LH
--  Revision History:
--  Initial Revision - TFS 5621 - 03/27/2017 (Modified 04/10/2017)
--  Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017
--  Added paging. TFS 26819 - 07/12/2023
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptHierarchySummary] 
(
@strEmpSitein nvarchar(20),
@strEmpin nvarchar(10),

@PageSize int,
@startRowIndex int, 
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

;with temp as (
	select ROW_NUMBER() over (order by eh.Emp_Name) as RowNumber, Count(*) over () as TotalRows 
			  ,eh.Emp_ID AS [Employee ID]
              ,CONVERT(nvarchar(50),DecryptByKey(eh.Emp_Name)) AS [Employee Name]
              ,ISNULL(eh.Emp_Site,'Unknown') AS [Site]
              ,ISNULL(eh.Emp_Job_Code,'-') AS [Employee Job Code]
              ,ISNULL(eh.Emp_Job_Description,'-') AS [Employee Job Description]
              ,ISNULL(eh.Emp_Program,'NA') AS [Program]
			  ,ISNULL(eh.Sup_ID,'-') AS [Supervisor Employee ID]
			  ,ISNULL(CONVERT(nvarchar(50),DecryptByKey(eh.Sup_Name)),'-')  AS [Supervisor Name]
			  ,ISNULL(eh.Sup_Job_Code,'-') AS [Supervisor Job Code]
              ,ISNULL(eh.Sup_Job_Description, '-') AS [Supervisor Job Description]
			  ,ISNULL(eh.Mgr_ID,'-') AS [Manager Employee ID]
			  ,ISNULL(CONVERT(nvarchar(50),DecryptByKey(eh.Mgr_Name)),'-')  AS [Manager Name]
			  ,ISNULL(eh.Mgr_Job_Code,'-') AS [Manager Job Code]
              ,ISNULL(eh.Mgr_Job_Description, '-') AS [Manager Job Description]
		      ,ISNULL(eh.Start_Date,'-')AS [Start Date]
		      ,ISNULL(eh.End_Date,'-') AS [End Date]
		      ,eh.Active AS [Status]
		      ,ISNULL(ess.Emp_Job_Code, '-') AS [Aspect Job Title]
		      ,ISNULL(ess.Emp_Program, '-') AS [Aspect Skill]
		      ,ISNULL(ess.Emp_Status, '-') AS [Aspect Status]
        from [EC].[Employee_Hierarchy] eh 
        left outer join [EC].[EmpID_To_SupID_Stage]ess on eh.Emp_ID = LTRIM(ess.Emp_ID)
		where ([eh].[Emp_ID]= @strEmpin or @strEmpin = '-1')
		       and ([eh].[Emp_Site] = @strEmpSitein or @strEmpSitein = 'All')
)
select * from temp
where RowNumber between @startRowIndex and @startRowIndex + @PageSize - 1;

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




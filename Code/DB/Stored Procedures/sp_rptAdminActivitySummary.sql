DROP PROCEDURE IF EXISTS [EC].[sp_rptAdminActivitySummary]; 
GO

/******************************************************************************* 
--	Author:			Susmitha Palacherla
--	Create Date:	3/27/2017
--	Description: Displays the Admin Activity Logs for selected Type, Action and Date Range.
--  Last Modified:    07/06/2023
--  Last Modified By: LH
--  Revision History: #26819 - Replace SSRS reports with datatables.
--  Initial Revision - TFS 5621 - 4/10/2017
--  Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017
--  Modified to add new Search paramter. TFS 24056 - 03/23/2022
--  Added paging. #26819 - 07/06/2023
 *******************************************************************************/
CREATE PROCEDURE [EC].[sp_rptAdminActivitySummary] 
(
@strTypein nvarchar(10),
@strActivityin nvarchar(20),
@strFormin nvarchar(50)= '',
@strSDatein datetime = '',
@strEDatein datetime = '',
@strSearchin nvarchar(50),

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

DECLARE	
@strSDate nvarchar(10),
@strEDate nvarchar(10),
@strSearch nvarchar(52)

SET @strSDate = convert(varchar(8),@strSDatein,112)
SET @strEDate = convert(varchar(8),@strEDatein,112)
SET @strSearch = '%' + @strSearchin + '%'

-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]  

-- Create a temp table to hold all Coaching admin activity logs for selected period

CREATE TABLE #CoachingAdminActivity ([Employee Level Id] int, [Employee Level] nvarchar(20),[Log Name] nvarchar(50), [Last Known Status]nvarchar(100),
[Action] nvarchar(20), [Action Date] datetime, [Requester ID] nvarchar(20), [Requester Name] nvarchar(50), [Assigned To ID] nvarchar(20),
[Assigned To Name] nvarchar(50), [Reason] nvarchar(250), [Requester Comments] nvarchar(4000) )

IF @strTypein in ('Coaching', 'All')

BEGIN

-- Insert logs from Coaching inactivation reactivation audit table

INSERT INTO #CoachingAdminActivity 
([Employee Level Id],[Employee Level], [Log Name], [Last Known Status],
[Action], [Action Date], [Requester ID], [Requester Name], [Assigned To ID],
[Assigned To Name], [Reason], [Requester Comments])
(
SELECT cl.ModuleID AS [Employee Level Id], dm.Module AS [Employee Level], cira.FormName AS [Log Name],
ds.Status AS [Last Known status], cira.Action AS [Action], cira.ActionTimestamp AS [action Date],
cira.RequesterID AS [Requester ID], 
CASE WHEN cira.RequesterID = '999998' 
THEN 'Hierarchy Load Process'
ELSE CONVERT(nvarchar(50),DecryptByKey(rh.Emp_Name)) END AS [Requester Name], 'NA' AS [Assigned To ID], 'NA' AS [Assigned To Name],
cira.Reason AS [Reason], ISNULL(cira.RequesterComments,'-') AS [Requester Comments]
FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]cira JOIN [EC].[Coaching_Log]cl
  ON cira.CoachingID = cl.CoachingID JOIN [EC].[DIM_Module] dm
  ON cl.ModuleID = dm.ModuleID JOIN [EC].[DIM_Status]ds
  ON cira.LastKnownStatus = ds.StatusID LEFT OUTER JOIN [EC].[Employee_Hierarchy]rh
  ON cira.RequesterID = rh.Emp_ID LEFT OUTER JOIN [EC].[Employee_Hierarchy] eh
  ON cl.EmpID = eh.Emp_ID
WHERE (convert(varchar(8),cira.ActionTimestamp,112) >= @strSDate
AND convert(varchar(8),cira.ActionTimestamp,112) <= @strEDate)
AND (CONVERT(nvarchar(50),DecryptByKey(eh.Emp_Name)) LIKE @strSearch OR cira.FormName LIKE @strSearch)

UNION

-- Insert logs from Coaching reassign audit table

SELECT cl.ModuleID AS [Employee Level ID], dm.Module AS [Employee Level], cra.FormName AS [Log Name],
ds.Status AS [Last Known status], 'Reassign' AS [Action], cra.ActionTimestamp AS [action Date],
cra.RequesterID AS [Requester ID],
CASE WHEN cra.RequesterID = '999998' 
THEN 'Hierarchy Load Process'
ELSE CONVERT(nvarchar(50),DecryptByKey(rh.Emp_Name)) END AS [Requester Name], cra.AssignedToID AS [Assigned To ID],
CONVERT(nvarchar(50),DecryptByKey(ah.Emp_Name)) AS [Assigned To Name],cra.Reason AS [Reason], ISNULL(cra.RequesterComments,'-') AS [Requester Comments]
FROM [EC].[AT_Coaching_Reassign_Audit]cra JOIN [EC].[Coaching_Log]cl
  ON cra.CoachingID = cl.CoachingID JOIN [EC].[DIM_Module] dm
  ON cl.ModuleID = dm.ModuleID JOIN [EC].[DIM_Status]ds
  ON cra.LastKnownStatus = ds.StatusID LEFT OUTER JOIN [EC].[Employee_Hierarchy]rh
  ON cra.RequesterID = rh.Emp_ID  LEFT OUTER JOIN [EC].[Employee_Hierarchy]ah
  ON cra.AssignedToID = ah.Emp_ID LEFT OUTER JOIN [EC].[Employee_Hierarchy] eh
  ON cl.EmpID = eh.Emp_ID
WHERE (convert(varchar(8),cra.ActionTimestamp,112) >= @strSDate
AND convert(varchar(8),cra.ActionTimestamp,112) <= @strEDate)
AND (CONVERT(nvarchar(50),DecryptByKey(eh.Emp_Name)) LIKE @strSearch OR cra.FormName LIKE @strSearch)
)

END

-- Create a temp table to hold all Warning admin activity logs for selected period


CREATE TABLE #WarningAdminActivity ([Employee Level Id] int, [Employee Level] nvarchar(20),[Log Name] nvarchar(50), [Last Known Status]nvarchar(100),
[Action] nvarchar(20), [Action Date] datetime, [Requester ID] nvarchar(20), [Requester Name] nvarchar(50), [Assigned To ID] nvarchar(20),
[Assigned To Name] nvarchar(50), [Reason] nvarchar(250), [Requester Comments] nvarchar(4000) )

IF @strTypein in ('Warning', 'All')

BEGIN

-- Insert logs from warning Inactivation Reactivation audit table

INSERT INTO #WarningAdminActivity 
([Employee Level Id],[Employee Level], [Log Name], [Last Known Status],
[Action], [Action Date], [Requester ID], [Requester Name], [Assigned To ID],
[Assigned To Name], [Reason], [Requester Comments])
(
SELECT wl.ModuleID AS [Employee Level Id], dm.Module AS [Employee Level], wira.FormName AS [Log Name],
ds.Status AS [Last Known status], wira.Action AS [Action], wira.ActionTimestamp AS [action Date],
wira.RequesterID AS [Requester ID], 
CASE WHEN wira.RequesterID = '999998' 
THEN 'Hierarchy Load Process'
ELSE CONVERT(nvarchar(50),DecryptByKey(rh.Emp_Name)) END AS [Requester Name], 'NA' AS [Assigned To ID], 'NA' AS [Assigned To Name],
wira.Reason AS [Reason], ISNULL(wira.RequesterComments,'-') AS [Requester Comments]
FROM [EC].[AT_Warning_Inactivate_Reactivate_Audit]wira JOIN [EC].[Warning_Log]wl
  ON wira.WarningID = wl.WarningID JOIN [EC].[DIM_Module] dm
  ON wl.ModuleID = dm.ModuleID JOIN [EC].[DIM_Status]ds
  ON wira.LastKnownStatus = ds.StatusID LEFT OUTER JOIN [EC].[Employee_Hierarchy]rh
  ON wira.RequesterID = rh.Emp_ID LEFT OUTER JOIN [EC].[Employee_Hierarchy] eh
  ON wl.EmpID = eh.Emp_ID
WHERE (convert(varchar(8),wira.ActionTimestamp,112) >= @strSDate
AND convert(varchar(8),wira.ActionTimestamp,112) <= @strEDate)
AND (CONVERT(nvarchar(50),DecryptByKey(eh.Emp_Name)) LIKE @strSearch OR wira.FormName LIKE @strSearch)
)
END

-- Display all selected coaching audit logs
IF @strTypein = 'Coaching'
begin
	with temp as ( 
        select ROW_NUMBER() over (order by [Action Date]) as RowNumber, Count(*) over () as TotalRows, * 
        from #CoachingAdminActivity 
		where ([Log Name] = @strFormin or @strFormin = 'All') and ([Action] = @strActivityin or @strActivityin = 'All')
    ) 
	select * from temp
    where RowNumber between @startRowIndex and @startRowIndex + @PageSize - 1;
end

-- Display all selected warning audit logs
IF @strTypein = 'Warning'
begin
	with temp as (
        select ROW_NUMBER() over (order by [Action Date]) as RowNumber, Count(*) over () as TotalRows, * 
        from #WarningAdminActivity 
		where ([Log Name] = @strFormin or @strFormin = 'All') and ([Action] = @strActivityin or @strActivityin = 'All') 
    ) 
	select * from temp
    where RowNumber between @startRowIndex and @startRowIndex + @PageSize - 1;
end

-- Display all selected coaching and warning audit logs
IF @strTypein = 'All'
begin
	with temp as (
		select ROW_NUMBER() over (order by [Action Date]) as RowNumber, Count(*) over () as TotalRows, *
		from (
			select * from #CoachingAdminActivity
			union
			select * from #WarningAdminActivity
		) s
		where ([Log Name] = @strFormin or @strFormin = 'All') and ([Action] = @strActivityin or @strActivityin = 'All') 
	) 
	select * from temp
    where RowNumber between @startRowIndex and @startRowIndex + @PageSize - 1;
end

  -- Drop the temp tables
  
  DROP TABLE #CoachingAdminActivity 
  DROP TABLE #WarningAdminActivity 

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


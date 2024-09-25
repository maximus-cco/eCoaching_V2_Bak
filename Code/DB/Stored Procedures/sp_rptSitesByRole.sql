SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 

--	Author:			Susmitha Palacherla
--	Create Date:	7/8/2022
--	Description: *	This procedure returns the list of Sites(s) for the logged in user. 
--  for users with ELS Role, only their site is returned. All sites returned for Other users.
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Report access for Early Worklife Supervisors. TFS 24924 - 7/8/2022
--  Modified to exclude Sub Sites. TFS 28688 - 09/16/2024
 *******************************************************************************/
CREATE OR ALTER      PROCEDURE [EC].[sp_rptSitesByRole] 
(
@LanID nvarchar(30),
@intModulein int = 1,
@isWarning bit,
 ------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   @returnCode int = NULL OUTPUT ,
   @returnMessage nvarchar(80)= NULL OUTPUT 
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
	@dtmDate datetime,
	@intELSRowID int;

-- Open Symmetric Key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 


SET @dtmDate  = GETDATE();  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@LanID,@dtmDate);
--print @nvcEmpID 
SET @intELSRowID = (SELECT TOP 1 [Row_ID] FROM [EC].[Historical_Dashboard_ACL] WITH(NOLOCK)
WHERE Role = 'ELS'
AND End_Date = 99991231 
AND (CONVERT(nvarchar(30),DecryptByKey([User_LanID])) =  @LanID
OR EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate()) = @nvcEmpID));


IF ISNULL(@intELSRowID, '') = ''


SELECT s.SiteID, Site
FROM  (
SELECT -1 AS SiteID, 'All' AS Site
UNION
SELECT DISTINCT cl.SiteID, cs.City AS Site
FROM EC.Coaching_Log cl WITH(NOLOCK) INNER JOIN EC.DIM_Site cs
ON cl.SiteID = cs.SiteID
WHERE  (cl.ModuleID =(@intModulein) or @intModulein = -1)
AND cs.City <> 'Unknown'
UNION
SELECT DISTINCT wl.SiteID, cs.City AS Site
FROM     EC.Warning_Log wl WITH(NOLOCK) INNER JOIN EC.DIM_Site cs
ON wl.SiteID = cs.SiteID
WHERE  (wl.ModuleID =(@intModulein) or @intModulein = -1)
AND cs.City <> 'Unknown'
)AS S , EC.DIM_Site ds
WHERE s.SiteID = ds.SiteID
AND -- Exclude Sub sites when Warnings indicator passed in
CASE WHEN @isWarning = 1 and ds.isSub = 0 THEN 1
     WHEN @isWarning = 0 and (ds.isSub = 0 OR ds.isSub = 1) THEN 1
ELSE 0 END = 1 -- Warnings sites exclusion
ORDER BY CASE WHEN s.SiteID = - 1 THEN 0 ELSE 1 END, s.Site
ELSE
SELECT SiteID, [City] AS Site 
FROM EC.Employee_Hierarchy eh INNER JOIN EC.DIM_Site s ON eh.Emp_Site = s.City WHERE Emp_ID = @nvcEmpID;
		                   
  -- Clode Symmetric Key
  CLOSE SYMMETRIC KEY [CoachingKey];
	    
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




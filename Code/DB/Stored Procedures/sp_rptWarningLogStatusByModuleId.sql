DROP PROCEDURE IF EXISTS [EC].[sp_rptWarningLogStatusByModuleId]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/18/2023
--	Description:		Returns warning log status by module id.
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptWarningLogStatusByModuleId] 
@intModuleId int
AS

SELECT StatusID, Status
FROM  
(
	SELECT -1 AS StatusID, 'All' AS Status
	UNION
	SELECT DISTINCT wl.StatusID, ds.Status
	FROM EC.Warning_Log AS wl 
	INNER JOIN EC.DIM_Status ds ON wl.StatusID = ds.StatusID
	WHERE  (wl.ModuleID = @intModuleId or @intModuleId = -1)
	AND wl.StatusID <> 2
)AS S
ORDER BY CASE WHEN StatusID = -1 THEN 0 ELSE 1 END, Status

GO




DROP PROCEDURE IF EXISTS [EC].[sp_rptLogStatusByModuleId]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/14/2023
--	Description:		Returns log status by module id.
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptLogStatusByModuleId] 
@intModuleId int
AS

SELECT StatusID, Status
FROM  
(
	SELECT -1 AS StatusID, 'All' AS Status
	UNION
	SELECT DISTINCT cl.StatusID, ds.Status
	FROM EC.Coaching_Log AS cl INNER JOIN EC.DIM_Status ds
	ON cl.StatusID = ds.StatusID
	WHERE (cl.ModuleID = @intModuleId or @intModuleId = -1)
	AND cl.StatusID <> 2
)AS S
ORDER BY CASE WHEN StatusID = -1 THEN 0 ELSE 1 END, Status


GO



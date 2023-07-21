DROP PROCEDURE IF EXISTS [EC].[sp_rptWarningReasonByModuleId]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/18/2023
--	Description:		Returns warning reasons by module id.
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables. Initial Revision.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptWarningReasonByModuleId] 
@intModuleId int
AS

SELECT ReasonID, Reason
FROM
(
	SELECT -1 AS ReasonID, 'All' AS Reason
    UNION
    SELECT DISTINCT wlr.CoachingReasonID AS ReasonID, dcr.CoachingReason AS Reason
    FROM EC.warning_log AS wl 
	INNER JOIN EC.warning_log_Reason AS wlr ON wl.WarningID = wlr.WarningID 
	INNER JOIN EC.DIM_Coaching_Reason AS dcr ON wlr.CoachingReasonID = dcr.CoachingReasonID
    WHERE (wl.ModuleID = @intModuleId or @intModuleId =-1) 
) AS s
ORDER BY CASE WHEN ReasonID = -1 THEN 0 ELSE 1 END, Reason

GO



DROP PROCEDURE IF EXISTS [EC].[sp_rptCoachingReasonByModuleId]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/13/2023
--	Description:		Returns coaching reasons by module id.
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptCoachingReasonByModuleId] 
@intModuleId int
AS

SELECT ReasonID, Reason
FROM 
(   
	SELECT -1 AS ReasonID, 'All' AS Reason
	UNION
	SELECT DISTINCT clr.CoachingReasonID AS ReasonID, dcr.CoachingReason AS Reason
	FROM     EC.Coaching_Log AS cl 
	INNER JOIN EC.Coaching_Log_Reason AS clr ON cl.CoachingID = clr.CoachingID 
	INNER JOIN EC.DIM_Coaching_Reason AS dcr ON clr.CoachingReasonID = dcr.CoachingReasonID
	WHERE  (cl.ModuleID =(@intModuleId) or @intModuleId = -1)
) AS s
ORDER BY CASE WHEN ReasonID = -1 THEN 0 ELSE 1 END, Reason


GO



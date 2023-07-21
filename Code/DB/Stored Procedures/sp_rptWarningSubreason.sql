DROP PROCEDURE IF EXISTS [EC].[sp_rptWarningSubreason]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/14/2023
--	Description:		Returns warning subreasons by coaching reason id.
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptWarningSubreason] 
@intReasonId int
AS

SELECT SubReasonID, SubReason
FROM     
(
	SELECT -1 AS SubReasonID, 'All' AS SubReason
    UNION
    SELECT DISTINCT wlr.SubCoachingReasonID AS SubReasonID, dscr.SubCoachingReason AS SubReason
    FROM EC.Warning_Log_Reason AS wlr 
	INNER JOIN EC.DIM_Sub_Coaching_Reason AS dscr ON wlr.SubCoachingReasonID = dscr.SubCoachingReasonID
    WHERE  (wlr.CoachingReasonID = @intReasonId or @intReasonId = -1)
) AS s
WHERE SubReason <> 'unknown'
ORDER BY CASE WHEN SubReasonID = - 1 THEN 0 ELSE 1 END, SubReason

GO




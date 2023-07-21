DROP PROCEDURE IF EXISTS [EC].[sp_rptCoachingSubreason]; 
GO

/*************************************************************************************** 
--	Author:				LH
--	Create Date:		07/14/2023
--	Description:		Returns coaching subreasons by coaching reason id.
--  Last Modified:  
--  Last Modified By: 
--  Revision History:	#26819 - Replace SSRS reports with datatables.
***************************************************************************************/
CREATE PROCEDURE [EC].[sp_rptCoachingSubreason] 
@intReasonId int
AS

SELECT SubReasonID, SubReason
FROM
(
	SELECT -1 AS SubReasonID, 'All' AS SubReason
    UNION
    SELECT DISTINCT clr.SubCoachingReasonID AS SubReasonID, dscr.SubCoachingReason AS SubReason
    FROM EC.Coaching_Log_Reason AS clr 
	INNER JOIN EC.DIM_Sub_Coaching_Reason AS dscr ON clr.SubCoachingReasonID = dscr.SubCoachingReasonID
    WHERE (clr.CoachingReasonID =(@intReasonId) or @intReasonId = -1) 
) AS s
WHERE SubReason <> 'unknown'
ORDER BY CASE WHEN SubReasonID = - 1 THEN 0 ELSE 1 END, SubReason


GO



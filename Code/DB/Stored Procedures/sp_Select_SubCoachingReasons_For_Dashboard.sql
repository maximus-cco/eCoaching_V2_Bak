SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/28/2022
--	Description: *	This procedure selects Sub Coaching Reasons to be displayed in the dashboard
--  Sub Coaching Reasons dropdown list.
--  Initial Revision. TFS 25387 - 09/26/2022
--	====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_Select_SubCoachingReasons_For_Dashboard] 
@nvcEmpID nvarchar(10)
AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max);
	   	
SET @nvcSQL = 'SELECT X.SubCoachingReasonId, X.SubCoachingReason FROM
(SELECT ''-1'' SubCoachingReasonId, ''All Sub-Reasons'' SubCoachingReason,  01 Sortorder From [EC].[DIM_Sub_Coaching_Reason]
UNION
SELECT CONVERT(nvarchar,[SubCoachingReasonId]) SubCoachingReasonId, 
[SubCoachingReason] SubCoachingReason,  02 Sortorder From [EC].[DIM_Sub_Coaching_Reason]
 WHERE 1 = 1 
 AND  [SubCoachingReason] <> ''Unknown'' ) x
ORDER BY X.Sortorder, X.SubCoachingReason'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_SubCoachingReasons_For_Dashboard

GO



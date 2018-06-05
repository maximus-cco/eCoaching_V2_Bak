/*
sp_SelectReviewFrom_Warning_Log_Reasons(02).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla


Version 02 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Warning_Log_Reasons' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log_Reasons]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Warning Log Reason and Sub Coaching Reason values for 
--  a given Form Name.
--  Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log_Reasons] @intLogId BIGINT
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)


SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, wlr.value
FROM [EC].[Warning_Log_Reason] wlr join [EC].[DIM_Coaching_Reason] cr
ON[wlr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [wlr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where WarningID = '''+CONVERT(NVARCHAR(20),@intLogId) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,wlr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Warning_Log_Reasons



GO




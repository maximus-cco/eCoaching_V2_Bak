/*
sp_SelectReviewFrom_Coaching_Log_Reasons(02).sql

Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla

Version 02 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

*/


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_Reasons' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Coaching Log Reason and Sub Coaching Reason values for 
--  a given Form Name.
--  Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons] @intLogId BIGINT
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, clr.value
FROM [EC].[Coaching_Log_Reason] clr join [EC].[DIM_Coaching_Reason] cr
ON[clr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [clr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where CoachingID = '''+CONVERT(NVARCHAR(20),@intLogId) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,clr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_Reasons





GO




/*
sp_SelectReviewFrom_Warning_Log_Reasons(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Warning_Log_Reasons] @strFormIDin nvarchar(50)
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@intWarningID INT

 
SET @intWarningID = (SELECT WarningID From [EC].[Warning_Log]where[FormName]=@strFormIDin)


SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, wlr.value
FROM [EC].[Warning_Log_Reason] wlr join [EC].[DIM_Coaching_Reason] cr
ON[wlr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [wlr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where WarningID = '''+CONVERT(NVARCHAR(20),@intWarningID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,wlr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Warning_Log_Reasons

GO


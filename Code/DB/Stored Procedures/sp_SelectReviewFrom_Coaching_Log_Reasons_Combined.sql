/*
sp_SelectReviewFrom_Coaching_Log_Reasons_Combined(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_Reasons_Combined' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons_Combined]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/12/2015
--	Description: 	This procedure displays the Coaching Log or Warning log Reasons 
--  and Sub Coaching Reason values for a given Form Name.

--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons_Combined] @strFormIDin nvarchar(50)
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@intCoachingID INT,
	@intWarningID INT

 
SET @intCoachingID = (SELECT CoachingID From [EC].[Coaching_Log]where[FormName]=@strFormIDin)

IF @intCoachingID IS NULL

BEGIN

SET @intWarningID = (SELECT WarningID From [EC].[Warning_Log]where[FormName]=@strFormIDin)


SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, wlr.value
FROM [EC].[Warning_Log_Reason] wlr join [EC].[DIM_Coaching_Reason] cr
ON[wlr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [wlr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where WarningID = '''+CONVERT(NVARCHAR(20),@intWarningID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,wlr.value'

END

ELSE

SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, clr.value
FROM [EC].[Coaching_Log_Reason] clr join [EC].[DIM_Coaching_Reason] cr
ON[clr].[CoachingReasonID] = [cr].[CoachingReasonID]Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [clr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where CoachingID = '''+CONVERT(NVARCHAR(20),@intCoachingID) + '''
ORDER BY cr.CoachingReason,scr.SubCoachingReason,clr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_Reasons_Combined


GO


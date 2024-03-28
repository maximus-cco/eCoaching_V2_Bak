SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         04/03/2023
-- Description:	        Given a CoachingID, returns the static Text associated with the Coaching for the given time period if one exists 
--                      for the Coaching Reason and sub Coaching Reason
--  Initial Revision. Created to suppport AUD feed. TFS 26432  - 04/03/2023
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_strCoachingLogStatictext] (
@intCoachingID bigint
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @strStaticText NVARCHAR(MAX),
		  @intSubmitDate int,
		  @bitSub bit;
SET @intSubmitDate = (SELECT [EC].[fn_intDatetime_to_YYYYMMDD]([SubmittedDate]) FROM [EC].[Coaching_Log] WHERE [CoachingID] = @intCoachingID);
SET @bitSub = (SELECT  s.isSub  FROM EC.Coaching_Log cl JOIN EC.DIM_Site s ON cl.SiteID = s.SiteID WHERE [CoachingID] = @intCoachingID);


IF @bitSub = 0

SET @strStaticText = (SELECT [TextDescription] StaticText
  FROM [EC].[Coaching_Log_StaticText] st INNER JOIN EC.Coaching_Log_Reason cr 
  ON st.[CoachingReasonID] = cr.[CoachingReasonID] 
  AND st.[SubCoachingReasonID] = cr.[SubCoachingReasonID]
  WHERE cr.CoachingID = @intCoachingID
  AND @intSubmitDate between st.StartDate and st.EndDate AND st.isSub = 0);
 
 IF @bitSub = 1

 SET @strStaticText = (SELECT [TextDescription] StaticText
  FROM [EC].[Coaching_Log_StaticText] st INNER JOIN EC.Coaching_Log_Reason cr 
  ON st.[CoachingReasonID] = cr.[CoachingReasonID] 
  AND st.[SubCoachingReasonID] = cr.[SubCoachingReasonID]
  WHERE cr.CoachingID = @intCoachingID
  AND @intSubmitDate between st.StartDate and st.EndDate AND st.isSub = 1);
 

    IF @strStaticText IS NULL
    SET @strStaticText = '';
        
RETURN @strStaticText 

END  -- fn_strCoachingLogStatictext
GO



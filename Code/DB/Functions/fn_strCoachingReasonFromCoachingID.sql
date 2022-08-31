
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:      04/21/2015
-- Description:	        Given a CoachingID returns the Coaching Reasons concatenated as a single string 
-- of values separated by a '|'
--  Modified to use string_agg fn during qn workflow updates. TFS 22187 - 08/30/2021
--  Updated to increase field size for @strCoachingReason to 2000. TFS 25250 - 8/29/2022
-- =============================================

 CREATE OR ALTER FUNCTION [EC].[fn_strCoachingReasonFromCoachingID]
  (
  @bigintCoachingID bigint
)
RETURNS NVARCHAR(2000)
AS
BEGIN
  DECLARE @strCoachingReason NVARCHAR(2000)
  
  IF @bigintCoachingID IS NOT NULL
  BEGIN
  SET @strCoachingReason = (SELECT STRING_AGG([CoachingReason], ' | ') WITHIN GROUP (ORDER BY CoachingID)
         FROM [EC].[Coaching_Log_Reason]m JOIN [EC].[DIM_Coaching_Reason]dcr
         ON m.[CoachingReasonID] = dcr.[CoachingReasonID]
         WHERE m.[CoachingID] =  @bigintCoachingID)
  END
    ELSE
    SET @strCoachingReason = NULL
        
RETURN @strCoachingReason

END  -- fn_strCoachingReasonFromCoachingID

GO



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSubCoachingReasonFromCoachingID' 
)
   DROP FUNCTION [EC].[fn_strSubCoachingReasonFromCoachingID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:      04/21/2015
-- Description:	        Given a CoachingID returns the Sub Coaching Reasons concatenated as a single string 
-- of values separated by a '|'
--  Modified to use string_agg fn during qn workflow updates. TFS 22187 - 08/30/2021
-- =============================================

CREATE OR ALTER FUNCTION [EC].[fn_strSubCoachingReasonFromCoachingID] (
  @bigintCoachingID bigint
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strSubCoachingReason NVARCHAR(1000)
  
  IF @bigintCoachingID IS NOT NULL
  BEGIN
  SET @strSubCoachingReason = (SELECT STRING_AGG([SubCoachingReason], ' | ') WITHIN GROUP (ORDER BY CoachingID)
         FROM [EC].[Coaching_Log_Reason]m JOIN [EC].[DIM_Sub_Coaching_Reason]dcr
         ON m.[SubCoachingReasonID] = dcr.[SubCoachingReasonID]
         WHERE m.[CoachingID] =  @bigintCoachingID)
	END
    ELSE
    SET @strSubCoachingReason = NULL
        
RETURN @strSubCoachingReason

END  -- fn_strSubCoachingReasonFromCoachingID

GO


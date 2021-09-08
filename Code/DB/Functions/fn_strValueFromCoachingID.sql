IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strValueFromCoachingID' 
)
   DROP FUNCTION [EC].[fn_strValueFromCoachingID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:      04/21/2015
-- Description:	        Given a CoachingID returns the Values concatenated as a single string 
-- of values separated by a '|'
--  Modified to use string_agg fn during qn workflow updates. TFS 22187 - 08/30/2021

-- =============================================

CREATE OR ALTER FUNCTION [EC].[fn_strValueFromCoachingID] (
  @bigintCoachingID bigint
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strValue NVARCHAR(1000)
  
  IF @bigintCoachingID IS NOT NULL
  BEGIN
  SET @strValue = (SELECT STRING_AGG([Value], ' | ') WITHIN GROUP (ORDER BY CoachingID)
            FROM [EC].[Coaching_Log_Reason]
         WHERE [CoachingID] = @bigintCoachingID )
 END
    ELSE
    SET @strValue = NULL
        
RETURN @strValue

END  -- fn_strValueFromCoachingID

GO


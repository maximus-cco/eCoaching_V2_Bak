SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:      09/03/2021
-- Description:	        Given a QN CoachingID returns the Evaluation Summary values separated by a '|'
-- Initial Revision. Quality Now workflow enhancement. TFS 22187 - 09/03/2021
-- =============================================

 CREATE OR ALTER FUNCTION [EC].[fn_strQNEvalSummaryFromCoachingID]
  (
  @bigintCoachingID bigint
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strQNEvalSummary NVARCHAR(max)
  
  IF @bigintCoachingID IS NOT NULL
  BEGIN
  SET @strQNEvalSummary = (SELECT STRING_AGG([EvalSummaryNotes], ' | ') WITHIN GROUP (ORDER BY SummaryID)
         FROM [EC].[Coaching_Log_Quality_Now_Summary] qs JOIN [EC].[Coaching_Log]cl
         ON qs.[CoachingID] = cl.[CoachingID]
         WHERE qs.[CoachingID] =  @bigintCoachingID)
  END
    ELSE
    SET @strQNEvalSummary = NULL
        
RETURN @strQNEvalSummary

END  -- fn_strQNEvalSummaryFromCoachingID

GO



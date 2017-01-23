/*
fn_strSubCoachingReasonFromCoachingID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


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
-- =============================================
CREATE FUNCTION [EC].[fn_strSubCoachingReasonFromCoachingID] (
  @bigintCoachingID bigint
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strSubCoachingReason NVARCHAR(1000)
  
  IF @bigintCoachingID IS NOT NULL
  BEGIN
  SET @strSubCoachingReason = (SELECT STUFF((SELECT  '| ' + CAST([SubCoachingReason] AS VARCHAR(2000)) [text()]
         FROM [EC].[Coaching_Log_Reason]m JOIN [EC].[DIM_Sub_Coaching_Reason]dscr
         ON m.[SubCoachingReasonID] = dscr.[SubCoachingReasonID]
         WHERE m.[CoachingID] = t.[CoachingID]
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') List_Output
FROM [EC].[Coaching_Log_Reason] t 
  where t.[CoachingID]= @bigintCoachingID
GROUP BY [CoachingID])       
	END
    ELSE
    SET @strSubCoachingReason = NULL
        
RETURN @strSubCoachingReason

END  -- fn_strSubCoachingReasonFromCoachingID

GO


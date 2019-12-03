/*
fn_strWarningLogStatictext(01).sql
Last Modified Date: 12/3/2019
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. Warnings workflow Update - TFS 15803 - 12/3/2019


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strWarningLogStatictext' 
)
   DROP FUNCTION [EC].[fn_strWarningLogStatictext]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         12/3/2019
-- Description:	        Given a WarningID, returns the static Text associated with the warning for the given time period if one exists 
--                      for the Coaching Reason and sub Coaching Reason
--  Initial Revision. TFS 15803- 12/3/2019
-- =============================================
CREATE FUNCTION [EC].[fn_strWarningLogStatictext] (
@intWarningID bigint
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @strStaticText NVARCHAR(MAX),
          @intReasonID int,
		  @intSubReasonID int,
		  @intSubmitDate int
		 
  
SET @intReasonID = (SELECT [CoachingReasonID] FROM [EC].[Warning_Log_Reason] WHERE [WarningID] = @intWarningID);
SET @intSubReasonID = (SELECT [SubCoachingReasonID] FROM [EC].[Warning_Log_Reason] WHERE [WarningID] = @intWarningID);
SET @intSubmitDate = (SELECT [EC].[fn_intDatetime_to_YYYYMMDD]([SubmittedDate]) FROM [EC].[Warning_Log] WHERE [WarningID] = @intWarningID);


SET @strStaticText = (SELECT [TextDescription] StaticText
  FROM [EC].[Warning_Log_StaticText]
  WHERE [CoachingReasonID] =   @intReasonID
  AND [SubCoachingReasonID] = @intSubReasonID
  AND @intSubmitDate between StartDate and EndDate);
                      
    IF @strStaticText IS NULL
    SET @strStaticText = '';
    

        
RETURN @strStaticText

END  -- fn_strWarningLogStatictext
GO





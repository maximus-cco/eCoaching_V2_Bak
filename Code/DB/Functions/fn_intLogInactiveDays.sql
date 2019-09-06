/*
fn_intLogInactiveDays(01).sql
Last Modified Date: 09/03/2019
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. Follow-up process for eCoaching submissions - TFS 13644 -  09/03/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intLogInactiveDays' 
)
   DROP FUNCTION [EC].[fn_intLogInactiveDays]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:        08/28/2019
-- Description:	 Given an CoachingID, returns the number of days since the log was last Inactivated
-- Initial revision. follow-up process for eCoaching submissions - TFS 13644 -  08/28/2019
-- =============================================
CREATE FUNCTION [EC].[fn_intLogInactiveDays]
 (
@LogID BIGINT
)

RETURNS INT
AS
BEGIN

DECLARE	@CountInactive int,
        @CountInactiveDays int
	
SET @CountInactive = (SELECT COUNT([SeqNum]) FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
WHERE [Action] = 'Inactivate'
AND [CoachingID] = @LogID)

IF @CountInactive = 0
BEGIN
SET @CountInactiveDays = 0
END


IF @CountInactive > 0
BEGIN   
SET @CountInactiveDays = (SELECT DATEDIFF(DAY, MAX([ActionTimestamp]), GetDate())
FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
WHERE [Action] = 'Inactivate'
AND [CoachingID] = @LogID);
END

RETURN @CountInactiveDays
  
END  -- fn_intLogInactiveDays()

GO



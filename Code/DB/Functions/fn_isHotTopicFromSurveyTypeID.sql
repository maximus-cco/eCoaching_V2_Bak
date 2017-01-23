/*
fn_isHotTopicFromSurveyTypeID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_isHotTopicFromSurveyTypeID' 
)
   DROP FUNCTION [EC].[fn_isHotTopicFromSurveyTypeID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 09/29/2015
--	Description:	 
--  *  Given a Survey Type ID returns a bit to indicate whether or not 
--     there is an Active  Hot topic question associated with the Survey.
-- Created per during CSR survey setup per TFS 549
--	=============================================
CREATE FUNCTION [EC].[fn_isHotTopicFromSurveyTypeID] 
(
  @intSurveyTypeID INT
)
RETURNS BIT
AS
BEGIN
 
	 DECLARE @intHotTopicCount int,
	         @isHotTopic bit
	      
	         
		
SET @intHotTopicCount = (SELECT COUNT(*) FROM [EC].[Survey_DIM_QAnswer]
WHERE [isHotTopic] = 1 and [isActive] = 1
AND SurveyTypeID = @intSurveyTypeID)
	
	-- IF at least active Hot topic question found
	
IF @intHotTopicCount > 0

-- Return 1
BEGIN

		SET @isHotTopic = 1
END
	  
ELSE 	

-- Return 0

BEGIN

		SET @isHotTopic = 0
END


RETURN 	@isHotTopic

END --fn_isHotTopicFromSurveyTypeID


GO


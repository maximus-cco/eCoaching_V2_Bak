/*
fn_bitCheckIfPilotSurvey(01).sql
Last Modified Date: 01/23/2018
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision - TFS 9511 - 01/23/2018


*/



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_bitCheckIfPilotSurvey' 
)
   DROP FUNCTION [EC].[fn_bitCheckIfPilotSurvey]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 01/23/2018
-- Description:	Given an Survey ID , returns a BIt indicating whether the Survey includes a Pilot Question
-- Last Modified by: Susmitha Palacherla
-- Revision History
-- Initial Revision. Created to incorporate Pilot Question. TFS 9511 - 01/23/2018
-- =============================================
CREATE FUNCTION [EC].[fn_bitCheckIfPilotSurvey] 
(
	@intSurveyID INT
)
RETURNS BIT
AS
BEGIN
	DECLARE 
	  @strSiteID INT,
	  @bitisPilot BIT
	

  SELECT  @strSiteID = [SiteID]
  FROM [EC].[Survey_Response_Header]
  WHERE [SurveyID] = @intSurveyID
  
    IF @strSiteID IS NULL
    SET @strSiteID = -1

  SELECT @bitisPilot = [isPilot]
  FROM [EC].[Survey_Sites]
  WHERE [SiteID] = @strSiteID

  
  IF @bitisPilot <> 1
    SET @bitisPilot = 0
  
  RETURN  @bitisPilot
  
END --fn_bitCheckIfPilotSurvey


GO



/*
sp_Select_SurveyDetails_By_SurveyID(03).sql
Last Modified Date: 01/23/2018
Last Modified By: Susmitha Palacherla

Version 03: Modified during Survey move to new architecture - TFS 10904 - 05/08/2018

Version 02: Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_SurveyDetails_By_SurveyID' 
)
   DROP PROCEDURE [EC].[sp_Select_SurveyDetails_By_SurveyID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: Given a survey ID this procedure returns the details of the Survey like
-- the Employee ID, eCL Form Name and whether or not a Hot Topic question is associated with this Survey.
-- TFS 549 - CSR Survey Setup - 09/24/2015
-- Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018
-- Modified during Survey move to new architecture - TFS 10904 - 05/08/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_SurveyDetails_By_SurveyID] 
@intSurveyID INT

AS
BEGIN
	DECLARE	
	--@intSurveyTypeID INT,
	@hasHotTopic BIT,
	@hasPilot BIT,
	@nvcSQL nvarchar(max)
	
--SET @intSurveyTypeID = (SELECT [SurveyTypeID] FROM [EC].[Survey_Response_Header]
--WHERE [SurveyID] = @intSurveyID)
	
SET @hasHotTopic = (SELECT [EC].[fn_bitCheckIfHotTopicSurvey](@intSurveyID))
SET @hasPilot = (SELECT [EC].[fn_bitCheckIfPilotSurvey](@intSurveyID))



SET @nvcSQL = 'SELECT SRH.[EmpID],
                      SRH.[CoachingID],
					  SRH.[FormName],
					  SRH.[Status],
					  '+CONVERT(NVARCHAR,@hasHotTopic)+' hasHotTopic,
					   '+CONVERT(NVARCHAR,@hasPilot)+' hasPilot
			  FROM [EC].[Survey_Response_Header]SRH
			  WHERE [SurveyID] = '+CONVERT(NVARCHAR,@intSurveyID)+''
			 


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SurveyDetails_By_SurveyID

GO



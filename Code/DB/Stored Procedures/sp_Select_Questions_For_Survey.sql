/*
sp_Select_Questions_For_Survey(04).sql
Last Modified Date: 03/21/2021
Last Modified By: Susmitha Palacherla

Version 04: Modified to add Quality Now surveys for additional sites - TFS 20256 - 3/21/2021
Version 03: Modified to support London Hot topic survey - TFS 14178 - 04/22/2019
Version 02: Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Questions_For_Survey' 
)
   DROP PROCEDURE [EC].[sp_Select_Questions_For_Survey]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: This procedure returns a list of Questions and their display order 
-- to be displayed in the UI.
-- TFS 549 - CSR Survey Setup - 09/24/2015
-- Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018
-- Modified to support London Hot topic survey - TFS 14178 - 04/22/2019
-- Modified to add Quality Now surveys for additional sites - TFS 20256 - 3/21/2021
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Questions_For_Survey] 
@intSurveyID INT

AS
BEGIN
	DECLARE	
	--@intToday INT = (SELECT [EC].[fn_intDatetime_to_YYYYMMDD](GetDate()))
	@intSurveyCreateDate INT = (SELECT [EC].[fn_intDatetime_to_YYYYMMDD]([CreatedDate]) FROM [EC].[Survey_Response_Header] WHERE [SurveyID] = @intSurveyID),
	@intSurveyTypeID INT,
	@intSourceID INT,
	@isPilot BIT,
	@isPilotSource BIT,
	@nvcSQL nvarchar(max)
	
SET @intSurveyTypeID = (SELECT [SurveyTypeID] FROM [EC].[Survey_Response_Header] WHERE [SurveyID] = @intSurveyID)

SET @intSourceID = (SELECT [SourceID] FROM [EC].[Survey_Response_Header]
WHERE [SurveyID] = @intSurveyID)

SET @isPilotSource = (SELECT CASE WHEN @intSourceID  in (135,136,235,236) THEN 1 ELSE 0 END)
SET @isPilot = (SELECT [EC].[fn_bitCheckIfPilotSurvey](@intSurveyID))

IF @isPilot = 0 -- Not a Pilot Site

BEGIN
SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic], Q.[isPilot]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1
			  AND '''+ CONVERT(NVARCHAR,@intSurveyCreateDate)+''' between Q.StartDate and Q.EndDate
			  AND QA.[SurveyTypeID] = '''+CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  AND Q.[isPilot] = 0
			  ORDER BY [DisplayOrder]'
END

ELSE

-- If Pilot Site and 
IF @isPilotSource = 1 --  Source needs to have extra question
BEGIN
SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic], Q.[isPilot]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1
			  AND '''+ CONVERT(NVARCHAR,@intSurveyCreateDate)+''' between Q.StartDate and Q.EndDate
			  AND QA.[SurveyTypeID] = '''+ CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  ORDER BY [DisplayOrder]'
END

ELSE

BEGIN
SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic], Q.[isPilot]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1 
			  AND '''+ CONVERT(NVARCHAR,@intSurveyCreateDate)+''' between Q.StartDate and Q.EndDate
			  AND QA.[SurveyTypeID] = '''+CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  AND Q.[isHotTopic] = 0
			  ORDER BY [DisplayOrder]'
END

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Questions_For_Survey
GO


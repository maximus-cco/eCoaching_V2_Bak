/*
sp_Select_Questions_For_Survey(02).sql
Last Modified Date: 01/23/2018
Last Modified By: Susmitha Palacherla

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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Questions_For_Survey] 
@intSurveyID INT

AS
BEGIN
	DECLARE	
	@intSurveyTypeID INT,
	@isPilot BIT,
	@nvcSQL nvarchar(max)
	
SET @intSurveyTypeID = (SELECT [SurveyTypeID] FROM [EC].[Survey_Response_Header]
WHERE [SurveyID] = @intSurveyID)

SET @isPilot = (SELECT [EC].[fn_bitCheckIfPilotSurvey](@intSurveyID))

IF @isPilot = 0

BEGIN
SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic], Q.[isPilot]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1 AND QA.[SurveyTypeID] = '''+CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  AND Q.[isPilot] = 0
			  ORDER BY [DisplayOrder]'
END

ELSE

BEGIN
SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic], Q.[isPilot]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1 AND QA.[SurveyTypeID] = '''+CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  ORDER BY [DisplayOrder]'
END

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Questions_For_Survey



GO



/*
sp_Select_Questions_For_Survey(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Questions_For_Survey] 
@intSurveyID INT

AS
BEGIN
	DECLARE	
	@intSurveyTypeID INT,
	@nvcSQL nvarchar(max)
	
SET @intSurveyTypeID = (SELECT [SurveyTypeID] FROM [EC].[Survey_Response_Header]
WHERE [SurveyID] = @intSurveyID)


SET @nvcSQL = 'SELECT DISTINCT Q.[QuestionID],Q.[Description],Q.[DisplayOrder],QA.[isHotTopic]
			  FROM [EC].[Survey_DIM_Question]Q JOIN [EC].[Survey_DIM_QAnswer]QA
			  ON Q.QuestionID = QA.QuestionID
			  WHERE Q.[isActive]= 1 AND QA.[SurveyTypeID] = '''+CONVERT(NVARCHAR,@intSurveyTypeID)+'''
			  ORDER BY [DisplayOrder]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Questions_For_Survey







GO


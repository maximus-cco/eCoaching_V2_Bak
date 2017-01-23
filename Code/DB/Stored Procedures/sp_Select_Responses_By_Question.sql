/*
sp_Select_Responses_By_Question(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Responses_By_Question' 
)
   DROP PROCEDURE [EC].[sp_Select_Responses_By_Question]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: This procedure returns a list of Questions Ids and all their possible Responses and their display order 
-- to be displayed in the UI.
-- TFS 549 - CSR Survey Setup - 09/24/2015
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Responses_By_Question] 


AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)
	


SET @nvcSQL = 'SELECT [QuestionID],[ResponseID],[ResponseValue]
			  FROM [EC].[Survey_DIM_QAnswer]
			  ORDER BY [QuestionID]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Responses_By_Question



GO


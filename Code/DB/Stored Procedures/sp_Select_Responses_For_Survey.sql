/*
sp_Select_Responses_For_Survey(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Responses_For_Survey' 
)
   DROP PROCEDURE [EC].[sp_Select_Responses_For_Survey]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/24/2015
--	Description: This procedure returns a list of all Active Responses and their Ids.
-- TFS 549 - CSR Survey Setup - 09/24/2015
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Responses_For_Survey] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)
	

SET @nvcSQL = 'SELECT [ResponseID],[Value]
			  FROM [EC].[Survey_DIM_Response]
			  WHERE [isActive]= 1'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Responses_For_Survey



GO


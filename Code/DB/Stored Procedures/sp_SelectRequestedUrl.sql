
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	10/05/2022
--	Description: 	This procedure returns the URL for a given Name value.
-- Initial Revision. TFS 25412 - 10/05/2022
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectRequestedUrl] @strName nvarchar(50)
AS

BEGIN
DECLARE	
@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT [Value] url
      FROM [EC].[Coaching_Support_Urls]
	  WHERE [Name] = '''+@strName+ '''
	  AND [isActive] = 1'	

--PRINT @nvcSQL		
EXEC (@nvcSQL)	
	    
END --sp_SelectRequestedUrl

GO



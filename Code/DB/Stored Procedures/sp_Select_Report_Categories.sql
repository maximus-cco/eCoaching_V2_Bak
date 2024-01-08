SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      01/02/2024
--    Description:     Used to retrieve Report Categories for Feed Load Dashboard.
--    Initial Revision. 
--    Created  to support Feed Load Dashboard - TFS 27523 - 01/02/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Report_Categories] 

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)
	

SET @nvcSQL = 'SELECT X.[CategoryID], X.Category  FROM
(SELECT ''-1'' CategoryID, ''All'' Category,  01 Sortorder From [EC].[DIM_Feed_List]
UNION
SELECT  CONVERT(nvarchar,[CategoryID]) CategoryID, Category , 02 Sortorder From [EC].[DIM_Feed_List]
where [isActive]= 1)X
ORDER BY X.Sortorder, Category '

--Print @nvcSQL

EXEC (@nvcSQL)	
END
GO



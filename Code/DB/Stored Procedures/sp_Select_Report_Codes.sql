SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      01/02/2024
--    Description:     Used to retrieve Report Codes for Feed Load Dashboard.
--    Initial Revision. 
--    Created  to support Feed Load Dashboard - TFS 27523 - 01/02/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Report_Codes] 
@intCategoryID INT = -1

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@NewLineChar nvarchar(2),
	@nvcCategory  nvarchar(20),
	@where nvarchar(max); 

SET @NewLineChar = CHAR(13) + CHAR(10);
SET @where = ' WHERE [isActive]= 1' ;

PRINT @WHERE 

IF @intCategoryID  <> -1
BEGIN 
    SET @nvcCategory = (SELECT DISTINCT [Category] FROM [EC].[DIM_Feed_List] WHERE [CategoryID] = @intCategoryID)
    SET @where = @where + @NewLineChar + 'AND [Category] =  ''' + @nvcCategory + ''''
END
	
PRINT @nvcCategory

SET @nvcSQL = 'SELECT X.[ReportID], X.[ReportCode]  FROM
(SELECT ''-1'' ReportID, ''All'' ReportCode,  01 Sortorder From [EC].[DIM_Feed_List]
UNION
SELECT  CONVERT(nvarchar,[ReportID]) ReportID, ReportCode , 02 Sortorder From [EC].[DIM_Feed_List]' +  @NewLineChar +
   @where +  @NewLineChar +
 ') X 
ORDER BY X.Sortorder, ReportCode '

--Print @nvcSQL

EXEC (@nvcSQL)	
END
GO



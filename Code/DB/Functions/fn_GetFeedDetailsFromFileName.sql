SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
--    Author:           Susmitha Palacherla
--    Create Date:      01/02/2024
--    Description:     Used to look up Report Code and Description given a File Name.
--    Initial Revision. 
--    Created  to support Feed Load Dashboard - TFS 27523 - 01/02/2024
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_GetFeedDetailsFromFileName] 
(
	@nvcFileName nvarchar(100)

)
RETURNS 
@Table_FeedDetails TABLE 
(
    [Code] [nvarchar](10) NULL,
	[Description] [nvarchar](100) NULL
)
AS
BEGIN
 
  INSERT @Table_FeedDetails
  (
    [Code],
	[Description]
  )
 
SELECT TOP 1 [ReportCode], [ReportDescription] FROM
(SELECT  TOP 1 [ReportCode], [ReportDescription] FROM [EC].[Feed_Contacts]
WHERE (CHARINDEX([ReportCode], @nvcFileName ) > 0 )
UNION ALL
SELECT DISTINCT 'Unknown' AS [ReportCode] , 'Unknown' AS [ReportDescription] FROM [EC].[Feed_Contacts] ) pocs
ORDER BY CASE WHEN  [ReportCode] = 'Unknown' THEN 2 ELSE 1 END



RETURN 
END -- fn_GetFeedDetailsFromFileName

GO



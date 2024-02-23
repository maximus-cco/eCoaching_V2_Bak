SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Sites to be displayed in the dashboard
--  Site dropdown list.
-- Last Modified By: Susmitha Palacherla
-- Modified per SCR 14893 Round 2 Performance improvements.
-- Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Sites_For_Dashboard] 

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.SiteID, X.Site, X.isSub  FROM
(SELECT ''-1'' SiteID, ''All Sites'' Site, 0 isSub ,  01 Sortorder From [EC].[DIM_Site]
UNION
SELECT  CONVERT(nvarchar,[SiteID]) SiteID, [City] Site, [isSub],  02 Sortorder From [EC].[DIM_Site]
where [isActive]= 1)X
ORDER BY X.Sortorder, Site'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sites_For_Dashboard

GO



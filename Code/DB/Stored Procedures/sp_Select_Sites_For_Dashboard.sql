/*
sp_Select_Sites_For_Dashboard(02).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla

Version 02 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Sites_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Sites_For_Dashboard]
GO


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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Sites_For_Dashboard] 

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.SiteID, X.Site  FROM
(SELECT ''-1'' SiteID, ''All Sites'' Site,  01 Sortorder From [EC].[DIM_Site]
UNION
SELECT  CONVERT(nvarchar,[SiteID]) SiteID, [City] Site, 02 Sortorder From [EC].[DIM_Site]
where [isActive]= 1)X
ORDER BY X.Sortorder, Site'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sites_For_Dashboard

GO




/*
sp_Select_Sites_For_Dashboard(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
-- Last Modified Date: 06/01/2015
-- Last Modified Bt: Susmitha Palacherla
-- Modified per SCR 14893 Round 2 Performance improvements.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Sites_For_Dashboard] 

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.SiteText, X.SiteValue FROM
(SELECT ''All Locations'' SiteText, ''%'' SiteValue, 01 Sortorder From [EC].[DIM_Site]
UNION
SELECT [City] SiteText, CONVERT(nvarchar,[SiteID]) SiteValue, 02 Sortorder From [EC].[DIM_Site]
where [isActive]= 1)X
ORDER BY X.Sortorder'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sites_For_Dashboard

GO


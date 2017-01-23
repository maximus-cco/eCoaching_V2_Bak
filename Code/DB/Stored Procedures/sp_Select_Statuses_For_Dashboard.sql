/*
sp_Select_Statuses_For_Dashboard(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Statuses_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Statuses_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Statuses to be displayed in the dashboard
--  Status dropdown list.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Statuses_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.StatusText, X.StatusValue FROM
(SELECT ''All Statuses'' StatusText, ''%'' StatusValue, 01 Sortorder From [EC].[DIM_Status]
UNION
SELECT [Status] StatusText, [Status] StatusValue, 02 Sortorder From [EC].[DIM_Status]
Where [Status] NOT IN (''Inactive'', ''Unknown''))X
ORDER BY X.Sortorder'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Statuses_For_Dashboard



GO


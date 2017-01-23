/*
sp_Select_Values_For_Dashboard(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Values_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_Values_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/06/2015
--	Description: *	This procedure selects Values to be displayed in the dashboard
--  filter dropdown list.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Values_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.ValueText, X.ValueValue FROM
(SELECT ''All Values'' ValueText, ''%'' ValueValue, 01 Sortorder 
UNION
SELECT Distinct [Value] ValueText, [Value] ValueValue, 02 Sortorder From [EC].[Coaching_Log_Reason] WITH(NOLOCK)
Where [Value] IS NOT NULL
AND [Value] <> ''Not Coachable'')X
ORDER BY X.Sortorder, X.ValueText'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Values_For_Dashboard

GO


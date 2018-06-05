/*
sp_Select_Values_For_Dashboard(02).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla

Version 02 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

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
-- Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Values_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.ValueValue, X.Value  FROM
(SELECT ''-1'' ValueValue,''All Values'' Value,  01 Sortorder 
UNION
SELECT Distinct [Value] ValueValue, [Value] Value,  02 Sortorder From [EC].[Coaching_Log_Reason] WITH(NOLOCK)
Where [Value] IS NOT NULL
AND [Value] <> ''Not Coachable'')X
ORDER BY X.Sortorder, X.Value'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Values_For_Dashboard
GO




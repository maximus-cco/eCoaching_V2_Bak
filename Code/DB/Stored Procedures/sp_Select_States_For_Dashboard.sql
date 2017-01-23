/*
sp_Select_States_For_Dashboard(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_States_For_Dashboard' 
)
   DROP PROCEDURE [EC].[sp_Select_States_For_Dashboard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	03/13/2015
--	Description: *	This procedure returns list of possible States for Warning Logs.
--  The 2 possible States of a Warning log are Active (within 91 days of warning given date) and Expired 
--  for logs that have WarningGivenDate over 91 days.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_States_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)



SET @nvcSQL = 'SELECT X.StateText, X.StateValue FROM
(SELECT ''All States'' StateText, ''%'' StateValue, 01 Sortorder 
UNION
SELECT ''Active'' StateText, ''1'' StateValue, 02 Sortorder 
UNION
SELECT ''Expired'' StateText, ''0'' StateValue, 03 Sortorder 
)X
ORDER BY X.Sortorder'



--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_States_For_Dashboard


GO


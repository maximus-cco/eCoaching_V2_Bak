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
--   Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--   Modified during changes to QN Workflow. TFS 22187 - 09/20/2021
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Statuses_For_Dashboard] 


AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT X.StatusId, X.Status FROM
(SELECT ''-1'' StatusId, ''All Statuses'' Status,  01 Sortorder From [EC].[DIM_Status]
UNION
SELECT CONVERT(nvarchar,[StatusID]) StatusId, [Status] Status,  02 Sortorder From [EC].[DIM_Status]
Where [Status] NOT IN (''Inactive'', ''Unknown''))X
ORDER BY X.Sortorder'


Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Statuses_For_Dashboard

GO






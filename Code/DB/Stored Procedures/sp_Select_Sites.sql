/*
sp_Select_Sites(01).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla


Version 01: Initial Revision. Created during Submissions move to new architecture - TFS 7136 - 04/10/2018 

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Sites' 
)
   DROP PROCEDURE [EC].[sp_Select_Sites]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/17/2018
--	Description: *	This procedure selects active Sites to be displayed in the UI
--  Created during Submissions move to new architecture - TFS 7136 - 04/10/2018.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Sites] 

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

SET @nvcSQL = 'select distinct * from ec.DIM_Site where city != ''unknown'' and isActive = 1 order by city'


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Sites



GO




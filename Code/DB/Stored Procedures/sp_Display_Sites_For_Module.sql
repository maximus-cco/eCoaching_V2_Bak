/*
sp_Display_Sites_For_Module(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Display_Sites_For_Module' 
)
   DROP PROCEDURE [EC].[sp_Display_Sites_For_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/01/14
--	Description: *	This procedure takes in a Module ID and returns the list of sites if the Module passed in 
--  supports By Site submissions.
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Display_Sites_For_Module] 

@strModulein nvarchar(30)

AS

BEGIN
DECLARE	
@isBySite BIT,
@nvcSQL nvarchar(max)


SET @isBySite = (SELECT BySite FROM [EC].[DIM_Module] Where [Module] = @strModulein and isActive =1)
IF @isBySite = 1

SET @nvcSQL = 'select [SiteID],[City] FROM [EC].[DIM_Site]WHERE [isActive] = 1 ORDER BY City'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Display_Sites_For_Module
  


GO


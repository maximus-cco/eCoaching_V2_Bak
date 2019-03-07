/*
sp_Select_Programs(03).sql
Last Modified Date: 03/07/2019
Last Modified By: Susmitha Palacherla

Version 03: Modified to change Sort Order - TFS 13643 - 03/07/2019

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Programs' 
)
   DROP PROCEDURE [EC].[sp_Select_Programs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure returns a list of Active Programs to
--  be made available in the UI submission page.
--  Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
-- Modified to change Sort Order - TFS 13643 - 03/07/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Programs] 
@intModuleIDin int

AS
BEGIN
	DECLARE	
	@isByProgram BIT,
	@nvcSQL nvarchar(max)
	
SET @isByProgram = (SELECT ByProgram FROM [EC].[DIM_Module] Where [ModuleID] = @intModuleIDin and isActive =1)
IF @isByProgram = 1

SET @nvcSQL = 'Select [ProgramID],[Program] as Program from [EC].[DIM_Program]
Where isActive = 1
Order by [SortOrder] '

--Print @nvcSQL

EXEC (@nvcSQL)	
END


GO



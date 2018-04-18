/*
sp_Select_CallID_By_Module(02).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_CallID_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_CallID_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module value and returns the Call Ids 
--                  valid for that Module and the format for the corresponding Ids for validation.
--  Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_CallID_By_Module] 
@intModuleIDin INT

AS
BEGIN
	DECLARE	
	@strModulein nvarchar(30),
	@nvcSQL nvarchar(max)

SET @strModulein = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)

SET @nvcSQL = 'Select [CallIdType] as CallIdType, [Format]as IdFormat from [EC].[CallID_Selection]
Where ' + @strModulein +' = 1' 


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_CallID_By_Module

GO




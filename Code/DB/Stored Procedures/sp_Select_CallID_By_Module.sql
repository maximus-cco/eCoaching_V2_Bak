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
--  Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_CallID_By_Module] 
@intModuleIDin INT

AS
BEGIN
	DECLARE	
	@strModulein nvarchar(30),
	@nvcSQL nvarchar(max);

SET @strModulein = (SELECT Replace([Module],' ','') FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin);

Print @strModulein;

SET @nvcSQL = 'Select [CallIdType] as CallIdType, [Format] as IdFormat from [EC].[CallID_Selection]
Where [' + @strModulein +'] = 1' 


--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_CallID_By_Module
GO


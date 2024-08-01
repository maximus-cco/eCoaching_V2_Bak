SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module and Source (Direct or Indirect)
--  and returns the Source IDis for the coresponding Sub Coaching Source.
--  Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
--  Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Source_By_Module] 
@intModuleIDin INT, @strSourcein nvarchar(30)

AS
BEGIN
	DECLARE	
	@strModulein nvarchar(30),
	@nvcSQL nvarchar(max);

SET @strModulein = (SELECT Replace([Module],' ','') FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin);

SET @nvcSQL = 'Select [SourceID] as SourceID, [SubCoachingSource]as Source from [EC].[DIM_Source]
Where ' + @strModulein +' = 1 and 
IsActive = 1 and 
CoachingSource =  '''+@strSourcein+'''
Order by [SubCoachingSource] '

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_Source_By_Module
GO


/*
sp_Select_Behaviors(02).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Behaviors' 
)
   DROP PROCEDURE [EC].[sp_Select_Behaviors]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	04/10/2015
--	Description: *	This procedure returns a list of Behaviors to
--  be made available in the UI submission page for Modules that track Behavior.
--  Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Behaviors] 
@intModuleIDin int

AS
BEGIN
	DECLARE	
	@isByBehavior BIT,
	@nvcSQL nvarchar(max)
	
SET @isByBehavior = (SELECT ByBehavior FROM [EC].[DIM_Module] Where [ModuleID] = @intModuleIDin and isActive =1)
IF @isByBehavior = 1

SET @nvcSQL = 'Select [BehaviorID], [Behavior] as Behavior from [EC].[DIM_Behavior]
Order by CASE WHEN [Behavior] = ''Other'' Then 1 Else 0 END, [Behavior]'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Behaviors
GO




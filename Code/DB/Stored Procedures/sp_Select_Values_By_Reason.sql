/*
sp_Select_Values_By_Reason(03).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla

Version 03: Submissions move to new architecture. Additional changes from V&V feedback - TFS 7136 - 04/30/2018

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Values_By_Reason' 
)
   DROP PROCEDURE [EC].[sp_Select_Values_By_Reason]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module and Coaching Reason 
--  and returns the Values associated with the Coaching Reason for that Module. 
--  Modified during Submissions move to new architecture - TFS 7136 - 04/30/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Values_By_Reason] 
@intReasonIDin INT, @intModuleIDin INT, @strSourcein nvarchar(30)

AS
BEGIN
	DECLARE	
	@strModulein nvarchar(30),
	@strReasonin nvarchar(100),
	@nvcSQL nvarchar(max)

SET @strModulein = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)
SET @strReasonin = (SELECT [CoachingReason] FROM [EC].[DIM_Coaching_Reason] WHERE [CoachingReasonID] = @intReasonIDin)	

SET @nvcSQL = 'Select CASE WHEN [isOpportunity] = 1 THEN ''Opportunity'' ElSE NULL END as Value from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
UNION
Select CASE WHEN [isReinforcement] = 1 THEN ''Reinforcement'' ElSE NULL END as Value from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1'


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Values_By_Reason
GO




/*
sp_Select_Values_By_Reason(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
--	Description: *	This procedure takes a Module 
--  and returns the Coaching Reasons associated with the Module. 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Values_By_Reason] 
@strReasonin nvarchar(200), @strModulein nvarchar(30), @strSourcein nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max)

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


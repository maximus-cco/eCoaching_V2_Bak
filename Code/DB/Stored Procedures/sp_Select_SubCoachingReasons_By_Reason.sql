/*
sp_Select_SubCoachingReasons_By_Reason(04).sql
Last Modified Date: 04/30/2018
Last Modified By: Susmitha Palacherla

Version 04: Submissions move to new architecture. Additional changes from V&V feedback - TFS 7136 - 04/30/2018

Version 03 : Modified to open Encryption key. TFS 10760 - 04/24/2018

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_SubCoachingReasons_By_Reason' 
)
   DROP PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module, Direct or Indirect, a Coaching Reason and the submitter lanid 
--  and returns the Sub Coaching Reasons associated with the Coaching Reason.
-- Last Modified By: Susmitha Palacherla
-- Modified during Submissions move to new architecture - TFS 7136 - 04/30/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason] 
@intReasonIDin INT, @intModuleIDin INT, @strSourcein nvarchar(30), @nvcEmpIDin nvarchar(10)

AS
BEGIN
	DECLARE	
	@nvcEmpJobCode nvarchar(30),
	@strModule nvarchar(30),
	@strCoachReason nvarchar(100),
	@nvcSQL nvarchar(max)
	

SET @strModule = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)	
SET @strCoachReason = (SELECT [CoachingReason] FROM [EC].[DIM_Coaching_Reason] WHERE [CoachingReasonID] = @intReasonIDin)	
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy WHERE Emp_ID = @nvcEmpIDin)


IF  (@strSourcein = 'Direct' and (@nvcEmpJobCode like 'WISY13' OR @nvcEmpJobCode like 'WSQA70' OR @nvcEmpJobCode like '%CS40%' OR @nvcEmpJobCode like '%CS50%' OR @nvcEmpJobCode like '%CS60%'))
OR
(@strSourcein = 'Direct' and @strCoachReason in ('Verbal Warning', 'Written Warning' ,'Final Written Warning'))

SET @nvcSQL = 'Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModule +' = 1 
and [CoachingReason] = '''+@strCoachReason +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
Order by CASE WHEN [SubCoachingReason] in (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'') Then 1 Else 0 END, [SubCoachingReason]'

ELSE

SET @nvcSQL = 'Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModule +' = 1 
and [CoachingReason] = '''+@strCoachReason +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
AND [SubCoachingReason] <> ''ETS''
Order by CASE WHEN [SubCoachingReason] in (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'') Then 1 Else 0 END, [SubCoachingReason]'

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SubCoachingReasons_By_Reason




GO




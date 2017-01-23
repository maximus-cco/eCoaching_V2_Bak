/*
sp_Select_SubCoachingReasons_By_Reason(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
-- Last Modified Date: 10/29/2014
-- Modified per SCR to display ETS as a Sub coaching Reason irrespective of Job Code
-- for Warnings related Coaching Reasons.
--
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason] 
@strReasonin nvarchar(200), @strModulein nvarchar(30), @strSourcein nvarchar(30), @nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	
	@nvcEmpID nvarchar(10),
	@nvcEmpJobCode nvarchar(30),
	@dtmDate datetime,
	@nvcSQL nvarchar(max)
	
	
SET @dtmDate  = GETDATE()  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate)
SET @nvcEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)


IF  (@strSourcein = 'Direct' and (@nvcEmpJobCode like 'WISY13' OR @nvcEmpJobCode like 'WSQA70' OR @nvcEmpJobCode like '%CS40%' OR @nvcEmpJobCode like '%CS50%' OR @nvcEmpJobCode like '%CS60%'))
OR
(@strSourcein = 'Direct' and @strReasonin in ('Verbal Warning', 'Written Warning' ,'Final Written Warning'))

SET @nvcSQL = 'Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
Order by CASE WHEN [SubCoachingReason] in (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'') Then 1 Else 0 END, [SubCoachingReason]'

ELSE

SET @nvcSQL = 'Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
AND [SubCoachingReason] <> ''ETS''
Order by CASE WHEN [SubCoachingReason] in (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'') Then 1 Else 0 END, [SubCoachingReason]'

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SubCoachingReasons_By_Reason

GO


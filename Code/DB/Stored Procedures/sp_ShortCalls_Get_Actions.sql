/*
sp_ShortCalls_Get_Actions(01).sql
Last Modified Date:  07/05/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision. New logic for handling Short calls - TFS 14108 - 07/05/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_ShortCalls_Get_Actions' 
)
   DROP PROCEDURE [EC].[sp_ShortCalls_Get_Actions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/25/2019
--	Description: *	This procedure takes a behavior that is not valid  and returns prescriptive actions for that behavior.
--  Initial revision. New process for short calls. TFS 14108 - 06/25/2019
--	=====================================================================
CREATE PROCEDURE [EC].[sp_ShortCalls_Get_Actions] 
@EmpId nvarchar(10), @intBehaviorId int
AS
BEGIN
	DECLARE	
	@ResetDays int,
	@InteractionCount int,
	@CurDisplayOrder int,
	@NewDisplayOrder int,
	@ActiveWarningCount int,
	@nvcSQL nvarchar(max)

-- Per Policy Interaction rollover timeframe has been set at 6 weeks based on event date.
SET @ResetDays = 42

	
SET @InteractionCount	= 
(SELECT COUNT(VerintCallID) FROM [EC].[ShortCalls_Evaluations] SCE JOIN [EC].[Coaching_Log] CL WITH (NOLOCK) 
ON SCE.CoachingId = CL.CoachingId
WHERE CL.EmpID = @EmpId
AND BehaviorId = @intBehaviorId
AND Action IS NOT NULL
AND DATEDIFF(D, [sce].[EventDate], GetDate()) <  @ResetDays
)

--PRINT @InteractionCount

IF @InteractionCount = 0
SET @NewDisplayOrder = 1
ELSE
SET @NewDisplayOrder = EC.fn_intActionDisplayOrder(@EmpId,@intBehaviorId)


SET @nvcSQL = 'Select BAL.ActionId AS ActionId, A.Action AS ActionText 
FROM [EC].[ShortCalls_Prescriptive_Actions] A JOIN [EC].[ShortCalls_Behavior_Action_Link] BAL
ON A.ID = BAL.ActionId
Where BAL.BehaviorId = '''+ CONVERT(NVARCHAR,@intBehaviorId) + '''
and BAL.Active = 1
and BAL.DisplayOrder = '''+ CONVERT(NVARCHAR,@NewDisplayOrder) + ''''


--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_ShortCalls_Get_Actions
GO

/*
fn_intActionDisplayOrder(01A).sql
Last Modified Date: 07/30/2019
Last Modified By: Susmitha Palacherla

Version 01A: Updated from V&V feedback.TFS 14108 - 07/30/2019
Version 01: Document Initial Revision. New process for short calls. - TFS 14108 - 06/25/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intActionDisplayOrder' 
)
   DROP FUNCTION [EC].[fn_intActionDisplayOrder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:        07/05/2019
-- Description:	 Given an EmpID and BehaviorID, determines the display order of the next action to be displayed
-- Initial revision. New process for short calls. TFS 14108 - 06/25/2019
-- =============================================
CREATE FUNCTION [EC].[fn_intActionDisplayOrder]
 (
@EmpId nvarchar(10), @intBehaviorId int
)

RETURNS INT
AS
BEGIN

DECLARE	@ResetDays int,
	    @NewDisplayOrder int

SET @ResetDays = 42
   
;WITH All_Actions AS (
  SELECT sce.*, ROW_NUMBER() OVER (PARTITION BY CL.EMPID, SCE.BEHAVIORID ORDER BY SCE.EventDate DESC) AS rn
  FROM [EC].[ShortCalls_Evaluations] SCE JOIN [EC].[Coaching_Log] CL WITH (NOLOCK) 
ON SCE.CoachingId = CL.CoachingId
WHERE CL.EmpID = @EmpId
AND BehaviorId = @intBehaviorId
AND Action IS NOT NULL
AND Valid = 0
AND DATEDIFF(D, [sce].[EventDate], GetDate()) <  @ResetDays
)

,Last_Action AS (
SELECT AA.BehaviorID, PA.ID
FROM  All_Actions AA JOIN [EC].[ShortCalls_Prescriptive_Actions] PA
ON AA.Action = PA.Action
WHERE rn = 1)

,Next_Action AS (
SELECT BehaviorID, ActionID, DisplayOrder,
LEAD(DisplayOrder) OVER (ORDER BY BehaviorID, DisplayOrder, ActionID) AS NextDisplayOrder
FROM [EC].[ShortCalls_Behavior_Action_Link] BAL
)
--SELECT * FROM Next_Action

SELECT @NewDisplayOrder = CASE WHEN NA.NextDisplayOrder > NA.DisplayOrder THEN NA.NextDisplayOrder
ELSE NA.DisplayOrder END 
FROM Last_Action LA JOIN Next_Action NA
ON LA.BehaviorID = NA.BehaviorID
AND LA.ID = NA.ActionID

RETURN @NewDisplayOrder
  
END  -- fn_intActionDisplayOrder()

GO






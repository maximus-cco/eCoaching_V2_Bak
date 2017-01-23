/*
fn_intLastKnownStatusForCoachingID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intLastKnownStatusForCoachingID' 
)
   DROP FUNCTION [EC].[fn_intLastKnownStatusForCoachingID]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:           Susmitha Palacherla
-- Create date:      04/21/2015
-- Description:	     Given a CoachingID returns the last known active status from the audit table.
-- Revision History:
-- Initial revision - Created per TFS 1709 Admin tool setup - 4/21/2016
-- =============================================

CREATE FUNCTION [EC].[fn_intLastKnownStatusForCoachingID] (
  @bigintID bigint
)
RETURNS INT
AS
BEGIN
  DECLARE @intLKStatusID INT


  SET @intLKStatusID = 
(SELECT A.[LastKnownStatus] 
FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]A
JOIN (SELECT [CoachingID], MAX([ActionTimestamp])AS MaxActionTimestamp
 FROM [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
 WHERE [LastKnownStatus] <> 2
 GROUP BY [CoachingID]) AMax
 ON A.[CoachingID]= AMax.[CoachingID]
 AND A.ActionTimestamp = AMax.MaxActionTimestamp
  WHERE  A.[CoachingID] = @bigintID)
  
         
RETURN @intLKStatusID

END  -- fn_intLastKnownStatusForCoachingID





GO


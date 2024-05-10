SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:           Susmitha Palacherla
-- Create date:      05/01/2024
-- Description:	     Given a WarningID returns the last known active status from the audit table.
-- Revision History:
-- Initial revision - Changes to Warning Inctivation Process. TFS 28097 -  05/07/2024
-- =============================================

CREATE OR ALTER FUNCTION [EC].[fn_intLastKnownStatusForWarningID] (
  @bigintID bigint
)
RETURNS INT
AS
BEGIN
  DECLARE @intLKStatusID INT


  SET @intLKStatusID = 
(SELECT A.[LastKnownStatus] 
FROM [EC].[AT_Warning_Inactivate_Reactivate_Audit]A
JOIN (SELECT [WarningID], MAX([ActionTimestamp])AS MaxActionTimestamp
 FROM [EC].[AT_Warning_Inactivate_Reactivate_Audit]
 WHERE [LastKnownStatus] <> 2
 GROUP BY [WarningID]) AMax
 ON A.[WarningID]= AMax.[WarningID]
 AND A.ActionTimestamp = AMax.MaxActionTimestamp
  WHERE  A.[WarningID] = @bigintID)
  
         
RETURN @intLKStatusID

END  -- fn_intLastKnownStatusForWarningID
GO



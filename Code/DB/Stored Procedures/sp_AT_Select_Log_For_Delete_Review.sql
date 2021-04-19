

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	4/15/2021
--	Description: *	This procedure calls Procedure(s) to display the review details for 
--  the Coaching or Warning log selected by the user for deletion.
--  Revision History: 
--  Initial Revision created during migration to AWS to correctly associate functionality with Admin Tool - TFS 20970
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Log_For_Delete_Review] @intFormIDin BIGINT, @bitisCoaching bit
AS

BEGIN

IF @bitisCoaching = 1
  EXEC  [EC].[sp_AT_Select_Coaching_Log_For_Delete_Review]  @intFormIDin; 
ELSE  
  EXEC  [EC].[sp_AT_Select_Warning_Log_For_Delete_Review] @intFormIDin ;
	    
END --sp_AT_Select_Log_For_Delete_Review
GO
/*
sp_ShortCalls_Get_MgrReviewDetails(01).sql
Last Modified Date:  07/05/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision. New logic for handling Short calls - TFS 14108 - 07/05/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_ShortCalls_Get_MgrReviewDetails' 
)
   DROP PROCEDURE [EC].[sp_ShortCalls_Get_MgrReviewDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/25/2019
--	Description: *	This procedure takes a log id and return the short call details
--  Last Modified By:
--  Last Modified Date: 
--  Initial revision. New process for short calls. TFS 14108 - 06/25/2019
--	=====================================================================

CREATE PROCEDURE [EC].[sp_ShortCalls_Get_MgrReviewDetails] @intLogId BIGINT
AS

BEGIN
DECLARE	 @nvcSQL nvarchar(max)


SET @nvcSQL = 
'SELECT [CoachingID]
      ,[VerintCallID]
      ,E.[Valid]
      ,B.Description AS Behavior
      ,Action
      ,[CoachingNotes]
      ,[LSAInformed]
	  ,[MgrAgreed]
	  ,[MgrComments]
      FROM [EC].[ShortCalls_Evaluations] E LEFT JOIN [EC].[ShortCalls_Behavior] B
	  ON E.[BehaviorId]= B.ID 
	  WHERE [CoachingID]= '''+ CONVERT(NVARCHAR,@intLogId) + ''' ';
	
--PRINT @nvcSQL
EXEC (@nvcSQL)
    
END --sp_ShortCalls_Get_MgrReviewDetails
GO








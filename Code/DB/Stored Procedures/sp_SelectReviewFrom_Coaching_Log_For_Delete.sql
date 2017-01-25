/*
sp_SelectReviewFrom_Coaching_Log_For_Delete(01).sql
Last Modified Date: 1/25/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/25/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_For_Delete' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	06/08/2015
--	Description: 	This procedure displays the Coaching Log attributes for given Form Name.
--  Initial Revision per SCR 14478.

--	=====================================================================

CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete] @strFormIDin nvarchar(50)
AS

BEGIN
DECLARE	

@intCoachID bigint,
@nvcSQL nvarchar(max)

SET @intCoachID = (SELECT  [CoachingID] FROM  [EC].[Coaching_Log] WITH (NOLOCK)
	 	WHERE [FormName] = @strFormIDin)
	 	
IF 	 @intCoachID IS NOT NULL

  SET @nvcSQL = 'SELECT  [CoachingID]CoachingID,
			[FormName],
			[EmpLanID],
			[EmpID],
			[SourceID]
		FROM  [EC].[Coaching_Log] WITH (NOLOCK)
	 	WHERE [FormName] = '''+@strFormIDin+''''
	 
ELSE

  SET @nvcSQL = 'SELECT  [WarningID]CoachingID,
			[FormName],
			[EmpLanID],
			[EmpID],
			[SourceID]
		FROM  [EC].[Warning_Log] WITH (NOLOCK)
	 	WHERE [FormName] = '''+@strFormIDin+''''
	 		

EXEC (@nvcSQL)
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_For_Delete




GO



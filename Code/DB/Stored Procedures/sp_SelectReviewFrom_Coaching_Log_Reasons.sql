/*
sp_SelectReviewFrom_Coaching_Log_Reasons(04).sql

Last Modified Date: 05/06/2020
Last Modified By: Susmitha Palacherla

Version 04: Updated to customize sort order for Security and Privacy Coaching Reason. TFS 17066 - 05/06/2020
Version 03: Modified to incorporate Quality Now. TFS 13332 - 03/19/2019
Version 02 : Modified during Hist dashboard move to new architecture - TFS 7138 - 04/30/2018

*/


IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectReviewFrom_Coaching_Log_Reasons' 
)
   DROP PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/26/2014
--	Description: 	This procedure displays the Coaching Log Reason and Sub Coaching Reason values for 
--  a given Form Name.
--  Modified during Hist dashboard move to new architecture - TFS 7138 - 04/20/2018
--  Modified to support Quality Now  TFS 13332 -  03/01/2019
--  Updated to customize sort order for Security and Privacy Coaching Reason. TFS 17066 - 05/06/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectReviewFrom_Coaching_Log_Reasons] @intLogId BIGINT
AS

BEGIN
	DECLARE	

	@nvcSQL nvarchar(max)

SET @nvcSQL = 'SELECT cr.CoachingReason, scr.SubCoachingReason, 
CASE WHEN cl.Sourceid in (235,236) THEN ''''
ELSE clr.value END Value
FROM [EC].[Coaching_Log] cl join [EC].[Coaching_Log_Reason] clr
ON cl.Coachingid = clr.CoachingID join [EC].[DIM_Coaching_Reason] cr
ON[clr].[CoachingReasonID] = [cr].[CoachingReasonID] Join [EC].[DIM_Sub_Coaching_Reason]scr
ON [clr].[SubCoachingReasonID]= [scr].[SubCoachingReasonID]
Where clr.CoachingID = '''+CONVERT(NVARCHAR(20),@intLogId) + '''
ORDER BY cr.CoachingReason,
CASE WHEN scr.[SubCoachingReason] in
 (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'', ''Other Policy Violation (non-Security/Privacy)'',
 ''Other Security & Privacy'') Then 1
 Else 0 END ,
 CASE WHEN (scr.[SubCoachingReason] like ''Disclosure%'') Then 0 Else 1  END ,
 CASE WHEN scr.[SubCoachingReason] in
 (''Disclosure - Other Disclosure'') Then ''zDisclosure - Other Disclosure'' Else scr.SubCoachingReason  END,
clr.value'

		
EXEC (@nvcSQL)	
--Print (@nvcSQL)
	    
END --sp_SelectReviewFrom_Coaching_Log_Reasons

GO


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
-- Modified to support updated requirements to replace ETS with Deltek - TFS 15144 - 08/21/2019
-- Updated to support changes to warnings workflow. TFS 15803 - 11/21/2019
-- Updated to customize sort order for Security and Privacy Coaching Reason. TFS 17066 - 05/06/2020
-- Updated to support chnages to Work at Home Crs and Sub CRS. TFS 27375- 11/30/2023
-- Modified to support ASR Logs. TFS 28298 - 07/15/2024
-- Modified to add the Production Planning Module to eCoaching. TFS 28361 - 07/24/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason] 
@intReasonIDin INT, @intModuleIDin INT, @strSourcein nvarchar(30), @nvcEmpIDin nvarchar(10), @intSourceIDin int

AS
BEGIN
	DECLARE	
	@strModule nvarchar(30),
	@nvcASRRestrictSQL nvarchar(200),
	@NewLineChar nvarchar(2),
	@nvcSQL nvarchar(max);

SET @strModule = (SELECT Replace([Module],' ','') FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin);

SET @nvcASRRestrictSQL = '';
SET @NewLineChar = CHAR(13) + CHAR(10);

-- For CSR and ISG Modules: Where Sourceis ASR and Coaching Reason is Call Efficiency  - Display only the specific Sub Reasons
IF @intSourceIDin IN (138,238) AND @intModuleIDin in (1,10) AND @intReasonIDin = 55
SET @nvcASRRestrictSQL = @nvcASRRestrictSQL  + 'AND [SubCoachingReasonID]  in (230, 328, 329, 330, 331)'
ELSE
-- In all other scenarios exclude the above displayed Sub Coaching Reasons
SET @nvcASRRestrictSQL = @nvcASRRestrictSQL  + 'AND [SubCoachingReasonID] not in (230, 328, 329, 330, 331)';

SET @nvcSQL = ' 
Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason
from [EC].[Coaching_Reason_Selection]
Where ' + @strModule +' = 1 
and [CoachingReasonID] = '''+ CONVERT(NVARCHAR,@intReasonIDin) + '''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1' + @NewLineChar +
@nvcASRRestrictSQL + ' ' + '
Order by CASE WHEN [SubCoachingReason] in
 (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'', ''Other Policy Violation (non-Security/Privacy)'',
 ''Other Security & Privacy'', ''Other WFH Agreement Violations: Specify reason under coaching details.'') Then 1
 Else 0 END ,
 CASE WHEN ([SubCoachingReason] like ''Disclosure%'') Then 0 Else 1  END ,
 CASE WHEN [SubCoachingReason] in
 (''Disclosure - Other Disclosure'') Then ''zDisclosure - Other Disclosure'' Else SubCoachingReason  END '
 
--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SubCoachingReasons_By_Reason

GO



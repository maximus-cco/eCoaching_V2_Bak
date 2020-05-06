/*
sp_Select_SubCoachingReasons_By_Reason(07).sql
Last Modified Date: 05/06/2020
Last Modified By: Susmitha Palacherla

Version 07: Updated to customize sort order for Security and Privacy Coaching Reason. TFS 17066 - 05/06/2020
Version 06: Updated to support changes to warnings workflow. TFS 15803 - 11/21/2019
Version 05: Modified to support updated requirements to replace ETS with Deltek - TFS 15144 - 08/21/2019
Version 04: Submissions move to new architecture. Additional changes from V&V feedback - TFS 7136 - 04/30/2018
Version 03 : Modified to open Encryption key. TFS 10760 - 04/24/2018
Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
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
-- Modified during Submissions move to new architecture - TFS 7136 - 04/30/2018
-- Modified to support updated requirements to replace ETS with Deltek - TFS 15144 - 08/21/2019
-- Updated to support changes to warnings workflow. TFS 15803 - 11/21/2019
-- Updated to customize sort order for Security and Privacy Coaching Reason. TFS 17066 - 05/06/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_SubCoachingReasons_By_Reason] 
@intReasonIDin INT, @intModuleIDin INT, @strSourcein nvarchar(30), @nvcEmpIDin nvarchar(10)

AS
BEGIN
	DECLARE	
	@strModule nvarchar(30),
	@nvcSQL nvarchar(max)
	

SET @strModule = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)	

SET @nvcSQL = ' 
Select [SubCoachingReasonID] as SubCoachingReasonID, [SubCoachingReason] as SubCoachingReason
from [EC].[Coaching_Reason_Selection]
Where ' + @strModule +' = 1 
and [CoachingReasonID] = '''+ CONVERT(NVARCHAR,@intReasonIDin) + '''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
Order by CASE WHEN [SubCoachingReason] in
 (''Other: Specify reason under coaching details.'', ''Other Policy (non-Security/Privacy)'', ''Other: Specify'', ''Other Policy Violation (non-Security/Privacy)'',
 ''Other Security & Privacy'') Then 1
 Else 0 END ,
 CASE WHEN ([SubCoachingReason] like ''Disclosure%'') Then 0 Else 1  END ,
 CASE WHEN [SubCoachingReason] in
 (''Disclosure - Other Disclosure'') Then ''zDisclosure - Other Disclosure'' Else SubCoachingReason  END '



--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_SubCoachingReasons_By_Reason

GO



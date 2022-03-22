/*
sp_Select_CoachingReasons_By_Module(06).sql
Last Modified Date: 03/18/2022
Last Modified By: Susmitha Palacherla

Version 06: Updated to support Coaching and SubCoaching Reason changes for LSA Module - TFS 24083 - 03/19/2022
Version 05: Updated to support changes to warnings workflow. TFS 15803 - 11/21/2019
Version 04: Modified to support updated requirements to replace ETS with Deltek - TFS 15144 - 08/21/2019
Version 03: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
Version 02: Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_CoachingReasons_By_Module' 
)
   DROP PROCEDURE [EC].[sp_Select_CoachingReasons_By_Module]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/20/2014
--	Description: *	This procedure takes a Module 
--  and returns the Coaching Reasons associated with the Module. 
-- Last Modified By: Susmitha Palacherla
-- Last Modified Date: 09/25/2014
-- Modified per SCR 13479 to add logic for incorporating WARNINGs.
-- Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017
-- Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
-- Modified to add Deltek as a Coaching Reason. TFS 15144 - 08/19/2019
-- Updated to support changes to warnings workflow. TFS 15803 - 11/21/2019
-- Updated to support Coaching and SubCoaching Reason changes for LSA Module - TFS 24083 - 03/19/2022
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_CoachingReasons_By_Module] 
@intModuleIDin INT, @strSourcein nvarchar(30), @isSplReason BIT, @splReasonPrty INT, @strEmpIDin nvarchar(10), @strSubmitterIDin nvarchar(10)

AS
BEGIN
	DECLARE	
	
	@nvcSQL nvarchar(max),
	@strModulein nvarchar(30),
	@nvcDirectHierarchy nvarchar(10),
	@nvcDirectReports nvarchar(10)

OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
SET @strModulein = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin)
SET @nvcDirectHierarchy = [EC].[fn_strDirectUserHierarchy] (@strEmpIDin, @strSubmitterIDin)
SET @nvcDirectReports = [EC].[fn_strDirectReports] (@strSubmitterIDin)

--print @nvcDirectHierarchy
	
IF @isSplReason = 1 

IF @nvcDirectHierarchy = 'Yes'

-- cse or warnings depending on [splReasonPrty] passed in (1= warnings, 2= cse)

SET @nvcSQL = 'SELECT x.CoachingReasonID, x.CoachingReason FROM
(SELECT DISTINCT  CASE WHEN [CoachingReasonID]  = 60 THEN 01 ELSE 02 END SortOrder, [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
AND IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 1
AND [splReasonPrty] = '''+ CONVERT(NVARCHAR,@splReasonPrty) + ''')x
ORDER BY x.SortOrder'

Else

-- return cse 

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
AND IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 1
AND [splReasonPrty] = 2
Order by  [CoachingReason]'

ELSE

-- @isSplReason = 0

IF @nvcDirectReports = 'yes'

-- return all coaching reasons for module where [splReason] = 0

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 and 
IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 0
Order by  [CoachingReason]'

ELSE

-- return all coaching reasons for module where [splReason] = 0 Except CoachingReason = 'Deltek'/59

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 and 
IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 0
AND [CoachingReasonID] NOT IN (59,70) 
Order by  [CoachingReason]'

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_CoachingReasons_By_Module
GO





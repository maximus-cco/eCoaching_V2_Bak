/*
sp_Select_CoachingReasons_By_Module(02).sql
Last Modified Date: 1/18/2018
Last Modified By: Susmitha Palacherla

Version 02: --  Modified to support Encryption of sensitive data. TFS 7856 - 11/28/2017

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
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_CoachingReasons_By_Module] 
@strModulein nvarchar(30), @strSourcein nvarchar(30), @isSplReason BIT, @splReasonPrty INT, @strCSRin nvarchar(30), @strSubmitterin nvarchar(30)

AS
BEGIN
	DECLARE	
	
	@nvcSQL nvarchar(max),
	@nvcDirectHierarchy nvarchar(10)

OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 
	
SET @nvcDirectHierarchy = [EC].[fn_strDirectUserHierarchy] (@strCSRin, @strSubmitterin, GETDATE())

--print @nvcDirectHierarchy
	
IF @isSplReason = 1 

IF @nvcDirectHierarchy = 'Yes'



SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
AND IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 1
AND [splReasonPrty] = '''+ CONVERT(NVARCHAR,@splReasonPrty) + '''
Order by  [CoachingReasonID]'

Else

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
AND IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 1
AND [splReasonPrty] = 2
Order by  [CoachingReason]'

ELSE

SET @nvcSQL = 'Select  DISTINCT [CoachingReasonID] as CoachingReasonID, [CoachingReason] as CoachingReason from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 and 
IsActive = 1 
AND ' + @strSourcein +' = 1
AND [splReason] = 0
Order by  [CoachingReason]'

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_CoachingReasons_By_Module


GO



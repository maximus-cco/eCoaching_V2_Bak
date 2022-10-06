SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/28/2022
--	Description: *	This procedure selects Coaching Reasons to be displayed in the dashboard
--  Coaching Reasons dropdown list.
--  Initial Revision. TFS 25387 - 09/28/2022
--	====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_CoachingReasons_For_Dashboard] 
@nvcEmpID nvarchar(10), @intSourceIdin int

AS
BEGIN
	DECLARE	
	@nvcSQL nvarchar(max),
	@nvcDisplayWarnings nvarchar(5),
	@nvcConditionalWhere nvarchar(100) = ''; 
	
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert] 	

SET @nvcDisplayWarnings = (SELECT ISNULL (EC.fn_strCheckIf_HRUser(@nvcEmpID),'NO')) 

IF @nvcDisplayWarnings = 'NO'

BEGIN
SET @nvcConditionalWhere = ' AND CoachingReasonID NOT IN (28,29,30,60) '
END

-- If HR user selects Warning source display only the 4 Warning Coaching Reasons in Dropdown

IF @nvcDisplayWarnings = 'YES' AND @intSourceIdin = 120

SET @nvcSQL = 'SELECT CONVERT(nvarchar,[CoachingReasonId]) CoachingReasonId, 
[CoachingReason] CoachingReason From [EC].[DIM_Coaching_Reason]
WHERE CoachingReasonID IN (28,29,30,60)
AND  [CoachingReason] <> ''Unknown'' 
ORDER BY CoachingReason'

ELSE

-- Display all Coaching Reasons for HR Users
-- Exclude the 4 Warning Coaching Reasons for all other users

SET @nvcSQL = 'SELECT X.CoachingReasonId, X.CoachingReason FROM
(SELECT ''-1'' CoachingReasonId, ''All Reasons'' CoachingReason,  01 Sortorder From [EC].[DIM_Coaching_Reason]
UNION
SELECT CONVERT(nvarchar,[CoachingReasonId]) CoachingReasonId, 
[CoachingReason] CoachingReason,  02 Sortorder From [EC].[DIM_Coaching_Reason]
 WHERE 1 = 1 '
  + @nvcConditionalWhere +
  ' AND  [CoachingReason] <> ''Unknown'' ) x
ORDER BY X.Sortorder, X.CoachingReason'

--Print @nvcSQL

EXEC (@nvcSQL)	
END --sp_Select_CoachingReasons_For_Dashboard

GO



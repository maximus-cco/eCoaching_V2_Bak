SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	7/8/2022
--	Description: *	This procedure returns the list of Sites(s) for the logged in user. 
--  for users with ELS Role, only their site is returned. All sites returned for Other users.
--  Last Modified By: 
--  Revision History:
--  Initial Revision. Report access for Early Life Supervisors. TFS TBD - 7/8/2022
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_AT_Select_Sites_By_User] 
@nvcEmpLanIDin nvarchar(30)

AS
BEGIN
	DECLARE	

	@nvcSQL nvarchar(max),
	@nvcEmpID nvarchar(10),
	@dtmDate datetime,
	@intELSRowID int;

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

SET @dtmDate  = GETDATE();  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@nvcEmpLanIDin,@dtmDate);
SET @intELSRowID = (SELECT COUNT(*) FROM [EC].[Historical_Dashboard_ACL]
WHERE Role = 'ELS' AND End_Date = 99991231 AND (CONVERT(nvarchar(30),DecryptByKey([User_LanID])) =  @nvcEmpLanIDin OR CONVERT(nvarchar(30),DecryptByKey([User_LanID])) =  @nvcEmpID));

IF @intELSRowID = 0
SET @nvcSQL = 'SELECT -1 SiteID,  ''All'' Site, 0 isSub
               UNION 
			   SELECT SiteID, [City] Site, [isSub] FROM  EC.DIM_Site WHERE isActive = 1'
ELSE
SET @nvcSQL = 'SELECT [EC].[fn_intSiteIDFromSite]([Emp_Site])SiteID,  [Emp_Site] Site, [isSub] FROM EC.Employee_Hierarchy WHERE Emp_ID = '''+@nvcEmpID+''''

--Print @nvcSQL

EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]  
END --sp_AT_Select_Sites_By_User




GO



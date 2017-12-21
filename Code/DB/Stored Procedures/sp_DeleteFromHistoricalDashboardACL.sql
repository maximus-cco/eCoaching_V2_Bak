/*
sp_DeleteFromHistoricalDashboardACL(02).sql
Last Modified Date: 10/23/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_DeleteFromHistoricalDashboardACL' 
)
   DROP PROCEDURE [EC].[sp_DeleteFromHistoricalDashboardACL]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Jourdain Augustin
--	Create Date:	09/19/2012
--	Description: 	Delete record from Historical dashboard ACL table 
--  Last Modified by: Susmitha Palacherla
--  Modified per SCR 10617 to removed hard coded authorized users and look at the IsAdmin flag in the ACL Table - 10/18/2013
--  Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
--	=====================================================================

CREATE  PROCEDURE [EC].[sp_DeleteFromHistoricalDashboardACL]
  (
    @nvcACTION Nvarchar(10),
	@nvcLANID	Nvarchar(30),
	@nvcUserLANID	Nvarchar(30),
	@nvcRole	Nvarchar(20) = NULL,
	@nvcErrorMsgForEndUser Nvarchar(180) OUT
)
AS
BEGIN
	

	DECLARE @nvcHierarchyLevel	Nvarchar(20),
            @nvcSQL Nvarchar(max),
	        @ROWID int,
	        @nvcIsAdmin Nvarchar(1)

  
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]
	        
	SET @nvcErrorMsgForEndUser = N''	

   -- Removing the domain name from the Lanid.
	  SET @nvcLANID = SUBSTRING(@nvcLANID, CHARINDEX('\', @nvcLANID) + 1, LEN(@nvcLANID))
   -- Checking the App Role of the User
	  SET @nvcIsAdmin = (SELECT CASE WHEN End_Date = '99991231' THEN [ISADMIN] ELSE 'N'  END
                        FROM [EC].[View_Historical_Dashboard_ACL] WHERE [User_LanID] = @nvcLANID)
	  

	
--	Checking if the User is authorized to Remove

IF @nvcIsAdmin = 'Y'
BEGIN
  
    IF @nvcACTION = 'REMOVE'  
         UPDATE [EC].[Historical_Dashboard_ACL]
         SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112),
         [Updated_By] = EncryptByKey(Key_GUID('CoachingKey'), @nvcLANID )
         Where CONVERT(nvarchar(30),DecryptByKey([User_LanID])) = @nvcUserLANID

ELSE
SET @nvcErrorMsgForEndUser = N'Action ' + @nvcACTION + N' is not an acceptable action.'
END
 
ELSE		
		
BEGIN
SET @nvcErrorMsgForEndUser = N'Requester ' + @nvclanid + N' is not authorized to ADD/REMOVE Records.'
END			


CLOSE SYMMETRIC KEY [CoachingKey] 	
END --sp_DeleteFromHistoricalDashboardACL



GO


/*
sp_Check_AgentRole(02).sql
Last Modified Date: 10/23/2017

Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Check_AgentRole' 
)
   DROP PROCEDURE [EC].[sp_Check_AgentRole]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	<11/16/11>
--	Last Update:	<>
--	Description: *	This procedure returns the Row_ID from the ACl table if agent belongs to the role being checked. 
--  Last Update:    03/12/2014 - Updated per SCR 12359 to add NOLOCK Hint
--  Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Check_AgentRole]
(
 @nvcLANID	Nvarchar(30),
 @nvcRole	Nvarchar(30)
)
AS
Declare
 @ROWID INT

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


BEGIN

	SELECT @ROWID = [Row_ID]
	FROM  [EC].[Historical_Dashboard_ACL] WITH(NOLOCK)
	WHERE CONVERT(nvarchar(70),DecryptByKey([User_LanID])) = @nvcLANID
	AND [Role]= @nvcRole
	AND [End_Date]='99991231'


IF @ROWID IS NULL RETURN 0
ELSE
RETURN 	 @ROWID	

CLOSE SYMMETRIC KEY [CoachingKey]      
END --sp_Check_AgentRole



GO

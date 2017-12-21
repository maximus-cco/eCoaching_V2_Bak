/*
sp_Check_AppRole(02).sql
Last Modified Date: 10/23/2017

Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Check_AppRole' 
)
   DROP PROCEDURE [EC].[sp_Check_AppRole]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/21/2012
--	Description: 	This procedure returns whether the User is an admin or not.
--	Last Update:	09/18/2013
--               Last Modified By: Susmitha Palacherla
--               Updated per SCR 10617 to return 'N' for all Inactive users.
--  Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Check_AppRole]
(
 @nvcLANID	Nvarchar(30)
)
AS

BEGIN
DECLARE	

@nvcSQL nvarchar(max)

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]

SET @nvcSQL = 'SELECT [ISADMIN]=
              CASE WHEN End_Date = ''99991231'' THEN [ISADMIN]
              ELSE ''N''
              END
              FROM [EC].[Historical_Dashboard_ACL]
			  WHERE CONVERT(nvarchar(70),DecryptByKey([User_LanID])) = '''+@nvcLANID+''''
    	
EXEC (@nvcSQL)	
CLOSE SYMMETRIC KEY [CoachingKey]    
  
END--sp_Check_AppRole

GO



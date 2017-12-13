IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Historical_Dashboard_ACL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/2012
--	Last Update:	<>
--	Description: *	This procedure selects the user records from the Historical_Dashboard_ACL table
--  TFS 7856 encryption/decryption - emp name, emp lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Historical_Dashboard_ACL] 
(
  @nvcRole Nvarchar(30)
)
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

SET @nvcSQL = '
SELECT Row_ID
  ,CONVERT(nvarchar, DecryptByKey(User_LanID)) AS User_LanID
  ,CONVERT(nvarchar, DecryptByKey(User_Name)) AS User_Name
  ,[Role]
FROM [EC].[Historical_Dashboard_ACL]
WHERE Role = ''' + @nvcRole + ''' 
  AND End_Date > getdate()
ORDER BY User_LanID';
		
EXEC (@nvcSQL)

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];		
	    
END -- [sp_SelectFrom_Historical_Dashboard_ACL] 
GO
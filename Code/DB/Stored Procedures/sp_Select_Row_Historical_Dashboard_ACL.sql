/*
sp_Select_Row_Historical_Dashboard_ACL(01).sql
Last Modified Date: 01/18/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Row_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_Select_Row_Historical_Dashboard_ACL]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--	====================================================================
--	Author:	Susmitha Palacherla
--	Create Date: 01/18/2018
--	Description: Returns a record from Historical Dashboard ACL table given a Row ID.
--  Revision History:    
--  Initial Revision. Created to replace embedded sql in UI code during encryption of sensitive data. TFS 7856. 01/18/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Row_Historical_Dashboard_ACL]
@rowId INT
AS


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


BEGIN

	SELECT [Row_ID]
       	  ,CONVERT(nvarchar(30),DecryptByKey(User_LanID)) AS [User_LanID]
          ,CONVERT(nvarchar(50),DecryptByKey(User_Name))[User_Name]
          ,[Role]
    FROM [EC].[Historical_Dashboard_ACL]
	WHERE [Row_ID] = @rowId




CLOSE SYMMETRIC KEY [CoachingKey]      
END --sp_Select_Row_Historical_Dashboard_ACL





GO



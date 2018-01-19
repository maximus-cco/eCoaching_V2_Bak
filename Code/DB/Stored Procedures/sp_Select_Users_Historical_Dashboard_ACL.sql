/*
sp_Select_Users_Historical_Dashboard_ACL(01).sql
Last Modified Date: 01/18/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Select_Users_Historical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_Select_Users_Historical_Dashboard_ACL]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--	====================================================================
--	Author:	Susmitha Palacherla
--	Create Date: 01/18/2018
--	Description: Returns active records from Historical Dashboard ACL table
--  Revision History:    
--  Initial Revision. Created to replace embedded sql in UI code during encryption of sensitive data. TFS 7856. 01/18/2018
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Select_Users_Historical_Dashboard_ACL]

AS


OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]


BEGIN

	SELECT [Row_ID]
       	  ,CONVERT(nvarchar(30),DecryptByKey(User_LanID)) AS [User_LanID]
          ,CONVERT(nvarchar(70),DecryptByKey(User_Name))[User_Name]
          ,[Role]
    FROM [EC].[Historical_Dashboard_ACL]
	WHERE [End_Date]='99991231'




CLOSE SYMMETRIC KEY [CoachingKey]      
END --sp_Select_Users_Historical_Dashboard_ACL




GO



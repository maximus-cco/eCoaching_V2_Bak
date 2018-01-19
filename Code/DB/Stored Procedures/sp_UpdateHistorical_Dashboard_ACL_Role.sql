/*
sp_UpdateHistorical_Dashboard_ACL_Role(01).sql
Last Modified Date: 01/18/2017
Last Modified By: Susmitha Palacherla


Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 01/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateHistorical_Dashboard_ACL_Role' 
)
   DROP PROCEDURE [EC].[sp_UpdateHistorical_Dashboard_ACL_Role]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--    ====================================================================
--	Author:	Susmitha Palacherla
--	Create Date: 01/18/2018
--	Description: Updates Role for a given record in Historical Dashboard ACL table
--  Revision History:    
--  Initial Revision. Created to replace embedded sql in UI code during encryption of sensitive data. TFS 7856. 01/18/2018 
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateHistorical_Dashboard_ACL_Role]
(
      @role nvarchar(30),
	  @rowId INT,
	  @updatedBy  nvarchar(30)
)

AS
BEGIN

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert]
            
       UPDATE [EC].[Historical_Dashboard_ACL]
	   SET [Role] = @role,
	   [Updated_By] = EncryptByKey(Key_GUID('CoachingKey'), @updatedBy)
	   WHERE Row_ID = @rowId
  
CLOSE SYMMETRIC KEY [CoachingKey]  	    
END -- [sp_UpdateHistorical_Dashboard_ACL_Role] 



GO



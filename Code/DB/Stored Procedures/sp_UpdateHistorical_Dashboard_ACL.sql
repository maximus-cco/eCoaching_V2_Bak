/*
sp_UpdateHistorical_Dashboard_ACL(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateHistorical_Dashboard_ACL' 
)
   DROP PROCEDURE [EC].[sp_UpdateHistorical_Dashboard_ACL]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--    ====================================================================
--    Author:                 Jourdain Augustin
--    Create Date:      <09/20/12>
--    Last Update:      <>
--    Description: *    This procedure allows supervisors to update the e-Coaching records from review page. 
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateHistorical_Dashboard_ACL]
(
      @nvcRowID Nvarchar(30),
      @nvcLANID Nvarchar(30),
      @nvcUserLANID Nvarchar(30),
      @nvcRole Nvarchar(30)
       --UNUSED PARAMETERS
  --  @nvcRole VARCHAR(30) = NULL

)
AS
BEGIN
            
       UPDATE [EC].[Historical_Dashboard_ACL]
	   SET [User_LanID] = @nvcUserLANID, [Role] = @nvcRole, [User_Name] = EC.fn_strUserName(@nvcUserLANID),
	   [Updated_By] = @nvcLANID
	   WHERE Row_ID = @nvcRowID
  
	    
END -- [sp_UpdateHistorical_Dashboard_ACL] 

GO


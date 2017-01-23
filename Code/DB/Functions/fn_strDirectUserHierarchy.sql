/*
fn_strDirectUserHierarchy(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strDirectUserHierarchy' 
)
   DROP FUNCTION [EC].[fn_strDirectUserHierarchy]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	=============================================
--	Author:		Susmitha Palacherla
--	Create Date: 09/29/2014
--	Description:	 
--  *  Given an CSR LAN ID, a Submitter LAN ID and a date, return the  Employee ID of the
-- CSR and Submitter. Then check to see if the Employee ID of the Submitter 
-- equals the employee ID of the Supervisor or Manager.
-- If it does the function returns a a 'Yes' to Indicate Direct Hierrachy.
-- last Modified Date: 
-- Last Modified By: 

--	=============================================
CREATE FUNCTION [EC].[fn_strDirectUserHierarchy] 
(
  @strCSRin Nvarchar(20),
  @strSubmitterin Nvarchar(20),
  @dtmDate Datetime
)
RETURNS nvarchar(10)
AS
BEGIN
 
	 DECLARE @strCSRID nvarchar(10),
	         @strSubmitterID nvarchar(10),
	         @strCSRSupID nvarchar(10),
	         @strCSRMgrID nvarchar(10),
	         @DirectHierarchy nvarchar(10)
	
	SET @strCSRID = [EC].[fn_nvcGetEmpIdFromLanId] (@strCSRin, @dtmDate)
	SET @strSubmitterID = [EC].[fn_nvcGetEmpIdFromLanId] (@strSubmitterin, @dtmDate)
	SET @strCSRSupID = (Select Sup_ID from EC.Employee_Hierarchy Where Emp_ID = @strCSRID)
	SET @strCSRMgrID = (Select Mgr_ID from EC.Employee_Hierarchy Where Emp_ID = @strCSRID)
	

 SET @DirectHierarchy =
 CASE WHEN @strSubmitterID = @strCSRSupID THEN 'Yes'
      WHEN @strSubmitterID = @strCSRMgrID THEN 'Yes'
      Else 'No' END
      

   
RETURN @DirectHierarchy

END --fn_strDirectUserHierarchy

GO


/*
fn_strDirectUserHierarchy(02).sql
Last Modified Date: 04/10/2018
Last Modified By: Susmitha Palacherla

Version 02: Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018

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
--  *  Given a CSR ID, a Submitter ID, checks to see if the submitter 
-- is the Supervisor or Manager of the given employee.
-- If it does the function returns a a 'Yes' to Indicate Direct Hierrachy.
-- Modified during Submissions move to new architecture - TFS 7136 - 04/10/2018
--	=============================================
CREATE FUNCTION [EC].[fn_strDirectUserHierarchy] 
(
  @strEmpIDin nvarchar(10),
  @strSubmitterIDin nvarchar(20)

)
RETURNS nvarchar(10)
AS
BEGIN
 
	 DECLARE @strEmpSupID nvarchar(10),
	         @strEmpMgrID nvarchar(10),
	         @DirectHierarchy nvarchar(10)
	

	SET @strEmpSupID = (Select Sup_ID from EC.Employee_Hierarchy Where Emp_ID = @strEmpIDin)
	SET @strEmpMgrID = (Select Mgr_ID from EC.Employee_Hierarchy Where Emp_ID = @strEmpIDin)
	

 SET @DirectHierarchy =
 CASE WHEN @strSubmitterIDin = @strEmpSupID THEN 'Yes'
      WHEN @strSubmitterIDin = @strEmpMgrID THEN 'Yes'
      Else 'No' END
      

   
RETURN @DirectHierarchy

END --fn_strDirectUserHierarchy



GO




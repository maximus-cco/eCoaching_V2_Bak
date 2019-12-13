/*
fn_strGetUserRole(05).sql
Last Modified Date: 12/12/2019
Last Modified By: Susmitha Palacherla

Revision 05: Added WPOP12 to Analyst Role - TFS 16261 - 12/12/2019
Revision 04: Added WPOP12 to ARC Role - TFS 15859 - 10/28/2019
Revision 03: Added logic for Manager role for WPPM job codes - TFS 12467 - 10/29/2018
Revision 02: Added logic for Analyst Role . TFS 12316 - 10/11/2018
Initial Revision:  Created during Mydashboard move to new architecture - TFS 7137 - 05/16/2018 

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strGetUserRole' 
)
   DROP FUNCTION [EC].[fn_strGetUserRole]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Susmitha Palacherla
-- Create date:  5/16/2018
-- Description:	Given an Employee ID returns the Role 
-- Last Modified By:
-- Revision History:
-- Initial Revision. Created during Mydashboard move to new architecture - TFS 7137 - 05/16/2018 
-- Added logic for Analyst Role . TFS 12316 - 10/11/2018
-- Added logic for Manager role for WPPM job codes - TFS 12467 - 10/29/2018
-- Added WPOP12 to ARC Role. TFS 15859 - 10/28/2019
-- Moved WPOP12 to Analyst Role. TFS 16261 - 12/11/2019 
-- =============================================

CREATE FUNCTION [EC].[fn_strGetUserRole] 
(
	@strEmpID nvarchar(10) 
)
RETURNS nvarchar(10)
AS
BEGIN
	DECLARE 
	@strEmpJobCode nvarchar(20),
	@strUserRole nvarchar(20)
	
SET @strEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @strEmpID);

 SET @strUserRole = 
 (SELECT CASE 
 WHEN (@strEmpJobCode LIKE 'WACS0%' AND [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'ARC') = 0) THEN 'CSR'
 WHEN (@strEmpJobCode LIKE 'WACS0%' AND [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'ARC') = 1) THEN 'ARC'
 WHEN (@strEmpJobCode LIKE 'WACQ0%' OR @strEmpJobCode LIKE 'WACQ12' OR @strEmpJobCode LIKE 'WIHD0%'
 OR  @strEmpJobCode LIKE 'WTTR1%' OR  @strEmpJobCode LIKE 'WTID%'  ) THEN 'Employee'
 WHEN @strEmpJobCode LIKE 'WH%' THEN 'HR'
 WHEN (@strEmpJobCode LIKE '%40' OR @strEmpJobCode LIKE 'WTTI%' OR @strEmpJobCode LIKE 'WACQ13') THEN 'Supervisor'
 WHEN ((@strEmpJobCode LIKE 'WPPM%' OR @strEmpJobCode LIKE 'WEEX%' OR @strEmpJobCode LIKE 'WISO%'
 OR @strEmpJobCode LIKE 'WISY%' OR  @strEmpJobCode = 'WPWL51' OR @strEmpJobCode LIKE 'WSTE%'
 OR @strEmpJobCode LIKE '%50' OR @strEmpJobCode LIKE '%60'  OR @strEmpJobCode LIKE '%70') 
 AND NOT([EC].[fn_strCheckIf_ACLRole](@strEmpID, 'SRM') = 1 OR [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIR') = 1)) 
 THEN 'Manager'
 WHEN  [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'SRM') = 1 THEN 'SrManager'
 WHEN  [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIR') = 1 THEN 'Director'
 WHEN  @strEmpJobCode LIKE 'WPOP12' THEN 'Analyst'
 ELSE 'Restricted' END);

 RETURN   @strUserRole
  
END --fn_strGetUserRole

GO



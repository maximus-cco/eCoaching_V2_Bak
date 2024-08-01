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
-- Added logic for Manager role for WPSM job codes - TFS 16389 - 01/13/2020
-- Removed references to SrMgr. TFS 18062 - 08/18/2020
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
-- Modified to Support Production Planning Module. TFS 28361 - 07/23/2024
-- =============================================

CREATE OR ALTER FUNCTION [EC].[fn_strGetUserRole] 
(
	@strEmpID nvarchar(10) 
)
RETURNS nvarchar(10)
AS
BEGIN
	DECLARE 
	@strEmpJobCode nvarchar(20),
	@strUserRole nvarchar(20);
	
SET @strEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy WHERE Emp_ID = @strEmpID);

 SET @strUserRole = 
 (SELECT CASE 
 WHEN (@strEmpJobCode LIKE 'WACS0%' AND @strEmpJobCode <> 'WACS05' AND [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'ARC') = 0) THEN 'CSR'
 WHEN (@strEmpJobCode = 'WACS05' AND [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'ARC') = 0) THEN 'ISG'
 WHEN (@strEmpJobCode LIKE 'WACS0%' AND [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'ARC') = 1) THEN 'ARC'
 WHEN (@strEmpJobCode LIKE 'WACQ0%' OR @strEmpJobCode LIKE 'WACQ12' OR @strEmpJobCode LIKE 'WIHD0%'
 OR  @strEmpJobCode LIKE 'WTTR1%' OR  @strEmpJobCode LIKE 'WTID%' OR @strEmpJobCode LIKE 'WMPL0%') THEN 'Employee'
 WHEN @strEmpJobCode LIKE 'WH%' THEN 'HR'
 WHEN (@strEmpJobCode LIKE '%40' OR @strEmpJobCode LIKE 'WTTI%' OR @strEmpJobCode LIKE 'WACQ13') THEN 'Supervisor'
 WHEN ((@strEmpJobCode LIKE 'WPPM%' OR @strEmpJobCode LIKE 'WPSM%' OR @strEmpJobCode LIKE 'WEEX%' OR @strEmpJobCode LIKE 'WISO%'
 OR @strEmpJobCode LIKE 'WISY%' OR  @strEmpJobCode = 'WPWL51' OR @strEmpJobCode LIKE 'WSTE%'
 OR @strEmpJobCode LIKE '%50' OR @strEmpJobCode LIKE '%60'  OR @strEmpJobCode LIKE '%70') 
 AND NOT([EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIR') = 1 OR [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIRPM') = 1  OR [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIRPMA') = 1)) 
 THEN 'Manager'
 WHEN  ([EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIR') = 1 OR [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIRPM') = 1  OR [EC].[fn_strCheckIf_ACLRole](@strEmpID, 'DIRPMA') = 1) THEN 'Director'
 WHEN  @strEmpJobCode LIKE 'WPOP12' THEN 'Analyst'
 ELSE 'Restricted' END);

 RETURN   @strUserRole
  
END --fn_strGetUserRole
GO


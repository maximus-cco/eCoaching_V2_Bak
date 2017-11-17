/*
fn_intModuleIDFromEmpID(02).sql
Last Modified Date: 11/17/2017
Last Modified By: Susmitha Palacherla

Version 02; Added Additional Modules and Job codes - TFS 8793 - 11/16/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intModuleIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_intModuleIDFromEmpID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Susmitha Palacherla
-- Create date:  12/12/2016
-- Description:	Given an Employee ID returns the Module ID for that user if user belongs to one of the existing Modules.
-- Last Modified By:
-- Revision History:
--  Initial Revision - Created during setup of ad-hoc generic load - TFS 4916 - 12/12/2016
--  Added Additional Modules and Job codes - TFS 8793 - 11/16/2017
-- =============================================
CREATE FUNCTION [EC].[fn_intModuleIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS int
AS
BEGIN
	DECLARE 
	@strEmpJobCode nvarchar(20),
	@intModuleID int
	
SET @strEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @strEmpID)

SET @intModuleID = (CASE
 WHEN (@strEmpJobCode IN ('WACS01', 'WACS02', 'WACS03')) THEN 1
 WHEN (@strEmpJobCode IN ('WACS40')) THEN 2
 WHEN (@strEmpJobCode IN ('WACQ02','WACQ03','WACQ12')) THEN 3
 WHEN (@strEmpJobCode IN ('WIHD01','WIHD02','WIHD03','WIHD04', 'WABA11', 'WISA03')) THEN 4
 WHEN (@strEmpJobCode IN ('WTTR02','WTTI02','WTTR12','WTTR13','WTID13')) THEN 5
 WHEN (@strEmpJobCode IN ('WABA01','WABA02','WABA03')) THEN 6
 WHEN (@strEmpJobCode IN ('WPSM11')) THEN 7
 WHEN (@strEmpJobCode IN ('WMPL02','WMPL03')) THEN 8
 WHEN (@strEmpJobCode IN ('WPPM11')) THEN 9
 ELSE -1
 END)

 
  RETURN  @intModuleID
  
END --fn_intModuleIDFromempID

GO



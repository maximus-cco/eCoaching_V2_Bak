/*
fn_intModuleIDFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
-- Description:	Given an Employee ID returns the Module ID for that user if iser belongs to one of the 5 Modules.
-- Last Modified By:
-- Revision History:
--  Created per TFS 4916- setup of ad-hoc generic load - 12/12/2016
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
 WHEN (@strEmpJobCode IN ('WIHD01','WIHD02','WIHD03','WIHD04')) THEN 4
 WHEN (@strEmpJobCode IN ('WTID13','WTTI02','WTTR12','WTTR13')) THEN 5
 ELSE -1
 END)

 
  RETURN  @intModuleID
  
END --fn_intModuleIDFromempID



GO


/*
fn_strCheckIf_ExcelExport(02).sql
Last Modified Date: 06/24/2019
Last Modified By: Susmitha Palacherla

Version 02: Modified to open up Export to Excel for non-WACS %40 job codes and Dept W282318. TFS 14726 - 06/21/2019
version 01: Initial Revision. Created during Mydashboard move to new architecture - TFS 7137 - 05/16/2018 

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strCheckIf_ExcelExport' 
)
   DROP FUNCTION [EC].[fn_strCheckIf_ExcelExport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date:  5/16/2018
-- Description:	Given an Employee ID and Role returns if User can Export to Excel
-- Last Modified By:
-- Revision History:
-- Initial Revision. Created during Mydashboard move to new architecture - TFS 7137 - 05/16/2018 
-- Modified to open up Export to Excel for non-WACS %40 job codes and Dept W282318. TFS 14726 - 06/21/2019
-- =============================================

CREATE FUNCTION [EC].[fn_strCheckIf_ExcelExport] 
(
	@nvcEmpID nvarchar(10), @Role nvarchar(40) 
)
RETURNS bit
AS
BEGIN
	DECLARE 
	@strEmpJobCode nvarchar(20),
	@strEmpDeptCode nvarchar(30),
	@bitIsHistoricalYes bit,
	@bitExcelExport bit

SET @strEmpJobCode = (SELECT Emp_Job_Code From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)	

SET @strEmpDeptCode= (SELECT Dept_ID From EC.Employee_Hierarchy
WHERE Emp_ID = @nvcEmpID)
	
SET @bitIsHistoricalYes = (SELECT HistoricalDashboard From [EC].[UI_Role_Page_Access]
WHERE RoleName = @Role )

IF @bitIsHistoricalYes = 1 AND  @strEmpJobCode <> 'WACS40' 

 IF @strEmpJobCode NOT LIKE '%40' 
   SET @bitExcelExport = 1
 ELSE 
   IF @strEmpJobCode LIKE '%40' AND  @strEmpDeptCode = 'W282318'
		SET @bitExcelExport = 1
   ELSE
		SET @bitExcelExport = 0
ELSE 
  SET @bitExcelExport = 0

RETURN   @bitExcelExport
  
END --fn_strCheckIf_ExcelExport
GO


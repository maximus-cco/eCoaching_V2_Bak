/*
fn_strSrMgrLvl2EmpIDFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSrMgrLvl2EmpIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strSrMgrLvl2EmpIDFromEmpID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 03/05/2015
-- Description:	Given an Employee ID returns the Sr Mananger level 2 Employee ID.
-- Last Modified by: Susmitha Palacherla
-- Last update: 02/18/2016
-- Simplified lookup while working TFS 1710 to set up Email reminders
-- =============================================
CREATE FUNCTION [EC].[fn_strSrMgrLvl2EmpIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE 

		 @strSrMgrLvl2EmpID nvarchar(10)

  SET @strSrMgrLvl2EmpID = (SELECT M.Mgr_ID
  FROM [EC].[Employee_Hierarchy]E JOIN [EC].[Employee_Hierarchy]M
  ON E.Mgr_ID = M.Emp_ID
  WHERE E.[Emp_ID] = @strEmpID)
  
  IF    (@strSrMgrLvl2EmpID IS NULL OR @strSrMgrLvl2EmpID = 'Unknown')
  SET    @strSrMgrLvl2EmpID = N'999999'
  
  RETURN  @strSrMgrLvl2EmpID
  
END --fn_strSrMgrLvl2EmpIDFromEmpID



GO


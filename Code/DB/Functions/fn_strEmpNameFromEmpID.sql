/*
fn_strEmpNameFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpNameFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strEmpNameFromEmpID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 01/05/2015
-- Description:	Given an Employee ID, fetches the User Name from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version : SCR 14031 for loading ETS Compliance Reports
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpNameFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpName nvarchar(40)


  
  SELECT @strEmpName = Emp_Name
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpName IS NULL 
  SET  @strEmpName = N'UnKnown'
  
  RETURN  @strEmpName 
END

GO


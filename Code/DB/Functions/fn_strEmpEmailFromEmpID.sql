SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 05/13/2015
-- Description:	Given an Employee ID, fetches the Email address from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version : Support LCSAT feed - SCR 14818 - 05/13/2015
-- Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
-- Updated to Revise stored procedures causing deadlocks. TFS 21713 - 6/17/2021
-- Modified to increase email param size to 250 chars. TFS 25490 - 10/19/2022
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_strEmpEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(250)
AS
BEGIN
	DECLARE 
	  @strEmpEmail nvarchar(250);

	    
  SELECT @strEmpEmail = CONVERT(nvarchar(250),DecryptByKey(Emp_Email)) 
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId;
  
  IF  @strEmpEmail IS NULL 
  SET @strEmpEmail = N'UnKnown';
  
  RETURN  @strEmpEmail 
END -- fn_strEmpEmailFromEmpID

GO



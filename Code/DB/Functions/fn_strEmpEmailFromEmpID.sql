/*
fn_strEmpEmailFromEmpID(03).sql
Last Modified Date: 6/21/2021
Last Modified By: Susmitha Palacherla

Version 03: Updated to Revise stored procedures causing deadlocks. TFS 21713 - 6/17/2021
Version 02: Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpEmailFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strEmpEmailFromEmpID]
GO



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
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE 
	  @strEmpEmail nvarchar(50);

	    
  SELECT @strEmpEmail = CONVERT(nvarchar(50),DecryptByKey(Emp_Email)) 
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId;
  
  IF  @strEmpEmail IS NULL 
  SET @strEmpEmail = N'UnKnown';
  
  RETURN  @strEmpEmail 
END -- fn_strEmpEmailFromEmpID

GO


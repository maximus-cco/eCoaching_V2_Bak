/*
fn_strEmpEmailFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
-- Initial version : SCR 14818 for loading LCSAT feed.
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpEmail nvarchar(50)


  
  SELECT @strEmpEmail = Emp_Email
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpEmail IS NULL 
  SET @strEmpEmail = N'UnKnown'
  
  RETURN  @strEmpEmail 
END -- fn_strEmpEmailFromEmpID


GO


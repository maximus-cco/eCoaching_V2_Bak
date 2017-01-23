/*
fn_strEmpLanIDFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpLanIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strEmpLanIDFromEmpID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 05/13/2015
-- Description:	Given an Employee ID, fetches the Lan ID from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version : SCR 14818 for loading LCSAT feed.
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpLanIDFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpLanID nvarchar(30)


  
  SELECT @strEmpLanID = Emp_LanID
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpLanID IS NULL 
  SET @strEmpLanID = N'UnKnown'
  
  RETURN  @strEmpLanID 
END -- fn_strEmpLanIDFromEmpID



GO


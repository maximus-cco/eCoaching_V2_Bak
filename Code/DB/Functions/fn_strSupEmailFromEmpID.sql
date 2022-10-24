
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 3/8/2016
-- Description:	Given an Employee ID, fetches the Email address of the Employee's Supervisor from the  Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version -  Review Supervisor Emails for LCS Reminders - TFS 2182 - 3/8/2016
-- Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
-- Fixed to pull correct Employee Email attribute for the Sups ID. TFS 7856 - 03/08/2018
-- Modified to increase email param size to 250 chars. TFS 25490 - 10/19/2022
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_strSupEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(250)
AS
BEGIN
	DECLARE 
	  @strSupEmpID nvarchar(10)
	  ,@strSupEmail nvarchar(250)

  SET @strSupEmpID = (SELECT Sup_ID
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID)
  
  IF     (@strSupEmpID IS NULL OR @strSupEmpID = 'Unknown')
  SET    @strSupEmpID = N'999999'
  
 SET @strSupEmail = (SELECT CONVERT(nvarchar(250),DecryptByKey(Emp_Email)) 
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strSupEmpID)
  
  IF  @strSupEmail IS NULL 
  SET @strSupEmail = N'UnKnown'
  
  RETURN  @strSupEmail 
END -- fn_strSupEmailFromEmpID


GO



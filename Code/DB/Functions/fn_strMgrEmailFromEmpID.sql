
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 10/21/2016
-- Description:	Given an Employee ID, fetches the Email address of the Employee's Manager from the  Hierarchy table.
-- If no match is found returns 'Unknown'
-- Initial version-Support Mgr Email for Reassigned Mgrs and Mgrs - TFS 4353 - 10/21/2016
-- Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
-- Fixed to pull correct Employee Email attribute for the Mgrs ID. TFS 7856 - 03/08/2018
-- Modified to increase email param size to 250 chars. TFS 25490 - 10/19/2022
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_strMgrEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(250)
AS
BEGIN
	DECLARE 
	  @strMgrEmpID nvarchar(10)
	  ,@strMgrEmail nvarchar(250)

  SET @strMgrEmpID = (SELECT Mgr_ID
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID)
  
  IF     (@strMgrEmpID IS NULL OR @strMgrEmpID = 'Unknown')
  SET    @strMgrEmpID = N'999999'
  
 SET @strMgrEmail = (SELECT CONVERT(nvarchar(250),DecryptByKey(Emp_Email))
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strMgrEmpID)
  
  IF  @strMgrEmail IS NULL 
  SET @strMgrEmail = N'UnKnown'
  
  RETURN  @strMgrEmail 
END -- fn_strMgrEmailFromEmpID


GO



/*
fn_strMgrEmailFromEmpID(02).sql
Last Modified Date: 11/01/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encrypted attributes. TFS 7856 - 11/01/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strMgrEmailFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strMgrEmailFromEmpID]
GO



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
-- =============================================
CREATE FUNCTION [EC].[fn_strMgrEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE 
	  @strMgrEmpID nvarchar(10)
	  ,@strMgrEmail nvarchar(50)

  SET @strMgrEmpID = (SELECT Mgr_ID
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID)
  
  IF     (@strMgrEmpID IS NULL OR @strMgrEmpID = 'Unknown')
  SET    @strMgrEmpID = N'999999'
  
 SET @strMgrEmail = (SELECT CONVERT(nvarchar(50),DecryptByKey(Mgr_Email))
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strMgrEmpID)
  
  IF  @strMgrEmail IS NULL 
  SET @strMgrEmail = N'UnKnown'
  
  RETURN  @strMgrEmail 
END -- fn_strMgrEmailFromEmpID


GO



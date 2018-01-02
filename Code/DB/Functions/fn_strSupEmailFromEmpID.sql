/*
fn_strSupEmailFromEmpID(02).sql
Last Modified Date: 11/01/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSupEmailFromEmpID' 
)
   DROP FUNCTION [EC].[fn_strSupEmailFromEmpID]
GO


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
-- =============================================
CREATE FUNCTION [EC].[fn_strSupEmailFromEmpID] 
(
	@strEmpId nvarchar(20)  --Emp ID of person 
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE 
	  @strSupEmpID nvarchar(10)
	  ,@strSupEmail nvarchar(50)

  SET @strSupEmpID = (SELECT Sup_ID
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID)
  
  IF     (@strSupEmpID IS NULL OR @strSupEmpID = 'Unknown')
  SET    @strSupEmpID = N'999999'
  
 SET @strSupEmail = (SELECT CONVERT(nvarchar(50),DecryptByKey(Sup_Email)) 
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strSupEmpID)
  
  IF  @strSupEmail IS NULL 
  SET @strSupEmail = N'UnKnown'
  
  RETURN  @strSupEmail 
END -- fn_strSupEmailFromEmpID


GO



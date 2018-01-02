/*
fn_strEmpLanIDFromEmpID(02).sql
Last Modified Date: 11/01/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
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
-- Initial version : Support LCSAT feed - SCR 14818 - 05/13/2015
-- Modified to support Encrypted attributes. TFS 7856 - 11/01/2017
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


  
  SELECT @strEmpLanID = CONVERT(nvarchar(30),DecryptByKey(Emp_LanID))
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_ID = @strEmpId
  
  IF  @strEmpLanID IS NULL 
  SET @strEmpLanID = N'UnKnown'
  
  RETURN  @strEmpLanID 
END -- fn_strEmpLanIDFromEmpID


GO





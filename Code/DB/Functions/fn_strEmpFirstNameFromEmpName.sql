/*
fn_strEmpFirstNameFromEmpName(01).sql
Last Modified Date: 9/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Initial version - Fix for re-used Ids - TFS 8228 - 09/18/2017 

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpFirstNameFromEmpName' 
)
   DROP FUNCTION [EC].[fn_strEmpFirstNameFromEmpName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 9/18/2017
-- Description:	Given an Employee Full name parses out the first name.
-- If no match is found returns 'Unknown'
-- Initial version - Fix for re-used Ids - TFS 8228 - 09/18/2017 
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpFirstNameFromEmpName] 
(
	@strEmpName nvarchar(60)  --Full Name of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strFirstMidleName nvarchar(30),
	  @strEmpFirstName nvarchar(30)


  IF @strEmpName <> 'Unknown'
  SELECT  @strFirstMidleName =   ltrim(rtrim(right(@strEmpName, len(@strEmpName) - charindex(',', @strEmpName))))

  SELECT @strEmpFirstName = 
  CASE WHEN Charindex(' ',@strFirstMidleName) > 0 THEN
  LEFT(@strFirstMidleName, charindex(' ', @strFirstMidleName) - 1)ELSE @strFirstMidleName END

  
  IF  @strEmpFirstName IS NULL 
  SET @strEmpFirstName = N'UnKnown'
  
  RETURN  @strEmpFirstName
END -- fn_strEmpFirstNameFromEmpName

GO



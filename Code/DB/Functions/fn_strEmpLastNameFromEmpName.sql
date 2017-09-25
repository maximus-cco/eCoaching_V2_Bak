/*
fn_strEmpLastNameFromEmpName(01).sql
Last Modified Date: 9/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Initial version - Fix for re-used Ids - TFS 8228 - 09/18/2017 

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strEmpLastNameFromEmpName' 
)
   DROP FUNCTION [EC].[fn_strEmpLastNameFromEmpName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 9/18/2017
-- Description:	Given an Employee Full name parses out the last name.
-- If no match is found returns 'Unknown'
-- Initial version - Fix for re-used Ids - TFS 8228 - 09/18/2017 
-- =============================================
CREATE FUNCTION [EC].[fn_strEmpLastNameFromEmpName] 
(
	@strEmpName nvarchar(60)  --Full Name of person 
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strEmpLastName nvarchar(30)


  IF @strEmpName <> 'Unknown'
  SELECT  @strEmpLastName = LTRIM(RTRIM(left(@strEmpName, charindex(',', @strEmpName) - 1)))


 
  IF  @strEmpLastName IS NULL 
  SET @strEmpLastName = N'UnKnown'
  
  RETURN  @strEmpLastName
END -- fn_strEmpLastNameFromEmpName

GO






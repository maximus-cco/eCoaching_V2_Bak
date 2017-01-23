/*
fn_strUserName(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strUserName' 
)
   DROP FUNCTION [EC].[fn_strUserName]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 09/21/2012
-- Description:	Given a LAN ID, fetches the User Name from the Employee Hierarchy table.
-- If no match is found returns 'Unknown'
-- Last Modified date: 09/18/2013
-- Modified By: Susmitha Palacherla
-- Modified to use Employee_Hierarchy Table
-- =============================================
CREATE FUNCTION [EC].[fn_strUserName] 
(
	@strUserLanId nvarchar(30)  -- LAN ID of person requesting CSR scorecard
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE 
	  @strUserName nvarchar(30)

  -- Strip domain off of the @strRequesterLanId parameter.
  --SET @strUserLanId = RTRIM(SUBSTRING(@strUserLanId, CHARINDEX(N'\', @strUserLanId) + 1, 100))
  SET @strUserLanId = SUBSTRING(@strUserLanId, CHARINDEX('\', @strUserLanId) + 1, LEN(@strUserLanId))

  
  SELECT @strUserName = Emp_Name
  FROM [EC].[Employee_Hierarchy]
  WHERE Emp_LanID = @strUserLanId
  
  IF  @strUserName IS NULL 
  SET  @strUserName = N'UnKnown'
  
  RETURN  @strUserName 
END

GO


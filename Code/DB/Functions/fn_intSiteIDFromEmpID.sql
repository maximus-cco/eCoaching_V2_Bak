/*
fn_intSiteIDFromEmpID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/



IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSiteIDFromEmpID' 
)
   DROP FUNCTION [EC].[fn_intSiteIDFromEmpID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 02/23/2014
-- Description:	Given an Employee ID returns the Employee site ID.
-- Last Modified by: Susmitha Palacherla
-- Last update: 

-- =============================================
CREATE FUNCTION [EC].[fn_intSiteIDFromEmpID] 
(
	@strEmpID nvarchar(10) 
)
RETURNS INT
AS
BEGIN
	DECLARE 
	  @strSiteName nvarchar(30),
	  @intSITEID INT
	

  SELECT  @strSiteName = [Emp_Site]
  FROM [EC].[Employee_Hierarchy]
  WHERE [Emp_ID] = @strEmpID
  
   
  IF @strSiteName is NULL OR @strSiteName ='OTHER'
  SET @strSiteName= N'Unknown'

  SELECT @intSiteID = [SiteID]
  FROM [EC].[DIM_Site]
  WHERE [City] = @strSiteName

  
  
  RETURN  @intSiteID
  
END --fn_intSiteIDFromEmpID



GO


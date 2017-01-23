/*
fn_strETSDescriptionFromRptCode(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strETSDescriptionFromRptCode' 
)
   DROP FUNCTION [EC].[fn_strETSDescriptionFromRptCode]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         11/3/2014
-- Description:	        Given a 3 or 4 letter ETS Report Code returns the Text Description
-- associated with that Report. 
-- =============================================
CREATE FUNCTION [EC].[fn_strETSDescriptionFromRptCode] (
  @strRptCode NVARCHAR(10)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @strDescription NVARCHAR(MAX)
  
  IF @strRptCode IS NOT NULL
  BEGIN
  SET @strDescription = (SELECT [Description] FROM [EC].[ETS_Description]
                         WHERE [ReportCode]= @strRptCode)       
	END
    ELSE
    SET @strDescription = NULL
        
RETURN @strDescription

END  -- fn_strETSDescriptionFromRptCode


GO


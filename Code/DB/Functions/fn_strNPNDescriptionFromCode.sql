/*
fn_strNPNDescriptionFromCode(03).sql
Last Modified Date: 2/28/2017
Last Modified By: Susmitha Palacherla

Version 03: Updated with correct tfs # - TFS 5653 - 02/28/2017

Version 02: Updated from V&V feedback - TFS 5649 - 02/20/2017

Version 01: Document Initial Revision - TFS 5649 - 02/17/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strNPNDescriptionFromCode' 
)
   DROP FUNCTION [EC].[fn_strNPNDescriptionFromCode]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         02/17/2017
-- Description:	        Given an NPN Code returns the Text Description
-- associated with that code. TFS 5653 - 02/28/2017
-- =============================================
CREATE FUNCTION [EC].[fn_strNPNDescriptionFromCode] (
  @strCode NVARCHAR(10)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @strDescription NVARCHAR(MAX)
  
IF @strCode IS NOT NULL
  BEGIN
  SET @strDescription = (SELECT [NPNDescription]+ ' Verint ID: ' FROM [EC].[NPN_Description]
                         WHERE [NPNCode]= @strCode)     
                         
  IF     @strDescription  IS NULL 
  SET    @strDescription = @strCode                        
END
    ELSE
    SET @strDescription = NULL
    

        
RETURN @strDescription

END  -- fn_strNPNDescriptionFromCode


/*
fn_strStatusFromStatusID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strStatusFromStatusID' 
)
   DROP FUNCTION [EC].[fn_strStatusFromStatusID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:        06/09/2016
-- Last modified by:    
-- Last modified date:  
-- Description:	 Given a Status ID returns the Status from Status table.
--    
-- =============================================
CREATE FUNCTION [EC].[fn_strStatusFromStatusID]
 (
 @strStatusID INT
)
RETURNS nvarchar(50)
AS
BEGIN
  DECLARE  @strStatus nvarchar(50)
   
  SELECT @strStatus = [Status] FROM [EC].[DIM_Status]
  WHERE [StatusID]= @strStatusID
  
  IF  @strStatus  IS NULL
  SET @strStatus = 'Unknown'
  
  RETURN @strStatus 
  
END  -- fn_strStatusFromStatusID




GO


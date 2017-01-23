/*
fn_strStatusIDFromStatus(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strStatusIDFromStatus' 
)
   DROP FUNCTION [EC].[fn_strStatusIDFromStatus]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/06/2014
-- Last modified by:    
-- Last modified date:  
-- Description:	 Given a Status returns the Status id from Status table.
--    
-- =============================================
CREATE FUNCTION [EC].[fn_strStatusIDFromStatus]
 (
 @strStatus NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
  DECLARE  @strStatusID INT 
   
  SELECT @strStatusID = [StatusID] FROM [EC].[DIM_Status]
  WHERE [Status]= @strStatus
  
      
  RETURN @strStatusID
  
END  -- fn_strStatusIDFromStatus()



GO


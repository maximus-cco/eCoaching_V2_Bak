/*
fn_intSourceIDFromOldSource(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSourceIDFromOldSource' 
)
   DROP FUNCTION [EC].[fn_intSourceIDFromOldSource]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the Old Form Type and Source value returns the Source ID. 
-- =============================================
CREATE FUNCTION [EC].[fn_intSourceIDFromOldSource] (
  @strFormType NVARCHAR(20), @strSource NVARCHAR(60)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSourceID INT
  
  SET @intSourceID = ( SELECT [SourceID]
  FROM [EC].[Historical_Source]
  WHERE [strFormType]=@strFormType 
  AND[strSource]= @strSource)
  
 IF  @intSourceID  IS NULL SET @intSourceID =213
 
RETURN @intSourceID

END  -- fn_intSourceIDFromOldSource()


GO


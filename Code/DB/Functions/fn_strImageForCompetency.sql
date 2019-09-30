/*
fn_strImageForCompetency(01).sql
Last Modified Date: 09/30/2019
Last Modified By: Susmitha Palacherla


Version 01: Created to support QM Bingo eCoaching logs. TFS 15465 - 08/15/2019

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strImageForCompetency' 
)
   DROP FUNCTION [EC].[fn_strImageForCompetency]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         08/12/2019
-- Description:	        populates Image for a given competency and bingo Type
-- Initial Revision. QM Bingo eCoaching logs. TFS 15465 - 09/28/2019
-- =============================================
CREATE FUNCTION [EC].[fn_strImageForCompetency] (
  @Competency nvarchar(30), @BingoType nvarchar(30)
)
RETURNS NVARCHAR(100)
AS
BEGIN
  DECLARE @strCompImage NVARCHAR(100)
  
  IF @Competency in (SELECT DISTINCT [Competency] FROM [EC].[Bingo_Images])

  BEGIN
  SET @strCompImage =  (SELECT [ImageDesc] FROM [EC].[Bingo_Images]
        WHERE [Competency] =  @Competency
	     AND [BingoType] = @BingoType) 
  END

 ELSE 
 BEGIN
  SET @strCompImage =  (SELECT [ImageDesc] FROM [EC].[Bingo_Images]
        WHERE [Competency] =  'Wild Card'
	     AND [BingoType] = @BingoType) 
  END

    IF @strCompImage IS NULL
    SET @strCompImage = ''
    

        
RETURN @strCompImage

END  -- fn_strImageForCompetency

GO



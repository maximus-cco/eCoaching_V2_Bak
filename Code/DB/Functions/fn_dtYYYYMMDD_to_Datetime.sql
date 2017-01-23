/*
fn_dtYYYYMMDD_to_Datetime(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_dtYYYYMMDD_to_Datetime' 
)
   DROP FUNCTION [EC].[fn_dtYYYYMMDD_to_Datetime]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 01/22/2014
-- Description:	Given an integer representing a date in 
-- format YYYYMMDD, return the corresponding datetime value.
-- =============================================
CREATE FUNCTION [EC].[fn_dtYYYYMMDD_to_Datetime] 
(
	@intYYYYMMDD int
)
RETURNS datetime
AS
BEGIN
	DECLARE 
	  @dtYYYYMMDD datetime,
	  @strYYYYMMDD nchar(8)

  SET @strYYYYMMDD = cast(@intYYYYMMDD as nchar(8))
  SET @dtYYYYMMDD = cast(@strYYYYMMDD as datetime)

	RETURN @dtYYYYMMDD
END  -- fn_dtYYYYMMDD_to_Datetime()

GO


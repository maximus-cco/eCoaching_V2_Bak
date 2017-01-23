/*
fn_intDatetime_to_YYYYMMDD(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intDatetime_to_YYYYMMDD' 
)
   DROP FUNCTION [EC].[fn_intDatetime_to_YYYYMMDD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 02/05/2014
-- Description:	Given a datetime value, return an integer
--   in format YYYYMMDD representing the date.
-- =============================================
CREATE FUNCTION [EC].[fn_intDatetime_to_YYYYMMDD]  
(
	@dtDatetime datetime
)
RETURNS int
AS
BEGIN
	DECLARE 
	  @strYYYYMMDD nchar(8),
	  @intYYYYMMDD int
	  
	SET @strYYYYMMDD = convert(nchar(8), @dtDatetime, 112)
	SET @intYYYYMMDD = cast(@strYYYYMMDD as int) 

	RETURN @intYYYYMMDD
END

GO


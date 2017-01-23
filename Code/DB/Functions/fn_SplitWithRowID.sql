/*
fnSplit_WithRowID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017
*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fnSplit_WithRowID' 
)
   DROP FUNCTION [EC].[fnSplit_WithRowID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      08/03/2014
--    Description:     This Function takes a string of values separated by commas 
--                     and parses it returning individual values with a row number.
--    =====================================================================

CREATE FUNCTION [EC].[fnSplit_WithRowID](
    @InputList NVARCHAR(200) -- List of delimited items
  , @Delimiter NVARCHAR(1)   -- delimiter that separates items
) RETURNS @List TABLE (RowID INT Identity (1,1),Item NVARCHAR(200))

BEGIN
DECLARE @Item VARCHAR(200)
WHILE CHARINDEX(@Delimiter,@InputList,0) <> 0
 BEGIN
 SELECT
  @Item=RTRIM(LTRIM(SUBSTRING(@InputList,1,CHARINDEX(@Delimiter,@InputList,0)-1))),
  @InputList=RTRIM(LTRIM(SUBSTRING(@InputList,CHARINDEX(@Delimiter,@InputList,0)+LEN(@Delimiter),LEN(@InputList))))
 
 IF LEN(@Item) > 0
  INSERT INTO @List SELECT @Item
 END

IF LEN(@InputList) > 0
 INSERT INTO @List SELECT @InputList -- Put the last item in
RETURN
END -- fnSplit_WithRowID


GO


/*
fnGetMaxDateTime(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fnGetMaxDateTime' 
)
   DROP FUNCTION [EC].[fnGetMaxDateTime]
GO


-- =============================================
-- Author:		Susmitha Palacherla
-- Create date: 02/17/2016
-- Description: Given 2 datetime values, returns the Greater of the 2 dates.
--  Created per TFS Change request 1710
-- =============================================
CREATE FUNCTION [EC].[fnGetMaxDateTime] (
    @dtDate1        DATETIME,
    @dtDate2        DATETIME
) RETURNS DATETIME AS
BEGIN
    DECLARE @dtReturn DATETIME;

    -- If either are NULL, then return NULL as cannot be determined.
    IF (@dtDate1 IS NULL) OR (@dtDate2 IS NULL)
        SET @dtReturn = NULL;

    IF (@dtDate1 > @dtDate2)
        SET @dtReturn = @dtDate1;
    ELSE
        SET @dtReturn = @dtDate2;

    RETURN @dtReturn;
END



GO


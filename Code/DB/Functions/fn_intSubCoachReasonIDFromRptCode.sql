/*
fn_intSubCoachReasonIDFromRptCode(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSubCoachReasonIDFromRptCode' 
)
   DROP FUNCTION [EC].[fn_intSubCoachReasonIDFromRptCode]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the 3 letter  Report code returns the Sub coaching reason for the log.
-- Last Modified Date: 6/15/2016
-- last Modified By: Susmitha Palacherla
-- TFS 1732 - To add SDR - 3/02/2016
-- TFS 2282 - To add ODT - 3/22/2016
-- TFS 2470 - To add OTH - 4/11/2016
-- TFS 2268 - To add CTC - 6/15/2016
-- TFS 3179 & 3186 - To add HFC & KUD - 7/14/2016
-- TFS 3972 - To add SEA - 9/15/2016
-- =============================================
CREATE FUNCTION [EC].[fn_intSubCoachReasonIDFromRptCode] (
  @strRptCode NVARCHAR(10)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSubCoachReasonID INT
  
  IF @strRptCode IS NOT NULL
    SET @intSubCoachReasonID =
      CASE @strRptCode 
			WHEN N'CAN' THEN 20
			WHEN N'DFQ' THEN 21
			WHEN N'OPN' THEN 22
			WHEN N'ISQ' THEN 23
			WHEN N'OSC' THEN 24
			WHEN N'ACW' THEN 25
			WHEN N'AHT' THEN 26
			WHEN N'SPI' THEN 27
			WHEN N'ACO' THEN 28
			WHEN N'IAE' THEN 29
			WHEN N'IDE' THEN 30
			WHEN N'IEE' THEN 31
			WHEN N'INF' THEN 32
			WHEN N'ISG' THEN 33
			WHEN N'LCS' THEN 34
			WHEN N'NIT' THEN 35
			WHEN N'RME' THEN 36
			WHEN N'SLG' THEN 37
			WHEN N'TRN' THEN 38 
			WHEN N'TR2' THEN 109  
			WHEN N'IAT' THEN 231
			WHEN N'SDR' THEN 232
            WHEN N'ODT' THEN 233
            WHEN N'OTH' THEN 42
            WHEN N'CTC' THEN 73
            WHEN N'HFC' THEN 12
            WHEN N'KUD' THEN 42
            WHEN N'SEA' THEN 42
        ELSE -1
      END
    ELSE
    SET @intSubCoachReasonID = -1
        
RETURN @intSubCoachReasonID  

END  -- fn_intSubCoachReasonIDFromRptCode()



GO


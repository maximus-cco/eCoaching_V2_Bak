/*
fn_intSubCoachReasonIDFromETSRptCode(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSubCoachReasonIDFromETSRptCode' 
)
   DROP FUNCTION [EC].[fn_intSubCoachReasonIDFromETSRptCode]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         11/11/2014
-- Description:	  Given the 3 or 4 letter ETS Report Code returns the Sub coaching reason for the ETS log.
-- Last Modified: 01/07/2015
-- Modified per SCR 14031 to incorporate ETS Outstanding Action (Compliance) reports.
-- =============================================
CREATE FUNCTION [EC].[fn_intSubCoachReasonIDFromETSRptCode] (
  @strRptCode NVARCHAR(10)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSubCoachReasonID INT
  
  IF @strRptCode IS NOT NULL
    SET @intSubCoachReasonID =
      CASE @strRptCode 
 
			
			WHEN N'EA' THEN 97
			WHEN N'EOT' THEN 98
			WHEN N'FWH' THEN 99
			WHEN N'FWHA' THEN 100
			WHEN N'HOL' THEN 101
			WHEN N'HOLA' THEN 102
			WHEN N'ITD' THEN 103
			WHEN N'ITDA' THEN 104
			WHEN N'ITI' THEN 105
			WHEN N'ITIA' THEN 106
			WHEN N'UTL' THEN 107
			WHEN N'UTLA' THEN 108
                                                      WHEN N'OAE' THEN 120
			WHEN N'OAS' THEN 121
		
        ELSE -1
      END
    ELSE
    SET @intSubCoachReasonID = -1
        
RETURN @intSubCoachReasonID  

END  -- fn_intSubCoachReasonIDFromETSRptCode()



GO


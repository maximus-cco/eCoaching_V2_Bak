/*
fn_strValueFromWarningID(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strValueFromWarningID' 
)
   DROP FUNCTION [EC].[fn_strValueFromWarningID]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:      04/21/2015
-- Description:	        Given a WarningID returns the Values concatenated as a single string 
-- of values separated by a '|'
-- =============================================
CREATE FUNCTION [EC].[fn_strValueFromWarningID] (
  @bigintWarningID bigint
)
RETURNS NVARCHAR(1000)
AS
BEGIN
  DECLARE @strValue NVARCHAR(1000)
  
  IF @bigintWarningID IS NOT NULL
  BEGIN
  SET @strValue = (SELECT STUFF((SELECT  '| ' + CAST([Value] AS VARCHAR(1000)) [text()]
            FROM [EC].[Warning_Log_Reason]
         WHERE [WarningID] = t.[WarningID]
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') List_Output
FROM [EC].[Warning_Log_Reason] t
  where t.[WarningID]= @bigintWarningID
GROUP BY [WarningID])       
	END
    ELSE
    SET @strValue = NULL
        
RETURN @strValue

END  -- fn_strValueFromWarningID

GO


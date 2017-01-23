/*
fn_intSiteIDFromSite(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_intSiteIDFromSite' 
)
   DROP FUNCTION [EC].[fn_intSiteIDFromSite]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the Site Name returns the Site ID. 
-- =============================================
CREATE FUNCTION [EC].[fn_intSiteIDFromSite] (
  @strSite NVARCHAR(20)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSiteID INT
  
  IF @strSite IS NOT NULL
    SET @intSiteID =
      CASE @strSite
			WHEN N'Bogalusa' THEN 1
			WHEN N'Boise' THEN 2
			WHEN N'Brownsville' THEN 3
			WHEN N'Chester' THEN 4
			WHEN N'Coralville' THEN 5
			WHEN N'Corbin' THEN 6
			WHEN N'Hattiesburg' THEN 7
			WHEN N'Houston' THEN 8
			WHEN N'London' THEN 9
			WHEN N'Lawrence' THEN 10
			WHEN N'Layton' THEN 11
			WHEN N'Lynn Haven' THEN 12
			WHEN N'Pearl' THEN 13
			WHEN N'Phoenix' THEN 14
			WHEN N'Riverview' THEN 15
			WHEN N'Sandy' THEN 16
			WHEN N'Waco' THEN 17
			WHEN N'Winchester' THEN 18
			WHEN N'Arlington' THEN 19
            ELSE -1 END 
    ELSE
    SET @intSiteID = -1
        
RETURN @intSiteID  

END  -- fn_intSiteIDFromSite()

GO


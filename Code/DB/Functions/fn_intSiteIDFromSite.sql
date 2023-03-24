SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         03/05/2014
-- Description:	  Given the Site Name returns the Site ID. 
-- Modified to add ability to search by FormName. TFS 25229 - 08/29/2022
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_intSiteIDFromSite] (
  @strSite NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
  DECLARE @intSiteID INT;
  
  IF @strSite IS NOT NULL
    SET @intSiteID = (SELECT [SiteID] FROM [EC].[DIM_Site] WHERE [City] =  @strSite);
      
        
RETURN COALESCE(@intSiteID, -1);  

END  -- fn_intSiteIDFromSite()

GO

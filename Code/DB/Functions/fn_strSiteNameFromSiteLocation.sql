SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:              Susmitha Palacherla
-- Create date:         07/25/2013
-- Description:	  Given a site location returns the site name
-- Last modified by: Susmitha Palacherla   
-- Last modified date:  08/21/2014
-- Updated mapping for Arlington during Modular design development.
-- Added mapping for new Phoenix office - TFS 12063 - 09/11/2018
-- Updated to add wildcards to accommodate new maximus location values- TFS 13168 - 01/08/2019
-- Integrate Brownsville into eCL. TFS 15450 - 09/23/2019
-- Modified to Support changes to Tampa Sites. TFS 24711 - 06/03/2022
-- Modified to Support El Paso and Remote East. TFS 25693 and 26354 - 04/12/2023
-- =============================================
CREATE OR ALTER   FUNCTION [EC].[fn_strSiteNameFromSiteLocation] (
  @strSiteLocation NVARCHAR(50)
)
RETURNS NVARCHAR(20)
AS
BEGIN
  DECLARE @strSiteName NVARCHAR(20)
  
  IF @strSiteLocation IS NOT NULL
    SET @strSiteName =
    (SELECT CASE 
	        WHEN (@strSiteLocation lIKE N'%Bogalusa%')    THEN N'Bogalusa'
		    WHEN (@strSiteLocation lIKE N'%Chester%' and @strSiteLocation NOT lIKE N'%Winchester%')  THEN N'Chester'
	        WHEN (@strSiteLocation lIKE N'%Coralville%')       THEN N'Coralville'
            WHEN (@strSiteLocation lIKE N'%Corbin%')      THEN N'Corbin'
		    WHEN (@strSiteLocation lIKE N'%Hattiesburg%')    THEN N'Hattiesburg'
			WHEN (@strSiteLocation lIKE N'%Houston%')     THEN N'Houston'
			WHEN (@strSiteLocation lIKE N'%Las Cruces%')     THEN N'Las Cruces'
		    WHEN (@strSiteLocation lIKE N'%Lawrence%')     THEN N'Lawrence'
			WHEN (@strSiteLocation lIKE N'%Layton%') THEN 'Layton'
			WHEN (@strSiteLocation lIKE N'%London%')    THEN N'London'
			WHEN (@strSiteLocation lIKE N'%Lynn Haven%')     THEN N'Lynn Haven'
		    WHEN (@strSiteLocation lIKE N'%Phoenix%') THEN N'Phoenix'
		    WHEN (@strSiteLocation lIKE N'%Sandy%')      THEN N'Sandy'
            WHEN (@strSiteLocation lIKE N'%Riverview%')      THEN N'Tampa Riverview'  
		    WHEN (@strSiteLocation lIKE N'%Netpark%')      THEN N'Tampa Netpark'  
		    WHEN (@strSiteLocation lIKE N'%Waco%')       THEN N'Waco'  
			WHEN (@strSiteLocation lIKE N'%Brownsville%')       THEN N'Brownsville' 
            WHEN (@strSiteLocation lIKE N'%Winchester%')   THEN N'Winchester'
			WHEN (@strSiteLocation lIKE N'%El Paso%')   THEN N'El Paso'
			WHEN (@strSiteLocation lIKE N'%Remote East%')   THEN N'Remote East'
       ELSE 'OTHER' END)
  
     
   
  RETURN @strSiteName  
END  -- fn_strSiteNameFromSiteLocation()
GO



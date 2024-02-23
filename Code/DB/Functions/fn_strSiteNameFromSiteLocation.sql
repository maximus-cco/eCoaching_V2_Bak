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
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- =============================================
CREATE OR ALTER FUNCTION [EC].[fn_strSiteNameFromSiteLocation] (
  @strSiteLocation NVARCHAR(50), @strIsSub NVARCHAR(1)
)
RETURNS NVARCHAR(20)
AS
BEGIN
  DECLARE @strSiteName NVARCHAR(20)
  
  IF @strSiteLocation IS NOT NULL
    SET @strSiteName =
    (SELECT CASE 
	        WHEN (@strSiteLocation lIKE N'%Bogalusa%' and @strIsSub = 'N')    THEN N'Bogalusa'
		    WHEN (@strSiteLocation lIKE N'%Chester%' and @strSiteLocation NOT lIKE N'%Winchester%' and @strIsSub = 'N')  THEN N'Chester'
	        WHEN (@strSiteLocation lIKE N'%Coralville%')       THEN N'Coralville'
            WHEN (@strSiteLocation lIKE N'%Corbin%')      THEN N'Corbin'
		    WHEN (@strSiteLocation lIKE N'%Hattiesburg%')    THEN N'Hattiesburg'
			WHEN (@strSiteLocation lIKE N'%Houston%')     THEN N'Houston'
			WHEN (@strSiteLocation lIKE N'%Las Cruces%')     THEN N'Las Cruces'
		    WHEN (@strSiteLocation lIKE N'%Lawrence%')     THEN N'Lawrence'
			WHEN (@strSiteLocation lIKE N'%Layton%') THEN 'Layton'
			WHEN (@strSiteLocation lIKE N'%London%' and @strIsSub = 'N')    THEN N'London'
			WHEN (@strSiteLocation lIKE N'%Lynn Haven%')     THEN N'Lynn Haven'
		    WHEN (@strSiteLocation lIKE N'%Phoenix%') THEN N'Phoenix'
		    WHEN (@strSiteLocation lIKE N'%Sandy%')      THEN N'Sandy'
            WHEN (@strSiteLocation lIKE N'%Riverview%')      THEN N'Tampa Riverview'  
		    WHEN (@strSiteLocation lIKE N'%Netpark%' and @strIsSub = 'N')      THEN N'Tampa Netpark'  
		    WHEN (@strSiteLocation lIKE N'%Waco%')       THEN N'Waco'  
			WHEN (@strSiteLocation lIKE N'%Brownsville%')       THEN N'Brownsville' 
            WHEN (@strSiteLocation lIKE N'%Winchester%' and @strIsSub = 'N')   THEN N'Winchester'
			WHEN (@strSiteLocation lIKE N'%El Paso%')   THEN N'El Paso'
			WHEN (@strSiteLocation lIKE N'%Remote East%')   THEN N'Remote East'
			WHEN (@strSiteLocation lIKE N'%Omaha%')   THEN N'Omaha NET'
			WHEN (@strSiteLocation lIKE N'%Winchester%' and @strIsSub = 'Y')   THEN N'Winchester Pearl'
			WHEN (@strSiteLocation lIKE N'%Chester%' and @strSiteLocation NOT lIKE N'%Winchester%' and @strIsSub = 'Y')  THEN N'Chester TDB'
		    WHEN (@strSiteLocation lIKE N'%Bogalusa%' and @strIsSub = 'Y')    THEN N'Bogalusa CBHS'
			WHEN (@strSiteLocation lIKE N'%London%' and @strIsSub = 'Y')    THEN N'London Peckham'
			 WHEN (@strSiteLocation lIKE N'%Netpark%' and @strIsSub = 'Y')      THEN N'Tampa Kenific'  
       ELSE 'OTHER' END)
  
     
   
  RETURN @strSiteName  
END  -- fn_strSiteNameFromSiteLocation()
GO



/*
fn_strSiteNameFromSiteLocation(04).sql
Last Modified Date: 09/23/2019
Last Modified By: Susmitha Palacherla

Version 04:  Updated to support QM Bingo eCoaching logs. TFS 15450 - 09/23/2019
Version 03:  Updated to add wildcards to accommodate new maximus location values- TFS 13168 - 01/08/2019
Version 02: Added mapping for new Phoenix office - TFS 12063 - 09/11/2018
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017


*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'fn_strSiteNameFromSiteLocation' 
)
   DROP FUNCTION [EC].[fn_strSiteNameFromSiteLocation]
GO


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
-- =============================================
CREATE FUNCTION [EC].[fn_strSiteNameFromSiteLocation] (
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
		    WHEN (@strSiteLocation lIKE N'%Chester%' and @strSiteLocation NOT lIKE N'%Winchester%')      THEN N'Chester'
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
            WHEN (@strSiteLocation lIKE N'%Riverview%')      THEN N'Tampa'    
		    WHEN (@strSiteLocation lIKE N'%Waco%')       THEN N'Waco'  
			WHEN (@strSiteLocation lIKE N'%Brownsville%')       THEN N'Brownsville' 
            WHEN (@strSiteLocation lIKE N'%Winchester%')   THEN N'Winchester'
       ELSE 'OTHER' END)
  
     
   
  RETURN @strSiteName  
END  -- fn_strSiteNameFromSiteLocation()
GO



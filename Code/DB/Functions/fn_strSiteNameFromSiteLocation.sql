/*
fn_strSiteNameFromSiteLocation(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
      CASE @strSiteLocation 
        WHEN N'AZ-Phoenix-8900 N 22nd Avenue'       THEN N'Phoenix'
        WHEN N'FL-Lynn Haven-1002 Arthur Dr'     THEN N'Lynn Haven'
        WHEN N'FL-Riverview-3020 US Hwy 301 S'       THEN N'Riverview'
        WHEN N'IA-Coralville-2400 Oakdale Blv'        THEN N'Coralville'
        WHEN N'IA-Coralville-2450 Oakdale Blv'        THEN N'Coralville'
        WHEN N'KS-Lawrence-3833 Greenway Dr'      THEN N'Lawrence'
        WHEN N'KY-Corbin-14892 N USHighway25E'      THEN N'Corbin'
        WHEN N'KY-London-4550 Old Whitley Rd'     THEN N'London'
        WHEN N'KY-Winchester-1025 Bypass Rd'     THEN N'Winchester'
        WHEN N'LA-Bogalusa-411 IndustrialPkwy'     THEN N'Bogalusa'
        WHEN N'MS-Hattiesburg-5912 Highway 49'     THEN N'Hattiesburg'
        WHEN N'TX-Houston-5959 Corporate Dr'     THEN N'Houston'
        WHEN N'TX-Waco-1205 N Loop 340'        THEN N'Waco'
        WHEN N'UT-Layton-2195 N Univ Pk Blvd' THEN 'Layton'
        WHEN N'UT-Sandy-8475 S Sandy Parkway'       THEN N'Sandy'
        WHEN N'VA-Chester-701 Liberty Way'      THEN N'Chester'
        WHEN N'VA-Falls Church-5201 Leesburg'     THEN N'Arlington'
        ELSE 'OTHER'
      END
    ELSE
      SET @strSiteName = N'Unknown'
      
   --IF @strSiteName like '%HOME%'
   -- SET @strSiteName = 'Other'
    
  RETURN @strSiteName  
END  -- fn_strSiteNameFromSiteLocation()


GO


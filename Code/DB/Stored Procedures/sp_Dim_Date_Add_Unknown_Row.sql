/*
sp_Dim_Date_Add_Unknown_Row(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dim_Date_Add_Unknown_Row' 
)
   DROP PROCEDURE [EC].[sp_Dim_Date_Add_Unknown_Row]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		         Susmitha Palacherla
-- ALTER date:        01/22/2014
-- Modified by:         
-- Last modified date:  
-- Description:	
--   Populate a row for an unknown value in dimension table
-- AC.Dim_Date.
--   This is adapted from AJ Adams' code file named 
-- "ACSchemaTableDDL.sql", dated 03/28/2011, and archived in 
-- Version Manager at "cms\BCC Performance Mgmt\Alternate 
-- Channels Scorecard\03_Load\SQL", VM revision # 1.0. 
-- =============================================
CREATE PROCEDURE [EC].[sp_Dim_Date_Add_Unknown_Row]
AS
BEGIN

  DELETE FROM EC.DIM_Date
  WHERE DateKey = -1

  INSERT INTO EC.Dim_Date (
    [DateKey],
	  [FullDate],
	  [DateName],
	  [DayOfWeek],
	  [DayNameOfWeek],
	  [DayOfMonth],
	  [WeekOfYear],
	  [MonthName],
	  [MonthOfYear],
	  [CalendarQuarter],
	  [CalendarYear],
	  [CalendarYearMonth],
	  [CalendarYYYYQQ]
	)
  VALUES(-1, '1900-01-01 00:00:00.000', '1/1/1900',  1, 'Monday', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

END  -- sp_Dim_Date_Add_Unknown_Row

GO


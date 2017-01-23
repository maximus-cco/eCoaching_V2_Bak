/*
sp_Dim_Date_Add_Date_Range(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Dim_Date_Add_Date_Range' 
)
   DROP PROCEDURE [EC].[sp_Dim_Date_Add_Date_Range]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		          Susmitha Palacherla
-- CREATE date:         01/22/2014
-- Modified by:         
-- Last modified date:  
-- Description:	
--   Given a begin and end date, populate table 
-- AC.Dim_Date for the given date range.
--   This is adapted from code found on 01/03/2012 at the 
-- following URL:  
--   http://arcanecode.com/2009/11/18/populating-a-kimball-date-dimension/
--   The following comments are from the original post at that 
-- URL:
-- A few notes, this code does nothing to the existing table, no deletes
-- are triggered before hand. Because the DateKey is uniquely indexed,
-- it will simply produce errors if you attempt to insert duplicates.
-- You can however adjust the Begin/End dates and rerun to safely add
-- new dates to the table every year.
--
-- If the begin date is after the end date, no errors occur but nothing
-- happens as the while loop never executes.
-- =============================================
CREATE PROCEDURE [EC].[sp_Dim_Date_Add_Date_Range]
  @intBeginDate INT,
  @intEndDate INT
AS
BEGIN

  SET NOCOUNT ON -- turn off all the 1 row inserted messages

  -- Hold our dates
  DECLARE @BeginDate DATETIME
  DECLARE @EndDate DATETIME
  
  SET @BeginDate = EC.fn_dtYYYYMMDD_to_Datetime(@intBeginDate)
  SET @EndDate   = EC.fn_dtYYYYMMDD_to_Datetime(@intEndDate)

  -- Holds a flag so we can determine if the date is the last day of month
  DECLARE @LastDayOfMon CHAR(1)

  -- Number of months to add to the date to get the current Fiscal date
  DECLARE @FiscalYearMonthsOffset INT   

  -- These two counters are used in our loop.
  DECLARE @DateCounter DATETIME    --Current date in loop
  DECLARE @FiscalCounter DATETIME  --Fiscal Year Date in loop

  -- Set this to the number of months to add to the current date to get
  -- the beginning of the Fiscal year. For example, if the Fiscal year
  -- begins July 1, put a 6 there.
  -- Negative values are also allowed, thus if your 2010 Fiscal year
  -- begins in July of 2009, put a -6.
  SET @FiscalYearMonthsOffset = 6

  -- Start the counter at the begin date
  SET @DateCounter = @BeginDate

  WHILE @DateCounter <= @EndDate
  BEGIN
  -- Calculate the current Fiscal date as an offset of
  -- the current date in the loop
  SET @FiscalCounter = DATEADD(m, @FiscalYearMonthsOffset, @DateCounter)

  -- Set value for IsLastMonthDay
  IF MONTH(@DateCounter) = MONTH(DATEADD(d, 1, @DateCounter))
  SET @LastDayOfMon = 'N'
  ELSE
  SET @LastDayOfMon = 'Y'  

  -- add a record into the date dimension table for this date
  INSERT INTO EC.DIM_Date
    (
      [DateKey]
    , [FullDate]
    , [DateName]
    , [DayOfWeek]
    , [DayNameOfWeek]
    , [DayOfMonth]
    , [WeekOfYear]
    , [MonthName]
    , [MonthOfYear]
    , [CalendarQuarter]
    , [CalendarYear]
    , [CalendarYearMonth]
    , [CalendarYYYYQQ]
       )

  VALUES  (
    ( YEAR(@DateCounter) * 10000 ) + ( MONTH(@DateCounter) * 100 )
      + DAY(@DateCounter)  --DateKey
    , @DateCounter -- FullDate
    , CAST(DATEPART(mm, @DateCounter) AS NVARCHAR(2)) + '/'
      + CAST(DATEPART(dd, @DateCounter) AS NVARCHAR(2))  + '/'
      + CAST(YEAR(@DateCounter) AS NVARCHAR(4)) -- Modified DateName to match table
--  Below is [DateName] as downloaded:    
--    , CAST(YEAR(@DateCounter) AS CHAR(4)) + '/'
--      + RIGHT('00' + RTRIM(CAST(DATEPART(mm, @DateCounter) AS CHAR(2))), 2) + '/'
--      + RIGHT('00' + RTRIM(CAST(DATEPART(dd, @DateCounter) AS CHAR(2))), 2) --DateName
    , DATEPART(dw, @DateCounter) --DayOfWeek
    , DATENAME(dw, @DateCounter) --DayNameOfWeek
    , DATENAME(dd, @DateCounter) --DayOfMonth
    , DATENAME(ww, @DateCounter) --WeekOfYear
    , DATENAME(mm, @DateCounter) --MonthName
    , MONTH(@DateCounter) --MonthOfYear
    , DATENAME(qq, @DateCounter) --CalendarQuarter
    , YEAR(@DateCounter) --CalendarYear
    , CAST(YEAR(@DateCounter) AS CHAR(4)) + '-'
      + RIGHT('00' + RTRIM(CAST(DATEPART(mm, @DateCounter) AS CHAR(2))), 2) --CalendarYearMonth
    , CAST(YEAR(@DateCounter) AS CHAR(4)) + 'Q' + DATENAME(qq, @DateCounter) --CalendarYYYYQQ
    )

    -- Increment the date counter for next pass thru the loop
    SET @DateCounter = DATEADD(d, 1, @DateCounter)
  END
  
END  -- sp_Dim_Date_Add_Date_Range


GO


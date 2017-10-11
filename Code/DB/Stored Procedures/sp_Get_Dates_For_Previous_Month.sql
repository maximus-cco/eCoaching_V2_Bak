/*
sp_Get_Dates_For_Previous_Month(01).sql
Last Modified Date: 10/06/2017
Last Modified By: Susmitha Palacherla


Version 01: Document Initial Revision - TFS 6066 - 10/06/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Get_Dates_For_Previous_Month' 
)
   DROP PROCEDURE [EC].[sp_Get_Dates_For_Previous_Month]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		      Susmitha Palacherla
-- Create date:       10/5/2017
-- Description:	
-- Sets the dates for previous Month.
-- Revision History
-- Initial Revision. Created during summary report schedulling. TFS 6066 - 10/05/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_Get_Dates_For_Previous_Month]
@intBeginDate INT OUTPUT,  
@intEndDate INT OUTPUT
 
AS
BEGIN

DECLARE

@BeginDate datetime,
@EndDate datetime


--SELECT DATEADD(DD,1,EOMONTH(Getdate(),-1)) firstdayofcurrentmonth, EOMONTH(Getdate()) lastdayofcurrentmonth
--SELECT DATEADD(DD,1,EOMONTH(Getdate(),-2)) firstdayoflastmonth, EOMONTH(Getdate(), -1) lastdayoflastmonth

SET @BeginDate = (SELECT DATEADD(DD,1,EOMONTH(Getdate(),-2))) --First day of previous month
SET @EndDate = (SELECT EOMONTH(Getdate(), -1)) --Last Day of previous month


 -- Above days in YYYYMMDD format 
  SET @intBeginDate = [EC].[fn_intDatetime_to_YYYYMMDD](@BeginDate)
  SET @intEndDate= [EC].[fn_intDatetime_to_YYYYMMDD](@EndDate)

-- Uncomment below 2 lines for providing specific dates
   --SET @intBeginDate= YYYYMMDD
   --SET @intEndDate =  YYYYMMDD
   
END -- Get_Dates_For_Previous_Month


GO



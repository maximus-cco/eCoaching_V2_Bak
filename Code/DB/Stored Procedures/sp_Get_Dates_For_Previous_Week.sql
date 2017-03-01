/*
sp_Get_Dates_For_Previous_Week(01).sql
Last Modified Date: 2/28/2017
Last Modified By: Susmitha Palacherla

Version 01: Document Initial Revision - TFS 5653 - 2/28/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Get_Dates_For_Previous_Week' 
)
   DROP PROCEDURE [EC].[sp_Get_Dates_For_Previous_Week]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		      Susmitha Palacherla
-- Create date:       02/28/2017
-- Description:	
-- Sets the dates for previous week (Sunday through Saturday)
-- Last update by:   Susmitha Palacherla
-- Initial Revision - Created as part of  TFS 5653 - 02/28/2017
-- =============================================
CREATE PROCEDURE [EC].[sp_Get_Dates_For_Previous_Week]
@intBeginDate INT OUTPUT,  
@intEndDate INT OUTPUT
 
AS
BEGIN

DECLARE

@BeginDate NVARCHAR(8),
@EndDate NVARCHAR(8)


-- Previous Sunday 
SET @BeginDate = CONVERT(NVARCHAR(8), (SELECT DATEADD(wk, DATEDIFF(wk, -1, CURRENT_TIMESTAMP), -8)) , 112)
-- Sunday 13 Weeks ago
--SET @BeginDate = CONVERT(NVARCHAR(8), (SELECT DATEADD(wk, DATEDIFF(wk, -1, CURRENT_TIMESTAMP), -92)) , 112)
-- Previous Saturday
SET @EndDate   = CONVERT(VARCHAR(8), (SELECT DATEADD(wk, DATEDIFF(wk, -2, CURRENT_TIMESTAMP), -9)) , 112)

 -- Above days in YYYYMMDD format 
  SET @intEndDate = [EC].[fn_intDatetime_to_YYYYMMDD](@EndDate)
  SET @intBeginDate= [EC].[fn_intDatetime_to_YYYYMMDD](@BeginDate)

-- Uncomment below 2 lines for providing specific dates
   --SET @intBeginDate= YYYYMMDD
   --SET @intEndDate =  YYYYMMDD
   
END -- sp_Get_Dates_For_Previous_Week



GO


/*
Last Modified Date: 12/21/2020
Last Modified By: Susmitha Palacherla

Version 01: Initial Revision - Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
*/


IF EXISTS (
  SELECT 1
    FROM SYS.VIEWS
   WHERE NAME = N'View_Coaching_Log_Bingo'
     AND TYPE = 'V'
)
DROP VIEW [EC].[View_Coaching_Log_Bingo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EC].[View_Coaching_Log_Bingo]
AS  

WITH params AS(
SELECT BeginDate, EndDate FROM [EC].[View_Coaching_Log_Bingo_Upload_Dates])
	
SELECT b.[CoachingID]
      ,[EmpID]
      ,[Competency]
      ,[BingoType]
  FROM [EC].[Coaching_Log_Bingo]b INNER JOIN EC.Coaching_Log cl
  ON b.CoachingID = cl.CoachingID, params
  WHERE cl.EventDate between BeginDate and EndDate;
GO





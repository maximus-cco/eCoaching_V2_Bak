/*
Last Modified Date: 04/14/2022
Last Modified By: Susmitha Palacherla

Version 02: Modified to support upload for any given month. TFS 24519 - 04/14/2022
Version 01: Initial Revision - Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
*/


IF EXISTS (
  SELECT 1
    FROM SYS.VIEWS
   WHERE NAME = N'View_Coaching_Log_Bingo_Upload_Dates'
     AND TYPE = 'V'
)
DROP VIEW [EC].[View_Coaching_Log_Bingo_Upload_Dates]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EC].[View_Coaching_Log_Bingo_Upload_Dates]
AS  

SELECT TOP 1 BeginDate, EndDate FROM
(SELECT BeginDate,EndDate, 1 AS Sortorder FROM [EC].[Bingo_Upload_Dates]
UNION ALL
-- For First day of previous month use -2 & For Last Day of previous month use -1
SELECT DATEADD(DD,1,EOMONTH(Getdate(),-2)) AS BeginDate, EOMONTH(Getdate(), -1) AS EndDate , 2 AS Sortorder) dates 
ORDER BY Sortorder

GO





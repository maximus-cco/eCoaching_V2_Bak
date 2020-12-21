/*
Last Modified Date: 12/21/2020
Last Modified By: Susmitha Palacherla

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

SELECT BeginDate =  DATEADD(DD,1,EOMONTH(Getdate(),-2)), -- For First day of previous month use -2
       EndDate = EOMONTH(Getdate(), -1); --For Last Day of previous month use -1

GO





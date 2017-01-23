/*
sp_InactivateExpiredWarningLogs(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InactivateExpiredWarningLogs' 
)
   DROP PROCEDURE [EC].[sp_InactivateExpiredWarningLogs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    10/27/2014
-- Description:	Inactivate Expired warning logs.
-- Warning Logs are considered as expired 13 Weeks after the Warning Given Date.
-- Last Modified Date:
-- Last Updated By: 

-- =============================================
CREATE PROCEDURE [EC].[sp_InactivateExpiredWarningLogs] 
AS
BEGIN

-- Inactivate Expired Warning logs 
-- Warnings expire 91 days (13 weeks) from warningGivenDate

BEGIN
UPDATE [EC].[Warning_Log]
SET [Active] = 0
WHERE DATEDIFF(D, [WarningGivenDate],GetDate()) > 91
OPTION (MAXDOP 1)
END


END  -- [EC].[sp_InactivateExpiredWarningLogs]


GO


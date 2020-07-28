/*
sp_Inactivations_From_Feed(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Inactivations_From_Feed' 
)
   DROP PROCEDURE [EC].[sp_Inactivations_From_Feed]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date:    04/22/2015
-- Description:	Inactivate Coaching and Warning logs from feed files.
-- Initial revision per SCR 14634.
-- Last Modified: 09/04/2015
-- Last Modified By: Susmitha Palacherla
-- Modified to Inactivate Surveys for ecls being inactivated per TFS 549.
-- =============================================
CREATE PROCEDURE [EC].[sp_Inactivations_From_Feed] 
@strLogType nvarchar(20)
AS
BEGIN



 IF @strLogType = 'Coaching'
 -- Coaching logs 
 -- Set Message for Invalid Form Names

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Form Name does not Exist.'
,[ProcessDate] = GETDATE()
WHERE [FormName] NOT IN 
(SELECT DISTINCT FormName FROM [EC].[Coaching_Log] C WITH (NOLOCK))
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Invalid Status

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Invalid Status for Inactivation.'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Coaching_Log] C 
ON I.[FormName]= C.[FormName]
WHERE C.[StatusID] IN (1,2)
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inactivate Coaching logs 

BEGIN
UPDATE [EC].[Coaching_Log]
SET [StatusID] = 2
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Coaching_Log] C 
ON I.[FormName]= C.[FormName]
WHERE C.[StatusID] NOT IN (1,2)
OPTION (MAXDOP 1)
END



WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Inactivated logs

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Successful'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Coaching_Log] C 
ON I.[FormName]= C.[FormName]
WHERE C.[StatusID] = 2
AND [Message] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


 -- Inactivate Survey records

BEGIN
UPDATE [EC].[Survey_Response_Header]
SET [Status] = 'Inactive'
,[InactivationDate] = GETDATE()
,[InactivationReason] = 'eCL Inactivated'
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Survey_Response_Header]SH
ON I.[FormName]= SH.[FormName]
WHERE SH.[Status] = 'Open'
AND [InactivationReason] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 IF @strLogType = 'Warning'
 
  -- Warning logs 
 -- Set Message for Invalid Form Names

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Form Name does not Exist.'
,[ProcessDate] = GETDATE()
WHERE [FormName] NOT IN 
(SELECT DISTINCT FormName FROM [EC].[Warning_Log] C WITH (NOLOCK))
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Invalid Status

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Invalid Status for Inactivation.'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Warning_Log] W 
ON I.[FormName]= W.[FormName]
WHERE W.[StatusID] <> 1
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms


-- Inactivate Coaching logs 

BEGIN
UPDATE [EC].[Warning_Log]
SET [StatusID] = 2
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Warning_Log]W
ON I.[FormName]= W.[FormName]
WHERE W.[StatusID] <> 2
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

 -- Set Message for Inactivated logs

BEGIN
UPDATE [EC].[Inactivations_Stage]
SET [Message] = 'Successful'
,[ProcessDate] = GETDATE()
FROM [EC].[Inactivations_Stage] I JOIN [EC].[Warning_Log] W
ON I.[FormName]= W.[FormName]
WHERE W.[StatusID] = 2
AND [Message] IS NULL
OPTION (MAXDOP 1)
END


WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
END  -- [EC].[sp_Inactivations_From_Feed]






GO


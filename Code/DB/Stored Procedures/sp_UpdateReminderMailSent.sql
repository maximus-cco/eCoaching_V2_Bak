/*
sp_UpdateReminderMailSent(02).sql
Last Modified Date: 11/18/2019
Last Modified By: Susmitha Palacherla

Version 02: Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateReminderMailSent' 
)
   DROP PROCEDURE [EC].[sp_UpdateReminderMailSent]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      02/16/2016
--    Description:      This procedure updates emailsent column to "True" for records from mail script. 
--    Last Update:      02/16/2016 - Modified per tfs 1710 to capture Notification Date to support Reminder initiative.
--    Updated to support changes to warnings workflow. TFS 15803 - 11/05/2019
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateReminderMailSent]
(
      @intNumID  int,
      @intLogType  int
 
)
AS
BEGIN

IF   @intLogType = 1
 BEGIN  
  	UPDATE [EC].[Coaching_Log]
	   SET ReminderSent = 1
	      ,ReminderDate = GetDate() 
	      ,ReminderCount = ReminderCount + 1
	WHERE CoachingID = @intNumID
END;
IF   @intLogType = 2
 BEGIN  
  	UPDATE [EC].[Warning_Log]
	   SET ReminderSent = 1
	      ,ReminderDate = GetDate() 
	      ,ReminderCount = ReminderCount + 1
	WHERE WarningID = @intNumID
END;

	
END --sp_UpdateReminderMailSent
GO




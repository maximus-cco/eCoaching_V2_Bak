/*
sp_UpdateFeedMailSent(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateFeedMailSent' 
)
   DROP PROCEDURE [EC].[sp_UpdateFeedMailSent]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--    ====================================================================
--    Author:           Jourdain Augustin
--    Create Date:      08/23/13
--    Description:      This procedure updates emailsent column to "True" for records from mail script. 
--    Last Update:      02/16/2016 - Modified per tfs 1710 to capture Notification Date to support Reminder initiative.
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateFeedMailSent]
(
      @nvcNumID nvarchar(30)
 
)
AS
BEGIN
DECLARE
@sentValue nvarchar(30),
@intNumID int

SET @sentValue = 1
SET @intNumID = CAST(@nvcNumID as INT)
   
  	UPDATE [EC].[Coaching_Log]
	   SET EmailSent = @sentValue
	      ,NotificationDate = GetDate() 
	WHERE CoachingID = @intNumID
	
END --sp_UpdateFeedMailSent




GO


/*
sp_UpdateSurveyMailSent(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_UpdateSurveyMailSent' 
)
   DROP PROCEDURE [EC].[sp_UpdateSurveyMailSent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--    ====================================================================
--    Author:           Susmitha Palacherla
--    Create Date:      08/27/15
--    Description:      This procedure updates EmailSent column to "True" for records from Survey mail script. 
--    Last Update:      02/26/2016 - Modified per tfs 2502 to capture Notification Date to support Reminder initiative.
--    
--    =====================================================================
CREATE PROCEDURE [EC].[sp_UpdateSurveyMailSent]
(
      @nvcSurveyID nvarchar(30)
 
)
AS
BEGIN
DECLARE
@SentValue nvarchar(30),
@intSurveyID int

SET @SentValue = 1
SET @intSurveyID = CAST(@nvcSurveyID as INT)
   
  	UPDATE [EC].[Survey_Response_Header]
	   SET EmailSent = @SentValue
          ,NotificationDate = GetDate() 
	WHERE SurveyID = @intSurveyID
	
END --sp_UpdateSurveyMailSent




GO


/*
sp_Update_Review_Coaching_Log_Manager_Pending_Research(04).sql
Last Modified Date: 06/01/2018
Last Modified By: Susmitha Palacherla

Version 04: Renamed during My Dashboard move to new architecture - TFS 7137 - 06/01/2018

Version 03: Updated to increase size for
param @nvcstrReasonNotCoachable to 100 - TFS 6881 - 06/01/2017

Version 02: New Breaks BRN and BRL feeds - TFS 6145 - 4/13/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update5Review_Coaching_Log' 
)
   DROP PROCEDURE [EC].[sp_Update5Review_Coaching_Log]
GO

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Update_Review_Coaching_Log_Manager_Pending_Research' 
)
   DROP PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Manager_Pending_Research]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:    11/16/2012
--    Description:    This procedure allows managers to update the e-Coaching records from the review page for Outlier records. 
--    Updated per TFS 644 to add IAE and IAT reports - 09/17/2015
--    Updated per TFS 2145 to reset Email reminder attributes for OMR logs  - 3/2/2016
--    Updated per TFS 1732 to support Training sdr  feed  - 3/4/2016
--    Updated per TFS 2283 to support Training odt feed  - 3/22/2016
--    Updated per TFS 1709 Admin tool setup to reset reassign count to 0 - 5/2/2016
--    Updated per TFS 6145  to support Training brl and brn feeds  - 4/13/2017
--    Updated per TFS 6881 to increase size for param @nvcstrReasonNotCoachable to 100 - 06/01/2017
--    TFS 7856 encryption/decryption - emp name, emp lanid, email
--    TFS 7137 move my dashboard to new architecture - 06/12/2018
--    =====================================================================
CREATE PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Manager_Pending_Research]
(
  @nvcFormID BIGINT,
  @nvcFormStatus Nvarchar(30),
  @nvcstrReasonNotCoachable Nvarchar(100),
  @nvcReviewerID Nvarchar(10),
  @dtmReviewAutoDate datetime,
  @dtmReviewManualDate datetime,
  @bitisCoachingRequired bit,
  @nvcReviewerNotes Nvarchar(max),
  @nvctxtReasonNotCoachable Nvarchar(max)
)
AS

BEGIN

DECLARE @RetryCounter INT;
SET @RetryCounter = 1;

RETRY: -- Label RETRY

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;

BEGIN TRY
DECLARE 
@nvcCat Nvarchar (10);

SET @nvcCat = (SELECT RTRIM(LEFT(strReportCode, LEN(strReportCode) - 8)) FROM EC.Coaching_Log WHERE CoachingID = @nvcFormID) 

IF @nvcCat IN ('OAE','OAS', 'IAE','IAT', 'SDR','ODT','BRL','BRN')
BEGIN      
  UPDATE EC.Coaching_Log
  SET 
    StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
    Review_SupID = @nvcReviewerID,
    strReasonNotCoachable = @nvcstrReasonNotCoachable,
    isCoachingRequired = @bitisCoachingRequired,
    SupReviewedAutoDate =  @dtmReviewAutoDate,
    CoachingDate =  @dtmReviewManualDate,
    CoachingNotes = @nvcReviewerNotes,		   
    txtReasonNotCoachable = @nvctxtReasonNotCoachable,
    ReassignCount = 0 
  WHERE CoachingID = @nvcFormID
  OPTION (MAXDOP 1);
  
  UPDATE EC.Coaching_Log_Reason
  SET 
    Value = (CASE WHEN @bitisCoachingRequired = 'True' THEN 'Opportunity' ELSE 'Not Coachable' END)
  FROM EC.Coaching_Log cl 
  INNER JOIN EC.Coaching_Log_Reason clr ON cl.CoachingID = clr.CoachingID
  WHERE cl.CoachingID = @nvcFormID
    AND clr.SubCoachingReasonID IN (120, 121, 29, 231, 232, 233, 238, 239)
  OPTION (MAXDOP 1);
END

ELSE
BEGIN
  UPDATE EC.Coaching_Log
  SET
    StatusID = (SELECT StatusID FROM EC.DIM_Status WHERE status = @nvcFormStatus),
    Review_MgrID = @nvcReviewerID,
    strReasonNotCoachable = @nvcstrReasonNotCoachable,
    isCoachingRequired = @bitisCoachingRequired,
    MgrReviewAutoDate = @dtmReviewAutoDate,
    MgrReviewManualDate = @dtmReviewManualDate,
    MgrNotes = @nvcReviewerNotes,		   
    txtReasonNotCoachable = @nvctxtReasonNotCoachable, 
    ReminderSent = 0,
    ReminderDate = NULL,
    ReminderCount = 0,
    ReassignCount = 0 
  WHERE CoachingID = @nvcFormID
  OPTION (MAXDOP 1);

  UPDATE EC.Coaching_Log_Reason
    SET 
	  Value = (CASE WHEN @bitisCoachingRequired = 'True' THEN 'Opportunity' ELSE 'Not Coachable' END)
  FROM EC.Coaching_Log cl 
  INNER JOIN EC.Coaching_Log_Reason clr ON cl.CoachingID = clr.CoachingID
  INNER JOIN EC.DIM_Coaching_Reason cr ON cr.CoachingReasonID = clr.CoachingReasonID
  WHERE cl.CoachingID = @nvcFormID
    AND cr.CoachingReason IN ('OMR / Exceptions', 'Current Coaching Initiative')
  OPTION (MAXDOP 1);
END -- End IF @nvcCat IN ('OAE','OAS', 'IAE','IAT', 'SDR','ODT','BRL','BRN')
	
COMMIT TRANSACTION;
END TRY

BEGIN CATCH
  ROLLBACK TRANSACTION;
  
  DECLARE @DoRetry bit; -- Whether to Retry transaction or not
  DECLARE @ErrorMessage NVARCHAR(4000);
  DECLARE @ErrorSeverity INT;
  DECLARE @ErrorState INT;

  SELECT   
    @ErrorMessage = ERROR_MESSAGE(),  
    @ErrorSeverity = ERROR_SEVERITY(),  
    @ErrorState = ERROR_STATE();
    
  SET @doRetry = 0;
	
  IF ERROR_NUMBER() = 1205 -- Deadlock Error Number
  BEGIN
    SET @doRetry = 1;      -- Set @doRetry to 1 only for Deadlock
  END

  IF @DoRetry = 1
  BEGIN
    SET @RetryCounter = @RetryCounter + 1; -- Increment Retry Counter By one
    IF (@RetryCounter > 3)                 -- Check whether Retry Counter reached to 3
    BEGIN
      -- Raise Error Message if still deadlock occurred after three retries
	  RAISERROR(@ErrorMessage, 18, 1); 
	END
    ELSE
    BEGIN
      WAITFOR DELAY '00:00:00.05'; -- Wait for 5 ms
      GOTO RETRY;	               -- Go to Label RETRY
    END
  END
  ELSE -- @DoRetry = 0, not deadlock error
  BEGIN
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
  END -- ELSE
END CATCH;

END --sp_Update_Review_Coaching_Log_Manager_Pending_Research



GO



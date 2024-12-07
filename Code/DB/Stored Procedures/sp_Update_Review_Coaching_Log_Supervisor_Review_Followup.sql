SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--    ====================================================================
--    Author:                 Susmitha Palacherla
--    Create Date:      08/31/2021
--    Description: *    This procedure allows supervisors to update the QN ecls with review info. 
--    Initial Revision. Quality Now workflow enhancement. TFS 22187 - 08/30/2021
--    Updated to support QN Supervisor evaluation changes. TFS 26002 - 02/02/2023
--    =====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Update_Review_Coaching_Log_Supervisor_Review_Followup]
(
  @nvcFormID BIGINT,
  @bitIsFollowup bit,
  @tableIds IdsTableType READONLY,
  @nvcFollowupReviewSupID Nvarchar(10),
  @dtmFollowupReviewAutoDate datetime,
  @nvcFollowupReviewCoachingNotes Nvarchar(4000) 
)
AS

BEGIN

DECLARE  @MonitoredLogs nvarchar(200),
         @FormName nvarchar(50),
         @RetryCounter INT;
SET @RetryCounter = 1;

RETRY: -- Label RETRY


BEGIN TRANSACTION;

BEGIN TRY

SET @FormName  = (SELECT Formname from EC.Coaching_Log WHERE CoachingID = @nvcFormID)

--CREATE TABLE #mlogs (ID bigint, ReviewMonitoredLogs nvarchar(200)); -- QN Supervisor logs to tie to original Coaching log

CREATE TABLE #mlogs (ID bigint); -- QN Supervisor logs to tie to original Coaching log

INSERT INTO #mlogs (ID)
SELECT ID
FROM @tableIds;

SET @MonitoredLogs = (SELECT STRING_AGG(CONVERT(NVARCHAR(20),ID), ' | ') AS MonitoredLogs FROM #mlogs);

--PRINT @MonitoredLogs;
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

UPDATE [EC].[Coaching_Log]
SET 
  StatusID = CASE @bitIsFollowUp
             WHEN 1 THEN 12 ELSE 13 END,
  [IsFollowupRequired] = @bitIsFollowup,
  [SupFollowupReviewCoachingNotes] = @nvcFollowupReviewCoachingNotes,
  [SupFollowupReviewMonitoredLogs] = @MonitoredLogs,
  [SupFollowupReviewAutoDate] = @dtmFollowupReviewAutoDate,
  [FollowupReviewSupID] = @nvcFollowupReviewSupID
WHERE CoachingID = @nvcFormID;

IF @bitIsFollowUp = 0
BEGIN
UPDATE [EC].[Coaching_Log]
SET CoachingNotes = coachingNotes +  '<br />' + [EC].[fn_strEmpNameFromEmpID](@nvcFollowupReviewSupID) + ' (' + convert(varchar, GetDate(),22) + ')' + N' No additional coaching is needed for this log.  Please acknowledge and enter comments'
WHERE CoachingID = @nvcFormID;
END

UPDATE [EC].[Coaching_Log]
SET 
  StatusID = 1,
  CoachingNotes = ISNULL(CoachingNotes,'') + N' Log has been attached to QN log ' + @FormName  + ' and no additional Coaching required.'
  FROM [EC].[Coaching_Log] cl JOIN #mlogs a
  ON cl.CoachingID = a.ID
  WHERE (cl.SourceID = 236 AND cl.StatusID <> 1);

CLOSE SYMMETRIC KEY [CoachingKey];  
	
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

END --sp_Update_Review_Coaching_Log_Supervisor_Review_Followup

GO



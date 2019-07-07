/*
sp_ShortCalls_SupReview_Submit(01).sql
Last Modified Date:  07/05/2019
Last Modified By: Susmitha Palacherla



Version 01: Document Initial Revision. New logic for handling Short calls - TFS 14108 - 07/05/2019

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_ShortCalls_SupReview_Submit' 
)
   DROP PROCEDURE [EC].[sp_ShortCalls_SupReview_Submit]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------
-- MULTIPLE ASTERISKS (***) DESIGNATE SECTIONS OF THE STORED PROCEDURE TEMPLATE THAT SHOULD BE CUSTOMIZED
---------------------------------------------------------------------------------------------------------
-- REQUIRED PARAMETERS:
-- INPUT: @***sampleInputVariable varchar(35)***
-- OUTPUT: @returnCode int, @returnMessage varchar(100)
-- The following 2 statements need to be executed when re-creating this stored procedure:
-- drop procedure [EC].[sp_ShortCalls_SupReview_Submit]
-- go
CREATE PROCEDURE [EC].[sp_ShortCalls_SupReview_Submit] (
  @strUserLanId NVARCHAR(50),
  @intLogId BIGINT,
  @tableSCSupReview SCSupReviewTableType READONLY,

     
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
@returnCode int OUTPUT,
@returnMessage varchar(100) OUTPUT
)
as
   declare @storedProcedureName varchar(80)
   declare @transactionCount int
   set @transactionCount = @@trancount
   set @returnCode = 0
   set @returnMessage = 'ok'
   -- If already in transaction, don't start another
   if @@trancount > 0
   begin
      save transaction currentTransaction
   end
   else
   begin
      begin transaction currentTransaction
   end
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED
-------------------------------------------------------------------------------------
   set @storedProcedureName = 'sp_ShortCalls_SupReview_Submit'
-------------------------------------------------------------------------------------
-- Revision History:
--  Initial revision. New process for short calls. TFS 14108 - 06/25/2019
-------------------------------------------------------------------------------------
-- Notes: set @returnCode and @returnMessage as appropriate
--        @returnCode defaults to '0',  @returnMessage defaults to 'ok'
--        IMPORTANT: do NOT place "return" statements in this custom code section
--        IF no severe error occurs,
--           @returnCode and @returnMessage will contain the values set by you
--        IF this procedure is not nested within another procedure,
--           you can force a rollback of the transaction
--              by setting @returnCode to a negative number
-------------------------------------------------------------------------------------
-- sample: select * from table where column = @sampleInputVariable
-- sample: update table set column = @sampleInputVariable where column = someValue
-- sample: insert into table (column1, column2) values (value1, value2)
-------------------------------------------------------------------------------------
-- *** BEGIN: INSERT CUSTOM CODE HERE ***
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SET NOCOUNT ON;


DECLARE @strUserID nvarchar(10),
      	@dtmDate datetime
     	
OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert];

SET @dtmDate  = GETDATE()   
SET @strUserID = EC.fn_nvcGetEmpIdFromLanID(@strUserID,@dtmDate)
     
  UPDATE [EC].[ShortCalls_Evaluations]
  SET [Valid] = T.[Valid],
  [BehaviorId] = T.[BehaviorId],
  [Action]= T.[Action],
  [CoachingNotes]= T.[CoachingNotes],
  [LSAInformed] = T.[LSAInformed]        
   FROM [EC].[ShortCalls_Evaluations]SCL JOIN  @tableSCSupReview T ON
   SCL.[VerintCallID] = T.[VerintCallID]
   AND SCL.[CoachingID] = @intLogId;

 UPDATE [EC].[Coaching_Log]
SET 
  StatusID = 5,
  Review_SupID = @strUserID,
  SupReviewedAutoDate = @dtmDate,
  ReassignCount = 0
WHERE CoachingID = @intLogId;    
             
WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms
    --PRINT 'STEP1'
					
						
CLOSE SYMMETRIC KEY [CoachingKey]           

-- *** END: INSERT CUSTOM CODE HERE ***
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- THE FOLLOWING CODE SHOULD NOT BE MODIFIED
   if @@error <> 0
   begin
      set @returnCode = @@error
      set @returnMessage = 'Error in stored procedure ' + @storedProcedureName
      rollback transaction currentTransaction
      return -1
   end
   --  We were NOT already in a transaction so one was started
   --  Therefore safely commit this transaction
   if @transactionCount = 0
   begin
      if @returnCode >= 0
      begin
         commit transaction
      end
      else -- custom code set the return code as negative, causing rollback
      begin
         rollback transaction currentTransaction
      end
   end
   -- if return message was not changed from default, do so now
   if @returnMessage = 'ok'
   begin
      set @returnMessage = @storedProcedureName + ' completed successfully'
   end
return 0
-- THE PRECEDING CODE SHOULD NOT BE MODIFIED

GO




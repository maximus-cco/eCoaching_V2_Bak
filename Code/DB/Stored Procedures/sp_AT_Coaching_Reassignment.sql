/*
sp_AT_Coaching_Reassignment(02).sql
Last Modified Date: 10/23/2017
Last Modified By: Susmitha Palacherla

Version 02: Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_AT_Coaching_Reassignment' 
)
   DROP PROCEDURE [EC].[sp_AT_Coaching_Reassignment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






---------------------------------------------------------------------------------------------------------
-- MULTIPLE ASTERISKS (***) DESIGNATE SECTIONS OF THE STORED PROCEDURE TEMPLATE THAT SHOULD BE CUSTOMIZED
--  Initial Revision per TFS 1709 Admin tool setup - 5/12/2016
--  Modified per TFS 4353 to reset recminder attributes for reassigned logs - 10/21/2016
--  Modified to support Encryption of sensitive data - Open key - TFS 7856 - 10/23/2017
---------------------------------------------------------------------------------------------------------
-- REQUIRED PARAMETERS:
-- INPUT: @***sampleInputVariable varchar(35)***
-- OUTPUT: @returnCode int, @returnMessage varchar(100)
-- The following 2 statements need to be executed when re-creating this stored procedure:
-- drop procedure [EC].[sp_AT_Coaching_Reassignment]
-- go
CREATE PROCEDURE [EC].[sp_AT_Coaching_Reassignment] (
  @strRequesterLanId NVARCHAR(50),
  @tableIds IdsTableType READONLY,
  @strAssignedId NVARCHAR(10),
  @intReasonId INT, 
  @strReasonOther NVARCHAR(250)= NULL, 
  @strComments NVARCHAR(4000)= NULL, 
     

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
   set @storedProcedureName = 'sp_AT_Coaching_Reassignment'
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


DECLARE @strRequestrID nvarchar(10),
        @strReason NVARCHAR(250),
        @intStatusID int,
        @intLKStatusID int,
     	@dtmDate datetime

OPEN SYMMETRIC KEY [CoachingKey]  
DECRYPTION BY CERTIFICATE [CoachingCert] 	

SET @dtmDate  = GETDATE()   
SET @strRequestrID = EC.fn_nvcGetEmpIdFromLanID(@strRequesterLanId,@dtmDate)
SET @strReason = (SELECT [Reason] FROM [EC].[AT_Action_Reasons]WHERE [ReasonId]= @intReasonId)

IF @strReason = 'Other'
BEGIN
SET @strReason = 'Other - ' + @strReasonOther
END
             
  INSERT INTO [EC].[AT_Coaching_Reassign_Audit]
           ([CoachingID],[FormName],[LastKnownStatus],
           [ActionTimestamp] ,[RequesterID],[AssignedToID],[Reason],[RequesterComments])
      SELECT [CoachingID], [Formname], [StatusID], 
      Getdate(), @strRequestrID,@strAssignedId, @strReason, @strComments 
      FROM  [EC].[Coaching_Log]CL JOIN @tableIds ID ON
      CL.CoachingID = ID.ID 

          
             
WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms
    --PRINT 'END STEP1'


UPDATE [EC].[Coaching_Log]
SET [ReassignedToID] =  @strAssignedId
    ,[ReassignDate]= Getdate()
	,[ReassignCount] = ReassignCount + 1
	,[ReminderSent]= 0
    ,[ReminderDate]= NULL
    ,[ReminderCount]= 0
FROM [EC].[Coaching_Log]CL JOIN @tableIds ID 
ON CL.CoachingID = ID.ID 
								
						
WAITFOR DELAY '00:00:00:02'  -- Wait for 2 ms
    --PRINT 'END STEP2'      
    
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
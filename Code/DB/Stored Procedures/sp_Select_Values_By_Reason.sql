SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	8/01/14
--	Description: *	This procedure takes a Module and Coaching Reason 
--  and returns the Values associated with the Coaching Reason for that Module. 
--  Modified during Submissions move to new architecture - TFS 7136 - 04/30/2018
-- Modified to support ASR Logs. TFS 28298 - 07/15/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_Select_Values_By_Reason] 
@intReasonIDin INT, @intModuleIDin INT, @strSourcein nvarchar(30), @intSourceIDin int

AS
BEGIN
	DECLARE	
	@strModulein nvarchar(30),
	@strReasonin nvarchar(100),
	@nvcASRAddvalueSQL nvarchar(200),
	@NewLineChar nvarchar(2),
	@nvcSQL nvarchar(max);

SET @strModulein = (SELECT [Module] FROM [EC].[DIM_Module] WHERE [ModuleID] = @intModuleIDin);
SET @strReasonin = (SELECT [CoachingReason] FROM [EC].[DIM_Coaching_Reason] WHERE [CoachingReasonID] = @intReasonIDin);

SET @nvcASRAddvalueSQL = '';
SET @NewLineChar = CHAR(13) + CHAR(10);

-- For CSR and ISG Modules: Indirect Submissions and ASR Source - Display 'Research Required' as an Additional Value.
IF @intSourceIDin = 238 AND @intModuleIDin in (1,10) AND @intReasonIDin = 55 AND @strSourcein = 'Indirect'
SET @nvcASRAddvalueSQL = @nvcASRAddvalueSQL + 'UNION '  + @NewLineChar + ' SELECT ''Reasearch Required'' ';


SET @nvcSQL = 'Select CASE WHEN [isOpportunity] = 1 THEN ''Opportunity'' ElSE NULL END as Value from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1
UNION
Select CASE WHEN [isReinforcement] = 1 THEN ''Reinforcement'' ElSE NULL END as Value from [EC].[Coaching_Reason_Selection]
Where ' + @strModulein +' = 1 
and [CoachingReason] = '''+@strReasonin +'''
and [IsActive] = 1 
AND ' + @strSourcein +' = 1' + @NewLineChar +
@nvcASRAddvalueSQL

--Print @nvcSQL

EXEC (@nvcSQL)	
END -- sp_Select_Values_By_Reason
GO

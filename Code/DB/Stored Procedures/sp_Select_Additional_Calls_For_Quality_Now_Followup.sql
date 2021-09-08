SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	08/03/2021
--	Description: *	This procedure returns a list of QNS logs generated for the CSR
--               after the QN batch. Supervisors will need to acknowledge listening to at least two of these
--               calls to proceed with the QN workflow.
--  Initial Revision. Quality Now workflow enhancement. TFS 22187 - 08/03/2021
--	=====================================================================

CREATE OR ALTER PROCEDURE [EC].[sp_Select_Additional_Calls_For_Quality_Now_Followup] 
@nvFormID BIGINT

AS
BEGIN
SET NOCOUNT ON
;WITH olog AS
(SELECT DISTINCT [CoachingID], [EmpID], [SubmittedDate]
FROM [EC].[Coaching_Log]  WITH (NOLOCK) 
WHERE [CoachingID]  = @nvFormID)

--select * from olog;
SELECT cl.[CoachingID], cl.[FormName]
FROM  [EC].[Coaching_Log] cl  WITH (NOLOCK) INNER JOIN olog o
ON cl.[EMPID] = o.[EmpID]
WHERE cl.[SourceID] = 236
AND cl.[SubmittedDate]> o.[SubmittedDate];

    
END -- sp_Select_Additional_Calls_For_Quality_Now_Followup
GO





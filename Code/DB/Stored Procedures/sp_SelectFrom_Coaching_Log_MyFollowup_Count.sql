SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/17/2019
--	Description: *	This procedure returns the count of CSRs logs that are pending follow-up by the supervisor 
--  Initial Revision. Display MyFollowup for CSRs. TFS 15621 - 09/17/2019 
--  Modified to exclude QN Logs. TFS 22187 - 08/03/2021
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyFollowup_Count] 
@nvcUserIdin nvarchar(10)

AS
BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@nvcEmpRole nvarchar(40),
@NewLineChar nvarchar(2),
@where nvarchar(max)        

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserIdin)

SET @NewLineChar = CHAR(13) + CHAR(10)
SET @where = 'WHERE 1 = 1 AND cl.[SourceID] NOT IN (235,236)'



IF @nvcEmpRole NOT IN ('CSR','ISG', 'ARC')
RETURN 1

IF @nvcEmpRole in ('CSR','ISG', 'ARC')
BEGIN
SET @where = @where + ' AND (cl.[EmpID] = ''' + @nvcUserIdin + '''  AND cl.[StatusID] = 10)'
END


SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT [cl].[FormName]	strFormID
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID '+ @NewLineChar +
	@where + ' ' + '
   ) x 
)

SELECT count(strFormID) as LogCount FROM TempMain'



EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_SelectFrom_Coaching_Log_MyFollowup_Count


GO



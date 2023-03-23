SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	02/08/2023
--	Description: *	This procedure returns the Pending Review QNS log counts for logged in user.
--  Initial Revision. QN Supervisor evaluation changes. TFS 26002 - 02/08/2023
--  Updated to support the highlighting of the Prepare or Coach links. TFS 26382 - 03/21/2023
--	=====================================================================
CREATE OR ALTER PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_MyPending_Count_QNS] 
@nvcUserIdin nvarchar(10), @intSourceIdin int

AS
BEGIN

SET NOCOUNT ON

DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcEmpRole nvarchar(40),
@NewLineChar nvarchar(2),
@where nvarchar(max)        

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
SET @nvcEmpRole = [EC].[fn_strGetUserRole](@nvcUserIdin)

IF @nvcEmpRole NOT IN ('Supervisor' ) OR @intSourceIdin NOT IN (235,236)
RETURN 1

SET @NewLineChar = CHAR(13) + CHAR(10)
IF @intSourceIdin = 236
	BEGIN
	SET @where = 'WHERE cl.[SourceID] in (236) '
	END
ELSE
	BEGIN
	SET @where = 'WHERE cl.[SourceID] in (235) '
	END

IF @nvcEmpRole = 'Supervisor'
BEGIN
SET @where = @where + ' AND ((cl.[ReassignCount]= 0 AND eh.[Sup_ID] = ''' + @nvcUserIdin + ''' AND cl.[StatusID] = 6 )' +  @NewLineChar +
		       ' OR (cl.[ReassignedToId] = ''' + @nvcUserIdin + '''  AND [ReassignCount] <> 0 AND cl.[StatusID] = 6 ))'
END



SET @nvcSQL = 'WITH TempMain 
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT DISTINCT [cl].[FormName]	strFormID
    FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
	JOIN [EC].[Employee_Hierarchy] eh ON eh.[EMP_ID] = veh.[EMP_ID]
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	LEFT JOIN [EC].[View_Employee_Hierarchy] vehs WITH (NOLOCK) ON cl.SubmitterID = vehs.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	LEFT JOIN [EC].[Coaching_Log_Quality_Now_Summary] sid ON cl.CoachingID = sid.CoachingID '+ @NewLineChar +
	@where + ' ' + @NewLineChar +
	' ) x 
)

SELECT count(strFormID) FROM TempMain'



EXEC (@nvcSQL)	
--PRINT @nvcSQL

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey]; 	 
	    
END -- sp_SelectFrom_Coaching_Log_MyPending_Count_QNS
GO



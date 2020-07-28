IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectFrom_Coaching_Log_HistoricalSUP_Count' 
)
   DROP PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP_Count]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	05/28/2015
--	Description: *	This procedure returns the count of completed   e-Coaching  records that will be 
--  displayed for the selected criteria on the SUP historical page.
-- Create per SCR 14893 dashboard redesign performance round 2.
--  Last Modified: 4/6/2016
--  Last Modified By: Susmitha Palacherla
--  Modified to add additional HR job code WHHR70 - TFS 1423 - 12/15/2015
--  Modified to reference table for HR job codes - TFS 2332 - 4/6/2016
--  TFS 7856 encrypt/decrypt - emp name, lanid, email
--	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectFrom_Coaching_Log_HistoricalSUP_Count] 

@strUserin nvarchar(30),
@strSourcein nvarchar(100),
@strCSRSitein nvarchar(30),
@strCSRin nvarchar(30),
@strSUPin nvarchar(30),
@strMGRin nvarchar(30),
@strSubmitterin nvarchar(30),
@strSDatein datetime,
@strEDatein datetime,
@strStatusin nvarchar(30), 
@strjobcode  nvarchar(20),
@strvalue  nvarchar(30)
--@intRecordCount int OUT

AS

BEGIN

SET NOCOUNT ON;

DECLARE	
@nvcSQL nvarchar(max),
@nvcSQL1 nvarchar(max),
@nvcSQL2 nvarchar(max),
@nvcSQL3 nvarchar(max),
@nvcEmpID nvarchar(10),
@dtmDate datetime,
@strFormStatus nvarchar(30),
@strSDate nvarchar(8),
@strEDate nvarchar(8),
@nvcDisplayWarnings nvarchar(5),
@where nvarchar(max); 

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert];
   
SET @dtmDate  = GETDATE();  
SET @nvcEmpID = EC.fn_nvcGetEmpIdFromLanID(@strUserin,@dtmDate);
 
SET @nvcDisplayWarnings = (SELECT ISNULL (EC.fn_strCheckIf_HRUser(@nvcEmpID),'NO')); 
   
SET @strFormStatus = 'Inactive';
SET @strSDate = convert(varchar(8),@strSDatein,112);
SET @strEDate = convert(varchar(8),@strEDatein,112);

SET @where = ' WHERE convert(varchar(8), [cl].[SubmittedDate],112) >= ''' + @strSDate + '''' +  
			 ' AND convert(varchar(8), [cl].[SubmittedDate],112) <= ''' + @strEDate + '''' +
			 ' AND [cl].[StatusID] <> 2';
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = ''' + @strSourcein + '''';
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = ''' + @strStatusin + '''';
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [clr].[value] = ''' + @strvalue + '''';
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [cl].[EmpID] =   ''' + @strCSRin + ''''; 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = ''' + @strSUPin + ''''; 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = ''' + @strMGRin + '''' 
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [cl].[SubmitterID] = ''' + @strSubmitterin + ''''; 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar, [cl].[SiteID]) = ''' + @strCSRSitein + '''';
END;			 

SET @nvcSQL1 = 'WITH TempCoaching
AS 
(
  SELECT DISTINCT x.strFormID
  FROM 
  (
    SELECT DISTINCT [cl].[FormName]	strFormID
	FROM [EC].[Employee_Hierarchy] eh 
	JOIN [EC].[Coaching_Log] cl WITH(NOLOCK) ON cl.EmpID = eh.Emp_ID 
	JOIN [EC].[Employee_Hierarchy] sh ON cl.SubmitterID = sh.EMP_ID 
	JOIN [EC].[DIM_Status] s ON cl.StatusID = s.StatusID 
	JOIN [EC].[DIM_Source] so ON cl.SourceID = so.SourceID 
	JOIN [EC].[DIM_Site] si ON cl.SiteID = si.SiteID 
	JOIN [EC].[Coaching_Log_Reason] clr WITH (NOLOCK) ON cl.CoachingID = clr.CoachingID' + 
    @where

SET @where = ' WHERE convert(varchar(8), [wl].[SubmittedDate],112) >= ''' + @strSDate + '''' +  
			 ' AND convert(varchar(8), [wl].[SubmittedDate],112) <= ''' + @strEDate + '''' +
			 ' AND [wl].[StatusID] <> 2';
			 
IF @strSourcein <> '%'
BEGIN
	SET @where = @where + ' AND [so].[SubCoachingSource] = ''' + @strSourcein + '''';
END
IF @strStatusin <> '%'
BEGIN
	SET @where = @where + ' AND [s].[Status] = ''' + @strStatusin + '''';
END
IF @strvalue <> '%'
BEGIN
	SET @where = @where + ' AND [wlr].[value] = '''+@strvalue+'''';
END
IF @strCSRin <> '%' 
BEGIN
	SET @where = @where + ' AND [wl].[EmpID] = ''' + @strCSRin + ''''; 
END
IF @strSUPin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Sup_ID] = ''' + @strSUPin + ''''; 
END
IF @strMGRin <> '%'
BEGIN
	SET @where = @where + ' AND [eh].[Mgr_ID] = ''' + @strMGRin + '''';
END	
IF @strSubmitterin <> '%'
BEGIN
	SET @where = @where + ' AND [wl].[SubmitterID] = ''' + @strSubmitterin + ''''; 
END
IF @strCSRSitein <> '%'
BEGIN
	SET @where = @where + ' AND CONVERT(varchar,[wl].[SiteID]) = ''' + @strCSRSitein + '''';
END;	

SET @nvcSQL2 = ' 
UNION
SELECT DISTINCT [wl].[FormName]	strFormID
FROM [EC].[Employee_Hierarchy] eh 
  JOIN [EC].[Warning_Log] wl WITH(NOLOCK) ON wl.EmpID = eh.Emp_ID 
  JOIN [EC].[Employee_Hierarchy] sh ON wl.SubmitterID = sh.EMP_ID 
  JOIN [EC].[DIM_Status] s ON wl.StatusID = s.StatusID 
  JOIN [EC].[DIM_Source] so ON wl.SourceID = so.SourceID 
  JOIN [EC].[DIM_Site] si ON wl.SiteID = si.SiteID 
  JOIN [EC].[Warning_Log_Reason] wlr WITH (NOLOCK) ON wl.WarningID = wlr.WarningID' +
@where 

SET @nvcSQL3 = '
  ) x
) SELECT count(strFormID) FROM TempCoaching';
	   
IF @nvcDisplayWarnings = 'YES'
  SET @nvcSQL = @nvcSQL1 + @nvcSQL2 +  @nvcSQL3; 
ELSE
  SET @nvcSQL = @nvcSQL1 + @nvcSQL3;

print @nvcSQL;
EXEC (@nvcSQL);	

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey] 	 
    
END; -- sp_SelectFrom_Coaching_Log_HistoricalSUP_Count
GO
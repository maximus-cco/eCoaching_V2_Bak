/*
sp_SelectCoaching4QNBingo(03).sql
Last Modified Date: 8/2/2021
Last Modified By: Susmitha Palacherla

Version 03: Updated to improve performance for Bingo upload job - TFS 22443 - 8/2/2021
Version 02: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 01: Initial revision. TFS 15063 - 08/15/2019
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_SelectCoaching4QNBingo' 
)
   DROP PROCEDURE [EC].[sp_SelectCoaching4QNBingo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	====================================================================
--	Author:		       Jourdain Augustin
--	Create Date:	   8/13/2019
--	Description: 	   This procedure queries db for Bingo feed records to send out mail
--  Last Updated By: Susmitha Palacherla
--  Initial Revision. TFS 15465 - 09/23/2019
--  Add trigger and review performance for Bingo upload job - TFS 22443 - 8/2/2021
--  	=====================================================================
CREATE PROCEDURE [EC].[sp_SelectCoaching4Bingo]
AS

BEGIN

DECLARE	
  @nvcSQL nvarchar(max)


-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
 
SET @nvcSQL = '
SELECT distinct b.CoachingID numID	
    ,cl.FormName strFormID
	,s.Status strFormStatus
    ,veh.Emp_Email strCSREmail
	,veh.Emp_Name strCSRName
	,CASE when cl.moduleid = 1 THEN veh.Sup_Email ELSE '' '' END strCCEmail
	,b.BingoType strBingoType
  ,[EC].[fn_strAchievementsForCoachingId](b.[CoachingID]) AS strAchievements
FROM [EC].[View_Employee_Hierarchy] veh WITH (NOLOCK)
JOIN [EC].[Employee_Hierarchy] eh WITH (NOLOCK) ON eh.Emp_ID = veh.Emp_ID
JOIN [EC].[Coaching_Log] cl WITH (NOLOCK) ON eh.Emp_ID = cl.EMPID 
JOIN [EC].[DIM_Status] s ON s.StatusID = cl.StatusID 
JOIN [EC].[Coaching_Log_Bingo] b ON b.CoachingId = cl.CoachingId 
WHERE cl.strReportCode like ''BQ%''
AND cl.EmailSent = ''False''
AND cl.statusid = 3
AND veh.Emp_Email IS NOT NULL
'

EXEC (@nvcSQL)	
--PRINT @nvcsql	    
-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	
	    
END --sp_SelectCoaching4Bingo
GO



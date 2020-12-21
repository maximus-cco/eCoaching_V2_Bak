/*
Last Modified Date: 12/21/2020
Last Modified By: Susmitha Palacherla

Version 02: Updated to roll up competencies across programs for Employee. TFS 19526 - 12/21/2020
Version 01: Document Initial Revision - TFS 19526 - 12/8/2020
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Sharepoint_Upload_Bingo_Phoenix' 
)
   DROP PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Phoenix]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	12/8/2020
--	Description:    Extracts previous month Phoenix Bingo logs for upload to Sharepoint
--  Initial Revision. Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
-- Updated to roll up competencies across programs for Employee. TFS 19526 - 12/21/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Phoenix] 
AS

SET NOCOUNT ON;
SET XACT_ABORT,
    QUOTED_IDENTIFIER,
    ANSI_NULLS,
    ANSI_PADDING,
    ANSI_WARNINGS,
    ARITHABORT,
    CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
 
DECLARE @localTran bit
IF @@TRANCOUNT = 0
BEGIN
    SET @localTran = 1
    BEGIN TRANSACTION LocalTran
END

BEGIN TRY

	-------------------------------------------------------------------------------------
	-- *** BEGIN: INSERT CUSTOM CODE HERE ***
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED


	  DECLARE @EmployeeSite nvarchar(30) = 'Phoenix',
              @BingoType nvarchar(2) = N'QN',
	          @BeginDate datetime = (SELECT BeginDate FROM [EC].[View_Coaching_Log_Bingo_Upload_Dates]),
              @EndDate datetime = (SELECT EndDate FROM [EC].[View_Coaching_Log_Bingo_Upload_Dates]);

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

                     SELECT DISTINCT
			    CASE WHEN ehv.Emp_Job_Code like 'WACS4%' THEN 'Supervisor' ELSE 'CSR' END  AS [Title],
			    ehv.Emp_Name AS [Employee_Name],
			    ehv.Emp_ID AS [Employee_ID],
			    ehv.Emp_Site AS [Employee_Site],
			    [EC].[fn_strBingoCompetenciesFromEmpID](s.Employee_ID, @BingoType) AS [Competencies],
				FORMAT(@BeginDate, 'MM/yyyy') AS [Month_Year],
			    ehv.Emp_Email AS [Employee_Email]
			    FROM EC.View_Employee_Hierarchy ehv
				 INNER JOIN [EC].[Coaching_Log_Bingo_SharePoint_Uploads] s
				       ON (ehv.Emp_ID = s.Employee_ID AND ehv.Emp_Site = s.Employee_Site)
					WHERE s.EventDate between @BeginDate and @EndDate
				AND ehv.Emp_Site = @EmployeeSite;
	 

--Print @nvcSQL
CLOSE SYMMETRIC KEY [CoachingKey];	
-- *** END: INSERT CUSTOM CODE HERE ***
	-------------------------------------------------------------------------------------
	-- Commit transaction only if it was started locally
    IF @localTran = 1 AND XACT_STATE() = 1
        COMMIT TRAN LocalTran
END TRY
BEGIN CATCH
    IF @localTran = 1 AND XACT_STATE() <> 0
        ROLLBACK TRAN;
 
	THROW;
END CATCH
GO






USE [eCoachingDev]
GO

/****** Object:  StoredProcedure [EC].[sp_Sharepoint_Upload_Bingo_London]    Script Date: 11/5/2020 9:50:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	09/29/2020
--	Description: 
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo] 
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
      DECLARE @BeginDate datetime,
              @EndDate datetime;

SET @BeginDate = (SELECT DATEADD(DD,1,EOMONTH(Getdate(),-14))); --First day of previous month
SET @EndDate = (SELECT EOMONTH(Getdate(), -13));--Last Day of previous month

PRINT @BeginDate;
PRINT @EndDate;


	-------------------------------------------------------------------------------------
	-- *** BEGIN: INSERT CUSTOM CODE HERE ***
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

               SELECT DISTINCT
			    N'CCO BINGO SOIBean' AS [Title],
			    ehv.Emp_Name AS [Employee_Name],
			    ehv.Emp_ID AS [Employee_ID],
			    ehv.Emp_Site AS [Employee_Site],
			    [EC].[fn_strBingoCompetenciesFromCoachingID] (cb.CoachingID) AS [Competencies],
				--cl.Submitteddate,
			    dt.CalendarYearMonth AS [Month_Year],
			    ehv.Emp_Email AS [Employee_Email]
			    FROM EC.View_Employee_Hierarchy ehv INNER JOIN EC.Coaching_Log cl
				ON ehv.Emp_ID = cl.EmpID INNER JOIN EC.Coaching_Log_Bingo cb 
				ON cl.CoachingID = cb.CoachingID INNER JOIN ec.DIM_Date dt
				ON cl.SubmittedDate = dt.FullDate
				WHERE cl.SubmittedDate between @BeginDate and @EndDate;
				
			
		
			 

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



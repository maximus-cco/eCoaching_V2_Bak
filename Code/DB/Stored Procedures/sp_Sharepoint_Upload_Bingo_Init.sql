/*
Last Modified Date: 12/8/2020
Last Modified By: Susmitha Palacherla

Version 01: Document Initial Revision - TFS 19526 - 12/8/2020
*/

IF EXISTS (
  SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'EC' AND SPECIFIC_NAME = N'sp_Sharepoint_Upload_Bingo_Init' 
)
   DROP PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Init]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--	====================================================================
--	Author:			Susmitha Palacherla
--	Create Date:	12/8/2020
--	Description:    Inserts the master data set of Bingo logs for all sites to tracking table.
-- Initial Revision. Extract bingo logs from ecl and post to share point sites. TFS 19526 - 12/8/2020
--	=====================================================================
CREATE PROCEDURE [EC].[sp_Sharepoint_Upload_Bingo_Init] 
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

	  DECLARE @BeginDate datetime,
              @EndDate datetime;
SET @BeginDate = (SELECT DATEADD(DD,1,EOMONTH(Getdate(),-2))); -- For First day of previous month use -2
SET @EndDate = (SELECT EOMONTH(Getdate(), -1));-- For Last Day of previous month use -1

---- Open Symmetric key
--OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

;WITH selected AS (
                SELECT DISTINCT				
			    cl.EmpID AS [Employee_ID],
			    eh.Emp_Site AS [Employee_Site],
				FORMAT(@BeginDate, 'MM/yyyy') AS [Month_Year],
			    cl.[EventDate],
				cl.[CoachingID]
			    FROM EC.Employee_Hierarchy eh INNER JOIN EC.Coaching_Log cl
				ON eh.Emp_ID = cl.EmpID
				WHERE cl.EventDate between @BeginDate and @EndDate
				AND cl.StatusID <> 2
				AND strReportCode like 'BQN%'
				AND eh.Emp_Job_Code in ('WACS01', 'WACS02', 'WACS03', 'WACS04'))

INSERT INTO [EC].[Coaching_Log_Bingo_SharePoint_Uploads]
           ([Employee_ID]
           ,[Employee_Site]
           ,[Month_Year]
		   ,[EventDate]
		   ,[CoachingID]		   
       )
SELECT s.*
FROM Selected s LEFT OUTER JOIN [EC].[Coaching_Log_Bingo_SharePoint_Uploads]u
ON (s.[Employee_ID] = u.[Employee_ID] AND s.[Employee_Site] = u.[Employee_Site] AND s.[Month_Year] = u.[Month_Year])
WHERE (u.[Employee_ID] IS NULL AND u.[Employee_Site] IS NULL AND u.[Month_Year] IS NULL)
     
	 

--Print @nvcSQL
--CLOSE SYMMETRIC KEY [CoachingKey];	
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


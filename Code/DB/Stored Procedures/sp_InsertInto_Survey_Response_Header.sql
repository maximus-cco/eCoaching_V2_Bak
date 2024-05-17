SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        8/21/2015
-- Checks for Completed eCLs in [EC].[Coaching_Log]table and generates a 
-- Survey Header record based on a randomly selected completed ecl
-- and inserts into [EC].[Survey_Response_Header]
-- This procedure checks to make sure that a survey has not been generated for the
-- calendar month for that employee.
-- After a survey is generated for an ecl, the coaching log is updated
-- in the Coaching_log to indicate that a Survey has been generated based on this ecl.
-- Created  per TFS 549 to setup CSR survey.
-- Modified during Encryption of sensitive data. Used Emp LanID from Emp table. TFS 7856 - 10/23/2017
-- Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018
-- Modified to increase surveys for London. TFS 13334 - 02/20/2019
-- Modified during Removal of Winchester to restrict Surveys for Inactive Sites. TFS 25626 - 10/26/2022
--  Modified to Support ISG Alignment Project. TFS 28026 - 05/06/2024
-- =============================================
CREATE OR ALTER  PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION
BEGIN TRY
      DECLARE @EndOfPeriod DATETIME
      DECLARE @StartOfPeriod DATETIME
      DECLARE @i INT
      DECLARE @j INT
      DECLARE @SurveyTypeID INT
      DECLARE @SurveyTypeID_Table table (idx INT Primary Key IDENTITY(1,1), SurveyTypeID INT)
	  DECLARE @numirows INT
      DECLARE @ModuleID INT
      DECLARE @Modules_Table table (idx INT Primary Key IDENTITY(1,1), ModuleID INT)
      DECLARE @numjrows INT
	  DECLARE @StartOfPilotDate1 DATETIME
	  DECLARE @EndOfPilotDate1 DATETIME
	  DECLARE @StartOfPilotDate2 DATETIME
	  DECLARE @EndOfPilotDate2 DATETIME


  SET @EndOfPeriod  = DATEADD(day, DATEDIFF(DD, 0, GetDate()),0) 
  -- For Start of Current Month
  --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate()),0) 
  -- For testing setting to beginning of year. 
  --SET @StartOfMonth = DATEADD(year, DATEDIFF(year, 0, GetDate()),0) 
  -- For n months in the past GetDate())-n
    --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate())-4,0) 
  -- For n days in the past GetDate())-n
  SET @StartOfPeriod = DATEADD(day, DATEDIFF(DD, 0, GetDate())-7,0) -- 7 days for Production code

  -- Set Pilot dates for London increased surveys

  --SET @StartOfPilotDate1 = '2019-04-01 00:00:00.000'
  --SET @EndOfPilotDate1 = '2019-04-30 00:00:00.000'
  --SET @StartOfPilotDate2 = '2019-05-01 00:00:00.000'
  --SET @EndOfPilotDate2 = '2019-07-31 00:00:00.000'
 
 
  SET @StartOfPilotDate1 = (SELECT [StartOfPilotDate1] FROM [EC].[Survey_Pilot_Date])
  SET @EndOfPilotDate1 = (SELECT [EndOfPilotDate1] FROM [EC].[Survey_Pilot_Date])
  SET @StartOfPilotDate2 = (SELECT [StartOfPilotDate2] FROM [EC].[Survey_Pilot_Date])
  SET @EndOfPilotDate2 = (SELECT [EndOfPilotDate2] FROM [EC].[Survey_Pilot_Date])


 --PRINT @StartOfPeriod
 --PRINT @EndOfPeriod   
 
-- Populate SurveyTypeID_Table 
INSERT @SurveyTypeID_Table
SELECT DISTINCT SurveyTypeID FROM [EC].[Survey_DIM_Type] WHERE [isActive] = 1
  
  -- Enumerate the SurveyTypeID_Table
  -- For generating a Survey per Active Survey Type.
SET @i = 1
SET @numirows = (SELECT COUNT(*) FROM @SurveyTypeID_Table)
IF @numirows > 0
    WHILE (@i <= (SELECT MAX(idx) FROM @SurveyTypeID_Table))
    BEGIN
SET @SurveyTypeID = (SELECT [SurveyTypeID] FROM @SurveyTypeID_Table WHERE idx = @i)

-- Looping through and checking for Modules that need the Survey generated for the above Survey Type.

INSERT   @Modules_Table
SELECT DISTINCT X.ModuleID FROM
(
SELECT CASE WHEN [CSR]= 1 THEN 1 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [ISG] = 1 THEN 10 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Supervisor]= 1 THEN 2 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Quality]= 1 THEN 3 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [LSA]= 1 THEN 4 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID
UNION 
SELECT CASE WHEN [Training]= 1 THEN 5 ELSE NULL END AS ModuleID FROM [EC].[Survey_DIM_Type] WHERE [SurveyTypeID]= @SurveyTypeID)X
WHERE X.ModuleID IS NOT NULL

 SET @j = 1
 SET @numjrows = (SELECT COUNT(*) FROM @Modules_Table)
IF @numjrows > 0

 WHILE (@j <= (SELECT MAX(idx) FROM @Modules_Table))
 
BEGIN
  SET @ModuleID = (SELECT [ModuleID] FROM @Modules_Table WHERE idx = @j)

--PRINT @ModuleID

 -- eCLs meeting criteria for Survey generation are first selected.
 -- Records for each employee are ordered by a new randomly generated ID.
 -- First row from the randomly ordered records is selected for each Employee.
 
 BEGIN 

 -- Selected random (non-special handling) completions for each Employee into temp table
-- Check that no Survey exists for current month and year.

-- SCL: Selecetd Coaching logs
---SP: Survey pool
-- SRH: Survey Response Header

IF OBJECT_ID('tempdb..#Temp_Logs_SelectedAll') IS NOT NULL
DROP TABLE #Temp_Logs_SelectedAll;

  CREATE TABLE #Temp_Logs_SelectedAll (
   SurveyTypeID int,
   CoachingID bigint,
   Formname nvarchar(50),
   EmpID nvarchar(10),
   EmpLanID varbinary(128),
   SiteID int,
   SourceID int,
   ModuleID int,
   Createddate datetime,
   MonthOfYear int,
   CalendarYear int,
   Status nvarchar(20)
  );

  ;WITH SelectedAll AS
  (SELECT DISTINCT @SurveyTypeID SurveyTypeID, 
                   CL.CoachingID,
                   CL.Formname, 
                   CL.EmpID,
				   CL.SiteID, 
                   CL.SourceID, 
                   CL.ModuleID,
                    CL.Submitteddate, 
                   DD.MonthOfYear, 
                   DD.CalendarYear 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN EC.DIM_Date DD
  ON DATEADD(dd, DATEDIFF(dd, 0, CL.CSRReviewAutoDate),0) = DD.Fulldate JOIN 
 (SELECT x.EmpID, x.CoachingID FROM
  (SELECT  CL.EMPID EmpID, CL.CoachingID CoachingID,ROW_NUMBER() OVER( PARTITION BY CL.EMPID
   ORDER BY NewID()) AS Rn 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN [EC].[Employee_Hierarchy]EH
  ON CL.EmpID = EH.Emp_ID
  WHERE Statusid = 1 -- Completed
  AND ModuleID = @ModuleID -- Each Module 
   AND SiteID IN (SELECT SiteID FROM EC.Survey_Sites WHERE isACtive = 1)
  AND ((SiteID IN (SELECT SiteID FROM [EC].[Survey_Sites] WHERE isPilot = 1) AND SourceID NOT IN (123, 130, 135,136, 223, 224,230, 235, 236 )) -- Exclude all Verint for Pilot site(s)
  OR (SiteID NOT IN (SELECT SiteID FROM [EC].[Survey_Sites] WHERE isPilot = 1) AND SourceID <> 224)) -- Exclude Verint-TQC for Non Pilot site(s)
    AND isCSRAcknowledged = 1
  AND SurveySent = 0
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )x
 WHERE x.Rn=1)SP
 ON CL.CoachingID = SP.CoachingID
 AND CL.EmpID = SP.EmpID)

INSERT INTO  #Temp_Logs_SelectedAll 
SELECT  SCL.SurveyTypeID [SurveyTypeID],
		SCL.CoachingID  [CoachingID],
		SCL.FormName    [FormName],
        SCL.EmpID       [EmpID],
        EH.Emp_LanID    [EmpLanID],
        SCL.SiteID      [SiteID],
        SCL.SourceID    [SourceID],
        SCL.ModuleID    [ModuleID],
        GETDATE()       [CreatedDate],
        SCL.MonthOfYear,
        SCL.CalendarYear,
        'Open'         [Status]
 FROM SelectedAll SCL JOIN [EC].[Employee_Hierarchy] EH
 ON SCL.EmpID = EH.Emp_ID LEFT OUTER JOIN [EC].[Survey_Response_Header] SRH 
  ON SCL.EmpID = SRH.EmpID
  AND SCL.ModuleID = SRH.ModuleID
  AND SCL.MonthOfYear = SRH.MonthOfYear
  AND SCL.CalendarYear = SRH.CalendarYear 
  AND SCL.[SurveyTypeID]= SRH.[SurveyTypeID]
WHERE (SRH.[SurveyTypeID] IS NULL AND SRH.EmpID is NULL AND SRH.MonthOfYear IS NULL AND SRH.CalendarYear IS NULL);


 -- Selected special handling completions for each Employee into temp table
--  All Coaching logs meeting criteria for generation period  will get a Survey
-- Per 13334 all Quality evlauations for London. 
-- Quality for the month of April
-- Quality Now for may through July.

-- SCL: Selecetd Coaching logs
---SP: Survey pool
-- SRH: Survey Response Header

IF OBJECT_ID('tempdb..#Temp_Logs_SelectedPilot') IS NOT NULL
DROP TABLE #Temp_Logs_SelectedPilot;

  CREATE TABLE #Temp_Logs_SelectedPilot (
   SurveyTypeID int,
   CoachingID bigint,
   Formname nvarchar(50),
   EmpID nvarchar(10),
   EmpLanID varbinary(128),
   SiteID int,
   SourceID int,
   ModuleID int,
   Createddate datetime,
   MonthOfYear int,
   CalendarYear int,
   Status nvarchar(20)
  );

  ;WITH SelectedPilot AS
  (SELECT DISTINCT @SurveyTypeID SurveyTypeID, 
                   CL.CoachingID,
                   CL.Formname, 
                   CL.EmpID,
                   CL.SiteID, 
                   CL.SourceID, 
                   CL.ModuleID,
                   CL.Submitteddate, 
                   DD.MonthOfYear, 
                   DD.CalendarYear 
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK) JOIN EC.DIM_Date DD
  ON DATEADD(dd, DATEDIFF(dd, 0, CL.CSRReviewAutoDate),0) = DD.Fulldate JOIN 
  (SELECT  CL.EMPID EmpID, CL.CoachingID CoachingID
  FROM [EC].[Coaching_Log] CL WITH (NOLOCK)  JOIN [EC].[Employee_Hierarchy]EH
  ON CL.EmpID = EH.Emp_ID
  WHERE Statusid = 1 -- Completed
  AND ModuleID = @ModuleID -- Each Module 
   AND SiteID IN (SELECT SiteID FROM EC.Survey_Sites WHERE isACtive = 1)
  AND SiteID IN (SELECT SiteID FROM [EC].[Survey_Sites] WHERE isPilot = 1) -- Include sites with Pilot Survey here
  AND ((SourceID IN (123, 130, 223, 230) AND DATEADD(day, DATEDIFF(DD, 0, GetDate()),0)  between @StartOfPilotDate1 and @EndOfPilotDate1) -- Quality
  OR (SourceID IN (135, 136, 235, 236) AND DATEADD(day, DATEDIFF(DD, 0, GetDate()),0)   between @StartOfPilotDate2 and @EndOfPilotDate2))  -- QualityNow
  AND isCSRAcknowledged = 1
  AND SurveySent = 0
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )SP
 ON CL.CoachingID = SP.CoachingID
 AND CL.EmpID = SP.EmpID)
 
INSERT INTO #Temp_Logs_SelectedPilot
SELECT  SCL.SurveyTypeID [SurveyTypeID],
		SCL.CoachingID  [CoachingID],
		SCL.FormName    [FormName],
        SCL.EmpID       [EmpID],
        EH.Emp_LanID    [EmpLanID],
        SCL.SiteID      [SiteID],
        SCL.SourceID    [SourceID],
        SCL.ModuleID    [ModuleID],
        GETDATE()       [CreatedDate],
        SCL.MonthOfYear,
        SCL.CalendarYear,
        'Open'         [Status]
 FROM SelectedPilot SCL JOIN [EC].[Employee_Hierarchy] EH
 ON SCL.EmpID = EH.Emp_ID LEFT OUTER JOIN [EC].[Survey_Response_Header] SRH 
  ON SCL.EmpID = SRH.EmpID
  AND SCL.CoachingID = SRH.CoachingID
  AND SCL.ModuleID = SRH.ModuleID
  AND SCL.MonthOfYear = SRH.MonthOfYear
  AND SCL.CalendarYear = SRH.CalendarYear 
  AND SCL.[SurveyTypeID]= SRH.[SurveyTypeID]
WHERE (SRH.[CoachingID] IS NULL AND SRH.EmpID is NULL AND SRH.MonthOfYear IS NULL AND SRH.CalendarYear IS NULL);


-- Insert both set of possible Surveys from temp tables into Survey header table 
 
   INSERT INTO [EC].[Survey_Response_Header]
           ([SurveyTypeID]
           ,[CoachingID]
           ,[FormName]
           ,[EmpID]
           ,[EmpLanID]
           ,[SiteID]
           ,[SourceID]
           ,[ModuleID]
           ,[CreatedDate]
           ,[MonthOfYear]
           ,[CalendarYear]
           ,[Status]
         )

SELECT * FROM #Temp_Logs_SelectedAll
UNION
SELECT * FROM #Temp_Logs_SelectedPilot
END


SET @j = @j + 1
END

SET @i = @i + 1
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

BEGIN
UPDATE [EC].[Coaching_Log]
SET [SurveySent] = 1
FROM [EC].[Survey_Response_Header]SRH JOIN [EC].[Coaching_Log] CL
ON SRH.[CoachingID] = CL.[CoachingID]
AND SRH.[Formname] = CL.[Formname]
AND [SurveySent] = 0

END

                  
COMMIT TRANSACTION
END TRY

      
      BEGIN CATCH
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION


    DECLARE @ErrorMessage NVARCHAR(4000)
    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE()

    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               )
      
    IF ERROR_NUMBER() IS NULL
      RETURN 1
    ELSE IF ERROR_NUMBER() <> 0 
      RETURN ERROR_NUMBER()
    ELSE
      RETURN 1
  END CATCH  
END -- sp_InsertInto_Survey_Response_Header
GO



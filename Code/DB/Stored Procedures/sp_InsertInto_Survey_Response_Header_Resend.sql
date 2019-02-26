/*
sp_InsertInto_Survey_Response_Header_Resend(04).sql
Last Modified Date: 02/25/2018
Last Modified By: Susmitha Palacherla

Version 04: Modified to increase surveys for London. TFS 13334 - 02/20/2019

Version 03: Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018

Version 02: Modified during Encryption of sensitive data. Used Emp LanID from Emp table. TFS 7856 - 10/23/2017

Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_InsertInto_Survey_Response_Header_Resend' 
)
   DROP PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header_Resend]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		        Susmitha Palacherla
-- Create date:        8/21/2015
-- Checks for Completed eCLs in [EC].[Coaching_Log]table and generates a 
-- Survey Header record and inserts into [EC].[Survey_Response_Header]
-- This procedure is used for resending a Survey, so it will regenerate a Survey 
-- even when a Survey has previously been generated in the same month.
-- After a survey is generated for an ecl, the coaching log is updated
-- in the Coaching_log to indicate that a Survey has been generated based on this ecl.
-- Created  per TFS 549 to setup CSR survey.
-- Modified during Encryption of sensitive data. Used Emp LanID from Emp table. TFS 7856 - 10/23/2017
-- Modified to incorporate Pilot Question. TFS 9511 - 01/23/2018
-- Modified to increase surveys for London. TFS 13334 - 02/20/2019
-- =============================================
CREATE PROCEDURE [EC].[sp_InsertInto_Survey_Response_Header_Resend]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION
BEGIN TRY

      DECLARE @EndOfPeriod DATETIME
      DECLARE @StartOfPeriod DATETIME
      DECLARE @DMonth INT
      DECLARE @DYear INT
      DECLARE @i INT
      DECLARE @j INT
      DECLARE @SurveyTypeID INT
      DECLARE @SurveyTypeID_Table table (idx INT Primary Key IDENTITY(1,1), SurveyTypeID INT)
	  DECLARE @numirows INT
      DECLARE @ModuleID INT
      DECLARE @Modules_Table table (idx INT Primary Key IDENTITY(1,1), ModuleID INT)
      DECLARE @numjrows INT
    
  SET @EndOfPeriod  = DATEADD(day, DATEDIFF(DD, 0, GetDate()),0) 
  -- For Start of Current Month
  --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate()),0) 
  -- For testing setting to beginning of year. 
  --SET @StartOfMonth = DATEADD(year, DATEDIFF(year, 0, GetDate()),0) 
  -- For n months in the past GetDate())-n
    --SET @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, GetDate())-4,0) 
  -- For n days in the past GetDate())-n
  SET @StartOfPeriod = DATEADD(day, DATEDIFF(DD, 0, GetDate())-7,0) -- 7 days for Production code
 
 --PRINT @StartOfPeriod
 --PRINT @EndOfPeriod 
   SET @DMonth = datepart(month,getdate())
   SET @DYear = datepart(year,getdate())  
 
-- Populate SurveyTypeID_Table 
INSERT @SurveyTypeID_Table
SELECT DISTINCT SurveyTypeID FROM [EC].[Survey_DIM_Type]WHERE [isActive] = 1
  
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
  ;WITH Selected AS
  (
  SELECT DISTINCT @SurveyTypeID SurveyTypeID, 
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
  AND ((SiteID IN (SELECT SiteID FROM [EC].[Survey_Sites] WHERE isPilot = 1) AND SourceID NOT IN (123, 130, 135,136, 223, 224,230, 235, 236 )) -- Exclude all Quality for Pilot site(s)
  OR (SiteID NOT IN (SELECT SiteID FROM [EC].[Survey_Sites] WHERE isPilot = 1) AND SourceID <> 224)) -- Exclude Verint-TQC for Non Pilot site(s)
  AND isCSRAcknowledged = 1
  AND SurveySent = 0
  AND CSRReviewAutoDate BETWEEN @StartOfPeriod and @EndOfPeriod
  AND EH.Active = 'A'
 )x
 WHERE x.Rn=1)SP
 ON CL.CoachingID = SP.CoachingID
 AND CL.EmpID = SP.EmpID 
)
 
 
--SELECT * FROM Selected
-- Insert selected random completions for each Employee into Survey header.
-- Check that no Survey exists for current month and year.

-- SCL: Selecetd Coaching logs
---SP: Survey pool
-- SRH: Survey Response Header




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
 FROM Selected SCL JOIN [EC].[Employee_Hierarchy] EH
 ON SCL.EmpID = EH.Emp_ID JOIN 
 (SELECT [SurveyTypeID],[CalendarYear],[MonthOfYear],[ModuleID],[EmpID], COUNT(*)SCount
FROM [EC].[Survey_Response_Header]
WHERE MonthOfYear = @DMonth
AND CalendarYear = @DYear
AND SurveyTypeID = @SurveyTypeID
GROUP BY [SurveyTypeID],[CalendarYear],[MonthOfYear],[ModuleID],[EmpID]
Having COUNT(*)= 1
) SRH
  ON SCL.EmpID = SRH.EmpID
  AND SCL.ModuleID = SRH.ModuleID
  AND SCL.MonthOfYear = SRH.MonthOfYear
  AND SCL.CalendarYear = SRH.CalendarYear 
  AND SCL.[SurveyTypeID]= SRH.[SurveyTypeID]
OPTION (MAXDOP 1)
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
OPTION (MAXDOP 1)
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
END -- sp_InsertInto_Survey_Response_Header_Resend

GO




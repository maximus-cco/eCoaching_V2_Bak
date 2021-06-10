/*
sp_Update_Quality_Other_Coaching_Stage(05).sql
Last Modified Date: 6/8/2021
Last Modified By: Susmitha Palacherla

Version 05: Updated to support WC Bingo records in Bingo feeds. TFS 21493 - 6/8/2021
Version 04: Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
Version 03:  Modified to support QN Bingo eCoaching logs. TFS 15063 - 08/15/2019
Version 02:  Modified to support OTA Report. TFS 12591 - 11/26/2018
Version 01:  Initial Revision - Created during encryption of secure data. TFF 7856 - 11/27/2017

*/


IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Update_Quality_Other_Coaching_Stage' 
)
   DROP PROCEDURE [EC].[sp_Update_Quality_Other_Coaching_Stage]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create date: 12/14/2017
-- Description:	Performs the following actions.
-- Populates EmpID and or lanID depending on incoming files as needed
-- Populate missing program values from employee table
-- Populates Role and Active status 
-- Rejects records and deletes rejected records per business rules.
-- Initial revision. Created during encryption of sensitive data - TFS 7856 - 04/24/2017
-- Modified to support OTA Report. TFS 12591 - 11/26/2018
-- Updated to support QN Bingo eCoaching logs. TFS 15063 - 08/12/2019
-- Updated to support QM Bingo eCoaching logs. TFS 15465 - 09/23/2019
-- Updated to support WC Bingo records in Bingo feeds. TFS 21493 - 6/8/2021
-- =============================================
CREATE PROCEDURE [EC].[sp_Update_Quality_Other_Coaching_Stage] 
@Count INT OUTPUT
AS
BEGIN

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

-- For Files where EmpID sent in strCSR. Copy directly to EmpID (KUD)

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Emp_ID]=[Emp_LanID]
WHERE NOT ISNULL([Emp_LANID],' ') like '%.%'
AND [Emp_ID] IS NULL;


WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

-- For Files where Emp LanID sent in strCSR.
-- Lookup Employee ID and Populate into (HFC)

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [EMP_ID]= [EC].[fn_nvcGetEmpIdFromLanId] ([EMP_LANID],[Submitted_Date])
WHERE  ISNULL([Emp_LANID],' ') like '%.%'
AND [Emp_ID] IS NULL;

 
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  

-- Replace unknown Employee Ids with ''

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [EMP_ID]= ''
WHERE  [EMP_ID]='999999';

 
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  

-- Populate SubmitterID as 999999 where NULL

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Submitter_ID]= '999999'
WHERE [Submitter_ID] IS NULL;
 
      
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms

 -- Populate Program Value from Employee table where missing

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Program]= H.[Emp_Program]
FROM [EC].[Quality_Other_Coaching_Stage]S JOIN [EC].[Employee_Hierarchy]H
ON S.[EMP_ID]=H.[Emp_ID]
WHERE ([Program] IS NULL OR [Program]= '');

 
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  


-- Determine and populate Reject Reasons
-- Employee not an Active Supervisor (CTC and QNBS)


UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to an active Supervisor.'
WHERE (EMP_ID = '' OR
EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code = 'WACS40'
 AND Active NOT IN ('T','D','P','L') 
 ))
AND (Report_Code lIKE 'CTC%' OR Report_Code LIKE 'BQNS%' OR Report_Code LIKE 'BQMS%')
AND [Reject_Reason]is NULL;
	
	
WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  

-- Employee not an Active CSR (HFC and KUD)

UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to an active CSR.'
WHERE (EMP_ID = '' OR
EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code IN ('WACS01', 'WACS02', 'WACS03')
 AND Active NOT IN ('T','D','P','L') 
 ))
 AND (Report_Code lIKE 'HFC%' OR Report_Code LIKE 'KUD%' OR Report_Code LIKE 'BQN2%' OR Report_Code LIKE 'BQM2%')
AND [Reject_Reason]is NULL;


WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  

-- Employee not an Active Quality Lead Specialist (OTA)


UPDATE [EC].[Quality_Other_Coaching_Stage]
SET [Reject_Reason]= N'Record does not belong to an active Quality Specialist.'
WHERE (EMP_ID = '' OR
EMP_ID NOT IN 
(SELECT DISTINCT EMP_ID FROM [EC].[Employee_Hierarchy]
 WHERE Emp_Job_Code in( 'WACQ12', 'WACQ02','WACQ03')
 AND Active NOT IN ('T','D','P','L') 
 ))
AND Report_Code lIKE 'OTA%' 
AND [Reject_Reason]is NULL;
 

WAITFOR DELAY '00:00:00.01'; -- Wait for 1 ms  

-- Reject BQN logs where an Employee does not have a valid set of QC competencies.

DECLARE @ReportCode nvarchar(30);
SET @ReportCode = (Select DISTINCT Report_Code FROM [EC].[Quality_Other_Coaching_Stage]);
--SELECT  @ReportCode;

IF @ReportCode LIKE 'BQ%'

BEGIN

	WITH comps AS
	(SELECT EMP_ID, STRING_AGG(Competency, '|') AS Competencies
	FROM ec.Quality_Other_Coaching_Stage
	WHERE Competency like 'Quality Correspondent%'
	GROUP BY EMP_ID)
	, invalidcomps AS
	(SELECT EMP_ID, Competencies FROM comps
	 WHERE Competencies IN
	 ('Quality Correspondent 1', 'Quality Correspondent 1|Quality Correspondent 2|Quality Correspondent 3'))

 --SELECT * FROM invalidcomps;

	UPDATE [EC].[Quality_Other_Coaching_Stage]
	SET [Reject_Reason]= N'Employee does not have a valid set of Quality Correspondent competencies '
	FROM [EC].[Quality_Other_Coaching_Stage] s JOIN invalidcomps i
	ON s.EMP_ID = i.EMP_ID
	WHERE Report_Code lIKE 'BQN%' 
	AND [Reject_Reason]is NULL;

  
-- Reject duplicate competencies for Bingo logs

	WITH dups AS
		(SELECT d.[EMP_ID], d.[Competency], d.[BingoType], COUNT(*) as Rec_Count FROM
		(SELECT DISTINCT [EMP_ID],
				[Competency],
				[BingoType],
				[Program],
				[TextDescription],
				[Note]				
		FROM [EC].[Quality_Other_Coaching_Stage])d
		GROUP BY d.[EMP_ID], d.[Competency], d.[BingoType]
		HAVING COUNT(*) > 1)
			--Select * from dups;

	UPDATE [EC].[Quality_Other_Coaching_Stage]
	SET [Reject_Reason]= N'Duplicate records for the same Competency and type. '
	FROM [EC].[Quality_Other_Coaching_Stage] s JOIN dups d
	ON (s.EMP_ID = d.EMP_ID AND s.Competency = d.Competency and s.BingoType = d.BingoType)
	AND [Reject_Reason]is NULL;
	
END;

--Insert Rejected Records into Rejected Table
INSERT INTO [EC].[Quality_Other_Coaching_Rejected]
           ([Report_ID]
           ,[Report_Code]
           ,[Source]
           ,[Event_Date]
           ,[Submitted_Date]
		   ,[FileName]
           ,[Rejected_Reason]
           ,[Rejected_Date]
       )
 SELECT S.[Report_ID]
      ,S.[Report_Code]
      ,S.[Source]
      ,S.[Event_Date]
      ,S.[Submitted_Date]
	  ,S.[FileName]
      ,s.[Reject_Reason]
      ,GETDATE()
   FROM [EC].[Quality_Other_Coaching_Stage]S left outer join [EC].[Quality_Other_Coaching_Rejected] R 
  ON S.Report_ID = R.Report_ID and S.Report_Code = R.Report_Code 
  WHERE R.Report_ID is NULL and R.Report_Code is NULL 
  AND S.[Reject_Reason] is not NULL;              


    
-- Delete rejected records
DELETE FROM [EC].[Quality_Other_Coaching_Stage]
WHERE [Reject_Reason]is not NULL;

SELECT @Count = @@ROWCOUNT;

-- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	


END  -- [EC].[sp_Update_Quality_Other_Coaching_Stage]
GO






SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 02/01/2024
-- Description:	Inserts a PMA Role for Quality Staff in the Historical Dashboard ACL table.
-- Created to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
--- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_Populate_Historical_Dashboard_ACL] 
AS
BEGIN

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 
DECLARE @UpdateBy nvarchar(50) = 'EmployeeLoad';
 
-- Maintain ELS ROle for Early Life Supervisors in ACL Table

IF OBJECT_ID(N'tempdb..#ELSACL') IS NOT NULL
BEGIN
DROP TABLE #ELSACL
END
 
CREATE TABLE #ELSACL
(
 [Row_ID] int,
 [Role] nvarchar(30), 
 [End_Date]  nvarchar(10),
 [User_ID] nvarchar(10)
)

INSERT INTO #ELSACL
SELECT DISTINCT [Row_ID]
      ,[Role]
      ,[End_Date]
      ,EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate())
	   FROM [EC].[Historical_Dashboard_ACL]
   WHERE Role = 'ELS';

 --SELECT * FROM #ELSACL


-- Inactivate ELS Role when record not in feed file or Emp Job code not WACS40 or WACS50

	UPDATE [EC].[Historical_Dashboard_ACL] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
    ,[Updated_By]= EncryptByKey(Key_GUID('CoachingKey'), @UpdateBy)
	 FROM #ELSACL elst INNER JOIN [EC].[Historical_Dashboard_ACL] acl  
	 ON elst.Row_ID = acl.Row_ID INNER JOIN EC.Employee_Hierarchy eh
	 ON elst.[User_ID] = eh.Emp_ID
	 WHERE elst.End_Date = 99991231
    AND (elst.[User_ID] NOT IN (Select Emp_ID from EC.ELS_Hierarchy_Stage) OR
	 eh.Emp_Job_Code NOT IN ('WACS40', 'WACS50', 'WACS60') OR
	 eh.Active IN ('T','D'));
	

-- Reactivate ELS Role when record in file and Inactivated record exists

	UPDATE [EC].[Historical_Dashboard_ACL] 
	SET [END_DATE] = '99991231'
    ,[Updated_By]= EncryptByKey(Key_GUID('CoachingKey'), @UpdateBy)
	 FROM #ELSACL elst INNER JOIN [EC].[Historical_Dashboard_ACL] acl  
	 ON elst.Row_ID = acl.Row_ID INNER JOIN EC.Employee_Hierarchy eh
	 ON elst.[User_ID] = eh.Emp_ID
	 WHERE elst.End_Date <> 99991231
	 AND elst.[User_ID] IN (Select Emp_ID from EC.ELS_Hierarchy_Stage)
	 AND eh.Emp_Job_Code IN ('WACS40', 'WACS50', 'WACS60')
	 AND eh.Active NOT IN ('T','D');


-- Insert new records for ELS Role in ACL Table

	  INSERT INTO EC.Historical_Dashboard_ACL 
			(   [Role]
               ,[End_Date]
               ,[IsAdmin]
			   ,[User_LanID]
               ,[User_Name]
			   ,[Updated_By])

	  SELECT 'ELS', '99991231', N'N', EH.Emp_LanID, EH.Emp_Name,EncryptByKey(Key_GUID('CoachingKey'), @UpdateBy)
				  		  FROM [EC].[ELS_Hierarchy_Stage] els INNER JOIN [EC].[Employee_Hierarchy] eh
						  ON els.Emp_ID = eh.Emp_ID  LEFT OUTER JOIN #ELSACL elst 
						  ON els.Emp_ID = elst.[User_ID]
					      WHERE elst.[User_ID] IS NULL
						  AND eh.Emp_Job_Code IN ('WACS40', 'WACS50', 'WACS60')
						  AND eh.Active NOT IN ('T','D');


-- Maintain PM Roles for Subcontractor Access in ACL Table

IF OBJECT_ID(N'tempdb..#PMACL') IS NOT NULL
BEGIN
DROP TABLE #PMACL
END
 
CREATE TABLE #PMACL
(
 [Row_ID] int,
 [Role] nvarchar(30), 
 [End_Date]  nvarchar(10),
 [User_ID] nvarchar(10)
)

INSERT INTO #PMACL
SELECT [Row_ID]
      ,[Role]
      ,[End_Date]
      ,EC.fn_nvcGetEmpIdFromLanId(CONVERT(nvarchar(30),DecryptByKey([User_LanID])), getdate())
	   FROM [EC].[Historical_Dashboard_ACL]
   WHERE Role IN ( 'QAM') ;

 --SELECT * FROM #PMACL

-- Insert new records for PMA Role in ACL Table

	  INSERT INTO EC.Historical_Dashboard_ACL 
			(   [Role]
               ,[End_Date]
               ,[IsAdmin]
			   ,[User_LanID]
               ,[User_Name]
			   ,[Updated_By])

	  SELECT 'QAM', '99991231', N'N', EH.Emp_LanID, EH.Emp_Name, EncryptByKey(Key_GUID('CoachingKey'), @UpdateBy)
				  		  FROM [EC].[Employee_Hierarchy] eh LEFT OUTER JOIN #PMACL pmt 
						  ON eh.Emp_ID = pmt.[User_ID]
					      WHERE pmt.[User_ID] IS NULL
						  AND eh.Emp_Job_Code IN ('WACQ13', 'WPPM50')
						  AND eh.Active NOT IN ('T','D');

 -- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	 

END --sp_Populate_Historical_Dashboard_ACL
GO



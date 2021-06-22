/*
sp_Populate_Employee_Hierarchy(08).sql
Last Modified Date: 6/21/2021
Last Modified By: Susmitha Palacherla

Version 08: Updated to Revise stored procedures causing deadlocks. TFS 21713 - 6/17/2021
Version 07: pdated to support Legacy Ids to Maximus Ids - TFS 13777 - 05/22/2019
Version 06:  Cross check employees on Leave against Aspect data - TFS 13074 - 12/21/2018
Version 05:  Updated to support Encryption of sensitive data - TFS 7856 - 11/17/2017
Version 04:  Updated to add two new columns from People Soft feed - TFS 8974  - 11/10/2017
Version 03: Updated to populate preferred name and Hire date attributes. TFS 8228 - 09/21/2017
Version 02: Change how email addresses with apostrophes are stored - TFS 6614 - 5/17/2017
Version 01: Document Initial Revision - TFS 5223 - 1/18/2017

*/

IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'EC'
     AND SPECIFIC_NAME = N'sp_Populate_Employee_Hierarchy' 
)
   DROP PROCEDURE [EC].[sp_Populate_Employee_Hierarchy]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 07/25/2013
-- Description:	Performs the following actions.
-- Updates existing records and Inserts New records from the Staging table.
-- Last Modified By: Susmitha Palacherla
-- updated during TFS 1710 to populate SrLvlMgr IDs - 2/18/2016
-- updated during TFS 6614 to Change how email addresses with apostrophes are stored - 05/16/2017
-- Updated to populate preferred name and Hire date attributes. TFS 8228 - 09/21/2017
-- Updated to add two new columns from People Soft feed - TFS 8974  - 11/10/2017
-- Updated to support Encryption of sensitive data - TFS 7856 - 11/17/2017
-- Updated to cross check employees on Leave against Aspect data - TFS 13074 - 12/21/2018
-- Updated to support Legacy Ids to Maximus Ids - TFS 13777 - 05/22/2019
-- Updated to Revise stored procedures causing deadlocks. TFS 21713 - 6/17/2021
-- =============================================
CREATE PROCEDURE [EC].[sp_Populate_Employee_Hierarchy] 
AS
BEGIN

-- Open Symmetric key
OPEN SYMMETRIC KEY [CoachingKey] DECRYPTION BY CERTIFICATE [CoachingCert]; 

 --Assigns End_Date to Inactive Records with status change in feed
 
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active in ('T', 'D')
	AND H.END_DATE= '99991231';

	
   WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Assigns End_Date to Inactive Records that stop arriving in feed

	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	,[Active] = 'T'
	 WHERE END_DATE = '99991231' AND Active = 'A'
	 AND Emp_ID <> '999999'
	 AND EMP_ID NOT IN
	(SELECT Emp_ID FROM [EC].[Employee_Hierarchy_Stage]);


 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Assigns Open Ended End_Date for Rehire records

	UPDATE [EC].[Employee_Hierarchy] 
	SET [Active]= S.Active
	,[Start_Date] = S.Start_Date
	,[END_DATE] = '99991231'
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active not in ('T', 'D')
	AND H.END_DATE  <> '99991231';

 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Updates Existing Records

	UPDATE [EC].[Employee_Hierarchy]
	   SET [Emp_Name] = EncryptByKey(Key_GUID('CoachingKey'), Replace(S.[Emp_Name],'''', ''))
	      ,[Emp_Email] = EncryptByKey(Key_GUID('CoachingKey'), S.[Emp_Email])
		  ,[Emp_LanID] = EncryptByKey(Key_GUID('CoachingKey'), S.Emp_LanID)
		  ,[Emp_Site] =  [EC].[fn_strSiteNameFromSiteLocation](S.Emp_Site)
		  ,[Emp_Job_Code] = S.Emp_Job_Code
		  ,[Emp_Job_Description] = S.Emp_Job_Description
		  ,[Emp_Program] = S.Emp_Program
		  ,[Sup_ID] = S.Sup_EMP_ID
		  ,[Sup_Name] = EncryptByKey(Key_GUID('CoachingKey'), Replace(S.[Sup_Name],'''', ''))
		  ,[Sup_Email] = EncryptByKey(Key_GUID('CoachingKey'), S.[Sup_Email])
		  ,[Sup_LanID] = EncryptByKey(Key_GUID('CoachingKey'), S.Sup_LanID)
		  ,[Sup_Job_Code] = S.Sup_Job_Code 
		  ,[Sup_Job_Description] = S.Sup_Job_Description
		  ,[Mgr_ID] = S.Mgr_EMP_ID 
		  ,[Mgr_Name] = EncryptByKey(Key_GUID('CoachingKey'), Replace(S.[Mgr_Name],'''', ''))
		  ,[Mgr_Email] = EncryptByKey(Key_GUID('CoachingKey'), S.[Mgr_Email])
		  ,[Mgr_LanID] = EncryptByKey(Key_GUID('CoachingKey'), S.Mgr_LanID)
		  ,[Mgr_Job_Code] = S.Mgr_Job_Code 
		  ,[Mgr_Job_Description] = S.Mgr_Job_Description
		  ,[Start_Date] = CONVERT(nvarchar(8),S.[Start_Date],112)
		  ,[Active] = S.Active
		  ,[Emp_Pri_Name] = EncryptByKey(Key_GUID('CoachingKey'), S.Emp_Pri_Name)
		  ,Dept_ID = S.Dept_ID
		  ,Dept_Description = S.Dept_Description
		  ,Reg_Temp = S.Reg_Temp
		  ,Full_Part_Time = S.Full_Part_Time
		  ,Term_Date = CONVERT(nvarchar(8),S.[Term_Date],112)
		  ,FLSA_Status = S.FLSA_Status
	 FROM [EC].[Employee_Hierarchy]H JOIN [EC].[Employee_Hierarchy_Stage]S
	 ON H.[Emp_ID] = S.[EMP_ID]
	 WHERE H.[Emp_ID] is NOT NULL;


WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms
    
-- Inserts New Records

	INSERT INTO [EC].[Employee_Hierarchy]
			  ([Emp_ID]
			   ,[Emp_Name]
			   ,[Emp_Email]
			   ,[Emp_LanID]
			   ,[Emp_Site]
			   ,[Emp_Job_Code]
			   ,[Emp_Job_Description]
			   ,[Emp_program]
			   ,[Active]
			   ,[Hire_Date]
			   ,[Start_Date]
			   ,[Sup_ID]
			   ,[Sup_Name]
			   ,[Sup_Email]
			   ,[Sup_LanID]
			   ,[Sup_Job_Code]
			   ,[Sup_Job_Description]
			   ,[Mgr_ID]
			   ,[Mgr_Name]
			   ,[Mgr_Email]
			   ,[Mgr_LanID]
			   ,[Mgr_Job_Code]
			   ,[Mgr_Job_Description]
			   ,[Dept_ID]
		       ,[Dept_Description]
		       ,[Reg_Temp]
			   ,[Full_Part_Time]
			   ,[Term_Date]
			   ,[FLSA_Status]
			   ,[Legacy_Emp_ID]
			   ,[PS_Emp_ID_Prefix]
			   ,[Emp_Pri_Name]
		   
			  )
							 SELECT DISTINCT S.[Emp_ID]
						      ,EncryptByKey(Key_GUID('CoachingKey'), Replace(S.[Emp_Name],'''', ''))
                              ,EncryptByKey(Key_GUID('CoachingKey'), S.[Emp_Email])
							  ,EncryptByKey(Key_GUID('CoachingKey'), S.Emp_LanID)
							  ,[EC].[fn_strSiteNameFromSiteLocation](S.[Emp_Site])
							  ,S.[Emp_Job_Code]
							  ,S.[Emp_Job_Description]
							  ,S.[Emp_Program]
							  ,S.[Active]
							  ,CONVERT(nvarchar(8),S.[Hire_Date],112)
							  ,CONVERT(nvarchar(8),S.[Start_Date],112)
							  ,S.[Sup_Emp_ID]
							  ,EncryptByKey(Key_GUID('CoachingKey'), Replace(S.[Sup_Name],'''', ''))
							  ,EncryptByKey(Key_GUID('CoachingKey'), S.[Sup_Email])
							  ,EncryptByKey(Key_GUID('CoachingKey'), S.Sup_LanID)
							  ,S.[Sup_Job_Code]
							  ,S.[Sup_Job_Description]
							  ,S.[Mgr_Emp_ID]
							  ,EncryptByKey(Key_GUID('CoachingKey'), Replace(S.[Mgr_Name],'''', ''))
							  ,EncryptByKey(Key_GUID('CoachingKey'), S.[Mgr_Email])
							  ,EncryptByKey(Key_GUID('CoachingKey'), S.Mgr_LanID)
							  ,S.[Mgr_Job_Code]
							  ,S.[Mgr_Job_Description]
						      ,S.[Dept_ID]
							  ,S.[Dept_Description]
							  ,S.[Reg_Temp]
							  ,S.[Full_Part_Time]
							  ,CONVERT(nvarchar(8),S.[Term_Date],112)
			                  ,S.[FLSA_Status]
							  ,S.[Legacy_Emp_ID]
							  ,N'NA'
							 ,EncryptByKey(Key_GUID('CoachingKey'), S.Emp_Pri_Name)
							 
						  FROM [EC].[Employee_Hierarchy_Stage]S Left outer Join [EC].[Employee_Hierarchy]H
						  ON S.Emp_ID = H.Emp_ID
						  WHERE (H.EMP_ID IS NULL and S.Emp_ID <> '')
						  AND S.Active NOT IN ('T', 'D');
					

 WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms

-- Update Employee Status from Aspect

	UPDATE [EC].[Employee_Hierarchy]
	   SET [Active] = 'A'
	    FROM [EC].[Employee_Hierarchy]H JOIN [EC].[EmpID_To_SupID_Stage]S
	 ON H.[Emp_ID] = S.[EMP_ID]
	 WHERE H.[Active] in ('L','P')
	  AND H.End_Date = 99991231
	 AND S.[Emp_Status] IN ('RFT','RPT', 'TPT', 'TFT');

 WAITFOR DELAY '00:00:00.02' -- Wait for 2 ms

 -- Populate SrMgr IDs

              UPDATE [EC].[Employee_Hierarchy]
              SET [SrMgrLvl1_ID]=	[EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])		  
				 ,[SrMgrLvl2_ID]=	[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])	
	             ,[SrMgrLvl3_ID]=	[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])
	FROM [EC].[Employee_Hierarchy]H;

 -- Close Symmetric key
CLOSE SYMMETRIC KEY [CoachingKey];	 

END --sp_Populate_Employee_Hierarchy
GO





/*
sp_Populate_Employee_Hierarchy(01).sql
Last Modified Date: 1/18/2017
Last Modified By: Susmitha Palacherla



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
-- Last Modified Date: 2/18/2016
-- updated during TFS 1710 to populate SrLvlMgr IDs
-- =============================================
CREATE PROCEDURE [EC].[sp_Populate_Employee_Hierarchy] 
AS
BEGIN


 --Assigns End_Date to Inactive Records with status change in feed
 
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active in ('T', 'D')
	AND H.END_DATE= '99991231'
OPTION (MAXDOP 1)
END


-- Assigns End_Date to Inactive Records that stop arriving in feed
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [END_DATE] = CONVERT(nvarchar(10),getdate(),112)
	,[Active] = 'T'
	 WHERE END_DATE = '99991231' AND Active = 'A'
	 AND Emp_ID <> '999999'
	 AND EMP_ID NOT IN
	(SELECT Emp_ID FROM [EC].[Employee_Hierarchy_Stage])

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Assigns Open Ended End_Date for Rehire records
BEGIN
	UPDATE [EC].[Employee_Hierarchy] 
	SET [Active]= S.Active
	,[Start_Date] = S.Start_Date
	,[END_DATE] = '99991231'
	FROM [EC].[Employee_Hierarchy_Stage] S JOIN [EC].[Employee_Hierarchy]H
	ON H.Emp_ID = S.Emp_ID
	AND S.Active not in ('T', 'D')
	AND H.END_DATE  <> '99991231'
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms

-- Updates Existing Records
BEGIN
	UPDATE [EC].[Employee_Hierarchy]
	   SET [Emp_Name] = Replace(S.[Emp_Name],'''', '')
	      ,[Emp_Email] = Replace(S.[Emp_Email],'''','''''')
		  ,[Emp_LanID] = S.Emp_LanID
		  ,[Emp_Site] =  [EC].[fn_strSiteNameFromSiteLocation](S.Emp_Site)
		  ,[Emp_Job_Code] = S.Emp_Job_Code
		  ,[Emp_Job_Description] = S.Emp_Job_Description
		  ,[Emp_Program] = S.Emp_Program
		  ,[Sup_ID] = S.Sup_EMP_ID
		  ,[Sup_Name] = Replace(S.[Sup_Name],'''', '')
		  ,[Sup_Email] = Replace(S.[Sup_Email],'''','''''')
		  ,[Sup_LanID] = S.Sup_LanID
		  ,[Sup_Job_Code] = S.Sup_Job_Code 
		  ,[Sup_Job_Description] = S.Sup_Job_Description
		  ,[Mgr_ID] = S.Mgr_EMP_ID 
		  ,[Mgr_Name] = Replace(S.[Mgr_Name],'''', '')
		  ,[Mgr_Email] = Replace(S.[Mgr_Email],'''','''''')
		  ,[Mgr_LanID] = S.Mgr_LanID
		  ,[Mgr_Job_Code] = S.Mgr_Job_Code 
		  ,[Mgr_Job_Description] = S.Mgr_Job_Description
		  ,[Start_Date] = CONVERT(nvarchar(8),S.[Start_Date],112)
		  ,[Active] = S.Active
	 FROM [EC].[Employee_Hierarchy]H JOIN [EC].[Employee_Hierarchy_Stage]S
	 ON H.[Emp_ID] = S.[EMP_ID]
	 WHERE H.[Emp_ID] is NOT NULL
OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Inserts New Records
BEGIN
	INSERT INTO [EC].[Employee_Hierarchy]
			  ([Emp_ID]
			   ,[Emp_Name]
			   ,[Emp_Email]
			   ,[Emp_LanID]
			   ,[Emp_Site]
			   ,[Emp_Job_Code]
			   ,[Emp_Job_Description]
			   ,[Emp_program]
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
			   ,[Start_Date]
			   ,[Active]
			  )
							 SELECT S.[Emp_ID]
						      ,Replace(S.[Emp_Name],'''', '')
                              ,Replace(S.[Emp_Email],'''','''''')
							  ,S.[Emp_LanID]
							  ,[EC].[fn_strSiteNameFromSiteLocation](S.[Emp_Site])
							  ,S.[Emp_Job_Code]
							  ,S.[Emp_Job_Description]
							  ,S.[Emp_Program]
							  ,S.[Sup_Emp_ID]
							  ,Replace(S.[Sup_Name],'''', '')
							  ,Replace(S.[Sup_Email],'''','''''')
							  ,S.[Sup_LanID]
							  ,S.[Sup_Job_Code]
							  ,S.[Sup_Job_Description]
							  ,S.[Mgr_Emp_ID]
							  ,Replace(S.[Mgr_Name],'''', '')
							  ,Replace(S.[Mgr_Email],'''','''''')
							  ,S.[Mgr_LanID]
							  ,S.[Mgr_Job_Code]
							  ,S.[Mgr_Job_Description]
							  ,CONVERT(nvarchar(8),S.[Start_Date],112)
							  ,S.[Active]
						  FROM [EC].[Employee_Hierarchy_Stage]S Left outer Join [EC].[Employee_Hierarchy]H
						  ON S.Emp_ID = H.Emp_ID
						  WHERE (H.EMP_ID IS NULL and S.Emp_ID <> '')

OPTION (MAXDOP 1)
END

WAITFOR DELAY '00:00:00.05' -- Wait for 5 ms
    
-- Populate SrMgr IDs
BEGIN
              UPDATE [EC].[Employee_Hierarchy]
              SET [SrMgrLvl1_ID]=	[EC].[fn_strSrMgrLvl1EmpIDFromEmpID]([H].[Emp_ID])		  
	   ,[SrMgrLvl2_ID]=	[EC].[fn_strSrMgrLvl2EmpIDFromEmpID]([H].[Emp_ID])	
	   ,[SrMgrLvl3_ID]=	[EC].[fn_strSrMgrLvl3EmpIDFromEmpID]([H].[Emp_ID])
	FROM [EC].[Employee_Hierarchy]H

     OPTION (MAXDOP 1)
     END

END --sp_Populate_Employee_Hierarchy

GO


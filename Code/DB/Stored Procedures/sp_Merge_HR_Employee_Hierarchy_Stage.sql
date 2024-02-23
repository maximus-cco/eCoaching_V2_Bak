
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		   Susmitha Palacherla
-- Create Date: 04/6/2016
-- Description:	Performs the following actions.
-- Updates existing records and inserts new records from the
-- HR Staging table to the general Employee Hierarchy staging table.
-- Last Modified By: 
-- Last Modified Date: 
-- Initial Revision - TFS 2332 - 4/6/2016
-- Updated to populate Emp ID With Prefix and Hire date - TFS 8228 - 09/21/2017
-- Updated to populate 'Exempt' in FLSA status - TFS 8974  - 11/10/2017
-- Modified to support Legacy Ids to Maximus Ids - TFS 13777 - 05/22/2019
-- Modified to support eCoaching Log for Subcontractors - TFS 27527 - 02/01/2024
-- =============================================
CREATE OR ALTER PROCEDURE [EC].[sp_Merge_HR_Employee_Hierarchy_Stage] 
AS
BEGIN


-- Updates Existing Records

	UPDATE [EC].[Employee_Hierarchy_Stage]
	   SET [Emp_Job_Code] = S.[Emp_Job_Code]
		  ,[Emp_Job_Description] = S.[Emp_Job_Description]
    FROM [EC].[Employee_Hierarchy_Stage]H JOIN [EC].[HR_Hierarchy_Stage]S
	 ON H.[Emp_ID] = S.[EMP_ID]
	 WHERE H.[Emp_ID] is NOT NULL;


WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms


-- Fetch Start date for existing records from employee Hierarchy Table
-- and populate into HR staging table


	UPDATE [EC].[HR_Hierarchy_Stage]
	   SET [Start_Date]= [EC].[fn_dtYYYYMMDD_to_Datetime] (EH.Start_Date)
		  FROM [EC].[Employee_Hierarchy]EH JOIN [EC].[HR_Hierarchy_Stage]S
	 ON EH.[Emp_ID] = S.[EMP_ID]
	 WHERE EH.[Emp_ID] is NOT NULL
	 AND EH.[Active]= 'A';


WAITFOR DELAY '00:00:00.02'; -- Wait for 2 ms
    
-- Inserts HR Records into Employee Hierarchy Staging Table
;
	INSERT INTO [EC].[Employee_Hierarchy_Stage]
           ([Emp_ID]
           ,[Emp_Name]
           ,[Emp_Email]
           ,[Emp_Site]
           ,[Emp_Job_Code]
           ,[Emp_Job_Description]
           ,[Emp_Program]
           ,[Emp_LanID]
           ,[Sup_Emp_ID]
           ,[Mgr_Emp_ID]
           ,[Start_Date]
           ,[Active]
		   ,[Legacy_Emp_ID]
	       ,[Hire_Date]
		   ,[Emp_Pri_Name]
           ,[Dept_ID]
           ,[Dept_Description]
           ,[Reg_Temp]
           ,[Full_Part_Time]
		   ,[FLSA_Status]
		   ,[isSub])
							 SELECT S.[Emp_ID]
									  ,S.[Emp_Name]
									  ,S.[Emp_Email]
									  ,S.[Emp_Site]
									  ,S.[Emp_Job_Code]
									  ,S.[Emp_Job_Description]
									  ,S.[Emp_Program]
									  ,S.[Emp_LanID]
									  ,'999999'
									  ,'999999'
									  ,ISNULL(S.[Start_Date], GETDATE())
									  ,'A'
									  ,S.[Legacy_Emp_ID]
	                                  ,S.[Hire_Date]
									  ,S.[Emp_Name]
									  ,'NA'
									  ,'NA'
									  ,'NA'
									  ,'NA'
									  ,'Exempt'
									  ,S.[isSub]
						  FROM [EC].[HR_Hierarchy_Stage]S Left outer Join [EC].[Employee_Hierarchy_Stage]H
						  ON S.Emp_ID = H.Emp_ID
						  WHERE H.EMP_ID IS NULL;


END --sp_Merge_HR_Employee_Hierarchy_Stage
GO



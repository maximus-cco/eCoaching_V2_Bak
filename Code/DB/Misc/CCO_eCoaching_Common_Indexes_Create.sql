/*
CCO_eCoaching_Indexes_Create.sql
Last Modified Date: 4/29/2021
Last Modified By: Susmitha Palacherla

**************************************************************/

--*************************************************************************************

 ---------------------------AT_Coaching_Inactivate_Reactivate_Audit-------------------

--*************************************************************************************

--1.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4') 
    DROP INDEX _dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4 ON [EC].[AT_Coaching_Inactivate_Reactivate_Audit]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4] ON [EC].[AT_Coaching_Inactivate_Reactivate_Audit](FormName ASC, LastKnownStatus ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 GO

--2.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_AT_Coaching_Inactivate_Reactivate_Audit_CoachingID') 
    DROP INDEX IDX_AT_Coaching_Inactivate_Reactivate_Audit_CoachingID ON [EC].[AT_Coaching_Inactivate_Reactivate_Audit]; 
GO

CREATE NONCLUSTERED INDEX [IDX_AT_Coaching_Inactivate_Reactivate_Audit_CoachingID] ON [EC].[AT_Coaching_Inactivate_Reactivate_Audit](CoachingID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 ---------------------------Coaching_Log-----------------------------------------------

--*************************************************************************************

 --1.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24 ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24] ON [EC].[Coaching_Log](ModuleID ASC, StatusID ASC, CSRReviewAutoDate ASC, CoachingID ASC, EmpID ASC, SourceID ASC) 
INCLUDE (FormName, SubmitterID, SubmittedDate)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --2.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8 ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8] ON [EC].[Coaching_Log](StatusID ASC, SubmittedDate ASC, ModuleID ASC) 
INCLUDE (CoachingID, EmpID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--3.
 
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1 ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1] ON [EC].[Coaching_Log](StatusID ASC, CSRReviewAutoDate ASC, ModuleID ASC, EmpID ASC, CoachingID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --4.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2 ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2] ON [EC].[Coaching_Log](EmpID ASC, ReassignedToID ASC, MgrID ASC, ReassignCount ASC, strReportCode ASC, StatusID ASC, SubmittedDate ASC) 
INCLUDE (CoachingID, FormName)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--5.
 
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2') 
    DROP INDEX _dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2 ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2] ON [EC].[Coaching_Log](EmpID ASC, SourceID ASC, StatusID ASC, SubmittedDate ASC) 
INCLUDE (FormName)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --6.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9') 
    DROP INDEX _dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9 ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9] ON [EC].[Coaching_Log](StatusID ASC, EmpID ASC, SubmittedDate ASC) 
INCLUDE (FormName, SubmitterID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --7.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_EmailSent_FormName') 
    DROP INDEX IDX_Coaching_Log_EmailSent_FormName ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_EmailSent_FormName] ON [EC].[Coaching_Log](EmailSent ASC, FormName ASC, strReportCode ASC, SourceID ASC, ModuleID ASC, StatusID ASC, EmpID ASC, MgrID ASC, SubmittedDate ASC) 
INCLUDE (CoachingID, CoachingDate, isCSE)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --8.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_FormName_SubmittedDate') 
    DROP INDEX IDX_Coaching_Log_FormName_SubmittedDate ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_FormName_submittedDate] ON [EC].[Coaching_Log](FormName ASC, SubmittedDate ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --9.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24') 
    DROP INDEX IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24 ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24] ON [EC].[Coaching_Log](SiteID ASC, CoachingID ASC, SourceID ASC, StatusID ASC, SubmitterID ASC, EmpID ASC, SubmittedDate ASC) 
INCLUDE (FormName)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --10.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_ReportID_ReportCode') 
    DROP INDEX IDX_Coaching_Log_ReportID_ReportCode ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_ReportID_ReportCode] ON [EC].[Coaching_Log](numReportID ASC, strReportCode ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --11.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_StatusID') 
    DROP INDEX IDX_Coaching_Log_StatusID ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_StatusID] ON [EC].[Coaching_Log](StatusID ASC) 
INCLUDE (CoachingID, FormName, SourceID, EmpID, SubmittedDate, ModuleID, ReassignCount, ReassignedToID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --12.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_StatusID_EmpID') 
    DROP INDEX IDX_Coaching_Log_StatusID_EmpID ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_StatusID_EmpID] ON [EC].[Coaching_Log](StatusID ASC, EmpID ASC) 
INCLUDE (CoachingID, FormName, SourceID, SubmitterID, SubmittedDate)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --13.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_SubmitterID') 
    DROP INDEX IDX_Coaching_Log_SubmitterID ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_SubmitterID] ON [EC].[Coaching_Log](SubmitterID ASC) 
INCLUDE (FormName, StatusID, EmpID, SubmittedDate)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --14.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_SubmitterID_StatusID') 
    DROP INDEX IDX_Coaching_Log_SubmitterID_StatusID ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_SubmitterID_StatusID] ON [EC].[Coaching_Log](SubmitterID ASC, StatusID ASC) 
INCLUDE (FormName, SourceID, EmpID, SubmittedDate)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 ---------------------------Coaching_Log_Quality_Now_Evaluations-----------------------------------------------

--*************************************************************************************

--1.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_QNEvals_CoachingID_EvalStatus') 
    DROP INDEX IDX_Coaching_Log_QNEvals_CoachingID_EvalStatus ON [EC].[Coaching_Log_Quality_Now_Evaluations]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_QNEvals_CoachingID_EvalStatus] ON [EC].[Coaching_Log_Quality_Now_Evaluations](CoachingID ASC, EvalStatus ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --2.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_QNEvals_CoachingID_EvalStatus_Include') 
    DROP INDEX IDX_Coaching_Log_QNEvals_CoachingID_EvalStatus_Include ON [EC].[Coaching_Log_Quality_Now_Evaluations]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_QNEvals_CoachingID_EvalStatus_Include] ON [EC].[Coaching_Log_Quality_Now_Evaluations](CoachingID ASC, EvalStatus ASC) 
INCLUDE (Eval_ID, Eval_Date, Evaluator_ID, Call_Date, Journal_ID, Program, VerintFormName, isCoachingMonitor, Business_Process, Business_Process_Reason, Business_Process_Comment, Info_Accuracy, Info_Accuracy_Reason, Info_Accuracy_Comment, Privacy_Disclaimers, Privacy_Disclaimers_Reason, Privacy_Disclaimers_Comment, Issue_Resolution, Issue_Resolution_Comment, Call_Efficiency, Call_Efficiency_Comment, Active_Listening, Active_Listening_Comment, Personality_Flexing, Personality_Flexing_Comment, Customer_Temp_Start, Customer_Temp_Start_Comment, Customer_Temp_End, Customer_Temp_End_Comment)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 ---------------------------Coaching_Log_Reason-----------------------------------------------

--*************************************************************************************

 --1.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4') 
    DROP INDEX _dta_index_Coaching_Log_Reason_26_1269579561__K1_K4 ON [EC].[Coaching_Log_Reason]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4] ON [EC].[Coaching_Log_Reason](CoachingID ASC, Value ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--2.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_Reason_Value') 
    DROP INDEX IDX_Coaching_Log_Reason_Value ON [EC].[Coaching_Log_Reason]; 
GO

 
CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_Reason_Value] ON [EC].[Coaching_Log_Reason](Value ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 ---------------------------DIM_Date-----------------------------------------------

--*************************************************************************************

 --1.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_DIM_Date_26_613577224__K1_2') 
    DROP INDEX _dta_index_DIM_Date_26_613577224__K1_2 ON [EC].[DIM_Date]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_DIM_Date_26_613577224__K1_2] ON [EC].[DIM_Date](DateKey ASC) 
INCLUDE (FullDate)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 ---------------------------Employee_Hierarchy-----------------------------------------------

--*************************************************************************************

--1.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Emp_Hierarchy_Active_Emp_Job_Code') 
    DROP INDEX IDX_Emp_Hierarchy_Active_Emp_Job_Code ON [EC].[Employee_Hierarchy]; 
GO

 
CREATE NONCLUSTERED INDEX [IDX_Emp_Hierarchy_Active_Emp_Job_Code] ON [EC].[Employee_Hierarchy](Active ASC, Emp_Job_Code ASC) 
INCLUDE (Emp_Name, Emp_LanID, Emp_Email, Emp_Site, Hire_Date, Start_Date, End_Date, Sup_ID, Sup_Name, Sup_LanID, Sup_Email, Mgr_ID, Mgr_Name, Mgr_Email)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --2.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Emp_Hierarchy_Emp_Job_Code_End_Date') 
    DROP INDEX IDX_Emp_Hierarchy_Emp_Job_Code_End_Date ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Emp_Hierarchy_Emp_Job_Code_End_Date] ON [EC].[Employee_Hierarchy](Emp_Job_Code ASC, End_Date ASC) 
INCLUDE (Emp_ID, Emp_Site)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--3.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Active') 
    DROP INDEX IDX_Employee_Hierarchy_Active ON [EC].[Employee_Hierarchy]; 
GO
 
CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Active] ON [EC].[Employee_Hierarchy](Active ASC) 
INCLUDE (Emp_ID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --4.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_K24_K1_K25_K26') 
    DROP INDEX IDX_Employee_Hierarchy_K24_K1_K25_K26 ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_K24_K1_K25_K26] ON [EC].[Employee_Hierarchy](SrMgrLvl1_ID ASC, Emp_ID ASC, SrMgrLvl2_ID ASC, SrMgrLvl3_ID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--5.
 

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_K25_K1_K24_K26') 
    DROP INDEX IDX_Employee_Hierarchy_K25_K1_K24_K26 ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_K25_K1_K24_K26] ON [EC].[Employee_Hierarchy](SrMgrLvl2_ID ASC, Emp_ID ASC, SrMgrLvl1_ID ASC, SrMgrLvl3_ID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --6.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_K26_K1_K24_K25') 
    DROP INDEX IDX_Employee_Hierarchy_K26_K1_K24_K25 ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_K26_K1_K24_K25] ON [EC].[Employee_Hierarchy](SrMgrLvl3_ID ASC, Emp_ID ASC, SrMgrLvl1_ID ASC, SrMgrLvl2_ID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --7.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Mgr_ID') 
    DROP INDEX IDX_Employee_Hierarchy_Mgr_ID ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Mgr_ID] ON [EC].[Employee_Hierarchy](Mgr_ID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --8.

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Site') 
    DROP INDEX IDX_Employee_Hierarchy_Site ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Site] ON [EC].[Employee_Hierarchy](Emp_Site ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --9.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Sup_ID') 
    DROP INDEX IDX_Employee_Hierarchy_Sup_ID ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Sup_ID] ON [EC].[Employee_Hierarchy](Sup_ID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO


--*************************************************************************************

 ---------------------------EmployeeID_To_LanID-----------------------------------------------

--*************************************************************************************

 --1.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_EmployeeID_To_LanID_EmpID') 
    DROP INDEX IDX_EmployeeID_To_LanID_EmpID ON [EC].[EmployeeID_To_LanID]; 
GO


CREATE NONCLUSTERED INDEX [IDX_EmployeeID_To_LanID_EmpID] ON [EC].[EmployeeID_To_LanID](EmpID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO
 

--2.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_EmployeeID_To_LanID_StartDate_EndDate') 
    DROP INDEX IDX_EmployeeID_To_LanID_StartDate_EndDate ON [EC].[EmployeeID_To_LanID]; 
GO

CREATE NONCLUSTERED INDEX [IDX_EmployeeID_To_LanID_StartDate_EndDate] ON [EC].[EmployeeID_To_LanID](StartDate ASC, EndDate ASC) 
INCLUDE (LanID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --3.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_EmployeeID_To_LanID_StartDate_EndDate_2') 
    DROP INDEX IDX_EmployeeID_To_LanID_StartDate_EndDate_2 ON [EC].[EmployeeID_To_LanID]; 
GO


CREATE NONCLUSTERED INDEX [IDX_EmployeeID_To_LanID_StartDate_EndDate_2] ON [EC].[EmployeeID_To_LanID](StartDate ASC, EndDate ASC) 
INCLUDE (EmpID, LanID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 ---------------------------Historical_Dashboard_ACL----------------------------------

--*************************************************************************************

--1.



IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Historical_Dashboard_ACL_Role') 
    DROP INDEX IDX_Historical_Dashboard_ACL_Role ON [EC].[Historical_Dashboard_ACL]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Historical_Dashboard_ACL_Role] ON [EC].[Historical_Dashboard_ACL](Role ASC) 
INCLUDE (Row_ID, End_Date, User_LanID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO


--*************************************************************************************

 ---------------------------Warning_Log----------------------------------

--*************************************************************************************

--1.



IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17') 
    DROP INDEX _dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17 ON [EC].[Warning_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17] ON [EC].[Warning_Log](EmpID ASC) 
INCLUDE (WarningID, FormName, SourceID, StatusID, SubmittedDate, Active)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

 --2.



IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8') 
    DROP INDEX _dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8 ON [EC].[Warning_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8] ON [EC].[Warning_Log](Active ASC, StatusID ASC, SubmittedDate ASC, ModuleID ASC, WarningID ASC, EmpID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO


 --3.


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Warning_Log_StatusID_SiteID') 
    DROP INDEX IDX_Warning_Log_StatusID_SiteID ON [EC].[Warning_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Warning_Log_StatusID_SiteID] ON [EC].[Warning_Log](StatusID ASC, SiteID ASC) 
INCLUDE (EmpID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO


--4.
 
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_Reason_26_1269579561__K1_K4') 
    DROP INDEX _dta_index_Warning_Log_Reason_26_1269579561__K1_K4 ON [EC].[Warning_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_Reason_26_1269579561__K1_K4] ON [EC].[Warning_Log_Reason](WarningID ASC, Value ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO


--5.

 
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_Reason_26_1269579561__K4') 
    DROP INDEX _dta_index_Warning_Log_Reason_26_1269579561__K4 ON [EC].[Warning_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_Reason_26_1269579561__K4] ON [EC].[Warning_Log_Reason](Value ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
GO

--*************************************************************************************

 -------------------------------------------------------------------------

--*************************************************************************************


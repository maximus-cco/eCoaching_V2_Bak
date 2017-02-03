/*
CCO_eCoaching_Common_Indexes_Create.sql(02).sql
Last Modified Date: 1/31/2017
Last Modified By: Susmitha Palacherla


Version 02:
Annual index review. TFS 5353 - 1/30/2017
Added new index #2 for warning_Log table
Added two new indexes #1 and #2 for warning_log_reason table
Replaced index #5 with index from test and added 2 new indexes #9 and #10 on  table Employee_Hierarchy 
Added 1 new index on AT_Coaching_Inactivate_Reactivate_Audit

Version 01:
Document Initial Revision - TFS 5223 - 1/18/2017

**************************************************************

--Index List by Table

**************************************************************


-- Coaching_Log
1. IDX_Coaching_Log_FormName_submittedDate
2. IDX_Coaching_Log_SubmitterID
3. IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24
4. _dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2
5. _dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2
6. _dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8
7. _dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9
8. _dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24
9. _dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1




-- Coaching_Log_Reason
1. IDX_Coaching_Log_Reason_Value
2. _dta_index_Coaching_Log_Reason_26_1269579561__K1_K4



-- Warning_Log
1. _dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8
2. _dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17

-- Warning_Log_Reason
1. _dta_index_Warning_Log_Reason_26_1269579561__K4
2. _dta_index_Warning_Log_Reason_26_1269579561__K1_K4



-- DIM_Date
1. _dta_index_DIM_Date_26_613577224__K1_2


-- Employee_Hierarchy
1. IDX_Employee_Hierarchy_Emp_LANID
2. IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names
3. IDX_Employee_Hierarchy_Sup_ID
4. IDX_Employee_Hierarchy_Mgr_ID
5. _dta_index_Employee_Hierarchy_31_133575514__K1_K2_K10_K16
6. _dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26
7. _dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25
8. _dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26
9. _dta_index_Employee_Hierarchy_26_K22_K5_K4_K6_K2_3_7_10_11_12_14_16_17_18_20
10._dta_index_Employee_Hierarchy_26_846626059__K1_K2_K10_4_9_15


-- AT_Coaching_Inactivate_Reactivate_Audit
1. _dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4


**************************************************************

--Index Creates

**************************************************************/

	


-- 1. Coaching_Log - IDX_Coaching_Log_FormName_submittedDate


--old cl 1

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_FormName_SubmittedDate') 
    DROP INDEX IDX_Coaching_Log_FormName_SubmittedDate ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_FormName_submittedDate] ON [EC].[Coaching_Log]
     (
     [FormName]ASC, [SubmittedDate] ASC
     )
      WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--*************************************************************************

-- 2. Coaching_Log - IDX_Coaching_Log_SubmitterID

--old cl 2

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_SubmitterID') 
    DROP INDEX [IDX_Coaching_Log_SubmitterID]
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_SubmitterID] ON [EC].[Coaching_Log]
     (
	[SubmitterID] ASC
     )
   INCLUDE ([FormName], [StatusID], [EmpID], [SubmittedDate])
      WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




--*************************************************************************

-- 3. Coaching_Log - IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24

--old cl 3

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24') 
    DROP INDEX IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24 
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_K6_K1_K4_K5_K9_K8_K24] ON [EC].[Coaching_Log] 
(
	[SiteID] ASC,
	[CoachingID] ASC,
	[SourceID] ASC,
	[StatusID] ASC,
	[SubmitterID] ASC,
	[EmpID] ASC,
	[SubmittedDate] ASC
	)
INCLUDE ([FormName])
WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--*************************************************************************

-- 4. Coaching_Log - _dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2



--old cl 4

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2') 
    DROP INDEX _dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_28_2105058535__K8_K4_K5_K24_2] ON [EC].[Coaching_Log] 
(
	[EmpID] ASC,
	[SourceID] ASC,
	[StatusID] ASC,
	[SubmittedDate] ASC
)
INCLUDE ( [FormName]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
GO

--*************************************************************************

-- 5. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2

-- pld cl 5 (set 2 - single return)

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2 
ON [EC].[Coaching_Log]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K8_K56_K43_K53_K36_K5_K24_1_2] ON [EC].[Coaching_Log] 
(
	[EmpID] ASC,
	[ReassignedToID] ASC,
	[MgrID] ASC,
	[ReassignCount] ASC,
	[strReportCode] ASC,
	[StatusID] ASC,
	[SubmittedDate] ASC
)
INCLUDE ( [CoachingID],
[FormName]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--*************************************************************************

-- 6. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8

--sr dash cl 1


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8 
ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K5_K24_K41_1_8] ON [EC].[Coaching_Log] 
(
	[StatusID] ASC,
	[SubmittedDate] ASC,
	[ModuleID] ASC
)
INCLUDE ( [CoachingID],
[EmpID]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--*************************************************************************

-- 7. Coaching_Log - _dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9

--sr dash cl 2

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9') 
    DROP INDEX _dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9 
ON [EC].[Coaching_Log]; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_31_418100530__K5_K8_K24_2_9] ON [EC].[Coaching_Log] 
(
	[StatusID] ASC,
	[EmpID] ASC,
	[SubmittedDate] ASC
)
INCLUDE ( [FormName],
[SubmitterID]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO



--*********************************

-- 8. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24

--sr dash cl 3


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24 
ON [EC].[Coaching_Log] ; 
GO


--comp details

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K41_K5_K32_K1_K8_K4_2_9_24] ON [EC].[Coaching_Log] 
(
	[ModuleID] ASC,
	[StatusID] ASC,
	[CSRReviewAutoDate] ASC,
	[CoachingID] ASC,
	[EmpID] ASC,
	[SourceID] ASC
)
INCLUDE ( [FormName],
[SubmitterID],
[SubmittedDate]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--*********************************

-- 9. Coaching_Log - _dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1

--sr dash cl 4


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1') 
    DROP INDEX _dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1 
ON [EC].[Coaching_Log] ; 
GO


--comp by week

CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_26_1333579789__K5_K32_K41_K8_K1] ON [EC].[Coaching_Log] 
(
	[StatusID] ASC,
	[CSRReviewAutoDate] ASC,
	[ModuleID] ASC,
	[EmpID] ASC,
	[CoachingID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

GO




--****************************************************************

--1. Coaching_Log_Reason - IDX_Coaching_Log_Reason_Value


--old clr 1


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Coaching_Log_Reason_Value') 
    DROP INDEX IDX_Coaching_Log_Reason_Value ON [EC].[Coaching_Log_Reason]; 
GO


CREATE NONCLUSTERED INDEX [IDX_Coaching_Log_Reason_Value] ON [EC].[Coaching_Log_Reason]
     (
     [Value]ASC
     )
     WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--*************************************************************************

--2. Coaching_Log_Reason - _dta_index_Coaching_Log_Reason_26_1269579561__K1_K4

--sr dash clr 2

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4') 
    DROP INDEX _dta_index_Coaching_Log_Reason_26_1269579561__K1_K4 
ON [EC].[Coaching_Log_Reason] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Coaching_Log_Reason_26_1269579561__K1_K4] ON [EC].[Coaching_Log_Reason] 
(
	[CoachingID] ASC,
	[Value] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--****************************************************************

--1. Warning_Log - _dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8



IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8') 
    DROP INDEX _dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8 
ON [EC].[Warning_Log] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_26_1828201563__K17_K5_K15_K16_K1_K8] ON [EC].[Warning_Log] 
(
	[Active] ASC,
	[StatusID] ASC,
	[SubmittedDate] ASC,
	[ModuleID] ASC,
	[WarningID] ASC,
	[EmpID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--*************************************************************************

--2. Warning_log -  _dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17') 
    DROP INDEX _dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17 
ON [EC].[Warning_Log] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_2_846626059__K8_1_2_4_5_9_17] ON [EC].[Warning_Log] 
(
	[EmpID ASC
)
INCLUDE ( [WarningID],
[FormName],
[SourceID],
[StatusID],
[SubmittedDate],
[Active]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


--*************************************************************************

--1. Warning_Log_Reason - _dta_index_Warning_Log_Reason_26_1269579561__K4


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_Reason_26_1269579561__K4') 
    DROP INDEX _dta_index_Warning_Log_Reason_26_1269579561__K4 ON [EC].[Warning_Log_Reason] 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_Reason_26_1269579561__K4] ON [EC].[Warning_Log_Reason]
     (
     [Value]ASC
     )
     WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--*************************************************************************

--2. Warning_Log_Reason - _dta_index_Warning_Log_Reason_26_1269579561__K1_K4


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Warning_Log_Reason_26_1269579561__K1_K4') 
    DROP INDEX _dta_index_Warning_Log_Reason_26_1269579561__K1_K4 
ON [EC].[Warning_Log_Reason] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Warning_Log_Reason_26_1269579561__K1_K4] ON [EC].[Warning_Log_Reason] 
(
	[WarningID] ASC,
	[Value] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--****************************************************************


--1. DIM_Date - _dta_index_DIM_Date_26_613577224__K1_2


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_DIM_Date_26_613577224__K1_2') 
    DROP INDEX _dta_index_DIM_Date_26_613577224__K1_2 
ON [EC].[DIM_Date] ; 
GO



CREATE NONCLUSTERED INDEX [_dta_index_DIM_Date_26_613577224__K1_2] ON [EC].[DIM_Date] 
(
	[DateKey] ASC
)
INCLUDE ( [FullDate]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--****************************************************************

--1. employee_Hierarchy - IDX_Employee_Hierarchy_Emp_LANID

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Emp_LANID') 
    DROP INDEX IDX_Employee_Hierarchy_Emp_LANID ON [EC].[Employee_Hierarchy]; 
GO
CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Emp_LANID] ON [EC].[Employee_Hierarchy]
     (
     [Emp_LANID]ASC
     )
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--*************************************************************************


--2. employee_Hierarchy - IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names') 
    DROP INDEX IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names ON [EC].[Employee_Hierarchy]; 
GO
CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Emp_Sup_Mgr_Names] ON [EC].[Employee_Hierarchy]
     (
	[Emp_Name] ASC,
	[Sup_Name] ASC,
	[Mgr_Name] ASC   
      )
     INCLUDE ([Emp_ID])
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--*************************************************************************

--3. employee_Hierarchy - IDX_Employee_Hierarchy_Sup_ID


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Sup_ID') 
    DROP INDEX IDX_Employee_Hierarchy_Sup_ID ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Sup_ID] ON [EC].[Employee_Hierarchy]
     (
     [Sup_ID]ASC
     )
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--*************************************************************************


--4. employee_Hierarchy - IDX_Employee_Hierarchy_Mgr_ID


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'IDX_Employee_Hierarchy_Mgr_ID') 
    DROP INDEX IDX_Employee_Hierarchy_Mgr_ID ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [IDX_Employee_Hierarchy_Mgr_ID] ON [EC].[Employee_Hierarchy]
     (
     [Mgr_ID]ASC
     )
          WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--****************************************************************





--5. employee_Hierarchy - _dta_index_Employee_Hierarchy_31_133575514__K1_K2_K10_K16

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_31_133575514__K1_K2_K10_K16') 
    DROP INDEX _dta_index_Employee_Hierarchy_31_133575514__K1_K2_K10_K16 ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_31_133575514__K1_K2_K10_K16] ON [EC].[Employee_Hierarchy] 
(
	[Emp_ID] ASC,
	[Emp_Name] ASC,
	[Sup_Name] ASC,
	[Mgr_Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




--****************************************************************


--6. employee_Hierarchy - _dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26
ON [EC].[Employee_Hierarchy] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K24_K1_K25_K26] ON [EC].[Employee_Hierarchy] 
(
	[SrMgrLvl1_ID] ASC,
	[Emp_ID] ASC,
	[SrMgrLvl2_ID] ASC,
	[SrMgrLvl3_ID] ASC

	
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO


--****************************************************************



--7. employee_Hierarchy - _dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25 
ON [EC].[Employee_Hierarchy] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K26_K1_K24_K25] ON [EC].[Employee_Hierarchy] 
(
	[SrMgrLvl3_ID] ASC,
	[Emp_ID] ASC,
	[SrMgrLvl1_ID] ASC,
	[SrMgrLvl2_ID] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
--****************************************************************



--8. employee_Hierarchy - 
IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26 
ON [EC].[Employee_Hierarchy] ; 
GO


CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K25_K1_K24_K26] ON [EC].[Employee_Hierarchy] 
(
	[SrMgrLvl2_ID] ASC,
	[Emp_ID] ASC,
	[SrMgrLvl1_ID] ASC,
	[SrMgrLvl3_ID] ASC
	
	
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO

--****************************************************************



--9. employee_Hierarchy - _dta_index_Employee_Hierarchy_26_K22_K5_K4_K6_K2_3_7_10_11_12_14_16_17_18_20

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_K22_K5_K4_K6_K2_3_7_10_11_12_14_16_17_18_20') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_K22_K5_K4_K6_K2_3_7_10_11_12_14_16_17_18_20 ON [EC].[Employee_Hierarchy]; 
GO

CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_K22_K5_K4_K6_K2_3_7_10_11_12_14_16_17_18_20] ON [EC].[Employee_Hierarchy] 
(
	[End_Date] ASC,
	[Emp_Site] ASC,
	[Emp_LanID] ASC,
	[Emp_Job_Code] ASC,
	[Emp_Name] ASC
)
INCLUDE ( [Emp_Email],
[Emp_Job_Description],
[Sup_Name],
[Sup_Email],
[Sup_LanID],
[Sup_Job_Description],
[Mgr_Name],
[Mgr_Email],
[Mgr_LanID],
[Mgr_Job_Description]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]



--****************************************************************

--10. employee_Hierarchy - _dta_index_Employee_Hierarchy_26_846626059__K1_K2_K10_4_9_15

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_Employee_Hierarchy_26_846626059__K1_K2_K10_4_9_15') 
    DROP INDEX _dta_index_Employee_Hierarchy_26_846626059__K1_K2_K10_4_9_15 ON [EC].[Employee_Hierarchy]
GO

CREATE NONCLUSTERED INDEX [_dta_index_Employee_Hierarchy_26_846626059__K1_K2_K10_4_9_15] ON [EC].[Employee_Hierarchy] 
(
	[Emp_ID] ASC,
	[Emp_Name] ASC,
	[Sup_Name] ASC
)
INCLUDE ( [Emp_LanID],
[Sup_ID],
[Mgr_ID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



--****************************************************************


--1. AT_Coaching_Inactivate_Reactivate_Audit - _dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4

IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'_dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4') 
    DROP INDEX _dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4 ON [EC].[AT_Coaching_Inactivate_Reactivate_Audit]
GO

CREATE NONCLUSTERED INDEX [_dta_index_AT_Coaching_Inactivate_Reactivat_26_1435079__K3_K4] ON [EC].[AT_Coaching_Inactivate_Reactivate_Audit] 
(
	[FormName] ASC,
	[LastKnownStatus] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]




--****************************************************************
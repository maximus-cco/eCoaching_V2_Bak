﻿using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace eCoachingLog.Utils
{
	public static class Constants
	{
        public const string TIMEZONE = "EST";

        public static readonly string APP_URL = System.Configuration.ConfigurationManager.AppSettings["App.Url"];

        public const string MAINTENANCE_PAGE = "~/index.html";

		public const string NEW_SBUMISSION = "NewSubmission";
		public const string MY_DASHBOARD = "MyDashboard";
        public const string MY_DASHBOARD_QN = "MyDashboardQn";
        public const string REVIEW = "Review";
		public const string HISTORICAL_DASHBOARD = "HistoricalDashboard";
		public const string UNAUTHORIZED = "Unauthorized";

		//public const string SUBMIT_TICKET_URL = "https://itservicedesk.maximus.com/CherwellPortal/IT?_=43e741d7#0";

		public const int SQL_COMMAND_TIMEOUT = 300; // 5 minutes
		public const int MAX_RECORDS_TO_EXPORT = 20000;

		public const string SITE_EMAIL_SUBJECT = "eCoaching Log";

		public const string USER_ROLE_CSR = "CSR";
		public const string USER_ROLE_ARC = "ARC";
        public const string USER_ROLE_ISG = "ISG";
		//public const string USER_ROLE_RESTRICTED = "Restricted";
		public const string USER_ROLE_SUPERVISOR = "Supervisor";
		public const string USER_ROLE_MANAGER = "Manager";
		// We don't have sr manager role
		// public const string USER_ROLE_SR_MANAGER = "SrManager";
		public const string USER_ROLE_DIRECTOR = "Director";
		public const string USER_ROLE_EMPLOYEE = "Employee";
		public const string USER_ROLE_HR = "HR";
        public const string USER_ROLE_ANALYST = "Analyst";

        public const int PAGE_MY_DASHBOARD = 10;
        public const int PAGE_MY_DASHBOARD_QN = 11;
		public const int PAGE_HISTORICAL_DASHBOARD = 20;
		public const int PAGE_SURVEY = 30;
		public const int PAGE_MY_SUBMISSION = 50;

        // Source
        public const int SOURCE_DIRECT_ASR = 138;
        public const int SOURCE_INDIRECT_ASR = 238;

        // Reason
        public const int REASON_CALL_EFFICIENCY = 55;

        // Sub Reason
        public const int SUBREASON_APPROPRIATE_USE_OF_HOLD = 230;
        public const int SUBREASON_APPROPRIATE_USE_OF_TRANSFER = 328;
        public const int SUBREASON_CALL_DURATION = 329;

        public const string LOG_SEARCH_TYPE_HISTORICAL = "Historical";
		public const string LOG_SEARCH_TYPE_MY_SUBMITTED = "MySubmitted";
		public const string LOG_SEARCH_TYPE_MY_PENDING = "MyPending";
		public const string LOG_SEARCH_TYPE_MY_FOLLOWUP = "MyFollowup";
		public const string LOG_SEARCH_TYPE_MY_COMPLETED = "MyCompleted";
		public const string LOG_SEARCH_TYPE_MY_TEAM_PENDING = "MyTeamPending";
		public const string LOG_SEARCH_TYPE_MY_TEAM_COMPLETED = "MyTeamCompleted";
		public const string LOG_SEARCH_TYPE_MY_TEAM_WARNING = "MyTeamWarning";
        // QN - extra
        public const string LOG_SEARCH_TYPE_MY_PENDING_REVIEW = "MyPendingReview";
        public const string LOG_SEARCH_TYPE_MY_PENDING_FOLLOWUP_REVIEW = "MyPendingFollowupReview";
        public const string LOG_SEARCH_TYPE_MY_PENDING_FOLLOWUP_COACH = "MyPendingFollowupCoach";

        // director dashboard
        public const string LOG_SEARCH_TYPE_MY_SITE_PENDING = "MySitePending";
		public const string LOG_SEARCH_TYPE_MY_SITE_COMPLETED = "MySiteCompleted";
		public const string LOG_SEARCH_TYPE_MY_SITE_WARNING = "MySiteWarning";

		public const string MY_SUBMISSION_FILTER_MANAGER = "Manager";
		public const string MY_SUBMISSION_FILTER_SUPERVISOR = "Supervisor";
		public const string MY_SUBMISSION_FILTER_EMPLOYEE = "Employee";

		public const int ALL_SITES = -1;
        public const int ALL_SITES_SUBCONTRACTOR = -3;
        public const int ALL_SITES_CCO = -4;

        public const string JOB_CODE_CSR_SUPERVISOR = "WACS40";
        public const string JOB_CODE_CSR_MANAGER = "WACS50";
        public const string JOB_CODE_CSR_SR_MANAGER = "WACS60";
        public const string JOB_CODE_QUALITY_SR_SPECIALIST = "WACQ13";
        public const string JOB_CODE_QUALITY_SUPERVISOR = "WACQ40";
        public const string JOB_CODE_PROGRAM_SR_MANAGER = "WPPM50";

        // Users with one of these job codes are allowed for mass submission (CSR coaching logs)
        public static HashSet<string> MASS_SUBMISSION_CSR = new HashSet<string>()
        {
            { "WACS40" },
            { "WACS50" },
            { "WACS60" }
        };

        // Users with one of these job codes are allowed for mass submission (ISG coaching logs)
        public static HashSet<string> MASS_SUBMISSION_ISG = new HashSet<string>()
        {
            { "WACS40" },
            { "WACS50" },
            { "WACS60" }
        };

        // Users with one of these job codes are allowed for mass submission (Supervisor coaching logs)
        public static HashSet<string> MASS_SUBMISSION_SUPERVISOR = new HashSet<string>()
        {
            { "WACS50" },
            { "WACS60" }
        };

        // Users with one of these job codes are allowed for mass submission (Quality coaching logs)
        public static HashSet<string> MASS_SUBMISSION_QUALITY = new HashSet<string>()
        {
            { "WACQ13" },
            { "WACQ40" },
            { "WPPM50" }
        };

        // Users with one of these job codes are allowed for mass submission (Production Planning coaching logs)
        public static HashSet<string> MASS_SUBMISSION_PRODUCTION_PLANNING = new HashSet<string>()
        {
            { "WMPR40" },
            { "WCWF50" },
            { "WPOP60" }
        };

        public const int ALL_STATUSES = -1;

		public const string DIRECT = "Direct";
		public const string INDIRECT = "Indirect";
		
		public const string PENDING = "Pending";
		public const string COMPLETED = "Completed";
		public const string WARNING = "Warning";

		public const string CALL_TYPE_VERINT = "Verint";
		public const string CALL_TYPE_AVOKE = "Avoke";
		public const string CALL_TYPE_UCID = "UCID";
		public const string CALL_TYPE_NGDID = "NGDID";

		public const string LOG_REPORT_CODE_OTHER = "Other";
		public const string LOG_REPORT_CODE_OMRBRL = "OMR/BRL";
		public const string LOG_REPORT_CODE_OMRBRN = "OMR/BRN";
		public const string LOG_REPORT_CODE_OMRIAE = "OMR/IAE";
		public const string LOG_REPORT_CODE_OTHDTT = "OTH/DTT";
        public const string LOG_REPORT_CODE_ASRAHT = "ASR/AHT";
        public const string LOG_REPORT_CODE_ASRHOLD = "ASR/HOLD";
        public const string LOG_REPORT_CODE_ASRTRANSFER = "ASR/TRANSFER";
        public const string LOG_REPORT_CODE_ASRACW = "ASR/ACW";
        public const string LOG_REPORT_CODE_ASRCHAT = "ASR/CHAT";

        public const int MAX_NUMBER_OF_EMPLOYEES_COACHING_PER_SUBMISSION = 100;
        public const int MAX_NUMBER_OF_EMPLOYEES_WARNING_PER_SUBMISSION = 1;
        public const int MAX_NUMBER_OF_COACHING_REASONS = 12;
		public const int WARNING_SOURCE_ID = 120;

		// ec.dim_module table
		public const int MODULE_UNKNOWN = 99999;
		public const int MODULE_CSR = 1;
		public const int MODULE_SUPERVISOR = 2;
		public const int MODULE_QUALITY = 3;
		public const int MODULE_LSA = 4;
		public const int MODULE_TRAINING = 5;
		public const int MODULE_ADMIN = 6;
		public const int MODULE_ANALYTICS_REPORTING = 7;
		public const int MODULE_PRODUCTION_PLANNING = 8;
		public const int MODULE_PROGRAM_ANALYST = 9;
        public const int MODULE_ISG = 10;
		// ec.dim_status table
		// Status IDs
		public const int LOG_STATUS_UNKNOWN = 99999;
		public const int LOG_STATUS_COMPLETED = 1;
		public const int LOG_STATUS_INACTIVE = 2;
		public const int LOG_STATUS_PENDING_ACKNOWLEDGEMENT = 3;
		public const int LOG_STATUS_PENDING_EMPLOYEE_REVIEW = 4;
		public const int LOG_STATUS_PENDING_MANAGER_REVIEW = 5;
		public const int LOG_STATUS_PENDING_SUPERVISOR_REVIEW = 6;
		public const int LOG_STATUS_PENDING_SRMANAGER_REVIEW = 7;
		public const int LOG_STATUS_PENDING_QUALITYLEAD_REVIEW = 8;
		public const int LOG_STATUS_PENDING_DEPUTYPROGRAMMANAGER_REVIEW = 9;
		public const int LOG_STATUS_PENDING_FOLLOWUP = 10;
        public const int LOG_STATUS_PENDING_FOLLOWUP_PREPARATION = 11;
        public const int LOG_STATUS_PENDING_FOLLOWUP_COACHING = 12;
        public const int LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW = 13;
        // Status Description
        public const string LOG_STATUS_UNKNOWN_TEXT = "Unknown";
		public const string LOG_STATUS_COMPLETED_TEXT = "Completed";
		public const string LOG_STATUS_INACTIVE_TEXT = "Inactive";
		public const string LOG_STATUS_PENDING_ACKNOWLEDGEMENT_TEXT = "Pending Acknowledgement";
		public const string LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT = "Pending Employee Review";
		public const string LOG_STATUS_PENDING_MANAGER_REVIEW_TEXT = "Pending Manager Review";
		public const string LOG_STATUS_PENDING_SUPERVISOR_REVIEW_TEXT = "Pending Supervisor Review";
		public const string LOG_STATUS_PENDING_SRMANAGER_REVIEW_TEXT = "Pending Sr. Manager Review";
		public const string LOG_STATUS_PENDING_QUALITYLEAD_REVIEW_TEXT = "Pending Quality Lead Review";
		public const string LOG_STATUS_PENDINGDE_PUTYPROGRAMMANAGER_REVIEW_TEXT = "Pending Deputy Program Manager Review";
		public const string LOG_STATUS_PENDING_SUPERVISOR_FOLLOWUP_TEXT = "Pending Follow-up";
        public const string LOG_STATUS_PENDING_SUPERVISOR_FOLLOWUP_PREPARATION_TEXT = "Pending Follow-up Preparation";
        public const string LOG_STATUS_PENDING_SUPERVISOR_FOLLOWUP_COACHING_TEXT = "Pending Follow-up Coaching";
        public const string LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW_TEXT = "Pending Follow-up Employee Review";

        public const int LOG_STATUS_LEVEL_1 = 1;
		public const int LOG_STATUS_LEVEL_2 = 2;
		public const int LOG_STATUS_LEVEL_3 = 3;
		public const int LOG_STATUS_LEVEL_4 = 4;

        public const string COACHING_REASON_PFD = "Performance, Feedback, and Development (PFD)";

        // ec.dim_source table
        public const int SOURCE_INTERNAL_CCO_REPORTING = 218;
        public const int SOURCE_QN = 235;
        public const int SOURCE_QNS = 236;

        public static readonly List<string> EXCEL_SHEET_NAMES =
            new List<string>() { "eCL", "Short Call eCL", "Quality Now eCL", "Quality Now WebChat", "Quality Now Written Corr" };

        // Start - Workflow section:
        // survey logs - work flow - < current status, next status>
        public static readonly Dictionary<int, string> WORKFLOW_SURVEY = new Dictionary<int, string>
        {
            { LOG_STATUS_PENDING_SUPERVISOR_REVIEW, LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT },
            { LOG_STATUS_PENDING_EMPLOYEE_REVIEW, LOG_STATUS_COMPLETED_TEXT }
        };

        // End - Workflow section

        public static readonly Dictionary<string, string> LogTypeToPageName = new Dictionary<string, string>
		{
			{ "My Pending", "_MyPending" },
			{ "My Follow-up", "_MyFollowup" },
			{ "My Completed", "_MyCompleted" },
			{ "My Submissions", "_MySubmission" },
			{ "My Team's Completed", "_MyTeamCompleted" },
			{ "My Team's Pending", "_MyTeamPending" },
			{ "My Team's Warnings", "_MyTeamWarning" },
        };

        public static readonly Dictionary<string, string> QnLogTypeToPageName = new Dictionary<string, string>
        {
            { "My Pending", "_MyPendingReview" }, // csr/isg, status 4
            { "My Pending Review", "_MyPendingReview" }, // supervisor, status 6
            { "My Pending Follow-up Preparation", "_MyPendingFollowupPrepare" }, 
            { "My Pending Follow-up Coaching", "_MyPendingFollowupCoaching" }, 
            { "My Team's Pending", "_MyTeamPending" },
            { "My Pending Follow-up", "_MyPendingFollowup" },
            { "My Team's Pending Follow-up", "_MyTeamPendingFollowup" },
            { "My Team's Completed", "_MyTeamCompleted" },
            { "My Completed", "_MyCompleted" },
            { "My Submissions", "_MySubmission" }
        };

        public static readonly Dictionary<int, string> Colors = new Dictionary<int, string>
		{
			{ 1, "#2B65EC" },
			{ 2, "#93FFE8" },
			{ 3, "#FFFF00" },
			{ 4, "#F88017" },
			{ 5, "#4E8975" },
			{ 6, "#B93B8F" },
			{ 7, "#7BFF33" },
			{ 8, "#FF0000" },
			{ 9, "#1B3BA6" },
            { 10, "#1B3BA6" },
            { 11, "#1B3BA6" },
            { 12, "#1B3BA6" },
            { 13, "#1B3BA6" },
            { 14, "#1B3BA6" },
            { 15, "#1B3BA6" }
        };

		public static readonly Dictionary<Tuple<int, int>, int> LogStatusLevel = new Dictionary<Tuple<int, int>, int>
		{
			// CSR
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
            { new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
            { new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_MANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_FOLLOWUP), LOG_STATUS_LEVEL_2 },
            { new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_FOLLOWUP_COACHING), LOG_STATUS_LEVEL_2 },
            { new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_FOLLOWUP_PREPARATION), LOG_STATUS_LEVEL_2 },
            // ISG
			{ new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_MANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_FOLLOWUP), LOG_STATUS_LEVEL_2 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_FOLLOWUP_COACHING), LOG_STATUS_LEVEL_2 },
            { new Tuple<int, int>(MODULE_ISG, LOG_STATUS_PENDING_FOLLOWUP_PREPARATION), LOG_STATUS_LEVEL_2 },
			// Supervisor
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_MANAGER_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_SRMANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
			// Quality
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDING_QUALITYLEAD_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDING_DEPUTYPROGRAMMANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
			// LSA
			{ new Tuple<int, int>(MODULE_LSA, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_LSA, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			// Training
			{ new Tuple<int, int>(MODULE_TRAINING, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_TRAINING, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_TRAINING, LOG_STATUS_PENDING_MANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
			{ new Tuple<int, int>(MODULE_TRAINING, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
			// Program Analyst
			{ new Tuple<int, int>(MODULE_PROGRAM_ANALYST, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_PROGRAM_ANALYST, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			// Administration
			{ new Tuple<int, int>(MODULE_ADMIN, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_ADMIN, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			// Analytics Reporting
			{ new Tuple<int, int>(MODULE_ANALYTICS_REPORTING, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_ANALYTICS_REPORTING, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			// Production Planning
			{ new Tuple<int, int>(MODULE_PRODUCTION_PLANNING, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_PRODUCTION_PLANNING, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 }
		};


		// TODO: move to resource file or database
		public const string REVIEW_OTH_APS_TEXT = "Your agent has reached a major attendance milestone with 11 perfect shifts.You are encouraged to validate that the agent indeed earned perfect attendance and verify that the hours have been removed in the Attendance Tracking Tool. And of course, please say thank you to your agent for a job well done. This notification is for your agent and does not apply to your personal attendance. Please refer to the name listed beside the 'employee' field to determine the employee who is receiving this message.";
		public const string REVIEW_OTH_APW_TEXT = "Your agent had perfect attendance during a recent critical week. You are encouraged to validate that the agent indeed earned perfect attendance and verify that the hours have been removed in the Attendance Tracking Tool. And of course, please say thank you to your agent for a job well done. This notification is for your agent and does not apply to your personal attendance. Please refer to the name listed beside the 'employee' field to determine the employee who is receiving this message.";

		public const string REVIEW_OMR_SHORT_CALL_TEXT = "The agent has multiple short calls that exceed the threshold. Please coach the behavior so the agent has fewer short calls.";

		public const string REVIEW_LCSAT = "You are receiving this eCL because you have been assigned to listen to and provide feedback on a call that was identified as having low customer satisfaction. Please " +
			"review the call from a perspective and provide details on the specific opportunities requiring coaching in the record below.";

		public const string REVIEW_TRAINING_SHORT_DURATION_REPORT_TEXT =
			"Agents are scheduled for specific times in WFO to ensure understanding of training materials presented. " +
			"It is important to utilize the timeframe allotted to successfully understand the training content. " +
			"Please be aware that the scheduled timeframe is a metric which has been agreed upon by CCO and CMS. " +
			"You should use all or the majority of the scheduled time to review each eLearning module assigned.";

		public const string REVIEW_TRAINING_OVERDUE_TRAINING_TEXT = "The above training is now overdue. Please have the training completed and provide coaching on the specific reasons it was overdue.";

		public const string REVIEW_QUALITY_HIGH5_CLUB = "Customer satisfaction is critical to our success; therefore, " +
			"to help gauge our performance, every caller is offered the option to complete a Customer Satisfaction (CSAT) survey. " +
			"Using a scale from one to five, callers are able to rate their overall satisfaction. Top box, or a rating of 5, indicates the caller was extremely satisfied!  " +
			"Thank you for taking good care of your callers; you make a difference for each caller AND for the CCO!";

        // KUDO for csr/isg
        public const string REVIEW_QUALITY_KUDO_CSR = "Congratulations - you received a Kudos! Click " +
			"<a href='https://maximus365.sharepoint.com/sites/CCO/Connection/Pages/KudosCentral.aspx' target='_blank'>here</a> " +
			"to take a listen to what a recent caller had to say about your customer service.";
        // no text for subcontractor
        public const string REVIEW_QUALITY_KUDO_CSR_SUBCONTRACTOR = ""; 

        public const string REVIEW_QUALITY_KUDO_SUPERVISOR = "Click <a href='https://maximus365.sharepoint.com/sites/CCO/Connection/Pages/KudosCentral.aspx' target='_blank'>here</a> " +
			"to listen to agent kudos.";
        // no text for subcontractor
        public const string REVIEW_QUALITY_KUDO_SUPERVISOR_SUBCONTRACTOR = "";

        // BRN/BRL
        public const string REVIEW_OMR_BREAK_TIME_EXCEEDED_TEXT = "You are receiving this eCL record because an Employee on your team was identified in a Break Outlier Report. " +
           "Please review the <a href='https://app.powerbi.com/reportEmbed?reportId=787ff793-f449-4dc2-a1ee-e319304ddfa9&autoAuth=true&ctid=b699068d-c14b-454b-a0bc-10918cf075d3&config=eyJjbHVzdGVyVXJsIjoiaHR0cHM6Ly93YWJpLXVzLW5vcnRoLWNlbnRyYWwtYi1yZWRpcmVjdC5hbmFseXNpcy53aW5kb3dzLm5ldC8ifQ%3D%3D' target='_blank'>CSR Dashboard</a>, " +
           "Break Outliers, <b>the ETS entries</b>, and refer to HCSD-POL-HR-MISC-08 Break Time Policy and Break Policy Reference guide for additional information and provide the details in the record below.";
        public const string REVIEW_OMR_BREAK_TIME_EXCEEDED_TEXT_SUBCONTRACTOR = "";

        // Internal CCO Reporting MSR static text
        public const string REVIEW_MSR_INTERNAL_CCO_REPORTING = "To view in full detail, your Supervisor will review your Performance Dashboard with you during your next coaching session. An overview of your scores is also contained within the eCL.";

		// ETS/HNC ETS/ICC
		// Currently this is only for CSRs/ISGs. Data feeds loaded as Pending Supervisor Review.
		// Display this link only for Supervisors
		public const string REVIEW_HNC_ICC = "Click " +
			"<a href='https://maximus365.sharepoint.com/sites/CCO/Initiatives/floorcheck/Timecard_Compliance_Reporting/Timcard%20Changes%20Reports/Forms/AllItems.aspx' target='_blank'>here</a>" +
			" to view the report containing the details of these changes.";
        public const string REVIEW_HNC_ICC_SUBCONTRACTOR = "";

        // CSE form
        public const string REVIEW_CSE = "Review the submitted coaching opportunity and determine if it is a confirmed Customer Service Escalation (CSE).  If it is a CSE, setup a meeting with the Employee and Supervisor and report your coaching in the box below.  If it not a CSE, enter notes for the Supervisor to use to coach the Employee.";

		public const string REVIEW_OMR = "You are receiving this eCL record because an Employee on your team was identified in an Outlier Management Report (OMR). Please research this item in accordance with the latest <a href='https://maximus365.sharepoint.com/sites/CCO/Resources/SOP/Contact%20Center%20Operations/Forms/AllItems.aspx' target='_blank'>" +
								"Contact Center Operations 46.0 Outlier Management Report (OMR): Outlier Research Process SOP</a> and provide the details in the record below.";
        public const string REVIEW_OMR_SUBCONTRACTOR = "You are receiving this eCL record because an Employee on your team was identified in an Outlier Management Report (OMR). Please research this item and provide the details in the record below.";

        public const string REVIEW_ETS_OAE = "You are receiving this eCL record because an Employee on your team was identified on the CCO TC Outstanding Actions report (also known as the TC Compliance Action report).  Please research why the employee did not complete their timecard before the deadline laid out in the latest " +
			"<a href='https://maximus365.sharepoint.com/sites/CCO/Resources/SOP/Contact%20Center%20Operations/Forms/AllItems.aspx' target='_blank'>Contact Center Operations 3.06 Timecard Audit SOP</a> and provide the details in the record below.";
        // no text for subcontractor
        public const string REVIEW_ETS_OAE_SUBCONTRACTOR = "";

        public const string REVIEW_ETS_OAS = "You are receiving this eCL record because a Supervisor on your team was identified on the CCO TC Outstanding Actions report(also known as the TC Compliance Action report).  Please research why the supervisor did not approve Or reject their agent’s timecard before the deadline laid out in the latest " +
			"<a href='https://maximus365.sharepoint.com/sites/CCO/Resources/SOP/Contact%20Center%20Operations/Forms/AllItems.aspx' target='_blank'>Contact Center Operations 3.06 Timecard Audit SOP</a> and provide the details in the record below.";
        // no text for subcontractor
        public const string REVIEW_ETS_OAS_SUBCONTRACTOR = "";

        public const string REVIEW_OMR_PBH = "Be sure to check the Beneficiary Indicators applet on every call. If a message is on file, the agent must follow protocol and review it to determine whether the information is applicable to the beneficiary’s reason for calling. However, the agent must read and follow any messages related to the new Medicare card, regardless of the reason for the call. In addition to reading such messages, the agent must be sure to log them as \"read\" to document that the information has been relayed to the caller." +  
			"<br /><br />" +
			"Remember, it is critical that we follow through with the appropriate action(s) outlined in the agent Notes portion of the Message Details applet. This includes checking and confirming whether the beneficiary’s correct mailing address is on file. Depending on whether the address is correct, the agent will take one of the two following actions:" +
			"<br />" +
			"- If the address is correct, you must order a replacement card for the beneficiary using the \"Medicare Card\" button (even if they don’t think they need one)." +
			"<br />" +
			"- If the address is incorrect, you must refer the beneficiary to the Social Security Administration (SSA) using information in Agent Partner Search." +
			"<br /><br />" +
			"When reviewing this type of message, always take the appropriate steps as directed, regardless of the reason for the call. Failing to do so in these cases will result in the beneficiary not receiving his/her new Medicare card.";

		public const string REVIEW_OMR_IDD = "You are receiving this eCL record because there is a discrepancy in data associated with an employee on your team.  Please review this item in accordance with the latest Contact Center Operations " +
			"<a href='https://maximus365.sharepoint.com/sites/CCO/CCOps/Supervisor/Supervisor%20Job%20Aids/Forms/AllItems.aspx' target='_blank'>Job Aid CCO Incentive Data Discrepancy</a> and provide the details in the record below.";
        public const string REVIEW_OMR_IDD_SUBCONTRACTOR = "";

        public const string ACK_COMMENT_TEXTBOX_LABEL = "Provide any comments or feedback below:";
		public const string ACK_OTA_COMMENT_TEXTBOX_LABEL = "Provide the details from the coaching session including action plans developed:";
		public const string ACK_CHECKBOX_TITLE_GENERAL = "Check the box below to acknowledge the coaching opportunity:";
		public const string ACK_CHECKBOX_TITLE_MONITOR = "Check the box below to acknowledge the monitor:";
		public const string ACK_CHECKBOX_TITLE_OVERTURNED_APPEAL = "Check the box below to acknowledge the monitor:";
		public const string ACK_CHECKBOX_TITLE_FOLLOWUP = "Check the box below to acknowledge the followup:";
		public const string ACK_CHECKBOX_TEXT_GENERAL = "I have read and understand all the information provided on this eCoaching Log.";
		public const string ACK_CHECKBOX_TEXT_OVERTURNED_APPEAL = "By checking this box, I indicate that I have reviewed this appeal and have taken the appropriate actions.";
		public const string ACK_CHECKBOS_TEXT_FOLLOWUP = "I have read and understand all the information provided on this eCoaching Log.";

		// Work From Home (Return to Site Only) HR text
		public const string RETURN_TO_SITE_1 = "<p>CCO employees who participate in the CCO Work From Home are obligated to comply with all Maximus policies and procedures. The purpose of this eCL is to notify you that your CCO Remote Work Agreement is being rescinded.</p>";
		public const string RETURN_TO_SITE_2 = "<p>Effective ";
		public const string RETURN_TO_SITE_2_1 = " you will be required to report to work at the ";
		public const string RETURN_TO_SITE_2_2 = " site. ";
		public const string RETURN_TO_SITE_2_3 = "You will be reporting to ";
		public const string RETURN_TO_SITE_2_4 = ". ";
		public const string RETURN_TO_SITE_2_5 = "Any wages adjustments that were completed based on your remote status and the county you live in will be adjusted to reflect the location you are working and your position.</p>";
		public const string RETURN_TO_SITE_3 = "<p>Any equipment you have received for the Work From Home assignment should be returned to your supervisor on your first day of reporting to the site.</p>";
		public const string RETURN_TO_SITE_4 = "<p>Maximus anticipates that a mutually beneficial employment relationship will continue as you work at the ";
		public const string RETURN_TO_SITE_4_1 = " site.</p>";

        public const string SURVEY = "Please contact your survey point of contact and/or manager with any questions.";

        // stored in table Coaching_Log_StaticText
        //public const string QN_FEEDBACK = "***There is no appeal process for Quality Now, but " +
        //    "<a href='https://maximus365.sharepoint.com/sites/CCO/Support/QA-OPS/Leads/Lists/Quality_NOW_Feedback/NewForm.aspx?Source=https%3a%2f%2fmaximus365.sharepoint.com%2fsites%2fCCO%2fSupport%2fQA-OPS%2fLeads%2fLists%2fQuality_NOW_Feedback%2fMy_Items.aspx%3fviewid%3d9bec3890%252D53e3%252D40f9%252D8dc6%252Df8400e9a4f4d%26OR%3dTeams%252DHL%26CT%3d1681396370842%26clickparams%3deyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyNy8yMzAzMDUwMTExMCIsIkhhc0ZlZGVyYXRlZFVzZXIiOmZhbHNlfQ%253D%253D&ContentTypeId=0x0100E3688E643B7C874CAD85E7C0C4441EFE&RootFolder=%2fsites%2fCCO%2fSupport%2fQA-OPS%2fLeads%2fLists%2fQuality_NOW_Feedback' target='_blank'>feedback</a>" +
        //    " for the Quality Team concerning this batch is welcomed. Please see SOP QA 33.0 for additional guidance.";
        //public const string QN_FEEDBACK_SUBCONTRACTOR = "There is no appeal process for Quality Now, but " +
        //    "<strong>feedback</strong> for the Quality Team concerning this batch is welcomed. Please see <strong>SOP QA 33.0</strong> for additional guidance.";
    }

    public enum EmployeeLogType
	{
		[Description("Coaching")]
		Coaching = 1,

		[Description("Warning")]
		Warning = 2
	}
}
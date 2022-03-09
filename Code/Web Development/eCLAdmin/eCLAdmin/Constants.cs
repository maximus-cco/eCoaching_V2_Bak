using System.ComponentModel;

namespace eCLAdmin
{
	public static class Constants
	{
		public const string MAINTENANCE_PAGE = "~/index.html";

		public const string REPORT_ISSUE_URL = "https://maximus365.sharepoint.com/sites/CCO/Resources/eCoaching/QSS/SitePages/Issue%20Tracker.aspx";

		public const int MODULE_UNKNOWN = -1;
		public const int MODULE_CSR = 1;
		public const int MODULE_SUPERVISOR = 2;
		public const int MODULE_QUALITY = 3;
		public const int MODULE_LSA = 4;
		public const int MODULE_TRAINING = 5;

		public const int LOG_STATUS_UNKNOWN = -1;
		public const int LOG_STATUS_COMPLETED = 1;
		public const int LOG_STATUS_INACTIVE = 2;
		public const int LOG_STATUS_PENDING_ACKNOWLEDGEMENT = 3;
		public const int LOG_STATUS_PENDING_EMPLOYEEREVIEW = 4;
		public const int LOG_STATUS_PENDING_MANAGERREVIEW = 5;
		public const int LOG_STATUS_PENDING_SUPERVISOR_REVIEW = 6;
		public const int LOG_STATUS_PENDING_SRMANAGER_REVIEW = 7;
		public const int LOG_STATUS_PENDING_QUALITYLEAD_REVIEW = 8;
		public const int LOG_STATUS_PENDING_DEPUTYPROGRAMMANAGER_REVIEW = 9;
		public const int LOG_STATUS_PENDING_FOLLOW_UP = 10;
        public const int LOG_STATUS_PENDING_FOLLOW_UP_PREPARATION = 11;
        public const int LOG_STATUS_PENDING_FOLLOW_UP_COACHING = 12;

        public const string LOG_ACTION_INACTIVATE = "Inactivate";
		public const string LOG_ACTION_REASSIGN = "Reassign";
		public const string LOG_ACTION_REACTIVATE = "Reactivate";

		public const string EMAIL_SUBJECT_REACTIVATION = "eCoaching Log(s) Reactivated";
		public const string EMAIL_SUBJECT_REASSIGNMENT = "eCoaching Log(s) Reassigned";
		public const string EMAIL_FROM = "ecl.admin@maximus.com";

		public const int USER_ROLE_ADMIN = 101;
		public const int USER_ROLE_MANAGER = 102;

		public const string ENTITLEMENT_MANAGE_COACHING_LOGS = "ManageCoachingLogs";
		public const string ENTITLEMENT_MANAGE_WARNING_LOGS = "ManageWarningLogs";
		public const string ENTITLEMENT_REACTIVATE_COACHING_LOGS = "ReactivateCoachingLogs";
		public const string ENTITLEMENT_REACTIVATE_WARNING_LOGS = "ReactivateWarningLogs";

		public const string ECOACHING_URL_PROD = "https://UVAAPADWEB50CCO.ad.local/ecl";
		public const string ECOACHING_URL_UAT = "https://UVAADADWEB50CCO.ad.local/ecl_uat";
		public const string ECOACHING_URL_ST = "https://UVAADADWEB50CCO.ad.local/ecl_test";
		public const string ECOACHING_URL_DEV = "https://UVAADADWEB50CCO.ad.local/ecl_dev";

		// Reports
		public const string REPORT_TEMPLATE = "ReportTemplate";
		public const string COACHING_SUMMARY_REPORT_NAME = "CoachingSummary";
		public const string COACHING_SUMMARY_REPORT_DESCRIPTION = "Coaching Log Summary";
		public const string COACHING_QUALITY_NOW_SUMMARY_REPORT_NAME = "CoachingSummaryQN";
		public const string COACHING_QUALITY_NOW_SUMMARY_REPORT_DESCRIPTION = "Quality Now Coaching Log Summary";
		public const string WARNING_SUMMARY_REPORT_NAME = "WarningSummary";
		public const string WARNING_SUMMARY_REPORT_DESCRIPTION = "Warning Log Summary";
		public const string HIERARCHY_SUMMARY_REPORT_NAME = "HierarchySummary";
		public const string HIERARCHY_SUMMARY_REPORT_DESCRIPTION = "Hierarchy Summary";
		public const string ADMIN_ACTIVITY_REPORT_NAME = "AdminActivitySummary";
		public const string ADMIN_ACTIVITY_REPORT_DESCRIPTION = "Admin Activity Summary";

		// For eCoaching Access Control
		// Role ECL
		public const string ECOACHING_ACCESS_ROLE_ECL = "ECL";
		public const string ECOACHING_ACCESS_ROLE_ECL_DESCRIPTION = "ECL";
		// Role ARC
		public const string ECOACHING_ACCESS_ROLE_ARC = "ARC";
		public const string ECOACHING_ACCESS_ROLE_ARC_DESCRIPTION = "ARC";
		// Duplicate record
		public const int DUPLICATE_RECORD = -2627;
		// End date 
		public const string ECOACHING_ACCESS_END_DATE = "99991231";
	}

	public enum EmployeeLogType
	{
		[Description("Coaching")]
		Coaching = 1,

		[Description("Warning")]
		Warning = 2
	}

	public enum EmailType
	{
		[Description("Reactivate Employee Logs")]
		Reactivation = 1,

		[Description("Reassign Employee Logs")]
		Reassignment = 2
	}
}
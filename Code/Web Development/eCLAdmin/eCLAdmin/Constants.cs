using System.ComponentModel;

namespace eCLAdmin
{
    public static class Constants
    {
        public const int LOG_STATUS_UNKNOWN = -1;
        public const int LOG_STATUS_COMPLETED = 1;
        public const int LOG_STATUS_INACTIVE = 2;
        public const int LOG_STATUS_PENDING_ACKNOWLEDGEMENT = 3;
        public const int LOG_STATUS_PENDING_EMPLOYEEREVIEW = 4;
        public const int LOG_STATUS_PENDING_MANAGERREVIEW = 5;
        public const int LOG_STATUS_PENDING_SUPERVISOR_REVIEW = 6;
        public const int LOG_STATUS_PENDING_SRMANAGER_REVIEW = 7;
        public const int LOG_STATUS_PENDING_QUALITYLEAD_REVIEW = 8;
        public const int LOG_STATUS_PENDINGDE_PUTYPROGRAMMANAGER_REVIEW = 9;

        public const string LOG_ACTION_INACTIVATE = "Inactivate";
        public const string LOG_ACTION_REASSIGN = "Reassign";
        public const string LOG_ACTION_REACTIVATE = "Reactivate";

        public const string EMAIL_SUBJECT_REACTIVATION = "eCoaching Log(s) Reactivated";
        public const string EMAIL_SUBJECT_REASSIGNMENT = "eCoaching Log(s) Reassigned";
        public const string EMAIL_FROM = "ecl.admin@gdit.com";
        public const string SMTP_CLIENT = "smtpout.gdit.com";

        public const int USER_ROLE_ADMIN = 101;
        public const int USER_ROLE_MANAGER = 102;

        public const string ENTITLEMENT_MANAGE_COACHING_LOGS = "ManageCoachingLogs";
        public const string ENTITLEMENT_MANAGE_WARNING_LOGS = "ManageWarningLogs";

        public const string WEB_SERVER_NAME_PROD = "f3420-mwbp11.vangent.local";
        public const string WEB_SERVER_NAME_ST = "f3420-mpmd01.vangent.local";
        public const string ECOACHING_URL_PROD = "https://f3420-mwbp11.vangent.local/coach/default.aspx";
        public const string ECOACHING_URL_ST = "https://f3420-mpmd01.vangent.local/coach3/default.aspx";
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
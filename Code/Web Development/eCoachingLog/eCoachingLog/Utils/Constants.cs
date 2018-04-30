using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace eCoachingLog.Utils
{
    public static class Constants
    {
		public const string DIRECT = "Direct";
		public const string INDIRECT = "Indirect";

		public const string CALL_TYPE_VERINT = "Verint";
		public const string CALL_TYPE_AVOKE = "Avoke";
		public const string CALL_TYPE_UCID = "UCID";
		public const string CALL_TYPE_NGDID = "NGDID";

		public const int MAX_NUMBER_OF_COACHING_REASONS = 12;

		// ec.dim_module table
		public const int MODULE_UNKNOWN = -1;
        public const int MODULE_CSR = 1;
        public const int MODULE_SUPERVISOR = 2;
        public const int MODULE_QUALITY = 3;
        public const int MODULE_LSA = 4;
        public const int MODULE_TRAINING = 5;
		public const int MODULE_ADMIN = 6;
		public const int MODULE_ANALYTICS_REPORTING = 7;
		public const int MODULE_PRODUCTION_PLANNING = 8;
		public const int MODULE_PROGRAM_ANALYST = 9;

		public const int LOG_STATUS_UNKNOWN = -1;
        public const int LOG_STATUS_COMPLETED = 1;
        public const int LOG_STATUS_INACTIVE = 2;
        public const int LOG_STATUS_PENDING_ACKNOWLEDGEMENT = 3;
        public const int LOG_STATUS_PENDING_EMPLOYEE_REVIEW = 4;
        public const int LOG_STATUS_PENDING_MANAGER_REVIEW = 5;
        public const int LOG_STATUS_PENDING_SUPERVISOR_REVIEW = 6;
        public const int LOG_STATUS_PENDING_SRMANAGER_REVIEW = 7;
        public const int LOG_STATUS_PENDING_QUALITYLEAD_REVIEW = 8;
        public const int LOG_STATUS_PENDINGDE_PUTYPROGRAMMANAGER_REVIEW = 9;

		public const int LOG_STATUS_LEVEL_1 = 1;
		public const int LOG_STATUS_LEVEL_2 = 2;
		public const int LOG_STATUS_LEVEL_3 = 3;
		public const int LOG_STATUS_LEVEL_4 = 4;

        public const string ECOACHING_URL_PROD = "https://f3420-mwbp11.vangent.local/coach/default.aspx";
        public const string ECOACHING_URL_ST = "https://f3420-mpmd01.vangent.local/coach3/default.aspx";

        public const string SITE_ADMIN_EMAIL = "CCO Quality<CCOQuality@gdit.com>";
        public const string SITE_EMAIL_SUBJECT = "Dashboard and Manage Employee Logs";

		// Dictionary<<moduleId, statusId>, statusLevel>
		public static readonly Dictionary<Tuple<int, int>, int> LogStatusLevel = new Dictionary<Tuple<int, int>, int>
		{
			// CSR
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_SUPERVISOR_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_MANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
			{ new Tuple<int, int>(MODULE_CSR, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
			// Supervisor
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_MANAGER_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_SRMANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
			{ new Tuple<int, int>(MODULE_SUPERVISOR, LOG_STATUS_PENDING_ACKNOWLEDGEMENT), LOG_STATUS_LEVEL_4 },
			// Quality
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDING_EMPLOYEE_REVIEW), LOG_STATUS_LEVEL_1 },
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDING_QUALITYLEAD_REVIEW), LOG_STATUS_LEVEL_2 },
			{ new Tuple<int, int>(MODULE_QUALITY, LOG_STATUS_PENDINGDE_PUTYPROGRAMMANAGER_REVIEW), LOG_STATUS_LEVEL_3 },
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
	}

    public enum UserRole
    {
        Manager = 1,
        Supervisor = 2,
        Employee = 3,
        Other = 4,
        Unknown = 5
    }

    public enum EmployeeLogType
    {
        [Description("Coaching")]
        Coaching = 1,

        [Description("Warning")]
        Warning = 2
    }

	public enum EmployeeTitle
	{
		Director = 1,
		Manager = 2,
		Supervisor = 3,
		Employee = 4,
		Other = 5,
	}

	//public enum LogSection
	//{
	//	Employee_MyPending,
	//	Employee_MyCompleted,
	//	Supervisor_MyPending,
	//	Supervisor_MyCompleted,
	//	Supervisor_MyTeamPending,
	//	Supervisor_MyTeamCompleted,
	//	Supervisor_MyTeamWarning,
	//	Manager_MyPending,
	//	Manager_MyCompleted,
	//	Manager_MyTeamPending,
	//	Manager_MyTeamCompleted,
	//	Manager_MyTeamWarning
	//}
}
using eCoachingLog.Utils;
using System;

namespace eCoachingLog.Models.Common
{
	public class LogFilter
    {
		public string LogType { get; set; }

		public UserRole UserRole { get; set; }

		public int SiteId { get; set; }
		public string ManagerId { get; set; }
		public string SupervisorId { get; set; }
        public string EmployeeId { get; set; }
		public string SubmitterId { get; set; }
		public int StatusId { get; set; }
        public int SourceId { get; set; }
		public string ValueId { get; set; }

		// Warning specific
		public bool IsActive { get; set; }

		// Get employees who is active or inactive, or both
		// 1 - active, 2 - inactive, 3 - both
		public int ActiveEmployee { get; set; }
		public string SubmitDateFrom { get; set; }
		public string SubmitDateTo { get; set; }

		public LogFilter()
		{
			this.LogType = string.Empty;
			this.SiteId = -2;
			this.SourceId = -1;
			this.EmployeeId = "-2";
			this.SupervisorId = "-2";
			this.ManagerId = "-2";
			this.SubmitterId = "-1";
			this.SubmitDateFrom = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy");
			this.SubmitDateTo = DateTime.Now.ToString("MM/dd/yyyy");
			this.StatusId = -1;
			this.ValueId = "-1";

			this.ActiveEmployee = 1;
		}
	}
}
using System;

namespace eCoachingLog.Models.Common
{
	public class LogFilter
    {
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
			this.SiteId = -2;
			this.SourceId = -1;
			this.EmployeeId = "-2";
			this.SupervisorId = "-2";
			this.ManagerId = "-2";
			this.SubmitterId = "-1";
			this.SubmitDateFrom = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
			this.SubmitDateTo = DateTime.Now.ToString("yyyy-MM-dd");
			this.StatusId = -1;
			this.ValueId = "-1";

			this.ActiveEmployee = 1;
		}
	}
}
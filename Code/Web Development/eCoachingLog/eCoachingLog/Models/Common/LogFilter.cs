using eCoachingLog.Utils;
using System;

namespace eCoachingLog.Models.Common
{
	public class LogFilter
    {
		public string LogType { get; set; }
		public string UserRole { get; set; }

        public bool IsBothQnNonQn { get; set; }

		public string SiteName { get; set; }

		public int SiteId { get; set; }
		public string ManagerId { get; set; }
		public string SupervisorId { get; set; }
        public string EmployeeId { get; set; }
		public string SubmitterId { get; set; }
		public int StatusId { get; set; }
        public int SourceId { get; set; }
        public int ReasonId { get; set; }
        public string ReasonText { get; set; }
        public int SubReasonId { get; set; }
        public string SubReasonText { get; set; }
		public string ValueId { get; set; }
		// Warning specific
		public bool IsActive { get; set; }

		// Get employees who is active or inactive, or both
		// 1 - active, 2 - inactive, 3 - both
		public int ActiveEmployee { get; set; }
		public string SubmitDateFrom { get; set; }
		public string SubmitDateTo { get; set; }

		// Datatables column show/hide
		public bool ShowSupNameColumn { get; set; }
		public bool ShowFollowupDateColumn { get; set; }

		public int PageSize { get; set; }

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
			this.ShowSupNameColumn = true;
			// Display followup date column always even though only CSR logs need followup
			// since under a supervisor pending list, there might be CSR logs and the supervisor's own logs;
			this.ShowFollowupDateColumn = false;
			this.PageSize = 25;

            this.ReasonId = -1;
            this.SubReasonId = -1;
		}
	}
}
using System;
using System.Collections.Generic;

namespace eCoachingLog.Models.Common
{
	public class BaseLogDetail
    {
        public long LogId { get; set; }
        public string FormName { get; set; }
        public string Source { get; set; }
		public int StatusId { get; set; }
        public string Status { get; set; }
        public string Type { get; set; }
        public string EmployeeName { get; set; }
		public string EmployeeId { get; set; }
        public string EmployeeSite { get; set; }
        public string SupervisorName { get; set; }
		public string SupervisorEmail { get; set; }
        public string ManagerName { get; set; }
		public string ManagerEmail { get; set; }
        public string SubmitterName { get; set; }
		public string SubmitterEmpId { get; set; }
        public string CreatedDate { get; set; } // SubmittedDate
        public string EventDate { get; set; } // Date happened

		public string SupervisorEmpId { get; set; }
		public string ManagerEmpId { get; set; }
		public string LogManagerEmpId { get; set; } // manager when the log was submitted

        public List<LogReason> Reasons { get; set; }
        //public string Reasons { get; set; }
        //public string SubReasons { get; set; }
        //public string Value { get; set; }

        public bool IsTypeDirect
        {
            get
            {
                return String.IsNullOrWhiteSpace(Type) ? false : "Direct".Equals(Type.Trim(), StringComparison.OrdinalIgnoreCase);
            }
        }

		public BaseLogDetail()
		{
			this.LogId = -1;
			this.FormName = String.Empty;
			// ...
			this.Reasons = new List<LogReason>();
		}
    }
}
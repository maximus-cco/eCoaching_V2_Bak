using System;

namespace eCoachingLog.Models.Common
{
	public class LogFilter
    {
		// TODO: update to use int for IDs
		public string SiteId { get; set; }
		public string ManagerId { get; set; }
		public string SupervisorId { get; set; }
        public string EmployeeId { get; set; }
		public string SubmitterId { get; set; }
		public string StatusId { get; set; }
        public string SourceId { get; set; }
		public string ValueId { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
		// Warning specific
		public bool IsActive { get; set; }

		public LogFilter()
		{
			//this.SupervisorId = "-1";
			//this.EmployeeId = "-1";
			//this.SourceId = "-1";
			//this.StartDate = null;
			//this.EndDate = null;

			this.SourceId = "%";
			this.SiteId = "%";
			this.EmployeeId = "%";
			this.SupervisorId = "%";
			this.ManagerId = "%";
			this.SubmitterId = "%";
			this.StartDate = Convert.ToDateTime("4/1/2108");
			this.EndDate = Convert.ToDateTime("4/9/2108");
			this.StatusId = "%";
			this.ValueId = "%";
		}
	}
}
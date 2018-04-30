using eCoachingLog.Models.Common;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.ViewModels
{
	public class BaseViewModel
	{
		public int? SiteId { get; set; }
		public IEnumerable<SelectListItem> SiteSelectList { get; set; }

		public Employee Manager { get; set; }
		public IEnumerable<SelectListItem> ManagerSelectList { get; set; }
		public IEnumerable<Employee> ManagerList { get; set; }

		public Employee Supervisor { get; set; }
		public IEnumerable<SelectListItem> SupervisorSelectList { get; set; }
		public IEnumerable<Employee> SupervisorList { get; set; }

		public Employee Employee { get; set; }
		public IEnumerable<SelectListItem> EmployeeSelectList { get; set; }
		public IEnumerable<Employee> EmployeeList { get; set; }

		public Employee Submitter { get; set; }
		public IEnumerable<SelectListItem> SubmitterSelectList { get; set; }
		public IEnumerable<Employee> SubmitterList { get; set; }

		public LogStatus LogStatus { get; set; }
		public IEnumerable<SelectListItem> LogStatusSelectList { get; set; }
		public IEnumerable<LogStatus> LogStatusList { get; set; }

		public LogSource LogSource { get; set; }
		public IEnumerable<SelectListItem> LogSourceSelectList { get; set; }
		public IEnumerable<LogStatus> LogSourceList { get; set; }

		public LogValue LogValue { get; set; }
		public IEnumerable<SelectListItem> LogValueSelectList { get; set; }
		public IEnumerable<LogStatus> LogValueList { get; set; }

		public LogFilter Search { get; set; }

		public BaseViewModel()
		{
			this.SiteId = -2;
			this.SiteSelectList = new List<SelectListItem>();
			this.Manager = new Employee();
			this.ManagerSelectList = new List<SelectListItem>();
			this.Supervisor = new Employee();
			this.SupervisorSelectList = new List<SelectListItem>();
			this.Employee = new Employee();
			this.EmployeeSelectList = new List<SelectListItem>();
			this.Submitter = new Employee();
			this.SubmitterSelectList = new List<SelectListItem>();
			this.LogStatus = new LogStatus();
			this.LogStatusSelectList = new List<SelectListItem>();
			this.LogSource = new LogSource();
			this.LogSourceSelectList = new List<SelectListItem>();
			this.LogValue = new LogValue();
			this.LogValueSelectList = new List<SelectListItem>();
			this.Search = new LogFilter();
		}
	}
}
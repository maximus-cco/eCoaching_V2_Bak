using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.ViewModels
{
	public class MyDashboardViewModel : BaseViewModel
	{
        // TODO: wrap them in User
        public User User { get; set; }
        //public string UserId { get; set; }
        //      public string UserLanId { get; set; }

        public int MyTotalPending { get; set; }
		public IList<LogCount> LogCountList { get; set; }
		public IList<LogCountForSite> LogCountForSiteList { get; set; }

		// Search (from director)
		public int LogStatusId { get; set; }

		public bool IsCoaching { get; set; }
		public bool IsWarning { get; set; }
		public int LogCategory { get; set; }

		// Search (for Manager, Supervisor and other)
		public string SupervisorId { get; set; }
        public string EmployeeId { get; set; }
		public string SourceId { get; set; }
		public IEnumerable<SelectListItem> SourceSelectList { get; set; }

		public IEnumerable<SelectListItem> WarningStatusSelectList { get; set; }

		// For Director
		private string selectedMonthYear;
		public string SelectedMonthYear
		{
			get
			{
				return DateTime.Now.ToString("MMMM yyyy");
			}
			set
			{
				selectedMonthYear = value;
			}
		}

		public IEnumerable<SelectListItem> Months
		{
			get
			{
				var now = DateTime.Now;
				var last12Months = Enumerable.Range(0, 12).Select(i => now.AddMonths(-i).ToString("MMMM yyyy"));

				return last12Months.Select(
					month => new SelectListItem
					{
						Text = month,
						Value = Convert.ToDateTime(month).ToString("MMM yyyy", System.Globalization.CultureInfo.InvariantCulture)
					});
			}
		}

		// To control how the bar chart displays
		// Either by site or by status
		public bool IsChartBySite { get; set; }

		public MyDashboardViewModel()
        {
			this.LogCountList = new List<LogCount>();
			this.LogCountForSiteList = new List<LogCountForSite>();

			this.Search.ManagerId = "-1";  // Default to All
			this.Search.SupervisorId = "-1"; // Default to All
			this.Search.EmployeeId = "-1"; // Default to All
			this.LogStatusSelectList = new List<SelectListItem>();
            this.SupervisorSelectList = new List<SelectListItem>();
            this.EmployeeSelectList = new List<SelectListItem>();
			this.SourceSelectList = new List<SelectListItem>();
			this.WarningStatusSelectList = new List<SelectListItem>();
		}

        public MyDashboardViewModel(User user) : this()
        {
            this.User = user;
			this.Search.UserRole = user.Role;
        }
	}
}
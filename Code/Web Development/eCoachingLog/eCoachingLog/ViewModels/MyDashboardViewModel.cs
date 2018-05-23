using eCoachingLog.Models.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.ViewModels
{
	public class MyDashboardViewModel : BaseViewModel
	{
		// TODO: wrap them in User
		// public User User { get; set; }
		public string UserId { get; set; }
        public string UserLanId { get; set; }

		// my team size 
		// if my team size is 1, then no one reports to the user
		// so only display "My Pending" and "My Completed";
		// otherwise, display team counts/list as well.
		public int MyTeamSize { get; set; }

		public int MyTotalPending { get; set; }
		public IList<LogCount> LogCountList { get; set; }
		public IList<LogCountForSite> LogCountForSiteList { get; set; }

		// Search (from director)
		public int LogStatusId { get; set; }
		//public IEnumerable<SelectListItem> LogStatusSelectList { get; set; }

		public bool IsCoaching { get; set; }
		public bool IsWarning { get; set; }

		// Search (for Manager, Supervisor and other)
		public string SupervisorId { get; set; }
        public string EmployeeId { get; set; }
		public string SourceId { get; set; }
        //public IEnumerable<SelectListItem> SupervisorSelectList { get; set; }
        //public IEnumerable<SelectListItem> EmployeeSelectList { get; set; }
		public IEnumerable<SelectListItem> SourceSelectList { get; set; }

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

		public MyDashboardViewModel()
        {
			this.LogCountList = new List<LogCount>();
			this.LogCountForSiteList = new List<LogCountForSite>();

			this.Search = new LogFilter();
			this.LogStatusSelectList = new List<SelectListItem>();
            this.SupervisorSelectList = new List<SelectListItem>();
            this.EmployeeSelectList = new List<SelectListItem>();
			this.SourceSelectList = new List<SelectListItem>();
		}

        public MyDashboardViewModel(string userId, string userLanId, string userRole) : this()
        {
            this.UserId = userId;
            this.UserLanId = userLanId;
			this.Search.UserRole = userRole;
        }
	}
}
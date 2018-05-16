using eCoachingLog.Models.Common;
using eCoachingLog.Models.MyDashboard;
using System.Collections.Generic;
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

		public IList<LogCount> LogCountList { get; set; }

		// Progress bar
		public int PercentCompleted { get; set; }

        public MyDashboardCounts Counts { get; set; }

		// Search (from director)
		public int LogStatusId { get; set; }
		//public IEnumerable<SelectListItem> LogStatusSelectList { get; set; }

		public bool IsCoaching { get; set; }
		public bool IsWarning { get; set; }

		//       public string LandingPartial { get; set; }

		// Search (for Manager, Supervisor and other)
		public string SupervisorId { get; set; }
        public string EmployeeId { get; set; }
		public string SourceId { get; set; }
        //public IEnumerable<SelectListItem> SupervisorSelectList { get; set; }
        //public IEnumerable<SelectListItem> EmployeeSelectList { get; set; }
		public IEnumerable<SelectListItem> SourceSelectList { get; set; }

        // TODO: Remove these. Will use entilement to control show/hide, see Index.cshtml
        public bool ShowMyPendingCoaching
        {
            get
            {
                return true;
            }
        }

        public bool ShowMyCompleted
        {
            get
            {
                return true;
            }
        }

        public bool ShowMyTeamPendingCoaching
        {
            get
            {
                return true;
            }
        }

        public bool ShowMyTeamCompletedCoaching
        {
            get
            {
                return true;
            }
        }

        public bool ShowMyTeamWarning
        {
            get
            {
                return true;
            }
        }

        public bool ShowMySubmission
        {
            get
            {
                return true;
            }
        }

		// Datatables column show/hide
		public bool ShowSupNameColumn { get; set; }

        public MyDashboardViewModel()
        {
			this.LogCountList = new List<LogCount>();

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
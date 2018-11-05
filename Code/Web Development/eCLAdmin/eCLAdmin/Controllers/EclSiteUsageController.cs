using eCLAdmin.Services;
using eCLAdmin.ViewModels;
using log4net;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
	public class EclSiteUsageController : Controller
    {
		private readonly ILog logger = LogManager.GetLogger(typeof(EmployeeLogController));

		private readonly IEclSiteUsageService Service;

		public EclSiteUsageController(IEclSiteUsageService service)
        {
			logger.Debug("Entered EclSiteUsageController(IEclSiteUsageService");
			this.Service = service;
		}

		// GET: EclSiteUsage
		public ActionResult Index()
        {
			var vm = new EclSiteUsageViewModel();
            return View(vm);
        }

		[HttpPost]
		public ActionResult GetStatistics(string byWhat, string startDate, string endDate)
		{
			var vm = new EclSiteUsageViewModel();
			vm.Statistics = this.Service.GetStatistics(byWhat, startDate, endDate);
			// total
			foreach (var s in vm.Statistics)
			{
				vm.TotalHitsNewSubmission += s.TotalHitsNewSubmission;
				vm.TotalUsersNewSubmission += s.TotalUsersNewSubmission;
				vm.TotalHitsMyDashboard += s.TotalHitsMyDashboard;
				vm.TotalUsersMyDashboard += s.TotalUsersMyDashboard;
				vm.TotalHitsHistorical += s.TotalHitsHistorical;
				vm.TotalUsersHistorical += s.TotalHitsHistorical;
				vm.TotalHitsReview += s.TotalHitsReview;
				vm.TotalUsersReview += s.TotalUsersReview;
			}

			vm.HeaderText = GetHeader(byWhat, startDate, endDate);
			vm.TimeSpanText = GetTimeSpanText(byWhat);
			return PartialView("_Statistics", vm);
		}

		private string GetHeader(string byWhat, string startDate, string endDate)
		{
			string header = string.Empty;
			if (string.IsNullOrEmpty(byWhat))
			{
				return header;
			}

			if (byWhat == Constants.BY_HOUR)
			{
				header = string.Format("Hourly Count: {0}", startDate);
			} else if (byWhat == Constants.BY_DAY)
			{
				header = string.Format("Daily Count: {0} ~ {1}", startDate, endDate);
			} else if (byWhat == Constants.BY_WEEK)
			{
				header = string.Format("Weekly Count: {0} ~ {1}", startDate, endDate);
			} else if (byWhat == Constants.BY_MONTH)
			{
				header = string.Format("Monthly Count: {0} ~ {1}", startDate, endDate);
			}

			return header;
		}

		private string GetTimeSpanText(string byWhat)
		{
			string text = string.Empty;
			if (string.IsNullOrEmpty(byWhat))
			{
				return text;
			}

			if (byWhat == Constants.BY_HOUR)
			{
				text = "Hour";
			}
			else if (byWhat == Constants.BY_DAY)
			{
				text = "Date";
			}
			else if (byWhat == Constants.BY_WEEK)
			{
				text = "Week";
			}
			else if (byWhat == Constants.BY_MONTH)
			{
				text = "Month";
			}

			return text;
		}
	}
}
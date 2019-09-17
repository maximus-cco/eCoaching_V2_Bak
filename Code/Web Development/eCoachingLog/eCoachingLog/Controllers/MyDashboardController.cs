using eCoachingLog.Extensions;
using eCoachingLog.Filters;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	[EclAuthorize]
	[SessionCheck]
	public class MyDashboardController : LogBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public MyDashboardController(ISiteService siteService, IEmployeeLogService employeeLogService, IEmployeeService employeeService) : base(siteService, employeeService, employeeLogService)
        {
            logger.Debug("Entered MyDashboardController(IEmployeeLogService, IDashboardService)");
        }

        // GET: MyDashboard
        public ActionResult Index()
        {
			var user = GetUserFromSession();
			Session["currentPage"] = Constants.PAGE_MY_DASHBOARD;

			var vm = new MyDashboardViewModel();
			if (user.Role == Constants.USER_ROLE_DIRECTOR)
			{
				var selectedDate = Convert.ToDateTime(vm.SelectedMonthYear);
				var start = (new DateTime(selectedDate.Year, selectedDate.Month, 1)).Date;
				var end = start.AddMonths(1).AddDays(-1);
				vm = InitMyDashboardViewModel(start, end);
				return View("_DefaultDirector", vm);
			}

			vm = InitMyDashboardViewModel(null, null);
			return View("_Default", vm);
        }

		[HttpPost]
		public ActionResult GetDataByMonth(string month)
		{
			DateTime selectedMonth = DateTime.Parse(month);
			// First day of the month
			var start = (new DateTime(selectedMonth.Year, selectedMonth.Month, 1)).Date; 
			// Last day of the month
			var end = start.AddMonths(1).AddDays(-1);
			var vm = InitMyDashboardViewModel(start, end);
			return PartialView("_DefaultDirectorBottom", vm);
		}

		[HttpPost]
		public ActionResult GetLogs(string whatLog, int? siteId, string siteName, string month)
		{
			logger.Debug("Entered GetLogs");
			return PartialView(whatLog, InitMyDashboardVMByLogType(whatLog, siteId, siteName, month)); 
		}

		[HttpPost]
		public ActionResult Search(MyDashboardViewModel vm, int? pageSizeSelected)
		{
			logger.Debug("Entered Search...");
			logger.Debug("pageSizeSelected = " + pageSizeSelected);
			vm.Search.PageSize = pageSizeSelected.HasValue ? pageSizeSelected.Value : 25; // Default to 25
			if (vm.Search.LogType == Constants.LOG_SEARCH_TYPE_MY_TEAM_WARNING 
				|| vm.Search.LogType == Constants.LOG_SEARCH_TYPE_MY_SITE_WARNING)
			{
				return PartialView("_WarningList", vm.Search);
			}

			return PartialView("_LogList", vm.Search);
		}

		[HttpPost]
		public ActionResult GetChartData(string monthYear)
		{
			IList<ChartDataset> dataSets = null;
			ChartData data = null;
			User user = GetUserFromSession();
			try
			{
				if (user.Role != Constants.USER_ROLE_DIRECTOR)
				{
					dataSets = empLogService.GetChartDataSets(user);
					data = CreateChartData(dataSets);
				}
				else
				{
					DateTime selectedMonth = DateTime.Parse(monthYear);
					var start = (new DateTime(selectedMonth.Year, selectedMonth.Month, 1)).Date;
					var end = start.AddMonths(1).AddDays(-1);
					var temp = empLogService.GetLogCountByStatusForSites(user, start, end);
					data = CreateChartDataForSites(temp);
				}
			}
			catch (Exception ex)
			{
				logger.Warn(ex.StackTrace);
				logger.Warn(ex.Message);
				// Error, reset
				// Show "No data to display".
				dataSets = new List<ChartDataset>();
				data = new ChartData();
			}

			return Json(new
			{
				data = data,
				chartTitle = string.Empty
			}
				, @"application/json");
		}

		private MyDashboardViewModel InitMyDashboardViewModel(DateTime? start, DateTime? end)
        {
            var user = GetUserFromSession();
            var vm = new MyDashboardViewModel(user.EmployeeId, user.LanId, user.Role);

			//if (vm.Search.UserRole == Constants.USER_ROLE_CSR)
			//{
			//	vm.Search.ShowSupNameColumn = false;
			//}

			// Data to be displayed next to bar chart
			if (user.Role == Constants.USER_ROLE_DIRECTOR)
			{
				IList<LogCountForSite> logCountForSiteList = empLogService.GetLogCountsForSites(user, start.Value, end.Value);
				vm.LogCountForSiteList = logCountForSiteList;
				vm.IsChartBySite = true;
			}
			else
			{
				IList<LogCount> logCountList = empLogService.GetLogCounts(user);
				foreach (var lc in logCountList)
				{
					lc.LogListPageName = Constants.LogTypeToPageName[lc.Description];

					if (lc.Description == "My Pending")
					{
						vm.MyTotalPending = lc.Count;
					}
				}
				vm.LogCountList = logCountList;
				vm.IsChartBySite = false;
				Session["LogCountList"] = logCountList;
			}

			return vm;
        }

		private MyDashboardViewModel InitMyDashboardVMByLogType(string whatLog, int? siteId, string siteName, string month)
		{
			var user = GetUserFromSession();
			var vm = new MyDashboardViewModel(user.EmployeeId, user.LanId, user.Role);
			// Default to all
			vm.Search.SiteId = -1;
			vm.Search.EmployeeId = "-1";
			vm.Search.SupervisorId = "-1";
			vm.Search.ManagerId = "-1";
			vm.Search.SiteName = siteName;
			// Default to MyDashboard
			// Set to MySubmission if "My Submission" link is clicked, used to control review page to be read only or editable
			Session["currentPage"] = Constants.PAGE_MY_DASHBOARD;

			if (user.ShowFollowup)
			{
				vm.Search.ShowFollowupDateColumn = true;
			}
			// Load dropdowns for search
			switch (whatLog)
			{
				// My Pending Section on My Dashboard
				case "_MyPending":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_PENDING;
					if (user.Role == Constants.USER_ROLE_MANAGER)
					{
						// Supervisor dropdown
						vm.SupervisorSelectList = GetSupsForMgrMyPending(user);

						// Employee dropdown
						if (Session["empsForMgrMyPending"] == null)
						{
							vm.EmployeeSelectList = new SelectList(employeeService.GetEmpsForMgrMyPending(user), "Id", "Name");
							Session["empsForMgrMyPending"] = vm.EmployeeSelectList;
						}
						else
						{
							vm.EmployeeSelectList = (SelectList)Session["empsForMgrMyPending"];
						}
					}
					break;
				// My Follow-up seciton on My Dashboard
				// This is for CSR only
				case "_MyFollowup":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_FOLLOWUP;
					vm.Search.ShowFollowupDateColumn = true;
					break;
				// My Completed section on My Dashboard
				case "_MyCompleted":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_COMPLETED;
					vm.Search.ShowFollowupDateColumn = false;
					// Default to all
					vm.Search.SupervisorId = "-1";
					vm.Search.ManagerId = "-1";
					break;
				// My Team Pending on My Dashboard
				case "_MyTeamPending":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_TEAM_PENDING;
					if (user.Role == Constants.USER_ROLE_SUPERVISOR || user.Role == Constants.USER_ROLE_OTHER)
					{
						// Employee dropdown
						vm.EmployeeSelectList = GetEmpsForSupMyTeamPending(user);
					}
					else if (user.Role == Constants.USER_ROLE_MANAGER)
					{
						// Supervisor dropdown
						vm.SupervisorSelectList = GetSupsForMgrMyTeamPending(user);
						// Employee dropdown
						vm.EmployeeSelectList = GetEmpsForMgrMyTeamPending(user);
					}
					// Source dropdown
					vm.SourceSelectList = GetLogSourceSelectList(user);
					break;
				// My Team Completed on My Dashboard
				case "_MyTeamCompleted":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_TEAM_COMPLETED;
					vm.Search.ShowFollowupDateColumn = false;

					if (user.Role == Constants.USER_ROLE_SUPERVISOR)
					{
						// Manager dropdown
						vm.ManagerSelectList = GetMgrsForSupMyTeamCompleted(user);
						// Employee dropdown
						vm.EmployeeSelectList = GetEmpsForSupMyTeamCompleted(user);
						// Source dropdown
						vm.SourceSelectList = GetLogSourceSelectList(user);
					}
					else if (user.Role == Constants.USER_ROLE_MANAGER)
					{
						// Supervisor dropdown
						vm.SupervisorSelectList = GetSupsForMgrMyTeamCompleted(user);
						// Employee dropdown
						vm.EmployeeSelectList = GetEmpsForMgrMyTeamCompleted(user);
					}
					// Source dropdown
					vm.SourceSelectList = GetLogSourceSelectList(user);
					break;
				// My Team Warning on My Dashboard
				case "_MyTeamWarning":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_TEAM_WARNING;
					Session["currentPage"] = Constants.PAGE_MY_DASHBOARD;
					vm.Search.ShowFollowupDateColumn = false;
					// Warning status dropdown
					vm.WarningStatusSelectList = GetWarningStatuses(user);
					break;
				case "_MySubmission":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_SUBMITTED;
					Session["currentPage"] = Constants.PAGE_MY_SUBMISSION;
					vm.Search.ShowFollowupDateColumn = false;
					// Manager dropdown
					vm.ManagerSelectList = GetMgrsForMySubmission(user);
					// Supervisor dropdown
					vm.SupervisorSelectList = GetSupsForMySubmission(user);
					// Employee dropdown
					vm.EmployeeSelectList = GetEmpsForMySubmission(user);
					// Status dropdown
					vm.LogStatusSelectList = GetLogStatusSelectList();
					break;
				case "_MySiteLogs":
					// Default to pending
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_SITE_PENDING;
					vm.Search.ShowFollowupDateColumn = false;
					// Warning status dropdown
					// vm.WarningStatusSelectList = GetWarningStatuses(user);
					DateTime selectedMonth = DateTime.Parse(month);
					// First day of the month
					var start = (new DateTime(selectedMonth.Year, selectedMonth.Month, 1)).Date;
					// Last day of the month
					var end = start.AddMonths(1).AddDays(-1);
					vm.Search.SubmitDateFrom = Convert.ToString(start);
					vm.Search.SubmitDateTo = Convert.ToString(end);
					vm.Search.SiteId = siteId.Value;
					break;
				default:
					break;
			}

			return vm;
		}

		private SelectList GetSupsForMgrMyPending(User user)
		{
			SelectList supsForMgrMyPending = null;
			if (Session["supsForMgrMyPending"] == null)
			{
				supsForMgrMyPending = new SelectList(employeeService.GetSupsForMgrMyPending(user), "Id", "Name");
				Session["supsForMgrMyPending"] = supsForMgrMyPending;
			}
			else
			{
				supsForMgrMyPending = (SelectList)Session["supsForMgrMyPending"];
			}

			return supsForMgrMyPending;
		}

		private SelectList GetEmpsForSupMyTeamPending(User user)
		{
			SelectList empsForSupMyTeamPending = null;
			if (Session["empsForSupMyTeamPending"] == null)
			{
				empsForSupMyTeamPending = new SelectList(employeeService.GetEmpsForSupMyTeamPending(user), "Id", "Name");
				Session["empsForSupMyTeamPending"] = empsForSupMyTeamPending;
			}
			else
			{
				empsForSupMyTeamPending = (SelectList)Session["empsForSupMyTeamPending"];
			}

			return empsForSupMyTeamPending;
		}

		private SelectList GetSupsForMgrMyTeamPending(User user)
		{
			SelectList supsForSupMyTeamPending = null;
			if (Session["supsForSupMyTeamPending"] == null)
			{
				supsForSupMyTeamPending = new SelectList(employeeService.GetSupsForMgrMyTeamPending(user), "Id", "Name");
				Session["supsForSupMyTeamPending"] = supsForSupMyTeamPending;
			}
			else
			{
				supsForSupMyTeamPending = (SelectList)Session["supsForSupMyTeamPending"];
			}

			return supsForSupMyTeamPending;
		}

		private SelectList GetEmpsForMgrMyTeamPending(User user)
		{
			SelectList empsForMgrMyTeamPending = null;
			if (Session["empsForMgrMyTeamPending"] == null)
			{
				empsForMgrMyTeamPending = new SelectList(employeeService.GetEmpsForMgrMyTeamPending(user), "Id", "Name");
				Session["empsForMgrMyTeamPending"] = empsForMgrMyTeamPending;
			}
			else
			{
				empsForMgrMyTeamPending = (SelectList)Session["empsForMgrMyTeamPending"];
			}

			return empsForMgrMyTeamPending;
		}

		private SelectList GetMgrsForSupMyTeamCompleted(User user)
		{
			SelectList mgrsForSupMyTeamCompleted = null;
			if (Session["mgrsForSupMyTeamCompleted"] == null)
			{
				mgrsForSupMyTeamCompleted = new SelectList(employeeService.GetMgrsForSupMyTeamCompleted(user), "Id", "Name");
				Session["mgrsForSupMyTeamCompleted"] = mgrsForSupMyTeamCompleted;
			}
			else
			{
				mgrsForSupMyTeamCompleted = (SelectList)Session["mgrsForSupMyTeamCompleted"];
			}

			return mgrsForSupMyTeamCompleted;
		}

		private SelectList GetEmpsForSupMyTeamCompleted(User user)
		{
			SelectList empsForSupMyTeamCompleted = null;
			if (Session["empsForSupMyTeamCompleted"] == null)
			{
				empsForSupMyTeamCompleted = new SelectList(employeeService.GetEmpsForSupMyTeamCompleted(user), "Id", "Name");
				Session["empsForSupMyTeamCompleted"] = empsForSupMyTeamCompleted;
			}
			else
			{
				empsForSupMyTeamCompleted = (SelectList)Session["empsForSupMyTeamCompleted"];
			}

			return empsForSupMyTeamCompleted;
		}

		private SelectList GetSupsForMgrMyTeamCompleted(User user)
		{
			SelectList supsForMgrMyTeamCompleted = null;
			if (Session["supsForMgrMyTeamCompleted"] == null)
			{
				supsForMgrMyTeamCompleted = new SelectList(employeeService.GetSupsForMgrMyTeamCompleted(user), "Id", "Name");
				Session["supsForMgrMyTeamCompleted"] = supsForMgrMyTeamCompleted;
			}
			else
			{
				supsForMgrMyTeamCompleted = (SelectList)Session["supsForMgrMyTeamCompleted"];
			}

			return supsForMgrMyTeamCompleted;
		}

		private SelectList GetEmpsForMgrMyTeamCompleted(User user)
		{
			SelectList empsForMgrMyTeamCompleted = null;
			if (Session["empsForMgrMyTeamCompleted"] == null)
			{
				empsForMgrMyTeamCompleted = new SelectList(employeeService.GetEmpsForMgrMyTeamCompleted(user), "Id", "Name");
				Session["empsForMgrMyTeamCompleted"] = empsForMgrMyTeamCompleted;
			}
			else
			{
				empsForMgrMyTeamCompleted = (SelectList)Session["empsForMgrMyTeamCompleted"];
			}

			return empsForMgrMyTeamCompleted;
		}

		private SelectList GetWarningStatuses(User user)
		{
			SelectList warningStatuses = null;
			if (Session["warningStatuses"] == null)
			{
				warningStatuses = new SelectList(empLogService.GetWarningStatuses(user), "Id", "Name");
				Session["warningStatuses"] = warningStatuses;
			}
			else
			{
				warningStatuses = (SelectList)Session["warningStatuses"];
			}

			return warningStatuses;
		}

		private SelectList GetMgrsForMySubmission(User user)
		{
			SelectList mgrsForMySubmission = null;
			if (Session["mgrsForMySubmission"] == null)
			{
				mgrsForMySubmission = new SelectList(employeeService.GetFiltersForMySubmission(user, Constants.MY_SUBMISSION_FILTER_MANAGER), "Id", "Name");
				Session["mgrsForMySubmission"] = mgrsForMySubmission;
			}
			else
			{
				mgrsForMySubmission = (SelectList)Session["mgrsForMySubmission"];
			}

			return mgrsForMySubmission;
		}

		private SelectList GetSupsForMySubmission(User user)
		{
			SelectList supsForMySubmission = null;
			if (Session["supsForMySubmission"] == null)
			{
				supsForMySubmission = new SelectList(employeeService.GetFiltersForMySubmission(user, Constants.MY_SUBMISSION_FILTER_SUPERVISOR), "Id", "Name");
				Session["supsForMySubmission"] = supsForMySubmission;
			}
			else
			{
				supsForMySubmission = (SelectList)Session["supsForMySubmission"];
			}

			return supsForMySubmission;
		}

		private SelectList GetEmpsForMySubmission(User user)
		{
			SelectList empsForMySubmission = null;
			if (Session["empsForMySubmission"] == null)
			{
				empsForMySubmission = new SelectList(employeeService.GetFiltersForMySubmission(user, Constants.MY_SUBMISSION_FILTER_EMPLOYEE), "Id", "Name");
				Session["empsForMySubmission"] = empsForMySubmission;
			}
			else
			{
				empsForMySubmission = (SelectList)Session["empsForMySubmission"];
			}

			return empsForMySubmission;
		}

		private ChartData CreateChartData(IList<ChartDataset> dataSets)
		{
			ChartData data = new ChartData();
			int index = 1;
			foreach (var ds in dataSets)
			{
				ds.backgroundColor = Constants.Colors[index];
				ds.borderColor = Constants.Colors[index];
				data.datasets.Add(ds);
				index++;
			}

			return data;
		}

		private ChartData CreateChartDataForSites(IList<LogCountByStatusForSite> logCountByStatusList)
		{
			ChartData data = new ChartData();
			var statuses = (from c in logCountByStatusList select c.Status).Distinct();
			int index = 0;
			bool xLabelsLoaded = false;
			foreach (var status in statuses)
			{
				index++;
				xLabelsLoaded = data.xLabels.Count > 0;
				ChartDataset ds = new ChartDataset();
				ds.label = status;
				ds.backgroundColor = Constants.Colors[index];
				ds.borderColor = Constants.Colors[index];
				// Go through all sites to get the count for the status
				foreach (var lcs in logCountByStatusList)
				{
					if (lcs.Status == status)
					{
						ds.data.Add(lcs.Count);
						// xLabels, which will be Site Names
						if (!xLabelsLoaded)
						{
							data.xLabels.Add(lcs.SiteName);
						}
					}
				}
				data.datasets.Add(ds);
			}

			return data;
		}

		[HttpPost]
		public JsonResult ExportToExcelDirector(MyDashboardViewModel vm)
		{
			try
			{
				MemoryStream ms = this.GenerateExcelFile(
										empLogService.GetLogDataTableToExport(
											vm.Search.SiteId,
											vm.Search.LogType,
											vm.Search.SubmitDateFrom,
											vm.Search.SubmitDateTo,
											GetUserFromSession().EmployeeId
										)
									  , Constants.EXCEL_SHEET_NAMES
									);

				Session["fileName"] = CreateExcelName(vm);
				Session["fileStream"] = ms;
				return Json(new { result = "ok" }, JsonRequestBehavior.AllowGet);
			}
			catch (Exception ex)
			{
				logger.Warn("Exception ExportToExcel: " + ex.Message);
				return Json(new { result = "fail" }, JsonRequestBehavior.AllowGet);
			}
		}

		private string CreateExcelName(MyDashboardViewModel vm)
		{
			// Get status text to be used in the excel file name
			string status = string.Empty;
			if (vm.Search.LogType == Constants.LOG_SEARCH_TYPE_MY_SITE_PENDING)
			{
				status = Constants.PENDING;
			}
			else if (vm.Search.LogType == Constants.LOG_SEARCH_TYPE_MY_SITE_COMPLETED)
			{
				status = Constants.COMPLETED;
			}
			else if (vm.Search.LogType == Constants.LOG_SEARCH_TYPE_MY_SITE_WARNING)
			{
				status = Constants.WARNING;
			}

			return string.Format("eCoachingLog_{0}_{1}_{2}{3}", DateTime.Now.ToString("yyyyMMddHHmmssffff"), vm.Search.SiteName, status, ".xlsx");
		}
	}
}
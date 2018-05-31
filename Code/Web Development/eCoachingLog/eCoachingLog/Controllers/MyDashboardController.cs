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

			var vm = InitMyDashboardViewModel();
			if (user.Role == Constants.USER_ROLE_DIRECTOR)
			{
				return View("_DefaultDirector", vm);
			}

            return View("_Default", vm);
        }

		[HttpPost]
		public ActionResult Default()
		{
			var user = GetUserFromSession();
			var vm = InitMyDashboardViewModel();
			return PartialView("_Default", vm);
		}

		[HttpPost]
		public ActionResult GetDataByMonth(string month)
		{
			var vm = InitMyDashboardViewModel();
			return PartialView("_DefaultDirectorBottom", vm);
		}

		[HttpPost]
		public ActionResult GetLogs(string whatLog, string siteName)
		{
			logger.Debug("Entered GetLogs");
			return PartialView(whatLog, InitMyDashboardViewModel(whatLog, siteName)); 
		}

		[HttpPost]
		public ActionResult Search(MyDashboardViewModel vm)
		{
			logger.Debug("Entered Search...");
			return PartialView("_LogList", vm.Search);
		}

		[HttpPost]
		public ActionResult GetChartData()
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
					var temp = empLogService.GetLogCountByStatusForSites(user);
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
				//dataSite = dataSite,
				chartTitle = string.Empty
			}
				, @"application/json");
		}

		private MyDashboardViewModel InitMyDashboardViewModel()
        {
            var user = GetUserFromSession();
            var vm = new MyDashboardViewModel(user.EmployeeId, user.LanId, user.Role);

			// only load these dropdowns for supervisor/other and managers, since they have search selections for log list
			// Supervisor Dropdown
			// TODO: Get all supervisors under this user (manager)
			if (user.Role == Constants.USER_ROLE_SUPERVISOR || user.Role == Constants.USER_ROLE_OTHER)
			{
				//List<Employee> employeeList = employeeService.GetEmployees(user.EmployeeId, logStatus);
				//employeeList.Insert(0, new Employee { Id = "-1", Name = "-- Select an Employee --" });
				//IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
				//vm.SupervisorSelectList = employees;
			}
			// TODO: only if user is director
			if (user.Role == Constants.USER_ROLE_DIRECTOR)
			{
				List<LogStatus> logStatusList = new List<LogStatus>();
				logStatusList.Insert(0, new LogStatus { Id = -1, Description = "-- Select a Status --" });
				IEnumerable<SelectListItem> logStatus = new SelectList(logStatusList, "Id", "Description");
				vm.LogStatusSelectList = logStatus;
			}

			// TODO: get real employees
			//vm.EmployeeSelectList = employees;
			if (vm.Search.UserRole == Constants.USER_ROLE_CSR)
			{
				vm.Search.ShowSupNameColumn = false;
			}

			// Data to be displayed next to bar chart
			if (user.Role == Constants.USER_ROLE_DIRECTOR)
			{
				IList<LogCountForSite> logCountForSiteList = empLogService.GetLogCountsForSites(user);
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

		private MyDashboardViewModel InitMyDashboardViewModel(string whatLog, string siteName)
		{
			var user = GetUserFromSession();
			var vm = new MyDashboardViewModel(user.EmployeeId, user.LanId, user.Role);
			// Default to all
			vm.Search.SiteId = -1;
			vm.Search.EmployeeId = "-1";
			vm.Search.SupervisorId = "-1";
			vm.Search.ManagerId = "-1";
			vm.Search.SiteName = siteName;

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
				// My Completed section on My Dashboard
				case "_MyCompleted":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_COMPLETED;
					// Default to all
					vm.Search.SupervisorId = "-1";
					vm.Search.ManagerId = "-1";
					break;
				// My Team Pending on My Dashboard
				case "_MyTeamPending":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_TEAM_PENDING;
					if (user.Role == Constants.USER_ROLE_SUPERVISOR)
					{
						user.EmployeeId = "380158";
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

					// Warning status dropdown
					vm.WarningStatusSelectList = GetWarningStatuses(user);
					break;
				case "_MySubmission":
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_SUBMITTED;
					Session["currentPage"] = Constants.PAGE_MY_SUBMISSION;
					break;
				case "_MySiteLogs":
					// Default to pending
					vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_SITE_PENDING;

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
	}
}
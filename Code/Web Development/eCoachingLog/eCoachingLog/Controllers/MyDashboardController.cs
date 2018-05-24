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
			// Default to pending
			// Need to tell index page what type of pending to display: Employee, Manager, or Other (Supervisor + Others)
			// TODO: the default pending page based on user role:
			// Employee Role: EmployeeMyPending.cshtml
			// Supervisor Role: SupervisorMyPending.cshtml
			// etc....,  and inside viewmodel, add "LandingPage" to indicate it is one of these:
			// Employee "My Pending"
			// Supervisor and Others "My Pending"
			// Manager "My Pending"
			var user = GetUserFromSession();
			Session["CurrentViewLogStatus"] = "Pending";

			// TODO: Get counts from database based on user lanid, hard coded right now
			// And save the counts in view model
			var vm = InitMyDashboardViewModel();
			vm.MyTeamSize = 12;

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
		public ActionResult GetLogs(string whatLog)
		{
			logger.Debug("Entered GetLogs");

			// TODO: get log list based on whatLog (_MyPending, _MyCompleted, etc.)
			// Set vm.Search.LogSectionWorkingOn approriately based on whatLog
			var vm = InitMyDashboardViewModel(whatLog);
			//vm.Search.LogSectionWorkingOn = LogSection.Employee_MyPending;
			vm.Search.LogType = Constants.LOG_SEARCH_TYPE_HISTORICAL;
			return PartialView(whatLog, vm); 
		}

		[HttpPost]
		public ActionResult Search(MyDashboardViewModel vm)
		{
			logger.Debug("Entered Search...");
			vm.Search.LogType = Constants.LOG_SEARCH_TYPE_HISTORICAL; // TODO: change
			return PartialView("_LogList", vm.Search);
		}




// TODO: remove
		[HttpPost]
		public ActionResult SearchMyPendingManager(string supervisorId, string employeeId)
		{
			var vm = InitMyDashboardViewModel();
			vm.Search.SupervisorId = supervisorId;
			vm.Search.EmployeeId = employeeId;
			return View("_LogList", vm.Search);
		}

		[HttpPost]
		public ActionResult SearchMyTeamPendingManager(string supervisorId, string employeeId, int sourceId)
		{
			var vm = InitMyDashboardViewModel();
			vm.Search.SupervisorId = supervisorId;
			vm.Search.EmployeeId = employeeId;
			vm.Search.SourceId = sourceId;
			return View("_LogList", vm);
		}
// End of TODO: remove

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
			
			// TODO: move LogSectionWorkingOn to MyDashboardViewModel from MyDashboardSearch
			// Add check LogSectionWorkingOn to decide which columns to hide
			if (vm.Search.UserRole == Constants.USER_ROLE_CSR)
			{
				vm.Search.ShowSupNameColumn = false;
			}

			// Data to be displayed next to bar chart
			if (user.Role == Constants.USER_ROLE_DIRECTOR)
			{
				IList<LogCountForSite> logCountForSiteList = empLogService.GetLogCountsForSites(user);
				foreach (var lcfs in logCountForSiteList)
				{
					// set page name here
				}
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

		private MyDashboardViewModel InitMyDashboardViewModel(string whatLog)
		{
			var user = GetUserFromSession();
			var vm = new MyDashboardViewModel(user.EmployeeId, user.LanId, user.Role);

			// Load dropdowns for search
			switch (whatLog)
			{
				// My Pending Section on My Dashboard
				case "_MyPending": 
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
					break;
				// My Team Pending on My Dashboard
				case "_MyTeamPending": 
					if (user.Role == Constants.USER_ROLE_SUPERVISOR)
					{
						user.EmployeeId = "380158";
						// Employee dropdown
						vm.EmployeeSelectList = GetEmpsForSupMyTeamPending(user);
					}
					else if (user.Role == Constants.USER_ROLE_MANAGER)
					{
						// Supervisor dropdown
						vm.SupervisorSelectList = new SelectList(employeeService.GetSupsForMgrMyTeamPending(user), "Id", "Name");
						// Employee dropdown
						vm.EmployeeSelectList = new SelectList(employeeService.GetEmpsForMgrMyTeamPending(user), "Id", "Name");
					}
					// Source dropdown
					vm.SourceSelectList = new SelectList(empLogService.GetAllLogSources(user.EmployeeId),"Id", "Name");
					break;
				// My Team Completed on My Dashboard
				case "_MyTeamCompleted":
					if (user.Role == Constants.USER_ROLE_SUPERVISOR)
					{
						// Manager dropdown
						vm.ManagerSelectList = new SelectList(employeeService.GetMgrsForSupMyTeamCompleted(user), "Id", "Name");
						// Employee dropdown
						vm.EmployeeSelectList = new SelectList(employeeService.GetEmpsForSupMyTeamCompleted(user), "Id", "Name");
					}
					else if (user.Role == Constants.USER_ROLE_MANAGER)
					{
						// Supervisor dropdown
						vm.SupervisorSelectList = new SelectList(employeeService.GetSupsForMgrMyTeamCompleted(user), "Id", "Name");
						// Employee dropdown
						vm.EmployeeSelectList = new SelectList(employeeService.GetEmpsForMgrMyTeamCompleted(user), "Id", "Name");
					}
					// Source dropdown
					vm.SourceSelectList = GetLogSourceSelectList(user);
					break;
				// My Team Warning on My Dashboard
				case "_MyTeamWarning":
					// State dropdown
					vm.LogStatusSelectList = new SelectList(empLogService.GetStatesForMyTeamWarning(user), "Id", "Description");
					break;
				case "_MySubmission":
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
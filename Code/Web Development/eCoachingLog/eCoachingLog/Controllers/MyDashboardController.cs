using eCoachingLog.Filters;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
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
            return View(vm);
        }

		[HttpPost]
		public ActionResult GetChartData()
		{
			ChartData data = GetChartData_Employee();
			return Json(new
			{
				data = data,
				//dataSite = dataSite,
				chartTitle = "My chart title"
			}
				, @"application/json");
		}

		private ChartData GetChartData_Employee()
		{
			ChartData data = new ChartData();
			data.xLabels = GetChartXLabels_Employee();
			Random rnd = new Random();
			ChartDatasets dataset = new ChartDatasets();
			var max = 100;

			ChartDatasets dataset1 = new ChartDatasets();
			dataset1.label = "Pending Acknowledgement";
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.backgroundColor = "#2B65EC";
			dataset1.borderColor = "#2B65EC";
			data.datasets.Add(dataset1);

			ChartDatasets dataset2 = new ChartDatasets();
			dataset2.label = "Pending Employee Review";
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.backgroundColor = "#93FFE8";
			dataset2.borderColor = "#93FFE8";
			data.datasets.Add(dataset2);

			return data;
		}

		private ChartData GetChartData_Director()
		{
			ChartData data = new ChartData();
			data.xLabels = GetChartXLabels_Director();
			Random rnd = new Random();
			ChartDatasets dataset = new ChartDatasets();
			var max = 100;
			dataset.label = "Completed";
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.data.Add(rnd.Next(1, max));
			dataset.backgroundColor = "#4CC417";
			dataset.borderColor = "#4CC417";
			data.datasets.Add(dataset);

			ChartDatasets dataset1 = new ChartDatasets();
			dataset1.label = "Pending Acknowledgement";
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.data.Add(rnd.Next(1, max));
			dataset1.backgroundColor = "#2B65EC";
			dataset1.borderColor = "#2B65EC";
			data.datasets.Add(dataset1);

			ChartDatasets dataset2 = new ChartDatasets();
			dataset2.label = "Pending Employee Review";
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.data.Add(rnd.Next(1, max));
			dataset2.backgroundColor = "#93FFE8";
			dataset2.borderColor = "#93FFE8";
			data.datasets.Add(dataset2);

			ChartDatasets dataset3 = new ChartDatasets();
			dataset3.label = "Pending Manager Review";
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.data.Add(rnd.Next(1, max));
			dataset3.backgroundColor = "#FFFF00";
			dataset3.borderColor = "#FFFF00";
			data.datasets.Add(dataset3);

			ChartDatasets dataset4 = new ChartDatasets();
			dataset4.label = "Pending Supervisor Review";
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.data.Add(rnd.Next(1, max));
			dataset4.backgroundColor = "#F88017";
			dataset4.borderColor = "#F88017";
			data.datasets.Add(dataset4);

			ChartDatasets dataset5 = new ChartDatasets();
			dataset5.label = "Pending Sr. Mgr Review";
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.data.Add(rnd.Next(1, max));
			dataset5.backgroundColor = "#4E8975";
			dataset5.borderColor = "#4E8975";
			data.datasets.Add(dataset5);

			ChartDatasets dataset6 = new ChartDatasets();
			dataset6.label = "Pending Qlt Lead Review";
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.data.Add(rnd.Next(1, max));
			dataset6.backgroundColor = "#4B0082";
			dataset6.borderColor = "#4B0082";
			data.datasets.Add(dataset6);

			ChartDatasets dataset7 = new ChartDatasets();
			dataset7.label = "Pending Dep Prg Mgr Review";
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.data.Add(rnd.Next(1, max));
			dataset7.backgroundColor = "#B93B8F";
			dataset7.borderColor = "#B93B8F";
			data.datasets.Add(dataset7);

			ChartDatasets dataset8 = new ChartDatasets();
			dataset8.label = "Warning";
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.data.Add(rnd.Next(1, max));
			dataset8.backgroundColor = "#FF0000";
			dataset8.borderColor = "#FF0000";
			data.datasets.Add(dataset8);

			return data;
		}

		private IList<string> GetChartXLabels_Director()
		{
			IList<string> xLabels = new List<string>();
			xLabels.Add("Bogalusa");
			xLabels.Add("Chester");
			xLabels.Add("Coralville");
			xLabels.Add("Corbin");
			xLabels.Add("Hattiesburg");
			xLabels.Add("London");
			xLabels.Add("Lawrence");
			xLabels.Add("Lynn Haven");
			xLabels.Add("Phoenix");
			xLabels.Add("Riverview");
			xLabels.Add("Sandy");
			xLabels.Add("Waco");
			xLabels.Add("Winchester");

			//xLabels.Add("Completed");
			//xLabels.Add("Pending Acknowledgement");
			//xLabels.Add("Pending Employee Review");
			//xLabels.Add("Pending Manager Review");
			//xLabels.Add("Pending Supervisor Review");
			//xLabels.Add("Pending Sr. Mgr Review");
			//xLabels.Add("Pending Qlt Lead Review");
			//xLabels.Add("Pending Dep Prg Mgr Review");
			//xLabels.Add("Warning");

			return xLabels;
		}

		private IList<string> GetChartXLabels_Employee()
		{
			IList<string> xLabels = new List<string>();
			//xLabels.Add("Pending Acknowledgement");
			//xLabels.Add("Pending Employee Review");

			return xLabels;
		}

		[HttpPost]
		public ActionResult Default()
		{
			var user = GetUserFromSession();
			var vm = InitMyDashboardViewModel();
			return PartialView("_Default", vm);
		}

		[HttpPost]
		public ActionResult GetLogss()
		{
			return View();
		}

		[HttpPost]
		public ActionResult GetLogs(string whatLog)
		{
			logger.Debug("Entered GetLogs");

			// TODO: get log list based on whatLog (_MyPending, _MyCompleted, etc.)
			// Set vm.Search.LogSectionWorkingOn approriately based on whatLog
			var vm = InitMyDashboardViewModel();
			//vm.Search.LogSectionWorkingOn = LogSection.Employee_MyPending;
			return PartialView(whatLog, vm.Search); 
		}

		[HttpPost]
		public ActionResult SearchMyPendingManager(string supervisorId, string employeeId)
		{
			var vm = InitMyDashboardViewModel();
			vm.Search.SupervisorId = supervisorId;
			vm.Search.EmployeeId = employeeId;
			return View("_LogList", vm.Search);
		}

		//[HttpPost]
		//public ActionResult GetMyTeamPending()
		//{
		//	logger.Debug("Entered GetMyTeamPending");

		//	// TODO: remove var vm = InitMyDashboardViewModel();
		//	// Get Pending list from db and save to vm
		//	var vm = InitMyDashboardViewModel();
		//	vm.Search.LogSectionWorkingOn = LogSection.Employee_MyCompleted;
		//	return PartialView("_MyCompleted", vm);
		//}

		[HttpPost]
		public ActionResult SearchMyTeamPendingManager(string supervisorId, string employeeId, int sourceId)
		{
			var vm = InitMyDashboardViewModel();
			vm.Search.SupervisorId = supervisorId;
			vm.Search.EmployeeId = employeeId;
			vm.Search.SourceId = sourceId;
			return View("_LogList", vm);
		}

		private MyDashboardViewModel InitMyDashboardViewModel()
        {
            var user = GetUserFromSession();
            var vm = new MyDashboardViewModel(user.EmployeeId, user.LanId, user.Role);

			// only load these dropdowns for supervisor/other and managers, since they have search selections for log list
			// Supervisor Dropdown
			// TODO: Get all supervisors under this user (manager)
			if (user.Role == UserRole.Supervisor || user.Role == UserRole.Other)
			{
				List<Employee> employeeList = employeeService.GetEmployeesByModule(1, "lili.huang");
				employeeList.Insert(0, new Employee { Id = "-1", Name = "-- Select an Employee --" });
				IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
				vm.SupervisorSelectList = employees;
			}
			// TODO: only if user is director
			if (user.Role == UserRole.Director)
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
			if (vm.Search.UserRole != UserRole.Employee)
			{
				vm.ShowSupNameColumn = true;
			}

			// Data to be displayed next to bar chart
			IList<LogCount> test = new List<LogCount>();
			LogCount lc = new LogCount();
			lc.Description = "My Pending";
			lc.Count = 10;
			lc.LogListPageName = "_MyPending";
			test.Add(lc);

			lc = new LogCount();
			lc.Description = "My Completed";
			lc.Count = 20;
			lc.LogListPageName = "_MyCompleted";
			test.Add(lc);

			vm.LogCountList = test;
			//vm.PercentCompleted = 60;
			return vm;
        }
    }
}
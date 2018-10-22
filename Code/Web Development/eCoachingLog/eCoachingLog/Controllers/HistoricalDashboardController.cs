using eCoachingLog.Extensions;
using eCoachingLog.Filters;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	[EclAuthorize]
	[SessionCheck]
	public class HistoricalDashboardController : LogBaseController
    {
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		public HistoricalDashboardController(ISiteService siteService, IEmployeeService employeeService, IEmployeeLogService empLogService) 
			: base(siteService, employeeService, empLogService)
        {
			logger.Debug("Entered HistoricalDashboardController(ISiteService)");
		}

		// GET: HistoricalDashboard
		public ActionResult Index()
        {
			Session["currentPage"] = Constants.PAGE_HISTORICAL_DASHBOARD;

			// TODO: To show loading spinner on page initial display, don't load data from database first to 
			// populate dropdowns; instead, display the page first, display loading spinner, then 
			// send an ajax call to load those dropdowns; hide the spinner upon ajax call completes 
			var vm = InitHistDashboardViewModel();
			return View(vm);
        }

		public ActionResult ResetPage()
		{
			var vm = InitHistDashboardViewModel();
			return PartialView("_Search", vm);
		}

		public JsonResult GetManagersBySite(int siteId)
		{
			// Site changed, reload managers and reset supervisors and employees to empty
			var managerList = this.employeeService.GetManagersBySite(siteId);
			managerList.Insert(0, new Employee { Id = "-2", Name = "-- Select a Manager --" });
			IEnumerable<SelectListItem> managers = new SelectList(managerList, "Id", "Name");
			return Json(new { managers = managers, supervisors = ResetSupervisors(), employees = ResetEmployees() }, JsonRequestBehavior.AllowGet );
		}

		public JsonResult GetSupervisorsByMgr(string mgrId)
		{
			// Manager changed, reload supervisors and reset employees to empty
			var supervisorList = this.employeeService.GetSupervisorsByMgr(mgrId);
			supervisorList.Insert(0, new Employee { Id = "-2", Name = "-- Select a Supervisor --" });
			IEnumerable<SelectListItem> supervisors = new SelectList(supervisorList, "Id", "Name");
			return Json(new { supervisors = supervisors, employees = ResetEmployees()}, JsonRequestBehavior.AllowGet);
		}

		public JsonResult GetEmployeesBySup(int siteId, string mgrId, string supId, int employeeStatus)
		{
			// Supervisor changed, reload employees
			var empList = this.employeeService.GetEmployeesBySup(siteId, mgrId, supId, employeeStatus);
			empList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
			IEnumerable<SelectListItem> employees = new SelectList(empList, "Id", "Name");

			JsonResult result = Json(employees);
			result.MaxJsonLength = Int32.MaxValue;
			result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
			return result;
		}

		private IEnumerable<SelectListItem> ResetSupervisors()
		{
			var supervisorList = new List<Employee>();
			supervisorList.Insert(0, new Employee { Id = "-2", Name = "-- Select a Supervisor --" });
			IEnumerable<SelectListItem> supervisors = new SelectList(supervisorList, "Id", "Name");
			return supervisors;
		}

		private IEnumerable<SelectListItem> ResetEmployees()
		{
			var employeeList = new List<Employee>();
			employeeList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
			IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
			return employees;
		}

		[HttpPost]
		public ActionResult Search(HistoricalDashboardViewModel vm)
		{
			logger.Debug("Entered Search...");
			vm.Search.LogType = Constants.LOG_SEARCH_TYPE_HISTORICAL;
			return PartialView("_LogList", vm.Search);
		}

		[HttpPost]
		public JsonResult ExportToExcel(HistoricalDashboardViewModel vm)
		{
			try
			{
				string userId = GetUserFromSession().EmployeeId;
				// Check if total number of records exceeds the limit
				// If over limit, don't export, display a message instead to the user
				int count = this.empLogService.GetLogCountToExport(vm.Search, userId);
				if (count > Constants.MAX_RECORDS_TO_EXPORT)
				{
					return Json(new { result = "overLimit", total = count }, JsonRequestBehavior.AllowGet);
				}

				MemoryStream ms = this.GenerateExcelFile(empLogService.GetLogDataTableToExport(vm.Search, userId));
				Session["fileName"] = "eCoachingLog_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
				Session["fileStream"] = ms;
				return Json(new { result = "success" }, JsonRequestBehavior.AllowGet);
			}
			catch (Exception ex)
			{
				logger.Warn("Exception ExportToExcel: " + ex.Message);
				return Json(new { result = "fail" }, JsonRequestBehavior.AllowGet);
			}
		}

		private HistoricalDashboardViewModel InitHistDashboardViewModel()
		{
			User user = GetUserFromSession();
			HistoricalDashboardViewModel vm = new HistoricalDashboardViewModel();
			vm.IsExportExcel = user.IsExportExcel;
			// Site
			var siteList = this.siteService.GetAllSites();
			siteList.Insert(0, new Site { Id = -2, Name = "-- Select a Site --" });
			IEnumerable<SelectListItem> sites = new SelectList(siteList, "Id", "Name");
			vm.SiteSelectList = sites;
			// Manager
			var managerList = new List<Employee>();
			managerList.Insert(0, new Employee { Id = "-2", Name = "-- Select a Manager --" });
			IEnumerable<SelectListItem> managers = new SelectList(managerList, "Id", "Name");
			vm.ManagerSelectList = managers;
			// Supervisor
			var supervisorList = new List<Employee>();
			supervisorList.Insert(0, new Employee { Id = "-2", Name = "-- Select a Supervisor --" });
			IEnumerable<SelectListItem> supervisors = new SelectList(supervisorList, "Id", "Name");
			vm.SupervisorSelectList = supervisors;
			// Employee
			var employeeList = new List<Employee>();
			employeeList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
			IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
			vm.EmployeeSelectList = employees;
			// Submitter
			var submitterList = GetAllSubmitters();
			IEnumerable<SelectListItem> submitters = new SelectList(submitterList, "Id", "Name");
			vm.SubmitterSelectList = submitters;
			// Status
			var statusList = GetAllLogStatuses();
			IEnumerable<SelectListItem> statuses = new SelectList(statusList, "Id", "Description");
			vm.LogStatusSelectList = statuses;
			// Source
			var sourceList = GetAllLogSources(user);
			IEnumerable<SelectListItem> sources = new SelectList(sourceList, "Id", "Name");
			vm.LogSourceSelectList = sources;
			// Value
			var valueList = GetAllLogValues();
			IEnumerable<SelectListItem> values = new SelectList(valueList, "Id", "Description");
			vm.LogValueSelectList = values;

			return vm;
		}
	}
}
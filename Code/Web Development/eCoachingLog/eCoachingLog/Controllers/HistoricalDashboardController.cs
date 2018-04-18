using eCoachingLog.Filters;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.ViewModels;
using log4net;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
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
			var managerList = GetEmployeesBySiteAndTitle(-1, (int)EmployeeTitle.Manager);
			managerList.Insert(0, new Employee { Id = "-1", Name = "-- Select a Managerr --" });
			IEnumerable<SelectListItem> managers = new SelectList(managerList, "Id", "Name");
			return Json(managers, JsonRequestBehavior.AllowGet );
		}

		public JsonResult GetSupervisorsByMgr(string mgrId)
		{
			var supervisorList = GetEmployeesBySiteAndTitle(-1, (int)EmployeeTitle.Supervisor);
			supervisorList.Insert(0, new Employee { Id = "-1", Name = "-- Select a Supervisor --" });
			IEnumerable<SelectListItem> supervisors = new SelectList(supervisorList, "Id", "Name");
			return Json(supervisors, JsonRequestBehavior.AllowGet);
		}

		public JsonResult GetEmployeesBySup(int supId)
		{
			var empList = GetEmployeesBySiteAndTitle(-1, (int)EmployeeTitle.Employee);
			empList.Insert(0, new Employee { Id = "-1", Name = "-- Select an Employee --" });
			IEnumerable<SelectListItem> employees = new SelectList(empList, "Id", "Name");
			return Json(employees, JsonRequestBehavior.AllowGet);
		}

		[HttpPost]
		public ActionResult Search(HistoricalDashboardViewModel vm)
		{
			logger.Debug("Entered Search...");
			return PartialView("_LogList", vm);
		}

		[HttpPost]
		public JsonResult ExportToExcel(HistoricalDashboardViewModel vm)
		{
			var searchModel = vm.Search;
			MemoryStream ms = CreateExcelFile();
			Session["fileName"] = "eCoachingLog_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
			Session["fileStream"] = ms;

			return Json(new { result = "ok" }, JsonRequestBehavior.AllowGet);
		}

		public void Download()
		{
			MemoryStream memoryStream = Session["fileStream"] as MemoryStream;
			string fileName = (string)Session["fileName"];
			var fName = fileName;// + ".xlsx";
			Response.Clear();
			Response.Buffer = true;
			Response.Charset = "UTF-8";
			Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
			// Give user option to open or save the excel file
			Response.AddHeader("content-disposition", "attachment; filename=" + fileName);
			memoryStream.WriteTo(Response.OutputStream);
			Response.Flush();
			Response.End();
		}

		static ExcelWorksheet GetWorkSheet(ExcelPackage excelPackage)
		{
			var workSheet = excelPackage.Workbook.Worksheets.Add("eCoachingLog");
			workSheet.View.ShowGridLines = true;
			return workSheet;
		}

		private MemoryStream CreateExcelFile()
		{
			ExcelPackage excelPackage;
			MemoryStream result = new MemoryStream();
			var logFilter = new LogFilter();
			using (excelPackage = new ExcelPackage())
			{
				ExcelWorksheet workSheet = GetWorkSheet(excelPackage);
				// A1: starting cell
				var dataTable = empLogService.GetLogDataTable(logFilter);
				workSheet.Cells["A1"].LoadFromDataTable(dataTable, true);
				//workSheet.Cells.AutoFitColumns();
				//var dPos = new List<int>();
				for (var i = 0; i < dataTable.Columns.Count; i++ )
				{
					if (dataTable.Columns[i].DataType.Name.Equals("DateTime"))
					{
						//dPos.Add(i);
						workSheet.Column(i + 1).Style.Numberformat.Format = "yyyy-mm-dd hh:mm";
					}
				}
				//foreach (var pos in dPos)
				//{
				//	workSheet.Column(pos + 1).Style.Numberformat.Format = "yyyy-mm-dd hh:mm";
				//}
				excelPackage.SaveAs(result);
			}
			return result;
		}

		private HistoricalDashboardViewModel InitHistDashboardViewModel()
		{
			User user = GetUserFromSession();
			HistoricalDashboardViewModel vm = new HistoricalDashboardViewModel();
			// Site Dropdown
			var siteList = GetSites(-1); // -1: all sites
			siteList.Insert(0, new Site { Id = -1, Name = "-- Select a Site --" });
			IEnumerable<SelectListItem> sites = new SelectList(siteList, "Id", "Name");
			vm.SiteSelectList = sites;

			// Manager Dropdown
			var managerList = new List<Employee>();// GetEmployeesBySiteAndTitle(-1, (int)EmployeeTitle.Manager);
			managerList.Insert(0, new Employee { Id = "-1", Name = "-- Select a Manager --" });
			IEnumerable<SelectListItem> managers = new SelectList(managerList, "Id", "Name");
			vm.ManagerSelectList = managers;

			// Supervisor Dropdown
			var supervisorList = new List<Employee>();// GetEmployeesBySiteAndTitle(-1, (int)EmployeeTitle.Supervisor);
			supervisorList.Insert(0, new Employee { Id = "-1", Name = "-- Select a Supervisor --" });
			IEnumerable<SelectListItem> supervisors = new SelectList(supervisorList, "Id", "Name");
			vm.SupervisorSelectList = supervisors;

			// Employee Dropdown
			var employeeList = new List<Employee>();// GetEmployeesBySiteAndTitle(-1, (int)EmployeeTitle.Employee);
			employeeList.Insert(0, new Employee { Id = "-1", Name = "-- Select an Employee --" });
			IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
			vm.EmployeeSelectList = employees;

			// Submitter Dropdown
			var submitterList = GetAllSubmitters();
			submitterList.Insert(0, new Employee { Id = "-1", Name = "-- Select a Submitter --" });
			IEnumerable<SelectListItem> submitters = new SelectList(submitterList, "Id", "Name");
			vm.SubmitterSelectList = submitters;

			// Status Dropdown - get from App Cache, since it is static
			var statusList = GetAllLogStatuses();
			statusList.Insert(0, new LogStatus { Id = "-1", Description = "-- Select a Status --" });
			IEnumerable<SelectListItem> statuses = new SelectList(statusList, "Id", "Description");
			vm.LogStatusSelectList = statuses;
			// Source Dropdown - get from App Cache, since it is static
			var sourceList = GetAllLogSources();
			sourceList.Insert(0, new LogSource { Id = "-1", Name = "-- Select a Source --" });
			IEnumerable<SelectListItem> sources = new SelectList(sourceList, "Id", "Name");
			vm.LogSourceSelectList = sources;
			// Value Dropdown - get from App Cache, since it is static
			var valueList = GetAllLogValues();
			valueList.Insert(0, new LogValue { Id = "-1", Description = "-- Select a Value --" });
			IEnumerable<SelectListItem> values = new SelectList(valueList, "Id", "Description");
			vm.LogValueSelectList = values;

			return vm;
		}
	}


	public class CodeDetail
	{
		public string Code { get; set; }
		public string Time { get; set; }
		public string Date { get; set; }
	}
}
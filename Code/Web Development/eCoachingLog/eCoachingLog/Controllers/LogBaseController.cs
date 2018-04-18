using eCoachingLog.Models.Common;
using eCoachingLog.ViewModels;
using eCoachingLog.Services;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class LogBaseController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		// TODO: change to private
		protected readonly ISiteService siteService;
		protected readonly IEmployeeService employeeService;
		protected readonly IEmployeeLogService empLogService;

		//public LogBaseController()
		//{
		//	logger.Debug("Entered LogBaseController");
		//}

		public LogBaseController(ISiteService siteService, IEmployeeService employeeService, IEmployeeLogService empLogService)
		{
			logger.Debug("Entered LogBaseController(ISiteService)");
			this.siteService = siteService;
			this.employeeService = employeeService;
			this.empLogService = empLogService;
		}

		public LogBaseController(IEmployeeLogService employeeLogService)
        {
            logger.Debug("Entered EmployeeLogBaseController(IEmployeeLogService)");
            this.empLogService = employeeLogService;
		}

		[HttpPost]
		public ActionResult GetLogDetail(int logId, string logType)
		{
			return RedirectToAction("Index", "Review", new { logId = logId, logType = logType });
		}

		[HttpPost]
		public ActionResult LoadData(LogFilter myDashboardSearch)
		{
			logger.Debug("Entered LoadData");

			// TODO: Based on myDashboardSearch.LogSectionWorkingOn (LogSection), get log list 

			var selectedMonthYear = Session["SelectedMonthYear"];

			//DateTime monthYear = Convert.ToDateTime("201512");
			DateTime firstDayOfMonth = Convert.ToDateTime("2015-01-01"); //Convert.ToDateTime(monthYear);
			DateTime lastDayOfMonth = Convert.ToDateTime("2017-01-01"); //firstDayOfMonth.AddMonths(1).AddDays(-1);

			// get Start (paging start index) and length (page size for paging)
			var draw = Request.Form.GetValues("draw").FirstOrDefault();
			var start = Request.Form.GetValues("start").FirstOrDefault();
			var length = Request.Form.GetValues("length").FirstOrDefault();
			//Get Sort columns value
			var sortColumn = Request.Form.GetValues("columns[" + Request.Form.GetValues("order[0][column]").FirstOrDefault() + "][name]").FirstOrDefault();
			var sortColumnDir = Request.Form.GetValues("order[0][dir]").FirstOrDefault();

			if (sortColumnDir == "asc")
			{
				sortColumnDir = "Y";
			}
			else
			{
				sortColumnDir = "N";
			}

			var search = Request.Form.GetValues("search[value]").FirstOrDefault();

			int pageSize = length != null ? Convert.ToInt32(length) : 0;
			int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
			int totalRecords = 0;

			//logType = "";

			string userLanId = "Takouhi.Bezzegh"; // GetUserFromSession().LanId;
			var logType = "Pending";

			// TODO:
			// New service method
			// dashboardService.GetLogList(myDashboardSearch, userLanId, search)


			//List<EmployeeLog> logs = dashboardService.GetLogList(GetUserFromSession().LanId, logStatus, (bool)Session["Coaching"], firstDayOfMonth, lastDayOfMonth, pageSize, rowStartIndex, sortColumn, sortColumnDir, search);
			List<LogBase> logs = empLogService.GetLogList(userLanId, logType, true, firstDayOfMonth, lastDayOfMonth, pageSize, rowStartIndex, sortColumn, sortColumnDir, search);
			//totalRecords = dashboardService.GetLogListTotal(GetUserFromSession().LanId, logStatus, (bool)Session["Coaching"], firstDayOfMonth, lastDayOfMonth, search);
			totalRecords = empLogService.GetLogListTotal(userLanId, logType, true, firstDayOfMonth, lastDayOfMonth, search);

			// TODO: remove, need to re-get data from database
			string test = (string)Session["review"];
			if (test == "review")
			{
				logs.RemoveAt(0);
			}
			// reset:
			//Session["review"] = null;
			string status = (string) Session["Status"];
			if (status == null)
			{
				status = "Pending";
			}

			foreach (var log in logs)
			{
				if (status == "Pending")
				{
					log.Status = "Pending Manager Review";
				}
				else if (status == "Completed")
				{
					log.Status = "Completed";
				}
			}

			var data = logs;
			return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = data }, JsonRequestBehavior.AllowGet);
		}

		protected int GetLogStatusLevel(int moduleId, int statusId)
		{
			var statusLevel = -1;

			//moduleId = 1;
			//statusId = 4;
			var tuple = new Tuple<int, int>(moduleId, statusId);
			if (Constants.LogStatusLevel.ContainsKey(tuple))
			{
				statusLevel = Constants.LogStatusLevel[tuple];
			}

			return statusLevel;
		}

		protected IList<Site> GetSites(int siteId)
		{
			return this.siteService.GetAllSites(); // TODO: update service method to GetSites (int siteId)
		}

		protected IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId)
		{
			return this.employeeService.GetEmployeesBySiteAndTitle(-1, titleId);
		}

		protected IList<Employee> GetAllSubmitters()
		{
			return this.employeeService.GetAllSubmitters();
		}

		protected IList<LogStatus> GetAllLogStatuses()
		{
			return this.empLogService.GetAllLogStatuses();
		}

		protected IList<LogSource> GetAllLogSources()
		{
			return this.empLogService.GetAllLogSources(GetUserFromSession().LanId);
		}

		protected IList<LogValue> GetAllLogValues()
		{
			return this.empLogService.GetAllLogValues();
		}

		//protected int GetLogStatusLevel(int moduleId, int statusId)
		//{
		//	int statusLevel = -1;

		//	switch (statusId)
		//	{
		//		case Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW:
		//			statusLevel = 1;
		//			break;
		//		case Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT:
		//			statusLevel = 4;
		//			break;
		//		case Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW:
		//			statusLevel = 2;
		//			break;
		//		case Constants.LOG_STATUS_PENDING_MANAGER_REVIEW:
		//			if (Constants.MODULE_CSR == moduleId || Constants.MODULE_TRAINING == moduleId)
		//			{
		//				statusLevel = 3;
		//			}
		//			else if (Constants.MODULE_SUPERVISOR == moduleId)
		//			{
		//				statusLevel = 2;
		//			}
		//			break;
		//		case Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW:
		//			statusLevel = 2;
		//			break;
		//		case Constants.LOG_STATUS_PENDING_SRMANAGER_REVIEW:
		//		case Constants.LOG_STATUS_PENDINGDE_PUTYPROGRAMMANAGER_REVIEW:
		//			statusLevel = 3;
		//			break;
		//		default:
		//			break;
		//	}

		//	return statusLevel;
		//}
	}
}
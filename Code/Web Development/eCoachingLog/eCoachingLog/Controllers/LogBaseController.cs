using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
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
		protected readonly ISiteService siteService;
		protected readonly IEmployeeService employeeService;
		protected readonly IEmployeeLogService empLogService;

		public LogBaseController(ISiteService siteService, IEmployeeService employeeService, IEmployeeLogService empLogService)
		{
			logger.Debug("Entered LogBaseController(ISiteService, IEmployeeService, IEmployeeLogService)");
			this.siteService = siteService;
			this.employeeService = employeeService;
			this.empLogService = empLogService;
		}

		public LogBaseController(IEmployeeLogService employeeLogService)
        {
            logger.Debug("Entered LogBaseController(IEmployeeLogService)");
            this.empLogService = employeeLogService;
		}

		[HttpPost]
		public ActionResult GetLogDetail(int logId, string isCoaching)
		{
			return RedirectToAction("Index", "Review", new { logId = logId, isCoaching = isCoaching == "true" ? true : false });
		}

		[HttpPost]
		public ActionResult LoadData(LogFilter logFilter)
		{
			logger.Debug("Entered LoadData");
			// TODO: Based on myDashboardSearch.LogSectionWorkingOn (LogSection), get log list 

			// Get Start (paging start index) and length (page size for paging)
			var draw = Request.Form.GetValues("draw").FirstOrDefault();
			var start = Request.Form.GetValues("start").FirstOrDefault();
			var length = Request.Form.GetValues("length").FirstOrDefault();
			//Get Sort columns value
			var sortBy = Request.Form.GetValues("columns[" + Request.Form.GetValues("order[0][column]").FirstOrDefault() + "][name]").FirstOrDefault();
			var sortDirection = Request.Form.GetValues("order[0][dir]").FirstOrDefault() == "asc" ? "Y" : "N";
			var search = Request.Form.GetValues("search[value]").FirstOrDefault();
			int pageSize = length != null ? Convert.ToInt32(length) : 0;
			int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
			int totalRecords = 0;
			try
			{
				User user = GetUserFromSession();
				List<LogBase> logs = empLogService.GetLogList(logFilter, user.EmployeeId, pageSize, rowStartIndex, sortBy, sortDirection, search);
				totalRecords = empLogService.GetLogListTotal(logFilter, user.EmployeeId, search);
				return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = logs }, JsonRequestBehavior.AllowGet);
			}
			catch (Exception ex)
			{
				logger.Warn(ex.StackTrace);
				var errorMsg = "Data is currently unavailable, please try again later.";
				return Json(new { draw = 1, recordsFiltered = 0, recordsTotal = 0, data = new List<LogBase>(), error = errorMsg }, JsonRequestBehavior.AllowGet);
			}
		}

		protected int GetLogStatusLevel(int moduleId, int statusId)
		{
			var statusLevel = -1;
			var tuple = new Tuple<int, int>(moduleId, statusId);
			if (Constants.LogStatusLevel.ContainsKey(tuple))
			{
				statusLevel = Constants.LogStatusLevel[tuple];
			}

			return statusLevel;
		}

		protected IList<Employee> GetAllSubmitters()
		{
			return this.employeeService.GetAllSubmitters();
		}

		protected IList<LogStatus> GetAllLogStatuses()
		{
			return this.empLogService.GetAllLogStatuses();
		}

		protected IList<LogSource> GetAllLogSources(User user)
		{
			return this.empLogService.GetAllLogSources(user.EmployeeId);
		}

		protected IList<LogValue> GetAllLogValues()
		{
			return this.empLogService.GetAllLogValues();
		}

		protected IEnumerable<SelectListItem> GetLogSourceSelectList(User user)
		{
			IList<LogSource> sourceList = GetAllLogSources(user);
			sourceList.Insert(0, new LogSource { Id = -1, Name = "-- Select a Source" });
			IEnumerable<SelectListItem> sources = new SelectList(sourceList, "Id", "Name");
			return sources;
		}
	}
}
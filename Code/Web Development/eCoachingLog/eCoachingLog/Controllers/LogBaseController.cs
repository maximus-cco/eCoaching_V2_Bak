using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	public class LogBaseController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		protected readonly ISiteService siteService;
		protected readonly IEmployeeService employeeService;
		protected readonly IEmployeeLogService empLogService;

        public LogBaseController()
        {

        }

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

        // non-qn
        [HttpPost]
		public ActionResult LoadData(LogFilter logFilter)
		{
			logger.Debug("Entered LoadData");
			
			if (logFilter == null)
            {
                logger.Error("LoadData: logFilter is null!!!");
            }

            if (logFilter == null)
            {
                logger.Error("LoadData: logFilter is null!!!");
            }

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
			User user = GetUserFromSession();
			try
			{
				List<LogBase> logs = empLogService.GetLogList(logFilter, user.EmployeeId, pageSize, rowStartIndex, sortBy, sortDirection, search);
				totalRecords = empLogService.GetLogListTotal(logFilter, user, search);
				Session["TotalPending"] = totalRecords;
				return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = logs }, JsonRequestBehavior.AllowGet);
			}
			catch (Exception ex)
			{
				var userId = user == null ? "usernull" : user.EmployeeId;
				StringBuilder msg = new StringBuilder("Exception: ");
				msg.Append("[")
					.Append(userId)
					.Append("]: ")
					.Append(ex.Message)
					.Append(Environment.NewLine)
					.Append(ex.StackTrace);
				logger.Warn(msg);

				var errorMsg = "Data is currently unavailable, please try again later.";
				return Json(new { draw = 1, recordsFiltered = 0, recordsTotal = 0, data = new List<LogBase>(), error = errorMsg }, JsonRequestBehavior.AllowGet);
			}
		}

        // qn + non-qn
        [HttpPost]
        public ActionResult LoadDataAll(LogFilter logFilter)
        {
            logger.Debug("Entered LoadData");

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
            User user = GetUserFromSession();
            try
            {
                List<LogBase> logs = empLogService.GetLogList(logFilter, user.EmployeeId, pageSize, rowStartIndex, sortBy, sortDirection, search);
                totalRecords = empLogService.GetLogListTotal(logFilter, user, search);
                Session["TotalPending"] = totalRecords;
                return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = logs }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                var userId = user == null ? "usernull" : user.EmployeeId;
                StringBuilder msg = new StringBuilder("Exception: ");
                msg.Append("[")
                    .Append(userId)
                    .Append("]: ")
                    .Append(ex.Message)
                    .Append(Environment.NewLine)
                    .Append(ex.StackTrace);
                logger.Warn(msg);

                var errorMsg = "Data is currently unavailable, please try again later.";
                return Json(new { draw = 1, recordsFiltered = 0, recordsTotal = 0, data = new List<LogBase>(), error = errorMsg }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult LoadDataQn(LogFilter logFilter)
        {
            logger.Debug("Entered LoadDataQn");

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
            User user = GetUserFromSession();
            try
            {
                List<LogBase> logs = empLogService.GetLogListQn(logFilter, user.EmployeeId, pageSize, rowStartIndex, sortBy, sortDirection, search);
                totalRecords = empLogService.GetLogListTotalQn(logFilter, user, search);
                Session["TotalPending"] = totalRecords;
                return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = logs }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                var userId = user == null ? "usernull" : user.EmployeeId;
                StringBuilder msg = new StringBuilder("Exception: ");
                msg.Append("[")
                    .Append(userId)
                    .Append("]: ")
                    .Append(ex.Message)
                    .Append(Environment.NewLine)
                    .Append(ex.StackTrace);
                logger.Warn(msg);

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
			IList<LogSource> allLogSources = new List<LogSource>();
			if (Session["allLogSources"] == null)
			{
				allLogSources = this.empLogService.GetAllLogSources(user.EmployeeId);
				Session["allLogSources"] = allLogSources;
			}
			else
			{
				allLogSources = (IList<LogSource>)Session["allLogSources"];
			}

			return allLogSources;
		}

		protected IList<LogValue> GetAllLogValues()
		{
			IList<LogValue> allLogValues = new List<LogValue>();
			if (Session["allLogValues"] == null)
			{
				allLogValues = this.empLogService.GetAllLogValues();
				Session["allLogValues"] = allLogValues;
			}
			else
			{
				allLogValues = (IList<LogValue>)Session["allLogValues"];
			}

			return allLogValues;
		}

		protected IEnumerable<SelectListItem> GetLogSourceSelectList(User user)
		{
			IList<LogSource> sourceList = GetAllLogSources(user);
			IEnumerable<SelectListItem> sources = new SelectList(sourceList, "Id", "Name");
			return sources;
		}

		protected IEnumerable<SelectListItem> GetLogStatusSelectList()
		{
			IList<LogStatus> statusList = GetAllLogStatuses();
			IEnumerable<SelectListItem> statuses = new SelectList(statusList, "Id", "Description");
			return statuses;
		}

        protected IEnumerable<SelectListItem> GetLogPendingStatusSelectList()
        {
            IList<LogStatus> statusList = this.empLogService.GetQnLogPendingStatuses();
            IEnumerable<SelectListItem> statuses = new SelectList(statusList, "Id", "Description");
            return statuses;
        }

        // Download the generated excel file
        public void Download()
		{
			string fileName = (string)Session["fileName"];
			try
			{
				MemoryStream memoryStream = (MemoryStream)Session["fileStream"];
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
			catch (Exception ex)
			{
				logger.Warn(string.Format("Failed to download excel file: {0}", fileName));
				logger.Warn(string.Format("Exception message: {0}", ex.Message));
			}
			finally
			{
				// Clean up Session["fileStream"]
				Session.Contents.Remove("fileStream");
			}
		}

        protected SelectList GetSupsForMgrMyPending(User user)
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

        protected SelectList GetEmpsForSupMyTeamPending(User user)
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

        protected SelectList GetSupsForMgrMyTeamPending(User user)
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

        protected SelectList GetEmpsForMgrMyTeamPending(User user)
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

        protected SelectList GetMgrsForSupMyTeamCompleted(User user)
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

        protected SelectList GetEmpsForSupMyTeamCompleted(User user)
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

        protected SelectList GetSupsForMgrMyTeamCompleted(User user)
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

        protected SelectList GetEmpsForMgrMyTeamCompleted(User user)
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

        protected SelectList GetWarningStatuses(User user)
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

        protected SelectList GetMgrsForMySubmission(User user)
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

        protected SelectList GetSupsForMySubmission(User user)
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

        protected SelectList GetEmpsForMySubmission(User user)
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

    }
}
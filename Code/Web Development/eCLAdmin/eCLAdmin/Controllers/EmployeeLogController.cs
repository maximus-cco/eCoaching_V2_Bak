using eCLAdmin.Filters;
using eCLAdmin.Models;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.User;
using eCLAdmin.Services;
using eCLAdmin.Utilities;
using eCLAdmin.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class EmployeeLogController : EmployeeLogBaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(EmployeeLogController));

        private readonly IEmployeeService employeeService;
        private readonly IEmailService emailService;

        public EmployeeLogController(IEmployeeService employeeService, IEmployeeLogService employeeLogService, IEmailService emailService, ISiteService siteService)
            : base(employeeLogService, siteService)
        {
            logger.Debug("%%%%%%%%%%%%%%%%%%Entered EmployeeLogController(IEmployeeService, IEmployeeLogService, EMailService)");
            this.employeeService = employeeService;
            this.emailService = emailService;
        }

        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        [EclAuthorize]
        public ActionResult SearchForInactivate()
        {
            logger.Debug("Entered SearchForInactivate [get]...");

            ViewBag.SubTitle = "Inactivate Employee Logs";
            // Employee log types - coaching or warning
            ViewBag.LogTypes = GetTypes(Constants.LOG_ACTION_INACTIVATE, false);
            // Empty module list
            ViewBag.Modules = GetEmptyModuleList();
            // Empty employee list
            List<Employee> employeeList = new List<Employee>();
            employeeList.Insert(0, new Employee { Id = "-1", Name = "Please select an employee" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
            ViewBag.Employees = employees;

            return View();
        }

        [HttpPost]
        public ActionResult SearchForInactivate(string searchOption, string module, string logType, string employee, string logTypeSearchByLogName, string logName)
        {
            logger.Debug("Entered SearchForInactivate [post]...");

            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();
            var searchByLogName = false;
            // default to invalid module id and log type id
            var moduleId = -3;
            int logTypeId = -3;

            try
            {
                moduleId = Int32.Parse(module);
            }
            catch (FormatException ex)
            {
                var error = String.Format("SearchForInactivate: user [{0}] invalid module selected {1}.", GetUserFromSession().EmployeeId, module);
                logger.Error(error, ex);
            }

            if ("default" == searchOption)
            {
                Session["LogType"] = logType;
            }
            else
            {
                Session["LogType"] = logTypeSearchByLogName;
                searchByLogName = true;
            }

            var strLogType = (string)Session["LogType"];
            try
            {
                logTypeId = Int32.Parse(strLogType);
                Session["LogTypeId"] = logTypeId;
            }
            catch (FormatException ex)
            {
                var error = String.Format("SearchForInactivate: user [{0}] invalid log type selected {1}.", GetUserFromSession().EmployeeId, strLogType);
                logger.Error(error, ex);
            }

            employeeLogs = employeeLogService.SearchLog(searchByLogName, moduleId, logTypeId, employee, logName, Constants.LOG_ACTION_INACTIVATE, GetUserFromSession().LanId);
            return PartialView("_SearchEmployeeLogResultPartial", CreateEmployeeLogSelectViewModel(employeeLogs));
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Inactivate(EmployeeLogSelectViewModel model, int reason, string otherReason, string comment)
        {
            logger.Debug("Entered Inactivate [post]...");

            // Save to database
            bool success = employeeLogService.ProcessActivation(
                                                GetUserFromSession().LanId,
                                                Constants.LOG_ACTION_INACTIVATE,
                                                (int)Session["LogTypeId"],
                                                model.GetSelectedIds(),
                                                reason,
                                                // Sanitize user input
                                                HttpUtility.HtmlEncode(otherReason),
                                                HttpUtility.HtmlEncode(comment)
                                             );

            return Json(new { success = success });
        }

        [HttpGet]
        [EclAuthorize]
        public ActionResult SearchForReassign()
        {
            logger.Debug("Entered SearchForReassign [get]...");

            ViewBag.SubTitle = "Reassign Employee Logs";
            ViewBag.Modules = GetModules(Constants.MODULE_UNKNOWN);

            ViewBag.LogTypes = GetTypes(Constants.LOG_ACTION_REASSIGN, false);

            List<Status> statusList = new List<Status>();
            statusList.Insert(0, new Status { Id = -1, Description = "Please select a status" });
            IEnumerable<SelectListItem> statuses = new SelectList(statusList, "Id", "Description");
            ViewBag.Statuses = statuses;

            // Empty reviewer list
            List<Employee> reviewerList = new List<Employee>();
            reviewerList.Insert(0, new Employee { Id = "-1", Name = "Please select a reviewer" });
            IEnumerable<SelectListItem> reviewers = new SelectList(reviewerList, "Id", "Name");
            ViewBag.Reviewers = reviewers;

            return View();
        }

        [HttpPost]
        public ActionResult SearchForReassign(string searchOption, int module, int employeeLogStatus, string reviewer, string logName)
        {
            logger.Debug("Entered SearchForReassign [post]...");

            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();
            var searchByLogName = "logname" == searchOption;

            Session["SearchBy"] = searchOption;         // "default" or "logname"
            Session["LogType"] = 1;                     // coaching log only for reassign

            // TODO: sp returns current reviewer site id and site name
            employeeLogs = employeeLogService.SearchLogForReassign(searchByLogName, module, employeeLogStatus, reviewer, logName);
            
            if (employeeLogs.Count > 0)
            {
                // employeeLogs: this is the log list for the given reviewer, so we can get reviewer information from any log in the list
                var log = employeeLogs[0];
                Session["CurrentReviewer"] = new Employee(log.CurrentReviewerId, log.CurrentReviewerName, log.CurrentReviewerSiteId, log.CurrentReviewerSiteName, log.IsSubcontractor);
            }

            return PartialView("_SearchEmployeeLogResultPartial", CreateEmployeeLogSelectViewModel(employeeLogs));
        }

		[HttpPost]
		[ValidateInput(false)]
		public ActionResult Reassign(EmployeeLogSelectViewModel model, int reason, string assignTo, string otherReason, string comment)
		{
			logger.Debug("Entered Reassign [post]...");

			// Save to database
			bool success = employeeLogService.ProcessReassignment(
												GetUserFromSession().LanId,
												model.GetSelectedIds(),
												assignTo,
												reason,
												// Sanitize user input
												HttpUtility.HtmlEncode(otherReason),
												HttpUtility.HtmlEncode(comment)
											 );

			if (success)
			{
				try
				{
					// Send email
                    var currentReviewerEmailList = model.GetCurrentReviewerEmailList(); // Current reviewer email passed back from page
                    var currentReviewerEmail = currentReviewerEmailList.Count > 0 ? currentReviewerEmailList[0] : null;

                    var reassignToReviewer = employeeService.GetEmployee(assignTo);     // new reviewer

                    List<string> to = new List<string> { reassignToReviewer.Email };
                    List<string> cc = null;
                    if (!string.IsNullOrEmpty(currentReviewerEmail))
                    {
                        cc = new List<string> { currentReviewerEmail };
                    }
                    else
                    {
                        logger.Debug("********Orignial reviewer[" + ((Employee)Session["CurrentReviewerName"]).Name + "] email is not available.");
                    }

					StoreEmail(EmailType.Reassignment, to, cc, model.GetSelectedLogNames(), "UI-Reassign");
				}
				catch (Exception ex)
				{
					logger.Warn(string.Format("Failed to send email.", ex));
				}
			}

            return Json(new { success = success });
        }

        [HttpGet]
        [EclAuthorize]
        public ActionResult SearchForReactivate()
        {
            logger.Debug("Entered SearchForReactivate [get]...");

            ViewBag.SubTitle = "Reactivate Employee Logs";
            // Empty module list
            ViewBag.Modules = GetEmptyModuleList();
            // Employee log types - coaching or warning
            ViewBag.LogTypes = GetTypes(Constants.LOG_ACTION_REACTIVATE, false);
            // Empty employee list
            List<Employee> employeeList = new List<Employee>();
            employeeList.Insert(0, new Employee { Id = "-1", Name = "Please select an employee" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
            ViewBag.Employees = employees;

            return View();
        }

        public ActionResult SearchForReactivate(string searchOption, string module, string logType, string employee, string logTypeSearchByLogName, string logName)
        {
            logger.Debug("Entered SearchForReactivate [post]...");

            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();
            var searchByLogName = false;
            // default to invalid module id and log type id
            var moduleId = -3;
            int logTypeId = -3;

            try
            {
                moduleId = Int32.Parse(module);
            }
            catch (FormatException ex)
            {
                var error = String.Format("SearchForReactivate: user [{0}] invalid module selected {1}.", GetUserFromSession().EmployeeId, module);
                logger.Error(error, ex);
            }

            if ("default" == searchOption)
            {
                Session["LogType"] = logType;
            }
            else
            {
                Session["LogType"] = logTypeSearchByLogName;
                searchByLogName = true;
            }

            var strLogType = (string)Session["LogType"];
            try
            {
                logTypeId = Int32.Parse(strLogType);
                Session["LogTypeId"] = logTypeId;
            }
            catch (FormatException ex)
            {
                var error = String.Format("SearchForReactivate: user [{0}] invalid log type selected {1}.", GetUserFromSession().EmployeeId, strLogType);
                logger.Error(error, ex);
            }

            employeeLogs = employeeLogService.SearchLog(searchByLogName, moduleId, logTypeId, employee, logName, Constants.LOG_ACTION_REACTIVATE, GetUserFromSession().LanId);
            return PartialView("_SearchEmployeeLogResultPartial", CreateEmployeeLogSelectViewModel(employeeLogs));
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Reactivate(int module, string employee, int logType, EmployeeLogSelectViewModel model, int reason, string otherReason, string comment)
        {
            logger.Debug("Entered Reactivate [post]...");

            logger.Debug("module=" + module);

            // Save to database
            bool success = employeeLogService.ProcessActivation(
                                                GetUserFromSession().LanId,
                                                Constants.LOG_ACTION_REACTIVATE,
                                                (int)Session["LogTypeId"],
                                                model.GetSelectedIds(),
                                                reason,
                                                // Sanitize user input
                                                HttpUtility.HtmlEncode(otherReason),
                                                HttpUtility.HtmlEncode(comment)
                                             );

			// Send email notification for Coaching logs Reactivation
			// Do not cc to anyone.
			if (success && (int)EmployeeLogType.Coaching == logType)
            {
				try
				{
					string emailTo = null;
					Employee employeeInfo = employeeService.GetEmployee(employee);
					var dict = EclAdminUtil.BuildLogStatusNamesDictionary(model.GetSelectedLogs());
					foreach (int key in dict.Keys)
					{
						emailTo = EmailUtil.GetEmailTo(module, key, employeeInfo);
						List<string> logNames = dict[key];
						StoreEmail(EmailType.Reactivation, new List<string> { emailTo }, null, logNames, "UI-Reactivate");
					}
				}
				catch (Exception ex)
				{
					logger.Warn(string.Format("Failed to send email.", ex));
				}
			}

            return Json(new { success = success });
        }

        // Get employee log modules (csr, training, ...)
        private IEnumerable<SelectListItem> GetModules(int logTypeId)
        {
            logger.Debug("Entered GetModules: logTypeId=" + logTypeId);

            User user = GetUserFromSession();
            List<Module> moduleList = employeeLogService.GetModules(user.LanId, logTypeId);
            moduleList.Insert(0, new Module { Id = -1, Name = "Please select Employee Level" });
            IEnumerable<SelectListItem> modules = new SelectList(moduleList, "Id", "Name");

            return modules;
        }

        // Get employee log modules in json format (csr, training, ...)
        public JsonResult GetModulesInJson(int logTypeId)
        {
            IEnumerable<SelectListItem> modules = GetModules(logTypeId);
            return Json(new SelectList(modules, "Value", "Text"));
        }

        // Get employees based on log type (coaching or warning), module (csr, training, ...), and action (inactivate or reactivate)
        public JsonResult GetEmployees(int logTypeId, int moduleId, string action)
        {
            string userLanId = GetUserFromSession().LanId;
            List<Employee> employeeList = employeeService.GetEmployees(userLanId, logTypeId, moduleId, action);
            employeeList.Insert(0, new Employee { Id = "-1", Name = "Please select an employee" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");

            return Json(new SelectList(employees, "Value", "Text"));
        }

        // Get pending statuses for the given module
        public JsonResult GetPendingStatuses(int moduleId)
        {
            List<Status> statusList = employeeLogService.GetPendingStatuses(moduleId);
            statusList.Insert(0, new Status { Id = -1, Description = "Please select a status" });
            IEnumerable<SelectListItem> statuses = new SelectList(statusList, "Id", "Description");

            return Json(new SelectList(statuses, "Value", "Text"));
        }

        // Get reviewers for the given log status (Pending Manager Review; Pending Supervisor Review; etc.)
        public JsonResult GetPendingReviewers(int employeeLogStatusId, int moduleId)
        {
            string userLanId = GetUserFromSession().LanId;
            List<Employee> reviewerList = employeeService.GetPendingReviewers(userLanId, moduleId, employeeLogStatusId);
            reviewerList.Insert(0, new Employee { Id = "-1", Name = "Please select a reviewer" });
            IEnumerable<SelectListItem> reviewers = new SelectList(reviewerList, "Id", "Name");

            return Json(new SelectList(reviewers, "Value", "Text"));
        }

        // Get reviewers for the given site.
        public JsonResult GetReviewersBySite(int siteId)
        {
            Employee currentReviewer = (Employee)Session["CurrentReviewer"];
            IEnumerable<SelectListItem> reviewers = new SelectList(GetReviewers(siteId, currentReviewer.Id), "Id", "Name");

            return Json(new SelectList(reviewers, "Value", "Text"));
        }

        private List<Employee> GetReviewers(int siteId, string excludeReviewerId)
        {
            List<Employee> reviewers = employeeService.GetReviewersBySite(siteId, excludeReviewerId);
            if (reviewers.Count > 0)
            {
                reviewers.Insert(0, new Employee { Id = "-1", Name = "Please select a reviewer" });
            }
            else
            {
                reviewers.Insert(0, new Employee { Id = "-1", Name = "No reviewers found" });
            }

            return reviewers;
        }

        // Browser caches the response. So the second time when you send the request browser will not forward it to the server 
        // because the same request was sent to the server before and the browser will return the cached response to the page.
        // Decorate the action method not to cache the response in between.
        [OutputCache(NoStore = true, Duration = 1, VaryByParam = "*")]
        public ActionResult InitInactivateModal()
        {
            logger.Debug("Entered InitInactivateModal ");

            int logTypeId = (int)Session["LogTypeId"];
            // Load inactivation reasons
            List<Reason> reasonList = employeeLogService.GetReasons(logTypeId, Constants.LOG_ACTION_INACTIVATE);
            reasonList.Insert(0, new Reason { Id = -1, Description = "Please select a reason" });
            IEnumerable<SelectListItem> reasons = new SelectList(reasonList, "Id", "Description");
            ViewBag.Reasons = reasons;

            return PartialView("_InactivatePartial");
        }

        [OutputCache(NoStore = true, Duration = 1, VaryByParam = "*")]
        public ActionResult InitReactivateModal()
        {
            logger.Debug("Entered InitReactivateModal ");

            int logTypeId = (int)Session["LogTypeId"];
            // Load inactivation reasons
            List<Reason> reasonList = employeeLogService.GetReasons(logTypeId, Constants.LOG_ACTION_REACTIVATE);
            reasonList.Insert(0, new Reason { Id = -1, Description = "Please select a reason" });
            IEnumerable<SelectListItem> reasons = new SelectList(reasonList, "Id", "Description");
            ViewBag.Reasons = reasons;

            return PartialView("_ReactivatePartial");
        }

        [OutputCache(NoStore = true, Duration = 1, VaryByParam = "*")]
        public ActionResult InitReassignModal()
        {
            // Load reassign reasons
            List<Reason> reasonList = employeeLogService.GetReasons((int)EmployeeLogType.Coaching, Constants.LOG_ACTION_REASSIGN);
            reasonList.Insert(0, new Reason { Id = -1, Description = "Please select a reason" });
            IEnumerable<SelectListItem> reasons = new SelectList(reasonList, "Id", "Description");
            ViewBag.Reasons = reasons;

            Employee currentReviewer = (Employee)Session["CurrentReviewer"];
            bool excludeSubSites = !currentReviewer.IsSubcontractor;
            logger.Debug("########## excludeSubSites=" + excludeSubSites);
            List <Site> siteList = siteService.GetSites(GetUserFromSession().EmployeeId, excludeSubSites);
            // default to current reviewer's site 
            IEnumerable<SelectListItem> sites = new SelectList(siteList, "Id", "Name", currentReviewer.SiteId);
            ViewBag.Sites = sites;
            ViewBag.AllowSiteSelection = !GetUserFromSession().IsSubcontractor && !currentReviewer.IsSubcontractor;

            logger.Debug("********** Current Reviewer: " + currentReviewer.Id + "************");
            IEnumerable<SelectListItem> reviewers = new SelectList(GetReviewers(currentReviewer.SiteId, currentReviewer.Id), "Id", "Name");
            ViewBag.AssignTo = reviewers;
            // display current reviewer name and site name on reassign popup
            ViewBag.CurrentReviewerName = currentReviewer.Name;
            ViewBag.CurrentReviewerSiteName = currentReviewer.SiteName;

            return PartialView("_ReassignPartial");
        }

        private EmployeeLogSelectViewModel CreateEmployeeLogSelectViewModel(List<EmployeeLog> employeeLogs)
        {
            var model = new EmployeeLogSelectViewModel();
            foreach (var employeeLog in employeeLogs)
            {
                var editorViewModel = new EmployeeLogSelectEditorViewModel(employeeLog);
                model.EmployeeLogs.Add(editorViewModel);
            }

            return model;
        }

        private void StoreEmail(EmailType emailType, List<string> to, List<string> cc, List<string> logNames, string emailSource)
        {
            Email email = new Email();
            email.To = to;
            email.CC = cc;
            email.From = Constants.EMAIL_FROM;
            email.Subject = EmailUtil.GetSubject(emailType);
            email.Body = FileUtil.ReadFile(Server.MapPath("~/EmailTemplates/") + EmailUtil.GetTemplateFileName(emailType));

            emailService.StoreEmail(email, logNames, Request.ServerVariables["SERVER_NAME"].ToLower(), emailSource, GetUserFromSession().EmployeeId);
        }
        
        private IEnumerable<SelectListItem> GetEmptyModuleList()
        {
            List<Module> moduleList = new List<Module>();
            moduleList.Insert(0, new Module { Id = -1, Name = "Please select Employee Level" });
            IEnumerable<SelectListItem> emptyModuleList = new SelectList(moduleList, "Id", "Name");

            return emptyModuleList;
        }

        [HttpGet]
        [EclAuthorize]
        public ActionResult SearchForDelete()
        {
            logger.Debug("Entered SearchForDelete [get]...");
            return View(new EmployeeLog());
        }

        [HttpPost]
        public ActionResult SearchForDelete(EmployeeLog logToDelete)
        {
            logger.Debug("Entered SearchForDelete [post]...");

            // Clean up delete message
            ViewBag.Success = null;
            ViewBag.Fail = null;

            return PartialView("_LogsForDeletePartial", employeeLogService.GetLogsByLogName(logToDelete.FormName));
        }

        public ActionResult ViewLogDetail(int id, bool isCoaching)
        {
            return base.GetLogDetail(id, isCoaching);
        }

        [HttpGet]
        public ActionResult InitDelete(int id, bool isCoaching)
        {
            EmployeeLog log = new EmployeeLog();
            log.ID = id;
            log.IsCoaching = isCoaching;

            return PartialView("_Delete", log);
        }

        [HttpPost]
        public ActionResult Delete(int id, bool isCoaching)
        {
            bool success = employeeLogService.Delete(id, isCoaching);
            if (success)
            {
                ViewBag.Success = "The log has been successfully deleted.";
            }
            else
            {
                ViewBag.Fail = "Failed to delete the log.";
            }

            return View("SearchForDelete");
        }
    }
}
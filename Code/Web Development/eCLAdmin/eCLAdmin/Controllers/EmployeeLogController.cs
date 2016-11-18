using eCLAdmin.Filters;
using eCLAdmin.Models;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.User;
using eCLAdmin.Services;
using eCLAdmin.Utilities;
using eCLAdmin.ViewModels;
using log4net;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class EmployeeLogController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(EmployeeLogController));

        private readonly IEmployeeService employeeService;
        private readonly IEmployeeLogService employeeLogService;
        private readonly IEmailService emailService;

        public EmployeeLogController(IEmployeeService employeeService, IEmployeeLogService employeeLogService, IEmailService emailService)
        {
            logger.Debug("Entered EmployeeLogController(IEmployeeService, IEmployeeLogService, EMailService)");
            this.employeeService = employeeService;
            this.employeeLogService = employeeLogService;
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
            ViewBag.LogTypes = GetTypes(Constants.LOG_ACTION_INACTIVATE);
            // Empty module list
            ViewBag.Modules = GetEmpltyModuleList();
            // Empty employee list
            List<Employee> employeeList = new List<Employee>();
            employeeList.Insert(0, new Employee { Id = "-1", Name = "Please select an employee" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
            ViewBag.Employees = employees;

            return View();
        }

        [HttpPost]
        public ActionResult SearchForInactivate(int module, int logType, string employee)
        {
            logger.Debug("Entered SearchForInactivate [post]...");

            Session["LogType"] = logType;
            List<EmployeeLog> employeeLogs = employeeLogService.GetLogsByEmpIdAndAction(module, logType, employee, Constants.LOG_ACTION_INACTIVATE);
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
                                                (int)Session["LogType"],
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
        public ActionResult SearchForReassign(int module, int employeeLogStatus, string reviewer)
        {
            logger.Debug("Entered SearchForInactivate [post]...");

            // Save for later use in Reassignment
            Session["ModuleId"] = module;
            Session["LogStatus"] = employeeLogStatus;
            Session["OriginalReviewer"] = reviewer;

            List<EmployeeLog> EmployeeLogs = employeeLogService.GetPendingLogsByReviewerEmpId(module, employeeLogStatus, reviewer);
            return PartialView("_SearchEmployeeLogResultPartial", CreateEmployeeLogSelectViewModel(EmployeeLogs));
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

            // Send email
            Employee reviewer = employeeService.GetEmployee(assignTo);
            Employee originalReviewer = employeeService.GetEmployee((string)Session["OriginalReviewer"]);
            List<string> to = new List<string> { reviewer.Email };
            List<string> cc = new List<string> { originalReviewer.Email };
            SendEmail(EmailType.Reassignment, to, cc, model.GetSelectedLogNames());

            return Json(new { success = success });
        }

        [HttpGet]
        [EclAuthorize]
        public ActionResult SearchForReactivate()
        {
            logger.Debug("Entered SearchForReactivate [get]...");

            ViewBag.SubTitle = "Reactivate Employee Logs";
            // Empty module list
            ViewBag.Modules = GetEmpltyModuleList();
            // Employee log types - coaching or warning
            ViewBag.LogTypes = GetTypes(Constants.LOG_ACTION_REACTIVATE);
            // Empty employee list
            List<Employee> employeeList = new List<Employee>();
            employeeList.Insert(0, new Employee { Id = "-1", Name = "Please select an employee" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
            ViewBag.Employees = employees;

            return View();
        }

        [HttpPost]
        public ActionResult SearchForReactivate(int module, int logType, string employee)
        {
            logger.Debug("Entered SearchForReactivate [post]...");
            logger.Debug("module=" + module + ", logType=" + logType + ", employee=" + employee);

            ViewBag.Action = Constants.LOG_ACTION_REACTIVATE;

            Session["LogType"] = logType;
            List<EmployeeLog> employeeLogs = employeeLogService.GetLogsByEmpIdAndAction(module, logType, employee, Constants.LOG_ACTION_REACTIVATE);
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
                                                (int)Session["LogType"],
                                                model.GetSelectedIds(),
                                                reason,
                                                // Sanitize user input
                                                HttpUtility.HtmlEncode(otherReason),
                                                HttpUtility.HtmlEncode(comment)
                                             );

            // Send email notification for Coaching logs Reactivation
            // Do not cc to anyone.
            if ((int)EmployeeLogType.Coaching == logType)
            {
                string emailTo = null;
                Employee employeeInfo = employeeService.GetEmployee(employee);
                var dict = EclAdminUtil.BuildLogStatusNamesDictionary(model.GetSelectedLogs());
                foreach (int key in dict.Keys)
                {
                    emailTo = EmailUtil.GetEmailTo(module, key, employeeInfo);
                    List<string> logNames = dict[key];
                    SendEmail(EmailType.Reactivation, new List<string> { emailTo }, null, logNames);
                }
            }

            return Json(new { success = true });
        }

        // Get employee log modules (csr, training, ...)
        private IEnumerable<SelectListItem> GetModules(int logTypeId)
        {
            logger.Debug("Entered GetModules: logTypeId=" + logTypeId);

            User user = GetUserFromSession();
            List<Module> moduleList = employeeLogService.GetModules(user.LanId, logTypeId);
            moduleList.Insert(0, new Module { Id = -1, Name = "Please select a module" });
            IEnumerable<SelectListItem> modules = new SelectList(moduleList, "Id", "Name");

            return modules;
        }

        // Get employee log modules in json format (csr, training, ...)
        public JsonResult GetModulesInJson(int logTypeId)
        {
            IEnumerable<SelectListItem> modules = GetModules(logTypeId);
            return Json(new SelectList(modules, "Value", "Text"));
        }

        // Get employee log types (coaching or warning)
        private IEnumerable<SelectListItem> GetTypes(string action)
        {
            User user = GetUserFromSession();
            List<Models.EmployeeLog.Type> typeList = employeeLogService.GetTypes(user, action);
            typeList.Insert(0, new Models.EmployeeLog.Type { Id = -1, Description = "Please select a type" });
            IEnumerable<SelectListItem> types = new SelectList(typeList, "Id", "Description");

            return types;
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

        // Browser caches the response. So the second time when you send the request browser will not forward it to the server 
        // because the same request was sent to the server before and the browser will return the cached response to the page.
        // Decorate the action method not to cache the response in between.
        [OutputCache(NoStore = true, Duration = 1, VaryByParam = "*")]
        public ActionResult InitInactivateModal()
        {
            logger.Debug("Entered InitInactivateModal ");

            int logTypeId = (int)Session["LogType"];
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

            int logTypeId = (int)Session["LogType"];
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

            // Load assignTo list
            string userLanId = GetUserFromSession().LanId;
            string originalReviewer = (string)Session["OriginalReviewer"];
            int moduleId = (int)Session["ModuleId"];
            int logStatusId = (int)Session["LogStatus"];
            List<Employee> assignToList = employeeService.GetAssignToList(userLanId, moduleId, logStatusId, originalReviewer);
            assignToList.Insert(0, new Employee { Id = "-1", Name = "Please select a person" });
            IEnumerable<SelectListItem> employees = new SelectList(assignToList, "Id", "Name");
            ViewBag.AssignTo = employees;

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

        private void SendEmail(EmailType emailType, List<string> to, List<string> cc, List<string> logNames)
        {
            Email email = new Email();
            email.To = to;
            email.CC = cc;
            email.From = Constants.EMAIL_FROM;
            email.Subject = EmailUtil.GetSubject(emailType);
            email.Logo = Server.MapPath("~/Content/Images/ecl-logo-small.png");
            email.Body = FileUtil.ReadFile(Server.MapPath("~/EmailTemplates/") + EmailUtil.GetTemplateFileName(emailType));

            emailService.Send(email, logNames, Request.ServerVariables["SERVER_NAME"].ToLower());
        }
        
        private IEnumerable<SelectListItem> GetEmpltyModuleList()
        {
            List<Module> moduleList = new List<Module>();
            moduleList.Insert(0, new Module { Id = -1, Name = "Please select a module" });
            IEnumerable<SelectListItem> emptyModuleList = new SelectList(moduleList, "Id", "Name");

            return emptyModuleList;
        }
    }
}
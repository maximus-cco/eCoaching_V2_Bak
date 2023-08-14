using eCLAdmin.Filters;
using eCLAdmin.Models;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.User;
using eCLAdmin.Services;
using eCLAdmin.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class ReportBaseController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        protected readonly IReportService reportService;
        protected readonly IEmployeeService employeeService;

        public ReportBaseController(IReportService reportService, ISiteService siteService, IEmployeeLogService employeeLogService, IEmployeeService employeeService) : base(employeeLogService, siteService)
        {
            logger.Debug("Entered ReportBaseController(IReportService, IEmployeeLogService)");
            this.reportService = reportService;
            this.employeeService = employeeService;
        }

        [HttpPost]
        public JsonResult GetEmployees(int moduleId, int siteId, string hireDate, bool isWarning)
        {
            logger.Debug("Entered GetEmployees...");
            logger.Debug("##########moduleId=" + moduleId + " siteId=" + siteId + " hireDate=" + hireDate + " isWarning=" + isWarning);

            JsonResult result = Json(GetEmployeesBySiteAndModule(moduleId, siteId, hireDate, isWarning));
            result.MaxJsonLength = Int32.MaxValue;

            return result;
        }

        [HttpPost]
        public JsonResult GetSites(int moduleId)
        {
            return Json(GetSitesByUserAndModule(moduleId));
        }

        [HttpPost]
        public JsonResult GetReasons(int moduleId, bool isWarning)
        {
            logger.Debug("Entered GetReasons...");
            logger.Debug("moduleId=" + moduleId + " isWarning=" + isWarning);
            return Json(GetReasonsByModule(moduleId, isWarning));
        }

        [HttpPost]
        public JsonResult GetSubreasons(int reasonId, bool isWarning)
        {
            logger.Debug("Entered GetSubreasons...");
            logger.Debug("reasonId=" + reasonId + " isWarning=" + isWarning);
            return Json(GetSubreasonsByReasonId(reasonId, isWarning));
        }

        [HttpPost]
        public JsonResult GetLogStatusList(int moduleId, bool isWarning)
        {
            logger.Debug("Entered GetLogStatusList...");
            logger.Debug("moduleId=" + moduleId + " isWarning=" + isWarning);
            return Json(GetLogStatusListByModuleId(moduleId, isWarning));
        }

        protected ReportBaseViewModel InitViewModel()
        {
            var vm = new ReportBaseViewModel();
            // employee level dropdown
            vm.EmployeeLevelSelectList = GetEmployeeLevels();
            // site dropdown
            List<Site> siteList = new List<Site>();
            siteList.Insert(0, new Site { Id = "-2", Name = "Select Site" });
            vm.SiteSelectList = new SelectList(siteList, "Id", "Name");
            //vm.SiteSelectList = GetSitesByUserAndModule(-1); // default to get sites for all modules

            // employee dropdown
            List<Employee> employeeList = new List<Employee>();
            employeeList.Insert(0, new Employee { Id = "-2", Name = "Select Employee" });
            vm.EmployeeSelectList = new SelectList(employeeList, "Id", "Name");

            // coaching reason dropdown
            List<Reason> reasonList = new List<Reason>();
            reasonList.Insert(0, new Reason { Id = -2, Description = "Select Coaching Reason" });
            vm.CoachingReasonSelectList = new SelectList(reasonList, "Id", "Description");

            // coaching subreason dropdown
            List<Reason> subreasonList = new List<Reason>();
            subreasonList.Insert(0, new Reason { Id = -2, Description = "Select Coaching Subreason" });
            vm.CoachingSubReasonSelectList = new SelectList(subreasonList, "Id", "Description");

            // log status dropdown
            List<Status> statusList = new List<Status>();
            statusList.Insert(0, new Status { Id = -2, Description = "Select Log Status" });
            vm.LogStatusSelectList = new SelectList(statusList, "Id", "Description");

            return vm;
        }

        protected IEnumerable<SelectListItem> GetSitesByUserAndModule(int moduleId)
        {
            User user = GetUserFromSession();
            List<Site> siteList = this.siteService.GetSitesForReport(user.EmployeeId, moduleId);
            siteList.Insert(0, new Site { Id = "-2", Name = "Select Site" });
            IEnumerable<SelectListItem> sites = new SelectList(siteList, "Id", "Name");

            return sites;
        }

        protected IEnumerable<SelectListItem> GetActions(int logTypeId, bool includeAll)
        {
            List<Models.EmployeeLog.Action> actionList = new List<Models.EmployeeLog.Action>();
            if (logTypeId == -2)
            {
                actionList.Add(new Models.EmployeeLog.Action { Id = -2, Description = "Select Action" });
            }
            else
            {
                actionList = this.reportService.GetActions(logTypeId);
                if (includeAll)
                {
                    actionList.Insert(0, new Models.EmployeeLog.Action { Id = -1, Description = "All" });
                }
                actionList.Insert(0, new Models.EmployeeLog.Action { Id = -2, Description = "Select Action" });
            }

            return actionList.Select(x => new SelectListItem() { Text = x.Description, Value = x.Description });
        }

        protected IEnumerable<SelectListItem> GetEmployeeLevels()
        {
            List<Module> moduleList = this.reportService.GetEmployeeLevels(GetUserFromSession());
            moduleList.Insert(0, new Module { Id = -2, Name = "Select Employee Level" });
            IEnumerable<SelectListItem> modules = new SelectList(moduleList, "Id", "Name");

            return modules;
        }

        protected IEnumerable<SelectListItem> GetEmployeesBySiteAndModule(int moduleId, int siteId, string hireDate, bool isWarning)
        {
            List<Employee> employeeList = new List<Employee>();
            if (siteId != -2)
            {
                employeeList = this.employeeService.GetEmployeesBySiteAndModuleId(moduleId, siteId, hireDate, isWarning);
            }

            if (siteId != -1) // a specific site is selected, not "All" is selected
            {
                employeeList.Insert(0, new Models.EmployeeLog.Employee { Id = "-2", Name = "Select Employee" });
            }

            return employeeList.Select(x => new SelectListItem() { Text = x.Name, Value = x.Id });
        }

        protected IEnumerable<SelectListItem> GetReasonsByModule(int moduleId, bool isWarning)
        {
            List<Reason> reasonList = new List<Reason>();
            if (moduleId != -2)
            {
                reasonList = this.reportService.GetReasonsByModuleId(moduleId, isWarning);
            }
            if (isWarning)
            {
                reasonList.Insert(0, new Reason { Id = -2, Description = "Select Warning Reason" });
            } else
            {
                reasonList.Insert(0, new Reason { Id = -2, Description = "Select Coaching Reason" });
            }

            return reasonList.Select(x => new SelectListItem() { Text = x.Description, Value = x.Id.ToString() });
        }

        protected IEnumerable<SelectListItem> GetSubreasonsByReasonId(int reasonId, bool isWarning)
        {
            List<Reason> subreasonList = new List<Reason>();
            if (reasonId != -2)
            {
                subreasonList = this.reportService.GetSubreasons(reasonId, isWarning);
            }
            if (isWarning)
            {
                subreasonList.Insert(0, new Reason { Id = -2, Description = "Select Warning Subreason" });
            } else
            {
                subreasonList.Insert(0, new Reason { Id = -2, Description = "Select Coaching Subreason" });
            }
            

            return subreasonList.Select(x => new SelectListItem() { Text = x.Description, Value = x.Id.ToString() });
        }

        protected IEnumerable<SelectListItem> GetLogStatusListByModuleId(int moduleId, bool isWarning)
        {
            List<Status> statusList = new List<Status>();
            if (moduleId != -2)
            {
                statusList = this.reportService.GetLogStatusList(moduleId, isWarning);
            }
            statusList.Insert(0, new Status { Id = -2, Description = "Select Log Status" });

            return statusList.Select(x => new SelectListItem() { Text = x.Description, Value = x.Id.ToString() });
        }

        protected IEnumerable<SelectListItem> GetWarningLogStates()
        {
            List<Status> stateList = this.reportService.GetWarningLogStates();
            stateList.Insert(0, new Status { Id = -2, Description = "Select Log State" });

            return stateList.Select(x => new SelectListItem() { Text = x.Description, Value = x.Id.ToString() });
        }

    }
}
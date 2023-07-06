using eCLAdmin.Models.User;
using eCLAdmin.Services;
using log4net;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class ReportBaseController : BaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        protected readonly IReportService reportService;

        public ReportBaseController(IReportService reportService, IEmployeeLogService employeeLogService) : base(employeeLogService)
        {
            logger.Debug("Entered ReportBaseController(ISiteService, IEmployeeService, IEmployeeLogService)");
            this.reportService = reportService;
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

        protected IEnumerable<SelectListItem> GetLogNames(string logType, string action, string startDate, string endDate, bool includeAll)
        {
            List<string> logNameList = new List<string>();
            if (logType == "-2")
            {
                logNameList.Add("Select Log");
            }
            else
            {
                logNameList = this.reportService.GetLogNames(logType, action, startDate, endDate);
                if (includeAll)
                {
                    logNameList.Insert(0, "All");
                }
                logNameList.Insert(0, "Select Log");
            }

            return logNameList.Select(x => new SelectListItem() { Text = x, Value = x });
        }


    }
}
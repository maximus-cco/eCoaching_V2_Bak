using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.Report;
using eCLAdmin.Services;
using eCLAdmin.Utilities;
using eCLAdmin.ViewModels.Reports;
using log4net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class ReportWarningController : ReportBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public ReportWarningController(IReportService reportService, IEmployeeLogService employeeLogService, IEmployeeService employeeService, ISiteService siteService) : base(reportService, siteService, employeeLogService, employeeService)
        {
            logger.Debug("Entered ReportWarningController(IReportService, IEmployeeLogService, IEmployeeService, ISiteService)");
        }

        // GET: ReportWarning
        public ActionResult Index()
        {
            return View(InitViewModel());
        }

        private new WarningSearchViewModel InitViewModel()
        {
            var vm = new WarningSearchViewModel();
            vm.EmployeeLevelSelectList = GetEmployeeLevels();
            vm.SiteSelectList = GetSitesByUserRole();

            List<Employee> employeeList = new List<Employee>();
            employeeList.Insert(0, new Employee { Id = "-2", Name = "Select Employee" });
            vm.EmployeeSelectList = new SelectList(employeeList, "Id", "Name");

            List<Reason> reasonList = new List<Reason>();
            reasonList.Insert(0, new Reason { Id = -2, Description = "Select Warning Reason" });
            vm.CoachingReasonSelectList = new SelectList(reasonList, "Id", "Description");

            List<Reason> subreasonList = new List<Reason>();
            subreasonList.Insert(0, new Reason { Id = -2, Description = "Select Warning Subreason" });
            vm.CoachingSubReasonSelectList = new SelectList(subreasonList, "Id", "Description");

            List<Status> statusList = new List<Status>();
            statusList.Insert(0, new Status { Id = -2, Description = "Select Log Status" });
            vm.LogStatusSelectList = new SelectList(statusList, "Id", "Description");

            // All, Active, Expired
            vm.LogStateSelectList = GetWarningLogStates();

            return vm;
        }

        [HttpPost]
        public ActionResult GenerateReport(WarningSearchViewModel vm)
        {
            if (ModelState.IsValid)
            {
                return PartialView("_Report", vm);
            }

            return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
        }

        [HttpPost]
        public ActionResult GetData(WarningSearchViewModel vm)
        {
            logger.Debug("Entered GetData");

            int totalRows = 0;
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            vm.PageSize = length != null ? Convert.ToInt32(length) : 25;
            vm.RowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            try
            {
                List<WarningLog> warningLogList = new List<WarningLog>();//
                warningLogList = this.reportService.GetWarningLogs(vm, out totalRows);
                return Json(new { draw = draw, recordsFiltered = totalRows, recordsTotal = totalRows, data = warningLogList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message);
                throw ex;
            }
        }

        [HttpPost]
        public JsonResult ExportToExcel(WarningSearchViewModel vm)
        {
            if (!ModelState.IsValid)
            {
                return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
            }

            try
            {
                vm.PageSize = Int32.MaxValue - 1;
                vm.RowStartIndex = 1;
                var dataSet = reportService.GetWarningLogs(vm);
                MemoryStream ms = EclAdminUtil.GenerateExcelFile(dataSet, Constants.EXCEL_SHEET_NAMES);
                Session["fileName"] = "WarningLogSummary_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
                Session["fileStream"] = ms;
                return Json(new { result = "success" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Warn("Exception ExportToExcel: " + ex.Message);
                return Json(new { result = "fail" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}
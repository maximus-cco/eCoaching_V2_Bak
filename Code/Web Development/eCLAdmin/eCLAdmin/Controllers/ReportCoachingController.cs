using eCLAdmin.Extensions;
using eCLAdmin.Filters;
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
    [SessionCheck]
    public class ReportCoachingController : ReportBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(ReportCoachingController));

        public ReportCoachingController(IReportService reportService, IEmployeeLogService employeeLogService, IEmployeeService employeeService, ISiteService siteService) : base(reportService, siteService, employeeLogService, employeeService)
        {
            logger.Debug("Entered ReportCoachingController(IReportService, IEmployeeLogService, IEmployeeService, ISiteService)");
        }

        // GET: ReportCoaching
        public ActionResult Index()
        {
            return View(InitViewModel());
        }

        [HttpPost]
        public ActionResult GenerateReport(CoachingSearchViewModel vm)
        {
            if (ModelState.IsValid)
            {
                return PartialView("_Report", vm);
            }

            return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
        }

        [HttpPost]
        public ActionResult GetData(CoachingSearchViewModel vm)
        {
            logger.Debug("Entered GetData");

            int totalRows = 0;
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            vm.PageSize = length != null ? Convert.ToInt32(length) : 100;
            vm.RowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            try
            {
                List<CoachingLog> coachingLogList = new List<CoachingLog>();//
                coachingLogList = this.reportService.GetCoachingLogs(vm, out totalRows);
                return Json(new { draw = draw, recordsFiltered = totalRows, recordsTotal = totalRows, data = coachingLogList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error(ex);
                throw ex;
            }
        }

        [HttpPost]
        public JsonResult ExportToExcel(CoachingSearchViewModel vm)
        {
            logger.Debug("################ site=" + vm.SelectedSite + ", employee=" + vm.SelectedEmployee);
            if (!ModelState.IsValid)
            {
                return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
            }

            try
            {
                vm.PageSize = Int32.MaxValue - 1;
                vm.RowStartIndex = 1;
                var dataSet = reportService.GetCoachingLogs(vm);
                MemoryStream ms = EclAdminUtil.GenerateExcelFile(dataSet, Constants.EXCEL_SHEET_NAMES);
                Session["fileName"] = "CoachingLogSummary_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
                Session["fileStream"] = ms;
                return Json(new { result = "success" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Warn(ex);
                return Json(new { result = "fail" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}
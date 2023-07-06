using eCLAdmin.Services;
using eCLAdmin.Extensions;
using eCLAdmin.ViewModels.Reports;
using log4net;
using System.Web.Mvc;
using System.Linq;
using System;
using eCLAdmin.Models.User;
using System.Collections.Generic;
using eCLAdmin.Models.Report;

namespace eCLAdmin.Controllers
{
    public class ReportAdminActivityController : ReportBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public ReportAdminActivityController(IReportService reportService, IEmployeeLogService employeeLogService) : base(reportService, employeeLogService)
        {
            logger.Debug("Entered ReportAdminActivityController(IReportService, IEmployeeLogService)");
        }

        // GET: ReportAdminActivity
        public ActionResult Index()
        {
            return View(InitViewModel());
        }

        private AdminActivitySearchViewModel InitViewModel()
        {
            var vm = new AdminActivitySearchViewModel();
            vm.LogTypeSelectList = GetTypes(Constants.ACTION_REPORT, true);
            vm.ActionSelectList = GetActions(-2, false); // since sp already returns 'All' :-)
            vm.LogNameSelectList = GetLogNames("-2", null, null, null, false);

            return vm;
        }

        public JsonResult GetActions(int logTypeId)
        {
            //return Json(new SelectList(GetActions(logTypeId, false), "Value", "Text"));
            return Json(GetActions(logTypeId, false));
        }

        public JsonResult GetLogNames(string logType, string action, string startDate, string endDate)
        {
            return Json(GetLogNames(logType, action, startDate, endDate, false));
        }

        [HttpPost]
        public ActionResult GenerateReport(AdminActivitySearchViewModel vm)
        {
            if (ModelState.IsValid)
            {
                return PartialView("_Report", vm);
            }

             return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
        }

        [HttpPost]
        public ActionResult GetData(string type, string action, string log, string startDate, string endDate, string logOrEmpName)
        {
            logger.Debug("Entered LoadData");

            // Get Start (paging start index) and length (page size for paging)
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            int pageSize = length != null ? Convert.ToInt32(length) : 25;
            int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            int totalRows = -1;
            try
            {
                List<AdminActivity> logs = this.reportService.GetActivityList(type, action, log, startDate, endDate, logOrEmpName, pageSize, rowStartIndex, out totalRows);
                return Json(new { draw = draw, recordsFiltered = totalRows, recordsTotal = totalRows, data = logs }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
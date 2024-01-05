using eCLAdmin.Services;
using log4net;
using System.Web.Mvc;
using eCLAdmin.Filters;
using eCLAdmin.ViewModels.Reports;
using System;
using System.Collections.Generic;
using System.Linq;
using eCLAdmin.Models.Report;
using eCLAdmin.Extensions;
using System.IO;
using eCLAdmin.Utilities;
using eCLAdmin.Models.Common;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class ReportFeedLoadHistoryController : ReportBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(ReportFeedLoadHistoryController));

        public ReportFeedLoadHistoryController(IReportService reportService, ISiteService siteService, IEmployeeLogService employeeLogService, IEmployeeService employeeService) : base(reportService, siteService, employeeLogService, employeeService)
        {
            logger.Debug("Entered ReportFeedLoadHistoryController(IReportService, IEmployeeLogService)");
        }

        // GET: ReportFeedLoadHistory
        public ActionResult Index()
        {
            return View(InitViewModel());
        }

        private new FeedLoadHistorySearchViewModel InitViewModel()
        {
            var vm = new FeedLoadHistorySearchViewModel();
            vm.CategorySelectList = GetFeedCategorySelectList();
            vm.ReportCodeSelectList = GetFeedReportCodeSelectList(-2);

            vm.StartDate = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy");
            vm.EndDate = DateTime.Now.ToString("MM/dd/yyyy");

            return vm;
        }

        [HttpPost]
        public ActionResult GenerateReport(FeedLoadHistorySearchViewModel vm)
        {
            return PartialView("_Report", vm);
        }

        private IEnumerable<SelectListItem> GetFeedCategorySelectList()
        {
            var categoryList = reportService.GetFeedCategories();
            categoryList.Insert(0, new IdName { Id = -2, Name = "Select Category" });
            IEnumerable<SelectListItem> categories = new SelectList(categoryList, "Id", "Name");

            return categories;
        }

        private IEnumerable<SelectListItem> GetFeedReportCodeSelectList(int categoryId)
        {
            logger.Debug($"Entered GetFeedReportCodeSelectList({categoryId})");
            var codeList = new List<IdName>();
            if (categoryId != -2)
            {
                codeList = reportService.GetFeedReportCodes(categoryId);
            }
            codeList.Insert(0, new IdName { Id = -2, Name = "Select Report Code" });
            IEnumerable<SelectListItem> codes = new SelectList(codeList, "Id", "Name");

            return codes;
        }
        
        [HttpPost]
        public JsonResult GetFeedReportCodes(int categoryId)
        {
            logger.Debug($"##########Entered GetFeedReportCodes({categoryId})");
            var temp = GetFeedReportCodeSelectList(categoryId);
            logger.Debug("@@@@@@@@@temp length= " + temp.Count());
            JsonResult result = Json(temp);
            result.MaxJsonLength = Int32.MaxValue;

            return result;
        }

        [HttpPost]
        public ActionResult GetData(int categoryId, int reportCodeId, string startDate, string endDate)
        {
            logger.Debug($"*********Entered LoadData {categoryId}, {reportCodeId}, {startDate}, {endDate}");

            // Get Start (paging start index) and length (page size for paging)
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            int pageSize = length != null ? Convert.ToInt32(length) : 25;
            int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            int totalRows = 1;
            try
            {
                List<FeedLoadHistory> feedLoadHistory = this.reportService.GetFeedLoadHistory(startDate, endDate, categoryId, reportCodeId, pageSize, rowStartIndex, out totalRows);
                return Json(new { draw = draw, recordsFiltered = totalRows, recordsTotal = totalRows, data = feedLoadHistory }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error(ex);
                throw ex;
            }
        }

        [HttpPost]
        public JsonResult ExportToExcel(FeedLoadHistorySearchViewModel vm)
        {
            logger.Debug($"StartDate[{vm.StartDate}], EndDate[{vm.EndDate}], Category[{vm.SelectedCategory}], ReportCode[{vm.SelectedReportCode}]");
            if (!ModelState.IsValid)
            {
                return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
            }

            try
            {
                var dataSet = reportService.GeFeedLoadHistory(vm.StartDate, vm.EndDate, vm.SelectedCategory, vm.SelectedReportCode);
                MemoryStream ms = EclAdminUtil.GenerateExcelFile(dataSet, Constants.EXCEL_SHEET_NAMES);
                Session["fileName"] = "FeedLoadHistory_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
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
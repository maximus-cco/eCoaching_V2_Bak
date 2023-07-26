using eCLAdmin.Extensions;
using eCLAdmin.Models;
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
    public class ReportEmployeeHierarchyController : ReportBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public ReportEmployeeHierarchyController(IReportService reportService, IEmployeeLogService employeeLogService, IEmployeeService employeeService, ISiteService siteService) : base(reportService, siteService, employeeLogService, employeeService)
        {
            logger.Debug("Entered ReportEmployeeHierarchyController(IReportService, IEmployeeLogService, IEmployeeService, ISiteService)");
        }

        // GET: ReportEmployeeHierarchy
        public ActionResult Index()
        {
            return View(InitViewModel());
        }

        private new EmployeeHierarchySearchViewModel InitViewModel()
        {
            var vm = new EmployeeHierarchySearchViewModel();
            vm.SiteSelectList = GetSites();
            vm.EmployeeSelectList = GetEmployees("Select Site");
    
            return vm;
        }

        private IEnumerable<SelectListItem> GetSites()
        {
            List<Site> siteList = siteService.GetSiteForHierarchyRpt();
            siteList.Insert(0, new Site { Id = "-2", Name = "Select Site" });
            IEnumerable<SelectListItem> sites = new SelectList(siteList, "Id", "Name");

            return sites;
        }

        public JsonResult GetEmployeesBySiteName(string site)
        {
            JsonResult result = Json(GetEmployees(site));
            result.MaxJsonLength = Int32.MaxValue;

            return result;
        }

        private IEnumerable<SelectListItem> GetEmployees(string site)
        {
            List<Employee> employeeList = new List<Employee>();
            if (site != "Select Site")
            {
                employeeList = this.employeeService.GetEmployeesBySite(site);
            }
            employeeList.Insert(0, new Models.EmployeeLog.Employee { Id = "-2", Name = "Select Employee" });

            return employeeList.Select(x => new SelectListItem() { Text = x.Name, Value = x.Id });
        }

        [HttpPost]
        public ActionResult GenerateReport(EmployeeHierarchySearchViewModel vm)
        {
            if (ModelState.IsValid)
            {
                return PartialView("_Report", vm);
            }

            return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
        }

        [HttpPost]
        public ActionResult GetData(string siteName, string employeeId)
        {
            logger.Debug("Entered GetData");

            // Get Start (paging start index) and length (page size for paging)
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            int pageSize = length != null ? Convert.ToInt32(length) : 25;
            int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            int totalRows = 0;
            try
            {
                List<EmployeeHierarchy> employeeHierarchyList = this.reportService.GetEmployeeHierarchy(siteName, employeeId, pageSize, rowStartIndex, out totalRows);
                return Json(new { draw = draw, recordsFiltered = totalRows, recordsTotal = totalRows, data = employeeHierarchyList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message);
                throw ex;
            }
        }

        [HttpPost]
        public JsonResult ExportToExcel(EmployeeHierarchySearchViewModel vm)
        {
            logger.Debug("################ site=" + vm.SelectedSite + ", employee=" + vm.SelectedEmployee);
            if (!ModelState.IsValid)
            {
                return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
            }

            try
            {
                var dataSet = reportService.GetEmployeeHierarchy(vm.SelectedSite, vm.SelectedEmployee);
                MemoryStream ms = EclAdminUtil.GenerateExcelFile(dataSet, Constants.EXCEL_SHEET_NAMES);
                Session["fileName"] = "EmployeeHierarchySummary_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
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
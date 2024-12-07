﻿using eCLAdmin.Services;
using eCLAdmin.Extensions;
using eCLAdmin.ViewModels.Reports;
using log4net;
using System.Web.Mvc;
using System.Linq;
using System;
using System.Collections.Generic;
using eCLAdmin.Models.Report;
using System.IO;
using eCLAdmin.Utilities;
using eCLAdmin.Filters;

namespace eCLAdmin.Controllers
{
    [SessionCheck]
    public class ReportAdminActivityController : ReportBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(ReportAdminActivityController));

        public ReportAdminActivityController(IReportService reportService, ISiteService siteService, IEmployeeLogService employeeLogService, IEmployeeService employeeService) : base(reportService, siteService, employeeLogService, employeeService)
        {
            logger.Debug("Entered ReportAdminActivityController(IReportService, IEmployeeLogService)");
        }

        // GET: ReportAdminActivity
        public ActionResult Index()
        {
            return View(InitViewModel());
        }

        private new AdminActivitySearchViewModel InitViewModel()
        {
            var vm = new AdminActivitySearchViewModel();
            vm.LogTypeSelectList = GetTypes(Constants.ACTION_REPORT, true);
            vm.ActionSelectList = GetActions(-2, false); // since sp already returns 'All' :-)

            vm.StartDate = DateTime.Now.AddDays(-30).ToString("MM/dd/yyyy");
            vm.EndDate = DateTime.Now.ToString("MM/dd/yyyy");

            return vm;
        }

        public JsonResult GetActions(int logTypeId)
        {
            return Json(GetActions(logTypeId, false));
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
        public ActionResult GetData(AdminActivitySearchViewModel vm)
        {
            // Get Start (paging start index) and length (page size for paging)
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            int pageSize = length != null ? Convert.ToInt32(length) : 25;
            int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            int totalRows = 0;
            try
            {
                List<AdminActivity> logs = this.reportService.GetActivityList(
                                                    EclAdminUtil.GetLogTypeNameById(vm.SelectedTypeId), 
                                                    vm.SelectedAction,
                                                    vm.SelectedLog, 
                                                    vm.StartDate, 
                                                    vm.EndDate, 
                                                    vm.FreeTextSearch, 
                                                    pageSize, 
                                                    rowStartIndex, 
                                                    out totalRows
                                            );

                return Json(new { draw = draw, recordsFiltered = totalRows, recordsTotal = totalRows, data = logs }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                logger.Error(ex);
                throw ex;
            }
        }

        [HttpPost]
        public JsonResult ExportToExcel(AdminActivitySearchViewModel vm)
        {
            logger.Debug("################ type=" + vm.SelectedTypeId + ", action=" + vm.SelectedAction + ", log=" + vm.SelectedLog);
            if (!ModelState.IsValid)
            {
                return Json(new { valid = false, validationErrors = ModelState.GetErrors() });
            }

            try
            {
                var dataSet = reportService.GetActivityList(EclAdminUtil.GetLogTypeNameById(vm.SelectedTypeId),
                        vm.SelectedAction, vm.SelectedLog, vm.StartDate, vm.EndDate, vm.FreeTextSearch);
                MemoryStream ms = EclAdminUtil.GenerateExcelFile(dataSet, Constants.EXCEL_SHEET_NAMES);
                Session["fileName"] = "AdminActivitySummary_" + DateTime.Now.ToString("yyyyMMddHHmmssffff") + ".xlsx";
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
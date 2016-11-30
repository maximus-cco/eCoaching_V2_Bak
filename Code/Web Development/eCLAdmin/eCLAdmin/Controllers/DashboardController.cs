using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Services;
using eCLAdmin.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace eCLAdmin.Controllers
{
    public class DashboardController : BaseController
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(DashboardController));

        private readonly IEmployeeLogService employeeLogService;
        private readonly IDashboardService dashboardService;

        public DashboardController(IEmployeeLogService employeeLogService, IDashboardService dashboardService)
        {
            logger.Debug("Entered DashboardController(IEmployeeLogService, IDashboardService)");
            this.employeeLogService = employeeLogService;
            this.dashboardService = dashboardService;
        }

        // GET: Dashboard
        public ActionResult Index()
        {
            // Check if user is allowed to access
            if (!IsAccessAllowed("SeniorManagerDashboard"))
            {
                return RedirectToAction("Index", "Unauthorized");
            }

            DashboardIndexViewModel model = new DashboardIndexViewModel();
            Session["SelectedMonthYear"] = model.SelectedMonthYear;

            DateTime monthYear = Convert.ToDateTime(model.SelectedMonthYear);
            DateTime firstDayOfMonth = Convert.ToDateTime(monthYear);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            model.TotalPendingCoachings = dashboardService.GetLogCount(GetUserFromSession().LanId, "Pending", true, firstDayOfMonth, lastDayOfMonth);
            model.TotalCompletedCoachings = dashboardService.GetLogCount(GetUserFromSession().LanId, "Completed", true, firstDayOfMonth, lastDayOfMonth);
            model.TotalPendingWarnings = dashboardService.GetLogCount(GetUserFromSession().LanId, "Active", false, firstDayOfMonth, lastDayOfMonth);

            DashboardGraphViewModel dgvm = new DashboardGraphViewModel()
            {
                CoachingCompleted = dashboardService.GetChartDataCoachingCompleted(GetUserFromSession().LanId, firstDayOfMonth, lastDayOfMonth),
                CoachingPending = dashboardService.GetChartDataCoachingPending(GetUserFromSession().LanId, firstDayOfMonth, lastDayOfMonth),
                WarningActive = dashboardService.GetChartDataWarningActive(GetUserFromSession().LanId, firstDayOfMonth, lastDayOfMonth)
            };

            model.GraphViewModel = dgvm;
            return View(model);
        }

        [HttpPost]
        public PartialViewResult FetchDataByMonth(string SelectedMonthYear)
        {
            Session["SelectedMonthYear"] = SelectedMonthYear;

            DateTime monthYear = Convert.ToDateTime(SelectedMonthYear);
            DateTime firstDayOfMonth = Convert.ToDateTime(monthYear);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            DashboardIndexViewModel model = new DashboardIndexViewModel();
            model.TotalPendingCoachings = dashboardService.GetLogCount(GetUserFromSession().LanId, "Pending", true, firstDayOfMonth, lastDayOfMonth);
            model.TotalCompletedCoachings = dashboardService.GetLogCount(GetUserFromSession().LanId, "Completed", true, firstDayOfMonth, lastDayOfMonth);
            model.TotalPendingWarnings = dashboardService.GetLogCount(GetUserFromSession().LanId, "Active", false, firstDayOfMonth, lastDayOfMonth);

            DashboardGraphViewModel dgvm = new DashboardGraphViewModel()
            {
                CoachingCompleted = dashboardService.GetChartDataCoachingCompleted(GetUserFromSession().LanId, firstDayOfMonth, lastDayOfMonth),
                CoachingPending = dashboardService.GetChartDataCoachingPending(GetUserFromSession().LanId, firstDayOfMonth, lastDayOfMonth),
                WarningActive = dashboardService.GetChartDataWarningActive(GetUserFromSession().LanId, firstDayOfMonth, lastDayOfMonth)
            };

            model.GraphViewModel = dgvm;

            return PartialView("_Dashboard", model);
        }

        [HttpPost]
        public ActionResult GetPending()
        {
            ViewBag.LogStatus = "Pending";
            ViewBag.Coaching = true;
            Session["Coaching"] = true;
            return PartialView("_List");
        }

        [HttpPost]
        public ActionResult GetCompleted()
        {
            ViewBag.LogStatus = "Completed";
            ViewBag.Coaching = true;
            Session["Coaching"] = true;
            return PartialView("_List");
        }

        [HttpPost]
        public ActionResult GetActive()
        {
            ViewBag.LogStatus = "Active";
            ViewBag.Coaching = false;
            Session["Coaching"] = false;
            return PartialView("_List");
        }

        [HttpPost]
        public ActionResult LoadData(string logStatus)
        {
            var selectedMonthYear = Session["SelectedMonthYear"];

            DateTime monthYear = Convert.ToDateTime(selectedMonthYear);
            DateTime firstDayOfMonth = Convert.ToDateTime(monthYear);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            // get Start (paging start index) and length (page size for paging)
            var draw = Request.Form.GetValues("draw").FirstOrDefault();
            var start = Request.Form.GetValues("start").FirstOrDefault();
            var length = Request.Form.GetValues("length").FirstOrDefault();
            //Get Sort columns value
            var sortColumn = Request.Form.GetValues("columns[" + Request.Form.GetValues("order[0][column]").FirstOrDefault() + "][name]").FirstOrDefault();
            var sortColumnDir = Request.Form.GetValues("order[0][dir]").FirstOrDefault();

            if (sortColumnDir == "asc")
            {
                sortColumnDir = "Y";
            }
            else
            {
                sortColumnDir = "N";
            }

            var search = Request.Form.GetValues("search[value]").FirstOrDefault();

            int pageSize = length != null ? Convert.ToInt32(length) : 0;
            int rowStartIndex = start != null ? Convert.ToInt32(start) + 1 : 1;
            int totalRecords = 0;

            List<EmployeeLog> logs = dashboardService.GetLogList(GetUserFromSession().LanId, logStatus, (bool)Session["Coaching"], firstDayOfMonth, lastDayOfMonth, pageSize, rowStartIndex, sortColumn, sortColumnDir, search);
            totalRecords = dashboardService.GetLogListTotal(GetUserFromSession().LanId, logStatus, (bool)Session["Coaching"], firstDayOfMonth, lastDayOfMonth, search);

            var data = logs;
            return Json(new { draw = draw, recordsFiltered = totalRecords, recordsTotal = totalRecords, data = data }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult GetLogDetail(int logId)
        {
            string partialView = "_CoachingDetail";
            bool isCoaching = (bool)Session["Coaching"];

            if (!isCoaching)
            {
                partialView = "_WarningDetail";
            }

            return PartialView(partialView, dashboardService.GetLogDetail(logId, isCoaching));
        }
    }
}
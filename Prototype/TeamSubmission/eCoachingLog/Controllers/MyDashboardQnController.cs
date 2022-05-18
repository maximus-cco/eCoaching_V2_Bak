using eCoachingLog.Models.Common;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class MyDashboardQnController : LogBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public MyDashboardQnController(ISiteService siteService, IEmployeeLogService employeeLogService, IEmployeeService employeeService) : base(siteService, employeeService, employeeLogService)
        {
            logger.Debug("Entered MyDashboardQnController(IEmployeeLogService, IDashboardService)");
        }

        // GET: MyDashboardQn
        public ActionResult Index()
        {
            var vm = InitViewModel(null, null);
            return View("_Default", vm);
        }

        private MyDashboardQnViewModel InitViewModel(DateTime? start, DateTime? end)
        {
            var user = GetUserFromSession();
            var vm = new MyDashboardQnViewModel();
            IList<LogCount> logCountList = empLogService.GetLogCountsQn(user);
            vm.LogCountList = logCountList;
            vm.Statistic = empLogService.GetPast3MonthStatisticQn(user);

            foreach (var lc in logCountList)
            {
                lc.LogListPageName = Constants.QnLogTypeToPageName[lc.Description];
                if (lc.Description.StartsWith("My Pending"))
                {
                    vm.MyTotalPending += lc.Count;
                }
            }

            vm.LogCountList = logCountList;
            Session["LogCountList"] = logCountList;

            if (user.IsCsr || user.IsArc)
            {
                vm.ShowMyPerformance = true;
                vm.ShowMyTeamPerformance = false;
            }
            else if (user.IsSupervisor || user.IsManager)
            {
                vm.ShowMyPerformance = false;
                vm.ShowMyTeamPerformance = true;
            }

            return vm;
        }

        [HttpPost]
        public ActionResult GetLogsQn(string whatLog, int? siteId, string siteName, string month)
        {
            logger.Debug("Entered GetLogsQn");
            return PartialView(whatLog, InitViewModelByLogType(whatLog, siteId, siteName, month));
        }

        private MyDashboardQnViewModel InitViewModelByLogType(string whatLog, int? siteId, string siteName, string month)
        {
            var user = GetUserFromSession();
            var vm = new MyDashboardQnViewModel(user);
            // Default to all
            vm.Search.SiteId = -1;
            vm.Search.EmployeeId = "-1";
            vm.Search.SupervisorId = "-1";
            vm.Search.ManagerId = "-1";
            vm.Search.SiteName = siteName;
            // Default to MyDashboard
            Session["currentPage"] = Constants.PAGE_MY_DASHBOARD_QN;

            if (user.ShowFollowup)
            {
                vm.Search.ShowFollowupDateColumn = true;
            }
            // Load dropdowns for search
            switch (whatLog)
            {
                // My QN Dashboard - My Pending
                case "_MyPendingReview":
                //case "_MyPendingCoaching":
                case "_MyPendingFollowupPrepare":
                case "_MyPendingFollowupCoaching":
                    // todo: set logtype based on whatlog, so the search sp knows what to search
                    // note: the sp needs to return status
                    vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_PENDING_REVIEW;
                    if (whatLog == "_MyPendingFollowupPrepare")
                    {
                        vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_PENDING_FOLLOWUP_REVIEW;
                    }
                    else if (whatLog == "_MyPendingFollowupCoaching")
                    {
                        vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_PENDING_FOLLOWUP_COACH;
                    }
                    if (user.IsManager)
                    {
                        // Supervisor dropdown
                        // Employee dropdown
                    }

                    // Action link(s) on each row
                    if (user.IsCsr || user.IsArc)
                    {
                        vm.AllowCsrReview = true;
                    }
                    else if (user.IsSupervisor)
                    {
                        if (whatLog == "_MyPendingReview" || whatLog == "_MyPendingFollowupCoaching")
                        {
                            vm.AllowCreateEditSummary = true;
                            vm.AllowCoach = true;
                        }
                        else
                        {
                            vm.AllowFollowupReview = true;
                        }
                    }
                    break;
                // My QN Dashboard - My Completed
                case "_MyCompleted":
                    vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_COMPLETED;
                    vm.Search.ShowFollowupDateColumn = false;
                    vm.ReadOnly = true;
                    // Default to all
                    vm.Search.SupervisorId = "-1";
                    vm.Search.ManagerId = "-1";
                    break;
                // My QN Dashboard - My Team Pending
                case "_MyTeamPending":
                    vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_TEAM_PENDING;
                    if (user.Role == Constants.USER_ROLE_SUPERVISOR)
                    {
                        // Employee dropdown
                        vm.EmployeeSelectList = GetEmpsForSupMyTeamPending(user);
                        // Pending Status dropdown
                        // Status dropdown
                        vm.LogStatusSelectList = GetLogPendingStatusSelectList();
                    }
                    else if (user.Role == Constants.USER_ROLE_MANAGER)
                    {
                        // Supervisor dropdown
                        vm.SupervisorSelectList = GetSupsForMgrMyTeamPending(user);
                        // Employee dropdown
                        vm.EmployeeSelectList = GetEmpsForMgrMyTeamPending(user);
                        // Pending Status dropdown
                        // Status dropdown
                        vm.LogStatusSelectList = GetLogPendingStatusSelectList();
                    }
                    // Source dropdown
                    vm.SourceSelectList = GetLogSourceSelectList(user);
                    break;
                // My QN Dashboard - My Team Completed
                case "_MyTeamCompleted":
                    vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_TEAM_COMPLETED;
                    vm.Search.ShowFollowupDateColumn = false;

                    if (user.IsSupervisor)
                    {
                        // Manager dropdown
                        vm.ManagerSelectList = GetMgrsForSupMyTeamCompleted(user);
                        // Employee dropdown
                        vm.EmployeeSelectList = GetEmpsForSupMyTeamCompleted(user);
                        // Source dropdown
                        vm.SourceSelectList = GetLogSourceSelectList(user);
                    }
                    else if (user.IsManager)
                    {
                        // Supervisor dropdown
                        vm.SupervisorSelectList = GetSupsForMgrMyTeamCompleted(user);
                        // Employee dropdown
                        vm.EmployeeSelectList = GetEmpsForMgrMyTeamCompleted(user);
                    }
                    // Source dropdown
                    vm.SourceSelectList = GetLogSourceSelectList(user);
                    break;
                case "_MySubmission":
                    vm.Search.LogType = Constants.LOG_SEARCH_TYPE_MY_SUBMITTED;
                    Session["currentPage"] = Constants.PAGE_MY_SUBMISSION;
                    vm.Search.ShowFollowupDateColumn = false;
                    // Manager dropdown
                    vm.ManagerSelectList = GetMgrsForMySubmission(user);
                    // Supervisor dropdown
                    vm.SupervisorSelectList = GetSupsForMySubmission(user);
                    // Employee dropdown
                    vm.EmployeeSelectList = GetEmpsForMySubmission(user);
                    // Status dropdown
                    vm.LogStatusSelectList = GetLogStatusSelectList();
                    break;
                default:
                    break;
            }

            return vm;
        }

        [HttpPost]
        public ActionResult Search(MyDashboardQnViewModel vm, int? pageSizeSelected)
        {
            logger.Debug("Entered Search...");
            logger.Debug("pageSizeSelected = " + pageSizeSelected);
            vm.Search.PageSize = pageSizeSelected.HasValue ? pageSizeSelected.Value : 25; // Default to 25

            return PartialView("_LogListQn", vm);
        }

    }
}
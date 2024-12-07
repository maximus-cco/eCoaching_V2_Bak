﻿using eCoachingLog.Filters;
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	[EclAuthorize]
	[SessionCheck]
    public class NewSubmissionController : LogBaseController
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IProgramService programService;
        private readonly IEmailService emailService;
        private readonly INewSubmissionService newSubmissionService;

        public NewSubmissionController(IEmployeeLogService empLogService, 
				ISiteService siteService,
				IEmployeeService employeeService, 
				IProgramService programService, 
				INewSubmissionService newSubmissionService, 
				IEmailService emailService
			) : base(siteService, employeeService, empLogService)
        {
            logger.Debug("Entered NewSubmissionController(ILogCategoryService, ISiteService, ....)");
            this.programService = programService;
            this.newSubmissionService = newSubmissionService;
            this.emailService = emailService;
        }

        // GET: NewSubmission
        public ActionResult Index()
        {
            var sessionId = Session == null ? null : Session.SessionID;
            logger.Debug("?????????SessionID=" + sessionId);

            var vm = InitNewSubmissionViewModel(Constants.MODULE_UNKNOWN);
            vm.IsSuccess = TempData["IsSuccess"] as bool? ?? null;
            vm.ErrorList = TempData["ErrorList"] as List<Error>;
            vm.LogName = TempData["LogName"] == null ? "" : TempData["LogName"] as string;
            Session["newSubmissionVM"] = vm;

            // Store all subcontract sites in session, will check against it when trying to filter out ASR source for subcontractor log submission
            if (Session["AllSubcontractorSites"] == null)
            {
                Session["AllSubcontractorSites"] = siteService.GetAllSubcontractorSites();
            }

            ViewBag.ValidationError = false;

            return View((NewSubmissionViewModel)Session["newSubmissionVM"]);
        }
        
        private IEnumerable<SelectListItem> GetSources(bool isCoachingByYou)
        {
            var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? Constants.DIRECT : Constants.INDIRECT;
            int moduleId = vm.ModuleId;
            bool isSubcontractorSite = false;
            foreach (var s in (IList<Site>)Session["AllSubcontractorSites"])
            {
                if (s.Id == vm.SiteId)
                {
                    isSubcontractorSite = true;
                    break;
                }
            }
            List<LogSource> sourceList = newSubmissionService.GetSourceListByModuleId(moduleId, directOrIndirect, isSubcontractorSite);
            sourceList.Insert(0, new LogSource { Id = -2, Name = "-- Select a Source --" });
            IEnumerable<SelectListItem> sources = new SelectList(sourceList, "Id", "Name");
            return sources;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Save(NewSubmissionViewModel vm)
        {
            logger.Debug("Entered Save ...");

            if (!ModelState.IsValid)
            {
                vm.IsSuccess = false;
                vm.IsValidationError = true;
                ViewBag.ClientValidateCoachingReasons = true;
                ViewBag.ClientValidateEmployee = AllowMassSubmission(vm.ModuleId);
                ViewBag.ValidationError = true;
                return StayOnThisPage(vm);
            }

            // single employee select dropdown 
            if (String.IsNullOrEmpty(vm.EmployeeIds))
            {
                vm.EmployeeIds = vm.Employee.Id;
            }

            //var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            var user = GetUserFromSession();
            IList<NewSubmissionResult> submissionResults = new List<NewSubmissionResult>();
            var successfulSubmissions = new List<NewSubmissionResult>();
            // 1. save submission to db
            try
            {
                // For some reason, when a log is NOT required follow-up, a follow-up is still passed back from page (even though not entered)
                if (vm.IsFollowupRequired.HasValue && !vm.IsFollowupRequired.Value)
                {
                    vm.FollowupDueDate = null;
                }

                if (vm.IsWorkAtHomeReturnSite)
                {
                    vm.BehaviorDetail = String.Format(Constants.RETURN_TO_SITE_1 +
                    Constants.RETURN_TO_SITE_2 + "{0}" +
                    Constants.RETURN_TO_SITE_2_1 + "{1}" +
                    Constants.RETURN_TO_SITE_2_2 +
                    Constants.RETURN_TO_SITE_2_3 + "{2}" +
                    Constants.RETURN_TO_SITE_2_4 +
                    Constants.RETURN_TO_SITE_2_5 +
                    Constants.RETURN_TO_SITE_3 +
                    Constants.RETURN_TO_SITE_4 + "{3}" +
                    Constants.RETURN_TO_SITE_4_1,
                    vm.ReturnToSiteDate, vm.ReturnToSite, vm.ReturnToSupervisor, vm.ReturnToSite);
                }

                vm.EmployeeIdList = EclUtil.ConvertToList(vm.EmployeeIds, ",").Distinct().ToList();
                submissionResults = this.newSubmissionService.Save(vm, GetUserFromSession());
                successfulSubmissions = submissionResults.Where(x => !string.IsNullOrWhiteSpace(x.LogId) && x.LogId != "-1").ToList();

                if (successfulSubmissions.Count != 0 && successfulSubmissions.Count == vm.EmployeeIdList.Count)
                {
                    TempData["IsSuccess"] = true;
                    // single submission - need to show user the log name
                    if (vm.EmployeeIdList.Count == 1)
                    {
                        TempData["LogName"] = successfulSubmissions[0].LogName;
                    }
                }
                else
                {
                    TempData["IsSuccess"] = false;
                    TempData["ErrorList"] = submissionResults.Where(x => (string.IsNullOrWhiteSpace(x.LogId) || x.LogName == "-1")).Select(o =>
                                                new Error
                                                {
                                                    Key = o.Employee.Name,
                                                    Value = o.Error
                                                }
                                            ).ToList<Error>();
                }
            }
            catch (Exception ex)
            {
                logger.Warn("Exception: " + ex);

                vm.IsSuccess = false;
                vm.IsFailAll = true;

                return StayOnThisPage(vm);
            } // end try - 1. save submission to db

            // 2. send notification email
            var sourceId = vm.SourceId;
            // work around to get email attributes for direct: direct [101, 200), indirect [201, 300)
            if (vm.IsWorkAtHomeReturnSite && vm.SourceId > 200)
            {
                sourceId  -= 100;
            }

            // send email for SUCCESSFUL submissions
            if (successfulSubmissions.Count > 0)
            {
                StoreEmail(successfulSubmissions, vm.ModuleId, sourceId, vm.IsWarning, vm.IsCse, user.EmployeeId);
            }

            return RedirectToAction("Index");
        }

        private void StoreEmail(List<NewSubmissionResult> newSubmissionResult, int moduleId, int sourceId, bool? isWarning, bool? isCse, string userId)
        {
            bool bIsCse = isCse != null ? isCse.Value : false;
            bool bIsWarning = isWarning != null && isWarning.Value;
            int iSourceId = bIsWarning ? Constants.WARNING_SOURCE_ID : sourceId;
            var template = (isWarning == null || !isWarning.Value) ?
                    Server.MapPath("~/EmailTemplates/NewSubmissionCoaching.html") : Server.MapPath("~/EmailTemplates/NewSubmissionWarning.html");

            this.emailService.StoreNotification(new MailParameter(newSubmissionResult, moduleId, bIsWarning, bIsCse, iSourceId, template, true, userId));
        }

        private ActionResult StayOnThisPage(NewSubmissionViewModel vm)
        {
            // Repopluate vm from data stored in session so it will be displayed on the page
            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.ModuleSelectList = vmInSession.ModuleSelectList;
            vm.SiteSelectList = vmInSession.SiteSelectList;
            vm.SiteNameSelectList = vmInSession.SiteNameSelectList;
            vm.EmployeeSelectList = vmInSession.EmployeeSelectList;
            vm.EmployeeList = vmInSession.EmployeeList; // dual listbox
            vm.ProgramSelectList = vmInSession.ProgramSelectList;
            vm.BehaviorSelectList = vmInSession.BehaviorSelectList;
            vm.Employee = vmInSession.Employee;
            vm.UserId = vmInSession.UserId;
            vm.UserLanId = vmInSession.UserLanId;
            if (!(vm.IsWarning.HasValue && vm.IsWarning.Value))
            {
                vm.CoachingReasons = SyncCoachReasons(vm.CoachingReasons);

                vm.CallTypeSelectList = vmInSession.CallTypeSelectList;
                vm.SourceSelectList = vmInSession.SourceSelectList;
            }
            else
            {
                vm.WarningReasonSelectList = vmInSession.WarningReasonSelectList;
                vm.WarningTypeSelectList = vmInSession.WarningTypeSelectList;
            }

            vm.ShowSiteDropdown = ShowSiteDropdown(vm);
            vm.ShowEmployeeDropdown = ShowEmployeeDropdown(vm.ModuleId);
            vm.ShowEmployeeDualListbox = ShowEmployeeDualListbox(vm);
            vm.ShowProgramDropdown = ShowProgramDropdown(vm);
			vm.ShowMgtInfo = true;
            vm.ShowBehaviorDropdown = ShowBehaviorDropdown(vm);
            vm.ShowIsCoachingByYou = vmInSession.ShowIsCoachingByYou;
            vm.ShowWarningChoice = vmInSession.ShowWarningChoice;
            vm.ShowIsCseChoice = vmInSession.ShowIsCseChoice;
            vm.ShowActionTextBox = vmInSession.ShowActionTextBox;
            vm.ShowCoachWarningDiv = vmInSession.ShowCoachWarningDiv;
            vm.ShowWarningQuestions = vmInSession.ShowWarningQuestions;
			vm.ShowCallTypeChoice = vmInSession.ShowCallTypeChoice;
			vm.ShowFollowup = vmInSession.ShowFollowup;
            vm.ShowPfdCompletedDate = vm.IsPfd;

            var selectedEmployeeIds = EclUtil.ConvertToList(vm.EmployeeIds, ",");
            foreach (var el in vm.EmployeeList)
            {
                if (selectedEmployeeIds.Contains(el.Value))
                {
                    el.IsSelected = true;
                }
                else
                {
                    el.IsSelected = false;
                }
            }

            return View("Index", vm);
        }

        [HttpPost]
        // For csr module, display dual listbox instead of dropdown for Employee selection, BUT this is for specific users ONLY.
        public ActionResult HandleSiteChanged(int siteIdSelected, int? programIdSelected, string programName)
        {
            logger.Debug($"#######siteSelected={siteIdSelected}");
            NewSubmissionViewModel vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vmInSession.SiteId = siteIdSelected;
            vmInSession.ProgramId = programIdSelected;
            GetEmployeesByModuleToSession(vmInSession.ModuleId, siteIdSelected);
            // Since user has selected a different site, reset partial page, 
            var vm = InitNewSubmissionViewModel(vmInSession.ModuleId);
            vm.ModuleSelectList = vmInSession.ModuleSelectList;
            vm.ModuleId = vmInSession.ModuleId;
            vm.SiteSelectList = vmInSession.SiteSelectList;
            vm.SiteId = siteIdSelected;
            vm.ShowSiteDropdown = true;
            vm.EmployeeSelectList = vmInSession.EmployeeSelectList;
            vm.EmployeeList = vmInSession.EmployeeList;
            vm.ShowEmployeeDropdown = ShowEmployeeDropdown(vm.ModuleId);
            vm.ShowEmployeeDualListbox = !vm.ShowEmployeeDropdown && ShowEmployeeDualListbox(vm);

            if (vm.ModuleId != Constants.MODULE_PRODUCTION_PLANNING)
            {
                vm.ProgramSelectList = vmInSession.ProgramSelectList;
                vm.ProgramId = programIdSelected;
                vm.ProgramName = programName;
                vm.ShowProgramDropdown = true;
            }

            vm.CallTypeSelectList = vmInSession.CallTypeSelectList;

            return PartialView("_NewSubmission", vm);
		}

        private void GetEmployeesByModuleToSession(int moduleId, int siteId)
        {
            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            IList<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, siteId, GetUserFromSession());
            List<SelectListItem> employees = (new SelectList(employeeList, "Id", "Name")).ToList();

            if (employees.Count > 0)
            {
                employees.Insert(0, new SelectListItem { Value = "-2", Text = "-- Select an Employee --" });
            }
            else
            {
                employees.Insert(0, new SelectListItem { Value = "-2", Text = "-- No employee found --" });
            }

            vmInSession.EmployeeSelectList = employees;
            vmInSession.EmployeeList = employeeList.Select(e => new TextValue(e.Name + " (Supervisor: " + e.SupervisorName.Trim() + ")", e.Id, e.SupervisorId + "," + e.ManagerId)).ToList<TextValue>();
        }

        [HttpPost]
        public ActionResult ResetIsCoachingByYou()
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.IsCoachingByYou = null;
            vm.ShowIsCoachingByYou = true;
            vm.ShowCoachWarningDiv = false;
            return PartialView("_NewSubmissionIsCoachingByYou", vm);
        }

        [HttpPost]
        public JsonResult GetMgtInfo(string employeeId)
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			vm.Employee = employeeService.GetEmployee(employeeId);
			return Json(new { SupervisorName = vm.Employee.SupervisorName, ManagerName = vm.Employee.ManagerName }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ResetPageBottom(//string employeeId, int? programId, 
            bool isCoachingByYou, bool? isCse, bool? isWarning, string employeeIds, int? sourceId)
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.IsCoachingByYou = isCoachingByYou;
            vm.IsCse = isCse;
            vm.IsWarning = isWarning;
            vm.EmployeeIds = employeeIds;
            if (!String.IsNullOrEmpty(employeeIds))
            {
                // employee selected in dual list box
                // reload employee
                var empIds = vm.EmployeeIds;
                vm.EmployeeIdList = EclUtil.ConvertToList(vm.EmployeeIds, ",").Distinct().ToList();
                vm.Employee = this.employeeService.GetEmployee(vm.EmployeeIdList.First());
            }
			vm.ShowIsCoachingByYou = true;
            vm.ShowCoachWarningDiv = true;
            vm.ShowWarningChoice = ShowWarningChoice(vm);
            vm.ShowIsCseChoice = ShowIsCseChoice(vm);
            vm.ShowActionTextBox = ShowActionTextbox(vm);
			vm.ShowCallTypeChoice = ShowCallTypeChoice(vm);

            bool isSpecialResaon = isCse.HasValue && isCse.Value ? true : false;
            int specialReasonPriority = 2;

            if (isWarning.HasValue && isWarning.Value) // warning
            {
                vm.WarningTypeSelectList = GetWarningTypes(isCoachingByYou, sourceId);
                vm.ShowWarningQuestions = true;
            }
            else // coaching
            {
                vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, specialReasonPriority, sourceId);
                vm.SourceSelectList = GetSources(isCoachingByYou);
                vm.ShowWarningQuestions = false;
            }

            return PartialView("_NewSubmissionBottom", vm);
        }

        private bool ShowWarningChoice(NewSubmissionViewModel vm)
        {

            // more than one selected in dual list box
            // One warning per submission
            if (vm.EmployeeIdList != null && vm.EmployeeIdList.Count > 1)
            {
                return false;
            }

            // only one employee selected
            // submitter is either the supervisor or manager, and submitter has chosen "coaching by you", and the selected employee is not subcontractor
            return vm.IsCoachingByYou.HasValue
                && vm.IsCoachingByYou.Value
                && !vm.Employee.IsSubcontractor // no warning logs for subcontractors 
                && (vm.Employee.SupervisorId == vm.UserId || vm.Employee.ManagerId == vm.UserId);
        }

        private Employee GetSelectedEmployee()
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            return vm.Employee;
        }

        private int GetSelectedModuleId()
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            return vm.ModuleId;
        } 

        private IEnumerable<SelectListItem> GetWarningTypes(bool isCoachingByYou, int? sourceId)
        {
            string employeeId = GetSelectedEmployee().Id;
			int moduleId = ((NewSubmissionViewModel)Session["newSubmissionVM"]).ModuleId;
			string source = GetDirectOrIndirect(isCoachingByYou);//"direct";
            bool specialReason = true;
            int reasonPriority = 1;
            // Warning Type Dropdown
            List<WarningType> warningTypeList = this.empLogService.GetWarningTypes(moduleId, source, specialReason, reasonPriority, employeeId, GetUserFromSession().EmployeeId, sourceId);
            warningTypeList.Insert(0, new WarningType { Id = -2, Text = "-- Select a Warning Type --" });
            IEnumerable<SelectListItem> warningTypes = new SelectList(warningTypeList, "Id", "Text");

            return warningTypes;
        }

        private string GetDirectOrIndirect(bool isCoachingByYou)
        {
            return isCoachingByYou ? Constants.DIRECT : Constants.INDIRECT;
        }

        [HttpPost]
        public JsonResult GetWarningReasons(int warningTypeId)
        {
            var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];

			if (warningTypeId == -2)
            {
                vm.WarningReasonSelectList = new List<SelectListItem>();
                return Json(new SelectList(vm.WarningReasonSelectList, "Value", "Text"), JsonRequestBehavior.AllowGet);
            }

            bool? isCoachingByYou = vm.IsCoachingByYou;
            bool coachingByYou = false;
            if (isCoachingByYou.HasValue)
            {
                coachingByYou = isCoachingByYou.Value;
            }

            string directOrIndirect = GetDirectOrIndirect(coachingByYou);
            string userLanId = GetUserFromSession().LanId;
            // Warning Reasons Dropdown
            List<WarningReason> warningReasonList = this.empLogService.GetWarningReasons(warningTypeId, directOrIndirect, vm.ModuleId, vm.Employee.Id, null); // NO "how was this identified question on page for warning"
            warningReasonList.Insert(0, new WarningReason { Id = -2, Text = "-- Select a Warning Reason --" });
            IEnumerable<SelectListItem> warningReasonSelectList = new SelectList(warningReasonList, "Id", "Text");
            vm.WarningReasonSelectList = warningReasonSelectList;

            return Json(new SelectList(warningReasonSelectList, "Value", "Text"), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ShowCoachQuestions(bool isCoachingByYou)
        {
            // Update vm
            var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.IsCoachingByYou = isCoachingByYou;
            return PartialView("_NewSubmissionCoach", (NewSubmissionViewModel)Session["newSubmissionVM"]);
        }

        // User selects a different module
        [HttpPost]
        public ActionResult ResetPage(int moduleId)
        {
            NewSubmissionViewModel vm = InitNewSubmissionViewModel(moduleId);

            if (moduleId == -2) // No module selected
            {
                Session["newSubmissionVM"] = vm;
                return PartialView("_NewSubmission", vm);
            }

            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = (vmInSession.IsCoachingByYou.HasValue && vmInSession.IsCoachingByYou.Value) ? Constants.DIRECT : Constants.INDIRECT;

            // Load Site dropdown
            if (moduleId == Constants.MODULE_CSR
                    || moduleId == Constants.MODULE_ISG
                    || moduleId == Constants.MODULE_QUALITY
                    || moduleId == Constants.MODULE_SUPERVISOR
                    || moduleId == Constants.MODULE_PRODUCTION_PLANNING)
            {
                IList<Site> siteList = this.siteService.GetSites(true, GetUserFromSession(), moduleId);
                siteList.Insert(0, new Site { Id = -2, Name = "-- Select a Site --" });
                vm.SiteSelectList = new SelectList(siteList, "Id", "Name");

                // Return to Site, remove "All Sites"
                var returnToSiteList = new List<Site>();
                foreach (var v in siteList)
                {
                    returnToSiteList.Add((Site)v.Clone());
                }
                returnToSiteList.Remove(returnToSiteList.Where(x => x.Name == "All Sites").FirstOrDefault<Site>());
                vm.SiteNameSelectList = new SelectList(returnToSiteList, "Name", "Name");
            }

            // Load Employee dropdown for others
            //if (moduleId != Constants.MODULE_CSR
            //        && !AllowMassSubmission(moduleId))
            if (!AllowMassSubmission(moduleId))
            {
                var siteId = 0;
                var user = GetUserFromSession();
                if (user.IsSubcontractor)
                {
                    siteId = user.SiteId; // subcontractor can submit logs for their own site only
                }
                // CCO user
                else
                {
                    // Regualr CCO users - can submit logs for CCO sites only
                    if (!user.IsPma && !user.IsDirPma && !user.IsArc && !user.IsQam) 
                    {
                        siteId = Constants.ALL_SITES_CCO;
                    }
                    // PMA, DIRPMA, ARC, QAM - can submit logs for CCO sites + subcontractor sites
                    else
                    {
                        siteId = Constants.ALL_SITES;
                    }
                }

                logger.Debug("&&&&&&&& siteID = " + siteId);

                IList<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, siteId, user);

                List<SelectListItem> employees = (new SelectList(employeeList, "Id", "Name")).ToList();
                employees.Insert(0, new SelectListItem { Value = "-2", Text = "-- Select an Employee --" });
                vm.EmployeeSelectList = employees;
                vm.EmployeeList = employeeList.Select(e => new TextValue(e.Name, e.Id)).ToList<TextValue>();
           }

            // Program Dropdown
            if (moduleId != Constants.MODULE_TRAINING && moduleId != Constants.MODULE_PRODUCTION_PLANNING)
            {
                IList<Program> programList = this.programService.GetPrograms(moduleId);
                programList.Insert(0, new Program { Id = -2, Name = "-- Select a Program --" });
                IEnumerable<SelectListItem> programSelectList = new SelectList(programList, "Id", "Name");
                vm.ProgramSelectList = programSelectList;
            }
            else // Behavior Dropdown
            {
                List<Behavior> behaviorList = this.empLogService.GetBehaviors(moduleId);
                behaviorList.Insert(0, new Behavior { Id = -2, Text = "-- Select a Behavior --" });
                IEnumerable<SelectListItem> behaviorSelectList = new SelectList(behaviorList, "Id", "Text");
                vm.BehaviorSelectList = behaviorSelectList;
            }

            vm.ShowSiteDropdown = ShowSiteDropdown(vm);
            vm.ShowEmployeeDropdown = ShowEmployeeDropdown(vm.ModuleId);
            vm.ShowEmployeeDualListbox = ShowEmployeeDualListbox(vm);
            vm.ShowProgramDropdown = ShowProgramDropdown(vm);
            vm.ShowBehaviorDropdown = ShowBehaviorDropdown(vm);

            IList<CallType> callTypeList = empLogService.GetCallTypes(moduleId);
            IEnumerable<SelectListItem> callTypes = new SelectList(callTypeList, "Name", "Name");
            Session["CallTypeList"] = callTypeList;
            vm.CallTypeSelectList = callTypes;

            Session["newSubmissionVM"] = vm;
            return PartialView("_NewSubmission", vm);
        }

        private List<CoachingReason> GetCoachingReasons(int iModuleId, bool isCoachingByYou, bool isCse, int priority, int? sourceId)
        {
            string directOrIndirect = GetDirectOrIndirect(isCoachingByYou);//"direct";
            int moduleId = ((NewSubmissionViewModel)Session["newSubmissionVM"]).ModuleId;
            string userId = GetUserFromSession().EmployeeId;
            string employeeId = ((NewSubmissionViewModel)Session["newSubmissionVM"]).Employee.Id;
            bool isSpecialResaon = isCse;
            int specialReasonPriority = priority;

            if (!isCoachingByYou)
            {
				directOrIndirect = Constants.INDIRECT;
            }

			List<CoachingReason> reasons = this.empLogService.GetCoachingReasons(directOrIndirect, moduleId, userId, employeeId, isSpecialResaon, specialReasonPriority, sourceId);

			return reasons;
        }

        [HttpPost]
        public ActionResult LoadCoachingReasons(bool? isCoachingByYou, bool? isCse, int sourceId)
        {
            bool coachingByYou = isCoachingByYou.HasValue ? isCoachingByYou.Value : false;
            bool cse = isCse.HasValue ? isCse.Value : false;
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, coachingByYou, cse, 2, sourceId);
            // Save in session
            vm.IsCoachingByYou = isCoachingByYou;
            vm.IsCse = isCse;

            return PartialView("_NewSubmissionCoachingReasons", vm);
        }

        [HttpPost]
        public ActionResult HandleCoachingReasonClicked(bool isChecked, int reasonId, int reasonIndex, int sourceId)
        {
            var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			CoachingReason thisReason = null;
			try
			{
				thisReason = vm.CoachingReasons.First(cr => cr.ID == reasonId);
			}
			catch (InvalidOperationException ioe)
			{
				// Something is wrong, log the exception
				User user = GetUserFromSession();
				var userId = user == null ? "usernull" : user.EmployeeId;
				int reasonsInSessionCount = vm.CoachingReasons == null ? -1 : vm.CoachingReasons.Count;
				StringBuilder msg = new StringBuilder("Exception: ");
				msg.Append("[").Append(userId).Append("]")
					.Append("|ReasonsInSessionCount").Append("[").Append(reasonsInSessionCount).Append("]")
					.Append("|ReasonIDToSearch").Append("[").Append(reasonId).Append("]: ")
					.Append(ioe.Message)
					.Append(Environment.NewLine)
					.Append(ioe.StackTrace);
				logger.Warn(msg);

				// Reload Coaching Reasons to Session if user is not null (means session not expired yet)
				// In this case, coaching reasons are reset, and user will lose his/her selections, still better than kicking user out of the system
				if (user != null)
				{
					bool isSpecialResaon = vm.IsCse.HasValue && vm.IsCse.Value ? true : false;
					bool isCoachingByYou = !vm.IsCoachingByYou.HasValue ? false : vm.IsCoachingByYou.Value;
					vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, 2, sourceId);
					thisReason = vm.CoachingReasons.First(cr => cr.ID == reasonId);

					StringBuilder info = new StringBuilder();
					info.Append("[").Append(userId).Append("]: ")
						.Append("Reload coaching reasons to session from database.");
					logger.Warn(info);
				}
			}

			thisReason.IsChecked = isChecked;
			thisReason.SubReasons = GetSubReasons(reasonId, sourceId);
			List<string> values = GetCoachValues(reasonId, sourceId);
			if (values.Any(s => s.Contains("Opportunity")))
			{
				thisReason.OpportunityOption = true;
			}
			if (values.Any(s => s.Contains("Reinforcement")))
			{
				thisReason.ReinforcementOption = true;
			}
            if (values.Any(s => s.Contains("Reasearch Required")))
            {
                thisReason.ResearchOption = true;
            }

            thisReason.AllowMultiSubReason = true;
            if (sourceId == Constants.SOURCE_DIRECT_ASR || sourceId == Constants.SOURCE_INDIRECT_ASR)
            {
                if (reasonId == Constants.REASON_CALL_EFFICIENCY)
                {
                    thisReason.AllowMultiSubReason = false;
                }
            }
		
			// _NewSubmissionCoachingReason.cshtml needs it.
			ViewData["index"] = reasonIndex;
			return PartialView("_NewSubmissionCoachingReason", thisReason);
		}

		private List<CoachingSubReason> GetSubReasons(int reasonId, int sourceId)
		{
			var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? "Direct" : "Indirect";
			return this.empLogService.GetCoachingSubReasons(reasonId, vm.ModuleId, directOrIndirect, GetUserFromSession().EmployeeId, sourceId);
		}

		private List<string> GetCoachValues(int reasonId, int sourceId)
		{
			var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? "Direct" : "Indirect";
			return this.empLogService.GetValues(reasonId, directOrIndirect, vm.ModuleId, sourceId);
		}

        private List<CoachingReason> SyncCoachReasons(List<CoachingReason> crs)
        {
			NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			// if vm is null, something must be wrong, don't check if vm is null,
			List<CoachingReason> reasonsInSession = vm.CoachingReasons;
			foreach (CoachingReason cr in crs)
			{
				CoachingReason crToChange = null;
				try
				{
					crToChange = reasonsInSession.First(c => c.ID == cr.ID);
					crToChange.IsChecked = cr.IsChecked;
					crToChange.Type = cr.Type;
					crToChange.SubReasonIds = cr.SubReasonIds;
				}
				catch (InvalidOperationException ioe)
				{
					// Something is wrong, log the exception
					User user = GetUserFromSession();
					var userId = user == null ? "usernull" : user.EmployeeId;
					int reasonsInSessionCount = reasonsInSession == null ? -1 : reasonsInSession.Count;
					StringBuilder msg = new StringBuilder("Exception: ");
					msg.Append("[").Append(userId).Append("]")
						.Append("|ReasonsInSessionCount").Append("[").Append(reasonsInSessionCount).Append("]")
						.Append("|ReasonIDToSearch").Append("[").Append(cr.ID).Append("]: ")
						.Append(ioe.Message)
						.Append(Environment.NewLine)
						.Append(ioe.StackTrace);
					logger.Warn(msg);

					// Reload Coaching Reasons to Session if user is not null (means session not expired yet)
					// In this case, coaching reasons are reset, and user will lose his/her selections, still better than kicking user out of the system
					if (user != null)
					{
						bool isSpecialResaon = vm.IsCse.HasValue && vm.IsCse.Value ? true : false;
						bool isCoachingByYou = !vm.IsCoachingByYou.HasValue ? false : vm.IsCoachingByYou.Value;
						reasonsInSession = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, 2, vm.SourceId);

						StringBuilder info = new StringBuilder();
						info.Append("[").Append(userId).Append("]: ")
							.Append("Reload coaching reasons to session from database. User lost selections.");
						logger.Warn(info);
					}
					break;
				}
			}

            return reasonsInSession;
        }

        private NewSubmissionViewModel InitNewSubmissionViewModel(int moduleId)
        {
            User user = GetUserFromSession();
            NewSubmissionViewModel vm = new NewSubmissionViewModel(user.EmployeeId, user.LanId);
            vm.IsSubcontractor = user.IsSubcontractor;
			vm.ModuleId = moduleId;
			vm.ShowFollowup = moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_ISG || moduleId == Constants.MODULE_PRODUCTION_PLANNING;
            vm.UserId = user.EmployeeId;

            // Module Dropdown
            List<Module> moduleList = this.empLogService.GetModules(user);
            moduleList.Insert(0, new Module { Id = -2, Name = "-- Select Employee Level --" });
            IEnumerable<SelectListItem> moduleSelectList = new SelectList(moduleList, "Id", "Name");
            vm.ModuleSelectList = moduleSelectList;

            return vm;
        }

        private bool ShowSiteDropdown(NewSubmissionViewModel vm)
        {
            return vm.ModuleId == Constants.MODULE_CSR
                        || vm.ModuleId == Constants.MODULE_ISG
                        || vm.ModuleId == Constants.MODULE_PRODUCTION_PLANNING
                        || AllowMassSubmission(vm.ModuleId);
        }

        private bool ShowEmployeeDropdown(int moduleId)
        {
            return moduleId != -2 && !AllowMassSubmission(moduleId);
        }

        // ISG - WACS50, WPPM50
        // Supervisor - WACS50, WACS60
        // Quality - WACQ13, WACQ40, and WPPM50
        // Production Planning - ???
        private bool AllowMassSubmission(int moduleId)
        {
            var userJobCode = GetUserFromSession().JobCode;
            if (String.IsNullOrEmpty(userJobCode))
            {
                return false;
            }

            userJobCode = userJobCode.Trim().ToUpper();

            // CSR module
            if (moduleId == Constants.MODULE_CSR)
            {
                return Constants.MASS_SUBMISSION_CSR.Contains(userJobCode);
            }

            // Supervisor module
            if (moduleId == Constants.MODULE_SUPERVISOR)
            {
                return Constants.MASS_SUBMISSION_SUPERVISOR.Contains(userJobCode);
            }

            // Quality module
            if (moduleId == Constants.MODULE_QUALITY)
            {
                return Constants.MASS_SUBMISSION_QUALITY.Contains(userJobCode);
            }

            // ISG module
            if (moduleId == Constants.MODULE_ISG)
            {
                return Constants.MASS_SUBMISSION_ISG.Contains(userJobCode);
            }

            // Production Planning module
            if (moduleId == Constants.MODULE_PRODUCTION_PLANNING)
            {
                return Constants.MASS_SUBMISSION_PRODUCTION_PLANNING.Contains(userJobCode);
            }

            // All other modules
            return false;
        }

        private bool ShowEmployeeDualListbox(NewSubmissionViewModel vm)
        {
            logger.Debug($"****######moduleId={vm.ModuleId}");
            logger.Debug($"****######siteId={vm.SiteId}");

            // No module selected
            if (vm.ModuleId == -2 || vm.SiteId == -2)
            {
                return false;
            }

            // No mass/team submission for modules OTHER THAN csr, quality, ISG, supervisor, and Production Planning
            if (vm.ModuleId != Constants.MODULE_CSR
                    && vm.ModuleId != Constants.MODULE_ISG
                    && vm.ModuleId != Constants.MODULE_QUALITY
                    && vm.ModuleId != Constants.MODULE_SUPERVISOR
                    && vm.ModuleId != Constants.MODULE_PRODUCTION_PLANNING)
            {
                return false;
            }

            // Show employee dual list box only if site is selected, so it knows what employees to display in the dual list box
            return vm.SiteId != null
                    && vm.SiteId > -5
                    && AllowMassSubmission(vm.ModuleId);
        }
        
        private bool ShowProgramDropdown(NewSubmissionViewModel vm)
        {
            // Do not display Program dropdown for Training/LSA/Production Planning
            return vm.ModuleId > 0 
                && vm.ModuleId != Constants.MODULE_TRAINING 
                && vm.ModuleId != Constants.MODULE_LSA
                && vm.ModuleId != Constants.MODULE_PRODUCTION_PLANNING;
        }

        private bool ShowBehaviorDropdown(NewSubmissionViewModel vm)
        {
            // TRAINING module only
            return vm.ModuleId == Constants.MODULE_TRAINING;
        }

        private bool ShowIsCseChoice(NewSubmissionViewModel vm)
        {
            return vm.ModuleId == Constants.MODULE_CSR 
                        || vm.ModuleId == Constants.MODULE_ISG 
                        || vm.ModuleId == Constants.MODULE_SUPERVISOR 
                        || vm.ModuleId == Constants.MODULE_TRAINING;
        }

        public bool ShowActionTextbox(NewSubmissionViewModel vm)
        {
            return vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value;
        }

		public bool ShowCallTypeChoice(NewSubmissionViewModel vm)
		{
            // Do not show Call Type question for LSA/Production Planning
			return vm.ModuleId != Constants.MODULE_LSA 
                        && vm.ModuleId != Constants.MODULE_PRODUCTION_PLANNING;
		}

        // Add employee to the unselected employee dual-listbox
        [HttpPost]
        public ActionResult InitAddEmployee(string excludeSiteId)
        {
            var vm = new NewSubmissionViewModel();
            NewSubmissionViewModel vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.SiteSelectList = vmInSession.SiteSelectList.Where(x => x.Value != excludeSiteId);
            return PartialView("_AddEmployee", vm);
        }
        
        public JsonResult GetEmployees(int siteId)
        {
            NewSubmissionViewModel vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            int moduleId = vmInSession.ModuleId;
            var userEmpId = GetUserFromSession().EmployeeId;
            var empList = this.employeeService.GetEmployeesByModule(moduleId, siteId, GetUserFromSession()).ToList<Employee>();
            // exclude employee(s) added to the left dual list box from Add (other sites)
            empList = empList.Where(x => vmInSession.EmployeeList.All(y => y.Value != x.Id)).ToList<Employee>();

            empList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
            IEnumerable<SelectListItem> employees = new SelectList(empList, "Id", "NamePlusSupervisorName");

            JsonResult result = Json(employees);
            result.MaxJsonLength = Int32.MaxValue;
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            return result;
        }
        
        [HttpPost]
        public JsonResult AddEmployeeToSession(string employeeId, string employeeName, string siteName)
        {
            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            var employeeFound = vmInSession.EmployeeList.Where(x => x.Value == employeeId).FirstOrDefault();
            if (employeeFound == null)
            {
                var employee = new TextValue(employeeName + "(" + siteName + ")", employeeId);
                vmInSession.EmployeeList.Add(employee);
            }

            return Json(new EmptyResult(), JsonRequestBehavior.AllowGet);
        }
   
    }

}
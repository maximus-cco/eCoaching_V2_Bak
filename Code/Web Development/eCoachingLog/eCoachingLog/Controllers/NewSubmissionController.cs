using eCoachingLog.Filters;
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
            Session["newSubmissionVM"] = vm;

            ViewBag.ValidationError = false;

            return View((NewSubmissionViewModel)Session["newSubmissionVM"]);
        }
        
        private IEnumerable<SelectListItem> GetSources(bool isCoachingByYou)
        {
            var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? Constants.DIRECT : Constants.INDIRECT;
            int moduleId = vm.ModuleId;
            List<LogSource> sourceList = newSubmissionService.GetSourceListByModuleId(moduleId, directOrIndirect);
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
                ViewBag.ClientValidateEmployee = vm.ModuleId == Constants.MODULE_CSR;
                ViewBag.ValidationError = true;
                return StayOnThisPage(vm);
            }

            // single employee select dropdown 
            if (String.IsNullOrEmpty(vm.EmployeeIds))
            {
                vm.EmployeeIds = vm.Employee.Id;
            }

            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
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

                vm.EmployeeIdList = EclUtil.ConvertToList(vm.EmployeeIds, ",");
                submissionResults = this.newSubmissionService.Save(vm, GetUserFromSession());
                successfulSubmissions = submissionResults.Where(x => x.LogId != "-1").ToList();

                if (successfulSubmissions.Count == vm.EmployeeIdList.Count)
                {
                    TempData["IsSuccess"] = true;
                }
                else
                {
                    TempData["IsSuccess"] = false;
                    TempData["ErrorList"] = submissionResults.Where(x => x.LogName == "-1").Select(o =>
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
                vm.ErrorList = new List<Error>()
                {
                    new Error()
                    {
                        Key = "Error",
                        Value = ex.Message
                    }
                };

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
            vm.ShowEmployeeDropdown = ShowEmployeeDropdown(vm);
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
        // only csr module has site dropdown, so this must be csr module. 
        // For csr module, display dual listbox instead of dropdown for Employee selection, BUT this is for specific users ONLY.
        public ActionResult HandleSiteChanged(int siteIdSelected, int programIdSelected, string programName)
        {
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
            // CSR - use dual listbox for users with job codes of WACS40, WACS50, WACS60
            vm.ShowEmployeeDropdown = ShowEmployeeDropdown(vm);
            vm.ShowEmployeeDualListbox = ShowEmployeeDualListbox(vm);

            vm.ProgramSelectList = vmInSession.ProgramSelectList;
            vm.ProgramId = programIdSelected;
            vm.ProgramName = programName;
            vm.ShowProgramDropdown = true;
            vm.CallTypeSelectList = vmInSession.CallTypeSelectList;

            return PartialView("_NewSubmission", vm);
		}

        private void GetEmployeesByModuleToSession(int moduleId, int siteId)
        {
            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            IList<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, siteId, GetUserFromSession().EmployeeId);
            //employeeList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
            List<SelectListItem> employees = (new SelectList(employeeList, "Id", "Name")).ToList();
            employees.Insert(0, new SelectListItem { Value = "-2", Text = "-- Select an Employee --" });
            vmInSession.EmployeeSelectList = employees;
            vmInSession.EmployeeList = employeeList.Select(e => new TextValue(e.Name + " (Supervisor: " + e.SupervisorName.Trim() + ")", e.Id)).ToList<TextValue>();
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
            bool isCoachingByYou, bool? isCse, bool? isWarning)
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.IsCoachingByYou = isCoachingByYou;
            vm.IsCse = isCse;
            vm.IsWarning = isWarning;
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
                vm.WarningTypeSelectList = GetWarningTypes(isCoachingByYou);
                vm.ShowWarningQuestions = true;
            }
            else // coaching
            {
                vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, specialReasonPriority);
                vm.SourceSelectList = GetSources(isCoachingByYou);
                vm.ShowWarningQuestions = false;
            }

            return PartialView("_NewSubmissionBottom", vm);
        }

        private bool ShowWarningChoice(NewSubmissionViewModel vm)
        {
            return vm.IsCoachingByYou.HasValue
                && vm.IsCoachingByYou.Value
                && ((vm.Employee.SupervisorId != null && vm.Employee.SupervisorId == vm.UserId) ||
                        (vm.Employee.ManagerId != null && vm.Employee.ManagerId == vm.UserId));
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

        private IEnumerable<SelectListItem> GetWarningTypes(bool isCoachingByYou)
        {
            string employeeId = GetSelectedEmployee().Id;
			int moduleId = ((NewSubmissionViewModel)Session["newSubmissionVM"]).ModuleId;
			string source = GetDirectOrIndirect(isCoachingByYou);//"direct";
            bool specialReason = true;
            int reasonPriority = 1;
            // Warning Type Dropdown
            List<WarningType> warningTypeList = this.empLogService.GetWarningTypes(moduleId, source, specialReason, reasonPriority, employeeId, GetUserFromSession().EmployeeId);
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
            List<WarningReason> warningReasonList = this.empLogService.GetWarningReasons(warningTypeId, directOrIndirect, vm.ModuleId, vm.Employee.Id);
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
            // Load Site dropdown for CSR
            if (moduleId == Constants.MODULE_CSR)
            {
                // Site dropdown is static, so we can use the one in session if exists
                if (vmInSession.SiteSelectList.Count() > 1)
                {
                    vm.SiteSelectList = vmInSession.SiteSelectList;
                }
                else
                {
                    IList<Site> siteList = this.siteService.GetSites();
                    siteList.Insert(0, new Site { Id = -2, Name = "-- Select a Site --" });
                    vm.SiteSelectList = new SelectList(siteList, "Id", "Name");
					vm.SiteNameSelectList = new SelectList(siteList, "Name", "Name");
				}
            }
            // Load Employee dropdown for others
            else 
            {
                IList<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, Constants.ALL_SITES, GetUserFromSession().EmployeeId);
                List<SelectListItem> employees = (new SelectList(employeeList, "Id", "Name")).ToList();
                employees.Insert(0, new SelectListItem { Value = "-2", Text = "-- Select an Employee --" });
                vm.EmployeeSelectList = employees;
                vm.EmployeeList = employeeList.Select(e => new TextValue(e.Name, e.Id)).ToList<TextValue>();
           }

            // Program Dropdown
            if (moduleId != Constants.MODULE_TRAINING)
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
            vm.ShowEmployeeDropdown = ShowEmployeeDropdown(vm);
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

        private List<CoachingReason> GetCoachingReasons(int iModuleId, bool isCoachingByYou, bool isCse, int priority)
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

			List<CoachingReason> reasons = this.empLogService.GetCoachingReasons(directOrIndirect, moduleId, userId, employeeId, isSpecialResaon, specialReasonPriority);

			return reasons;
        }

        [HttpPost]
        public ActionResult LoadCoachingReasons(bool? isCoachingByYou, bool? isCse)
        {
            bool coachingByYou = isCoachingByYou.HasValue ? isCoachingByYou.Value : false;
            bool cse = isCse.HasValue ? isCse.Value : false;
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, coachingByYou, cse, 2);
            // Save in session
            vm.IsCoachingByYou = isCoachingByYou;
            vm.IsCse = isCse;

            return PartialView("_NewSubmissionCoachingReasons", vm);
        }

        [HttpPost]
        public ActionResult HandleCoachingReasonClicked(bool isChecked, int reasonId, int reasonIndex)
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
					vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, 2);
					thisReason = vm.CoachingReasons.First(cr => cr.ID == reasonId);

					StringBuilder info = new StringBuilder();
					info.Append("[").Append(userId).Append("]: ")
						.Append("Reload coaching reasons to session from database.");
					logger.Warn(info);
				}
			}

			thisReason.IsChecked = isChecked;
			thisReason.SubReasons = GetSubReasons(reasonId);
			List<string> values = GetCoachValues(reasonId);
			if (values.Any(s => s.Contains("Opportunity")))
			{
				thisReason.OpportunityOption = true;
			}
			if (values.Any(s => s.Contains("Reinforcement")))
			{
				thisReason.ReinforcementOption = true;
			}
			
			// _NewSubmissionCoachingReason.cshtml needs it.
			ViewData["index"] = reasonIndex;
			return PartialView("_NewSubmissionCoachingReason", thisReason);
		}

		private List<CoachingSubReason> GetSubReasons(int reasonId)
		{
			var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? "Direct" : "Indirect";
			return this.empLogService.GetCoachingSubReasons(reasonId, vm.ModuleId, directOrIndirect, GetUserFromSession().EmployeeId);
		}

		private List<string> GetCoachValues(int reasonId)
		{
			var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
			string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? "Direct" : "Indirect";
			return this.empLogService.GetValues(reasonId, directOrIndirect, vm.ModuleId);
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
					crToChange.IsOpportunity = cr.IsOpportunity;
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
						reasonsInSession = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, 2);

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
			vm.ModuleId = moduleId;
			vm.ShowFollowup = moduleId == Constants.MODULE_CSR;

            // Module Dropdown
            List<Module> moduleList = this.empLogService.GetModules(user);
            moduleList.Insert(0, new Module { Id = -2, Name = "-- Select Employee Level --" });
            IEnumerable<SelectListItem> moduleSelectList = new SelectList(moduleList, "Id", "Name");
            vm.ModuleSelectList = moduleSelectList;

            return vm;
        }

        private bool ShowSiteDropdown(NewSubmissionViewModel vm)
        {
            return vm.ModuleId == Constants.MODULE_CSR;
        }

        private bool ShowEmployeeDropdown(NewSubmissionViewModel vm)
        {
            // No module selected or allow team submit for CSR module
            if (vm.ModuleId == -2 || (vm.ModuleId == Constants.MODULE_CSR && AllowTeamSubmissionForCSR()))
            {
                return false;
            }

            return true;
        }

        private bool AllowTeamSubmissionForCSR()
        {
            var userJobCode = GetUserFromSession().JobCode;
            if (String.IsNullOrEmpty(userJobCode))
            {
                return false;
            }

            userJobCode = userJobCode.Trim().ToUpper();
            return "WACS40".Equals(userJobCode) || "WACS50".Equals(userJobCode) || "WACS60".Equals(userJobCode);
        }
        
        private bool ShowEmployeeDualListbox(NewSubmissionViewModel vm)
        {
            // No module selected Or module selected is other than CSR module
            if (vm.ModuleId == -2 || vm.ModuleId != Constants.MODULE_CSR)
            {
                return false;
            }

            // if it gets to here, it means CSR module is selected
            // csr module only for users with job codes WACS40 WACS50 WACS60
            // show dual list box only if site is selected, so it knows what employees to display in the dual list box
            if (vm.SiteId != null && vm.SiteId > 0 && AllowTeamSubmissionForCSR())
            {
                return true;
            }

            return false;
        }        

        private bool ShowProgramDropdown(NewSubmissionViewModel vm)
        {
            // Only display program dropdown for non-traning modules
            if (vm.ModuleId == Constants.MODULE_CSR)
            {
            	return true;
            }
            else
            {
                return vm.ModuleId > 0 && vm.ModuleId != Constants.MODULE_TRAINING && vm.ModuleId != Constants.MODULE_LSA;
            }
        }

        private bool ShowBehaviorDropdown(NewSubmissionViewModel vm)
        {
            // TRAINING module only
            return vm.ModuleId == Constants.MODULE_TRAINING;
        }

        private bool ShowIsCseChoice(NewSubmissionViewModel vm)
        {
            return vm.ModuleId == Constants.MODULE_CSR ||
                vm.ModuleId == Constants.MODULE_SUPERVISOR ||
                vm.ModuleId == Constants.MODULE_TRAINING;
        }

        public bool ShowActionTextbox(NewSubmissionViewModel vm)
        {
            return vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value;
        }

		public bool ShowCallTypeChoice(NewSubmissionViewModel vm)
		{
			return vm.ModuleId != Constants.MODULE_LSA;
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
            var empList = this.employeeService.GetEmployeesByModule(moduleId, siteId, userEmpId);
            empList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
            IEnumerable<SelectListItem> employees = new SelectList(empList, "Id", "Name");
            JsonResult result = Json(employees);
            result.MaxJsonLength = Int32.MaxValue;
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            return result;
        }

        [HttpPost]
        public JsonResult AddEmployeeToSession(string employeeId, string employeeName, string siteName)
        {
            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
            var employee = new TextValue(employeeName + "(" + siteName + ")", employeeId);
            vmInSession.EmployeeList.Add(employee);

            return Json(new EmptyResult(), JsonRequestBehavior.AllowGet);
        }
   
    }

}
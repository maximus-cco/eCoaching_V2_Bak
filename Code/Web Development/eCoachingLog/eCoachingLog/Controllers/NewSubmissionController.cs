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

			Session["newSubmissionVM"] = InitNewSubmissionViewModel(Constants.MODULE_UNKNOWN);
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

			if (ModelState.IsValid)
            {
                bool isDuplicate = false;
				string logNameSaved = null;

                string failMsg = "Failed to save your submission. Please ensure you have entered all required fields.";
				string duplicateMsg = "A warning with the same category and type already exists. Please review your warning section on My Dashboard page for details.";
				try
				{
					var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
					// For some reason, when a log is NOT required follow-up, a follow-up is still passed back from page (even though not entered)
					if (vm.IsFollowupRequired.HasValue && !vm.IsFollowupRequired.Value )
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

					logNameSaved = this.newSubmissionService.Save(vm, GetUserFromSession(), out isDuplicate);
					if (string.IsNullOrEmpty(logNameSaved))
					{
						throw new Exception("Failed to save submission.");
					}
                    TempData["ShowSuccessMessage"] = true;
                    TempData["ShowFailMessage"] = false;
                    TempData["SuccessMessage"] = string.Format("Your submission {0} was saved successfully.", logNameSaved);
					
					// send email
					// work around to get email attributes for direct
					// direct [101, 200);
					// indirect [201, 300); 
					if (vm.IsWorkAtHomeReturnSite && vm.SourceId > 200)
					{
						vm.SourceId -= 100;
					}
					vmInSession.SourceId = vm.SourceId;
					vmInSession.IsCse = vm.IsCse;
					if (!SendEmail(logNameSaved)) // Failed to send email
					{
						var user = GetUserFromSession();
						var userId = user == null ? "usernull" : user.EmployeeId;
						StringBuilder msg = new StringBuilder("Failed to send email: ");
						msg.Append("[").Append(userId).Append("]")
							.Append("|logname[").Append(logNameSaved).Append("]");

						logger.Warn(msg);
					};
				}
				catch (Exception ex)
				{
					logger.Warn("Exception: " + ex);

					if (string.IsNullOrEmpty(logNameSaved)) // Failed to save
					{
						TempData["ShowSuccessMessage"] = false;
                        TempData["ShowFailMessage"] = true;
						if (isDuplicate) // Same log already exists
						{
                            TempData["FailMessage"] = duplicateMsg;
						}
						else
						{
                            TempData["FailMessage"] = failMsg;
						}
					}
					return StayOnThisPage(vm);
				}
                return RedirectToAction("Index");
            }

            TempData["ShowSuccessMessage"] = false;
            TempData["ShowFailMessage"] = true;
            TempData["FailMessage"] = "Please correct all errors indicated in red to proceed###";
            ViewBag.ClientValidateCoachingReasons = true;
			ViewBag.ValidationError = true;
            return StayOnThisPage(vm);
        }

        private bool SendEmail(string logName)
        {
            var vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            var template = (vm.IsWarning == null || !vm.IsWarning.Value) ? 
					Server.MapPath("~/EmailTemplates/NewSubmissionCoaching.html") : Server.MapPath("~/EmailTemplates/NewSubmissionWarning.html");
            return this.emailService.Send(vm, template, logName);
        }

        private ActionResult StayOnThisPage(NewSubmissionViewModel vm)
        {
			// Repopluate vm from data stored in session so it will be displayed on the page
			var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
			vm.ModuleSelectList = vmInSession.ModuleSelectList;
            vm.SiteSelectList = vmInSession.SiteSelectList;
			vm.SiteNameSelectList = vmInSession.SiteNameSelectList;
            vm.EmployeeSelectList = vmInSession.EmployeeSelectList;
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

			return View("Index", vm);
        }

        [HttpPost]
        public ActionResult HandleSiteChanged(int siteIdSelected)
        {
            NewSubmissionViewModel vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
			vmInSession.SiteId = siteIdSelected;
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
			vm.ShowEmployeeDropdown = true;
			vm.ProgramSelectList = vmInSession.ProgramSelectList;
			vm.ShowProgramDropdown = true;
			vm.CallTypeSelectList = vmInSession.CallTypeSelectList;

			return PartialView("_NewSubmission", vm);
		}

		private void GetEmployeesByModuleToSession(int moduleId, int siteId)
        {
            IList<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, siteId, GetUserFromSession().EmployeeId);
            employeeList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
            var vmInSession = (NewSubmissionViewModel)Session["newSubmissionVM"];
			vmInSession.EmployeeSelectList = employees;
            vmInSession.EmployeeList = employeeList;
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
                employeeList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
                IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
                vm.EmployeeSelectList = employees;
                vm.EmployeeList = employeeList;
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
            // No module selected
            if (vm.ModuleId == -2)
            {
                return false;
            }

            if (vm.ModuleId == Constants.MODULE_CSR)
            {
                return vm.SiteId.HasValue && vm.SiteId > 0;
            }

            return true;
        }

        private bool ShowProgramDropdown(NewSubmissionViewModel vm)
        {
            // Only display program dropdown for non-traning modules
            if (vm.ModuleId == Constants.MODULE_CSR)
            {
                return vm.SiteId.HasValue && vm.SiteId.Value > 0;
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
	}
}
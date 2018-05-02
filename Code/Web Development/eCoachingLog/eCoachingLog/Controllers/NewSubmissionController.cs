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
using System.Web.Mvc;
using Vereyon.Web;

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

            Session["newSubmissionVM"] = InitNewSubmissionViewModel();
			ViewBag.ValidationError = false;
			return View((NewSubmissionViewModel)Session["newSubmissionVM"]);
        }

        private IEnumerable<SelectListItem> GetSources(bool isCoachingByYou)
        {
            var vm = GetNewSubmissionVMFromSession();
            string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? Constants.DIRECT : Constants.INDIRECT;
            int moduleId = vm.ModuleId;
            List<LogSource> sourceList = newSubmissionService.GetSourceListByModuleId(moduleId, directOrIndirect);
            sourceList.Insert(0, new LogSource { Id = -2, Name = "-- Select a Source --" });
            IEnumerable<SelectListItem> sources = new SelectList(sourceList, "Id", "Name");
            return sources;
        }

        private NewSubmissionViewModel GetNewSubmissionVMFromSession()
        {
            NewSubmissionViewModel vm = (NewSubmissionViewModel)Session["newSubmissionVM"];
            if (vm == null)
            {
                vm = InitNewSubmissionViewModel(); 
                Session["newSubmissionVM"] = vm;
            }
            return vm;
        }

        [HttpPost]
        public ActionResult Save(NewSubmissionViewModel vm)
        {
			logger.Debug("Entered Save ...");
			if (ModelState.IsValid)
            {
                bool isDuplicate = false;
				string logNameSaved = null;

				try
				{
					logNameSaved = this.newSubmissionService.Save(vm, GetUserFromSession(), out isDuplicate);
					FlashMessage.Confirmation(string.Format("Your sumbmission {0} was saved successfully.", logNameSaved));
					// Only send email for coaching logs
					if (vm.IsWarning == null || !vm.IsWarning.Value)
					{
						var vmInSession = GetNewSubmissionVMFromSession();
						vmInSession.SourceId = vm.SourceId;
						vmInSession.IsCse = vm.IsCse;
						if (!SendEmail(logNameSaved)) // Failed to send email
						{
							logger.Warn(string.Format("Failed to send email [%0]", logNameSaved));
						};
					}
				}
				catch (Exception ex)
				{
					logger.Warn("Exception: " + ex.StackTrace);

					if (string.IsNullOrEmpty(logNameSaved)) // Failed to save
					{
						if (isDuplicate) // Same log already exists
						{
							FlashMessage.Info("A warning with the same category and type already exists. Please review your warning section in the My Dashboard for details.");
						}
						else
						{
							FlashMessage.Warning("Failed to save your submission.");
						}
					}
					return StayOnThisPage(vm);
				}
                return RedirectToAction("Index");
            }

            FlashMessage.Danger("Please correct all errors indicated in red to proceed.");
            ViewBag.ClientValidateCoachingReasons = true;
			ViewBag.ValidationError = true;
            return StayOnThisPage(vm);
        }

        private bool SendEmail(string logName)
        {
            var vm = GetNewSubmissionVMFromSession();
            var logo = Server.MapPath("~/Content/Images/ecl-logo-small.png");
            var template = Server.MapPath("~/EmailTemplates/NewSubmission.html");
            return this.emailService.Send(vm, template, logo, logName);
        }

        private ActionResult StayOnThisPage(NewSubmissionViewModel vm)
        {
            // Repopluate vm from data stored in session so it will be displayed on the page
            NewSubmissionViewModel vmInSession = GetNewSubmissionVMFromSession();
            vm.ModuleSelectList = vmInSession.ModuleSelectList;
            vm.SiteSelectList = vmInSession.SiteSelectList;
            vm.EmployeeSelectList = vmInSession.EmployeeSelectList;
            vm.ProgramSelectList = vmInSession.ProgramSelectList;
            vm.BehaviorSelectList = vmInSession.BehaviorSelectList;
            vm.Employee = vmInSession.Employee;
            vm.UserId = vmInSession.UserId;
            vm.UserLanId = vmInSession.UserLanId;
            if (!(vm.IsWarning.HasValue && vm.IsWarning.Value))
            {
                vm.CoachingReasons = GetCoachReasonsInSession(vm.CoachingReasons);

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
            vm.ShowBehaviorDropdown = ShowBehaviorDropdown(vm);
            vm.ShowIsCoachingByYou = vmInSession.ShowIsCoachingByYou;
            vm.ShowWarningChoice = vmInSession.ShowWarningChoice;
            vm.ShowIsCseChoice = vmInSession.ShowIsCseChoice;
            vm.ShowActionTextBox = vmInSession.ShowActionTextBox;
            vm.ShowCoachWarningDiv = vmInSession.ShowCoachWarningDiv;
            vm.ShowWarningQuestions = vmInSession.ShowWarningQuestions;
			vm.ShowCallTypeChoice = vmInSession.ShowCallTypeChoice;

			return View("Index", vm);
        }

        [HttpPost]
        public ActionResult HandleSiteChanged(int siteIdSelected)
        {
            NewSubmissionViewModel vmInSession = GetNewSubmissionVMFromSession();
            vmInSession.SiteId = siteIdSelected;
            GetEmployeesByModuleToSession(vmInSession.ModuleId, siteIdSelected);
			// Since user has selected a different site, reset partial page, 
			var vm = InitNewSubmissionViewModel();
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
            List<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, siteId, GetUserFromSession().EmployeeId);
            employeeList.Insert(0, new Employee { Id = "-2", Name = "-- Select an Employee --" });
            IEnumerable<SelectListItem> employees = new SelectList(employeeList, "Id", "Name");
            var vmInSession = GetNewSubmissionVMFromSession();
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
                vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, isCoachingByYou, isSpecialResaon, specialReasonPriority, vm.Employee.LanId);
                vm.SourceSelectList = GetSources(isCoachingByYou);
                vm.ShowWarningQuestions = false;
            }

            return PartialView("_NewSubmissionBottom", vm);
        }

        private bool ShowWarningChoice(NewSubmissionViewModel vm)
        {
			return vm.IsCoachingByYou.HasValue
				&& vm.IsCoachingByYou.Value
				&& vm.Employee.SupervisorId != null
				&& vm.Employee.SupervisorId == vm.UserId;
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
            int moduleId = GetNewSubmissionVMFromSession().ModuleId;
            string source = GetDirectOrIndirect(isCoachingByYou);//"direct";
            bool specialReason = true;
            int reasonPriority = 1;
            string userLanId = GetUserFromSession().LanId;
            // Warning Type Dropdown
            List<WarningType> warningTypeList = this.empLogService.GetWarningTypes(moduleId, source, specialReason, reasonPriority, employeeId, userLanId);
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
            var vm = GetNewSubmissionVMFromSession();

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
            NewSubmissionViewModel vm = InitNewSubmissionViewModel();
            vm.ModuleId = moduleId;

            if (moduleId == -2) // No module selected
            {
                Session["newSubmissionVM"] = vm;
                return PartialView("_NewSubmission", vm);
            }

            var vmInSession = GetNewSubmissionVMFromSession();
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
                    IEnumerable<SelectListItem> siteSelectList = new SelectList(siteList, "Id", "Name");
                    vm.SiteSelectList = siteSelectList;
                }
            }
            // Load Employee dropdown for others
            else 
            {
                List<Employee> employeeList = employeeService.GetEmployeesByModule(moduleId, Constants.ALL_SITES, GetUserFromSession().EmployeeId);
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

        private List<CoachingReason> GetCoachingReasons(int iModuleId, bool isCoachingByYou, bool isCse, int priority, string empLanId)
        {
            string directOrIndirect = GetDirectOrIndirect(isCoachingByYou);//"direct";
            int moduleId = GetNewSubmissionVMFromSession().ModuleId;
            string userId = GetUserFromSession().EmployeeId;
            string employeeId = GetNewSubmissionVMFromSession().Employee.Id;
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
            vm.CoachingReasons = GetCoachingReasons(vm.ModuleId, coachingByYou, cse, 2, vm.Employee.LanId);
            // Save in session
            vm.IsCoachingByYou = isCoachingByYou;
            vm.IsCse = isCse;

            return PartialView("_NewSubmissionCoachingReasons", vm);
        }

        [HttpPost]
        public ActionResult HandleCoachingReasonClicked(bool isChecked, int reasonId)
        {
            var vm = GetNewSubmissionVMFromSession();
            if (isChecked)
            {
                HandleCoachingReasonSelected(vm, reasonId);
            }
            else
            {
                HandleCoachingReasonUnSelected(vm, reasonId);
            }
            return PartialView("_NewSubmissionCoachingReasons", vm);
        }

        private void HandleCoachingReasonUnSelected(NewSubmissionViewModel vm, int reasonId)
        {
            var thisCoachReason = vm.CoachingReasons.Where(x => x.ID == reasonId).ToList()[0];
            // Set the coach reason to be unselected
            thisCoachReason.IsChecked = false;
            // Do not show value selections (Opportunity, Reinforcement)
            thisCoachReason.OpportunityOption = false;
            thisCoachReason.ReinforcementOption = false;
            // Reset value selection to none
            thisCoachReason.IsOpportunity = null;
            // Reset all sub reasons to be unselected
            thisCoachReason.SubReasonIds = null;
        }

        private void HandleCoachingReasonSelected(NewSubmissionViewModel vm, int reasonId)
        {
			int moduleId = GetNewSubmissionVMFromSession().ModuleId;
            var thisCoachReason = vm.CoachingReasons.Where(x => x.ID == reasonId).ToList()[0];
            string directOrIndirect = vm.IsCoachingByYou.HasValue && vm.IsCoachingByYou.Value ? "Direct" : "Indirect";
            List<string> values = this.empLogService.GetValues(reasonId, directOrIndirect, moduleId);
            List<CoachingSubReason> subReasonList = this.empLogService.GetCoachingSubReasons(reasonId, moduleId, directOrIndirect, GetUserFromSession().EmployeeId);
            if (values.Any(s => s.Contains("Opportunity")))
            {
                thisCoachReason.OpportunityOption = true;
            }
            if (values.Any(s => s.Contains("Reinforcement")))
            {
                thisCoachReason.ReinforcementOption = true;
            }

            // Save in session
            thisCoachReason.SubReasons = subReasonList;
            thisCoachReason.IsChecked = true;
        }

        [HttpPost]
        public ActionResult HandleCoachingValueClicked(int reasonId, bool isOpportunity)
        {
            var vm = GetNewSubmissionVMFromSession();
            var thisCoachReason = vm.CoachingReasons.Where(x => x.ID == reasonId).ToList()[0];
            thisCoachReason.IsOpportunity = isOpportunity;

            return PartialView("_NewSubmissionCoachingReasons", vm);
        }

        [HttpPost]
        public ActionResult HandleSubreasonsSelected(int[] idsSelected, int reasonId)
        {
            var vm = GetNewSubmissionVMFromSession();
            var thisCoachReason = vm.CoachingReasons.Where(x => x.ID == reasonId).ToList()[0];
            // Save selected sub reason ids in session
            thisCoachReason.SubReasonIds = idsSelected;
            return PartialView("_NewSubmissionCoachingReasons", vm);
        }

        private List<CoachingReason> GetCoachReasonsInSession(List<CoachingReason> crs)
        {
            List<CoachingReason> reasonsInSession = GetNewSubmissionVMFromSession().CoachingReasons;

            foreach (CoachingReason cr in crs)
            {
                var crToChange = reasonsInSession.First(c => c.ID == cr.ID);
                crToChange.IsChecked = cr.IsChecked;
                crToChange.IsOpportunity = cr.IsOpportunity;
                crToChange.SubReasonIds = cr.SubReasonIds;
            }

            return reasonsInSession;
        }

        private NewSubmissionViewModel InitNewSubmissionViewModel()
        {
            User user = GetUserFromSession();
            NewSubmissionViewModel vm = new NewSubmissionViewModel(user.EmployeeId, user.LanId);
            // Module Dropdown
            List<Module> moduleList = this.empLogService.GetModules(user);
            moduleList.Insert(0, new Module { Id = -2, Name = "-- Select a Module --" });
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
                return vm.ModuleId > 0 && vm.ModuleId != Constants.MODULE_TRAINING;
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
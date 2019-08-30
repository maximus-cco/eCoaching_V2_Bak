using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace eCoachingLog.ViewModels
{
    public class NewSubmissionViewModel : BaseViewModel, IValidatableObject
    {
        public string UserId { get; set; }
        public string UserLanId { get; set; }
        public int StatusId { get; set; }
        public int ModuleId { get; set; }
        public int? ProgramId { get; set; }
		public string ProgramName { get; set; }
        public int? BehaviorId { get; set; }
		public string BehaviorName { get; set; }
        public bool? IsCoachingByYou { get; set; }
        public bool ShowActionTextBox { get; set; }
        public bool? IsWarning { get; set; }
        public bool? IsCse { get; set; }
        public bool ShowIsCseChoice { get; set; }
		public bool ShowCallTypeChoice { get; set; }
        public bool IsCallAssociated { get; set; }
        public string CallTypeName { get; set; }
        public string CallId { get; set; }
		public bool? IsFollowupRequired { get; set; }
		public DateTime? FollowupDueDate { get; set; }
        public IEnumerable<SelectListItem> ModuleSelectList { get; set; }
        public IEnumerable<SelectListItem> ProgramSelectList { get; set; }
        public IEnumerable<SelectListItem> BehaviorSelectList { get; set; }
        public IEnumerable<SelectListItem> WarningTypeSelectList { get; set; }
        public IEnumerable<SelectListItem> WarningReasonSelectList { get; set; }
        public int? WarningTypeId { get; set; }
        public int? WarningReasonId { get; set; }
        public IEnumerable<SelectListItem> CallTypeSelectList { get; set; }
        public DateTime? CoachingDate { get; set; }
        public DateTime? WarningDate { get; set; }
        public bool ShowWarningChoice { get; set; }
        public bool ShowWarningQuestions { get; set; }
        public bool ShowCoachWarningDiv { get; set; }
        public bool ShowSubmitDiv { get; set; }
        public bool VerifiedCheckbox { get; set; }
        public List<CoachingReason> CoachingReasons { get; set; }
		[AllowHtml]
        public string BehaviorDetail { get; set; }
		[AllowHtml]
        public string ActionPlans { get; set; }
        public int SourceId { get; set; }
        public IEnumerable<SelectListItem> SourceSelectList { get; set; }
        public bool ShowSiteDropdown { get; set; }
        public bool ShowEmployeeDropdown { get; set; }
        public bool ShowProgramDropdown { get; set; }
        public bool ShowBehaviorDropdown { get; set; }
        public bool ShowIsCoachingByYou { get; set; }
		public bool ShowMgtInfo { get; set; }
		public bool ShowFollowup { get; set; }

        public NewSubmissionViewModel() : base()
        {
            this.ModuleId = -1;
            this.ProgramId = -1;
            this.ModuleSelectList = new List<SelectListItem>();
            this.ProgramSelectList = new List<SelectListItem>();
            this.BehaviorSelectList = new List<SelectListItem>();
            this.WarningTypeSelectList = new List<SelectListItem>();
            this.WarningReasonSelectList = new List<SelectListItem>();
            this.SourceSelectList = new List<SelectListItem>();
            this.CallTypeSelectList = new List<SelectListItem>();

            this.Employee = new Employee();
            this.CoachingReasons = new List<CoachingReason>();

            this.ShowWarningChoice = false;
            this.IsCse = false;
            this.IsCallAssociated = false;
            this.IsWarning = false;
        }

        public NewSubmissionViewModel(string userId, string userLanId) : this()
        {
            this.UserId = userId;
            this.UserLanId = userLanId;
        }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            // Confirm box, this is common to both Warning and Coaching
            if (this.IsWarning.HasValue && !this.IsWarning.Value && !this.VerifiedCheckbox)
            {
                var verifiedCheckbox = new[] { "VerifiedCheckbox" };
                yield return new ValidationResult("You must select the verification checkbox to submit this form.", verifiedCheckbox);
            }

            // Validate warning log questions
            if (this.IsWarning.HasValue && this.IsWarning.Value)
            {
                if (!this.WarningTypeId.HasValue || this.WarningTypeId.Value == -2)
                {
                    var warningTypeId = new[] { "WarningTypeId" };
                    yield return new ValidationResult("Please select a warning type.", warningTypeId);
                }

				if (!this.WarningReasonId.HasValue || this.WarningReasonId.Value == -2)
                {
                    var warningReasonId = new[] { "WarningReasonId" };
                    yield return new ValidationResult("Please select a warning reason.", warningReasonId); // warning sub reason
                }

                if (!this.WarningDate.HasValue)
                {
                    var warningDate = new[] { "WarningDate" };
                    yield return new ValidationResult("Please enter a warning date.", warningDate);
                }

                yield break;
            }

            // Validate Coaching log questions
            // Will you be delivering the coaching session?
            if (!this.IsCoachingByYou.HasValue)
            {
                var isCoachingByYou = new[] { "IsCoachingByYou" };
                yield return new ValidationResult("Please make a selection.", isCoachingByYou);
            }
            // Coaching Date
            if (!this.CoachingDate.HasValue)
            {
                var coachDate = new[] { "CoachingDate" };
                yield return new ValidationResult("Please enter a coaching date.", coachDate);
            }
            // Provide details of the behavior to be coached.
            if (String.IsNullOrWhiteSpace(this.BehaviorDetail))
            {
                var behaviorDetail = new[] { "BehaviorDetail" };
                yield return new ValidationResult("Please provide details of the behavior to be coached.", behaviorDetail);
            }
            // Provide the details from the coaching session including action plans developed.
            if (IsCoachingByYou.HasValue && IsCoachingByYou.Value && String.IsNullOrWhiteSpace(this.ActionPlans))
            {
                var actionPlans = new[] { "ActionPlans" };
                yield return new ValidationResult("Please provide details from the coaching session including action plans developed.", actionPlans);
            }
            // How was the coaching opportunity identifed?
            if (this.SourceId == -2)
            {
                var sourceId = new[] { "SourceId" };
                yield return new ValidationResult("Please select how the coaching was identified.", sourceId);
            }

            // Validate call id format
            if (this.IsCallAssociated)
            {
                if (this.CallId == null)
                {
                    var callId = new[] { "CallId" };
                    yield return new ValidationResult("Call ID is required.", callId);
                }
                else
                {
                    var pattern = ((IEnumerable<CallType>)HttpContext.Current.Session["CallTypeList"]).FirstOrDefault(x => x.Name == this.CallTypeName).IdPattern;
                    Regex rgx = new Regex(pattern);
                    if (!rgx.IsMatch(this.CallId))
                    {
                        var callId = new[] { "CallId" };
                        yield return new ValidationResult("Please enter a valid call ID.", callId);
                    }
                }
            }

            // Validate coaching reasons/sub reasons/opportunityOrReinforcement
            List<CoachingReason> coachingReasonsSelected = this.CoachingReasons.Where(x => x.IsChecked).ToList();
            // For some reason, these validation error messages wouldn't display
            // Set the Validation error, so can be used in controller to check if ModelState.IsValid
            // if not valid, client javascript funtion will be called to validate and display errors
            if (coachingReasonsSelected.Count == 0)
            {
                var coachingReasons = new[] { "CoachingReasons" };
                yield return new ValidationResult("Please select at least one coaching reason.");
            }
            else if (coachingReasonsSelected.Count > 12)
			{
				var coachingReasons = new[] { "CoachingReasons" };
				yield return new ValidationResult("You can only select 12 coaching reasons maximum.");
			}
			else 
			{
                foreach (CoachingReason cr in coachingReasonsSelected)
                {
                    if (!cr.IsOpportunity.HasValue || cr.SubReasonIds == null || cr.SubReasonIds.Count() == 0)
                    {
                        // Reason selected, but opportunity or sub reason not selected
                        var coachingReasons = new[] { "CoachingReasons" };
                        yield return new ValidationResult("Please make a selection.");
                    }
                }
            }
			// Validate follow-up entries
			if (this.IsFollowupRequired.HasValue)
			{
				// followup Date
				if (!this.FollowupDueDate.HasValue)
				{
					var followupDueDate = new[] { "FollowupDueDate" };
					yield return new ValidationResult("Please select a follow-up date.", followupDueDate);
				}
			}
			else
			{
				// followup radio button
				var isFollowupRequired = new[] { "IsFollowupRequired" };
				yield return new ValidationResult("Please make a selction.", isFollowupRequired);
			}
		}

        public static implicit operator NewSubmission(NewSubmissionViewModel vm)
        {
			return new NewSubmission
			{
				ModuleId = vm.ModuleId,
				SiteId = vm.SiteId,
				Employee = vm.Employee,
				ProgramId = vm.ProgramId,
				ProgramName = vm.ProgramName,
				BehaviorId = vm.BehaviorId,
				BehaviorName = vm.BehaviorName, 
                IsDirect = vm.IsCoachingByYou,
                IsWarning = vm.IsWarning,
                IsCse = vm.IsCse,
                CoachingDate = vm.CoachingDate,
                WarningDate = vm.WarningDate,
                BehaviorDetail = vm.BehaviorDetail,
                Plans = vm.ActionPlans,
                CoachingReasons = vm.CoachingReasons,
                IsCallAssociated = vm.IsCallAssociated,
                CallTypeName = vm.CallTypeName,
                CallId = vm.CallId,
                SourceId = vm.SourceId,
                StatusId = vm.StatusId,
				FollowupDueDate = vm.FollowupDueDate,
				IsFollowupRequired = vm.IsFollowupRequired,

                WarningTypeId = vm.WarningTypeId,
                WarningReasonId = vm.WarningReasonId
            };
        }
    }
}
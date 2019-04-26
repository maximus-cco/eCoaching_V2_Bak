using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace eCoachingLog.ViewModels
{
	public class ReviewViewModel : IValidatableObject
	{
		public string ReviewPageName { get; set; }

		public CoachingLogDetail LogDetail { get; set; }
		public WarningLogDetail WarningLogDetail { get; set; }

		public int LogStatusLevel { get; set; }

		// Common
		public string InstructionText { get; set; }
		public DateTime? DateCoached { get; set; }
		[AllowHtml]
		public string DetailsCoached { get; set; }

		// Research related
		public bool IsCoachingRequired { get; set; }
		// result from dropdown list
		public string MainReasonNotCoachable { get; set; }
		[AllowHtml]
		public string DetailReasonNotCoachable { get; set; }
		[AllowHtml]
		public string DetailReasonCoachable { get; set; }
		// CSE related
		public bool? IsConfirmedCse { get; set; } // Confirmed cse
		public bool? IsSubmittedAsCse { get; set; }
		public DateTime? DateReviewed { get; set; }
		[AllowHtml]
		public string ReasonNotCse { get; set; }
		[AllowHtml]
		public string Comment { get; set; }

		public IEnumerable<SelectListItem> MainReasonNotCoachableList { get; set; }
		public IEnumerable<SelectListItem> EmployeeCommentsDdlList { get; set; }

		// Show Manger Notes, Coching Notes
		public bool ShowManagerNotes { get; set; }
		public bool ShowCoachingNotes { get; set; }

		public bool IsReviewForm { get; set; }
		public bool IsReadOnly { get; set; }
		public bool IsReviewByManager { get; set; }
		public bool IsRegularPendingForm { get; set; }
		public bool IsResearchPendingForm { get; set; }
		public bool IsCsePendingForm { get; set; }
		public bool IsAcknowledgeForm { get; set; }
		public bool IsReinforceLog { get; set; }
		public bool IsAckOverTurnedAppeal { get; set; }

		// To control display on Historical/Review
		public bool ShowConfirmedCseText { get; set; }
		public bool ShowConfirmedNonCseText { get; set; }
		public bool ShowViewMgtNotes { get; set; }
		public bool ShowViewSupReviewInfo { get; set; }

		public bool Acknowledge { get; set; }
		public bool IsAckOpportunityLog { get; set; }
		public bool ShowCommentTextBox { get; set; }
		public bool ShowCommentDdl { get; set; }

		public string CommentTextBoxLabel { get; set; }

		public IEnumerable<SelectListItem> CommentSelectList { get; set; }

		public ReviewViewModel()
		{
			this.LogDetail = new CoachingLogDetail();
			this.WarningLogDetail = new WarningLogDetail();
			this.MainReasonNotCoachableList = new List<SelectListItem>();
			this.EmployeeCommentsDdlList = new List<SelectListItem>();
			// Default to true
			this.IsCoachingRequired = true;
		}

		public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
		{
			// Regular Pending
			if (this.IsRegularPendingForm)
			{
				if (!this.DateCoached.HasValue)
				{
					var dateCoached = new[] { "DateCoached" };
					yield return new ValidationResult("Provide coaching date.", dateCoached);
				}

				if (string.IsNullOrEmpty(this.DetailsCoached))
				{
					var detailsCoached = new[] { "DetailsCoached" };
					yield return new ValidationResult("Provide coaching details.", detailsCoached);
				}

				yield break;
			}

			// Reasearch
			if (this.IsResearchPendingForm)
			{
				if (!this.DateCoached.HasValue)
				{
					var dateCoached = new[] { "DateCoached" };
					yield return new ValidationResult("Provide coaching date.", dateCoached);
				}

				if (!this.IsCoachingRequired)
				{
					if (string.IsNullOrEmpty(this.MainReasonNotCoachable))
					{
						var mainReasonNotCoachable = new[] { "MainReasonNotCoachable" };
						yield return new ValidationResult("Select a main reason.", mainReasonNotCoachable);
					}

					if (string.IsNullOrEmpty(this.DetailReasonNotCoachable))
					{
						var detailReasonNotCoachable = new[] { "DetailReasonNotCoachable" };
						yield return new ValidationResult("Provide a non-coachable reason.", detailReasonNotCoachable);
					}
				}
				else
				{
					if (string.IsNullOrEmpty(this.DetailReasonCoachable))
					{
						var detailReasonCoachable = new[] { "DetailReasonCoachable" };
						yield return new ValidationResult("Provide a coachable reason.", detailReasonCoachable);
					}
				}

				yield break;
			}

			// CSE
			if (this.IsCsePendingForm)
			{
				if (this.IsConfirmedCse.HasValue && this.IsConfirmedCse.Value) // Confirmed cse
				{
					if (!this.DateCoached.HasValue)
					{
						var dateCoached = new[] { "DateCoached" };
						yield return new ValidationResult("Provide coaching date.", dateCoached);
					}

					if (string.IsNullOrEmpty(this.DetailsCoached))
					{
						var detailsCoached = new[] { "DetailsCoached" };
						yield return new ValidationResult("Provide details coached.", detailsCoached);
					}
				}
				else // confirmed it is not CSE
				{
					if (!this.DateReviewed.HasValue)
					{
						var dateReviewed = new[] { "DateReviewed" };
						yield return new ValidationResult("Provide reviewed date.", dateReviewed);
					}

					if (string.IsNullOrEmpty(this.ReasonNotCse))
					{
						var reasonNotCse = new[] { "ReasonNotCse" };
						yield return new ValidationResult("Provide reason not cse.", reasonNotCse);
					}
				}
			}

			if (this.IsAcknowledgeForm)
			{
				if (!this.Acknowledge)
				{
					var ack = new[] { "Acknowledge" };
					yield return new ValidationResult("You must select the checkbox to complete this review.", ack);
				}

				if (this.IsAckOverTurnedAppeal && string.IsNullOrEmpty(this.Comment))
				{
					var ack = new[] { "Comment" };
					yield return new ValidationResult("Provide comment.", ack);
				}
			}
		} // end Validate 

		public static implicit operator Review(ReviewViewModel vm)
		{
			return new Review
			{
				DateCoached = vm.DateCoached,
				DetailsCoached = vm.DetailsCoached,
				IsCoachingRequired = vm.IsCoachingRequired,
				MainReasonNotCoachable = vm.MainReasonNotCoachable,
				DetailReasonNotCoachable = vm.DetailReasonNotCoachable,
				DetailReasonCoachable = vm.DetailReasonCoachable,
				IsConfirmedCse = vm.IsConfirmedCse,
				DateReviewed = vm.DateReviewed,
				ReasonNotCse = vm.ReasonNotCse,
				Comment = vm.Comment,
				IsRegularPendingForm = vm.IsRegularPendingForm,
				IsResearchPendingForm = vm.IsResearchPendingForm,
				IsCsePendingForm = vm.IsCsePendingForm,
				IsAckOpportunityLog = vm.IsAckOpportunityLog,
				IsAckOverTurnedAppeal = vm.IsAckOverTurnedAppeal,
				IsReviewForm = vm.IsReviewForm,
				IsAcknowledgeForm = vm.IsAcknowledgeForm,
				LogDetail = vm.LogDetail,
				WarningLogDetail = vm.WarningLogDetail,
				LogStatusLevel = vm.LogStatusLevel,
				IsReinforceLog = vm.IsReinforceLog,
				Acknowledge = vm.Acknowledge
			};
		}

	} // End class ReviewViewModel
}
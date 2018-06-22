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
		public CoachingLogDetail LogDetail { get; set; }
		public WarningLogDetail WarningLogDetail { get; set; }

		public int LogStatusLevel { get; set; }

		// Data to be collected on the review page
		// TODO: move these to CoachingLogDetail
		// So the page will submit these data in CoachingLogDetail model
		// Common
		public string InstructionText { get; set; }
		public DateTime? DateCoached { get; set; }
		public string DetailsCoached { get; set; }

		// Research related
		public bool IsCoachingRequired { get; set; }
		// result from dropdown list
		public string MainReasonNotCoachable { get; set; }
		public string DetailReasonNotCoachable { get; set; }
		public string DetailReasonCoachable { get; set; }
		// CSE related
		public bool IsCse { get; set; } // Confirmed cse
		public bool IsCseUnconfirmed { get; set; }
		public DateTime? DateReviewed { get; set; }
		public string ReasonNotCse { get; set; }
		// Pending employee review related
		//public string EmployeeCommentsTextBox { get; set; }
		//// result from dropdown list
		//public string EmployeeCommentsDdl { get; set; }
		public string EmployeeComments { get; set; }


		// TODO: add dropdownlist properties for MainReasonNotCoachable and EmployeeCommentsDdl
		public IEnumerable<SelectListItem> MainReasonNotCoachableList { get; set; }
		public IEnumerable<SelectListItem> EmployeeCommentsDdlList { get; set; }

		// Show Manger Notes, Coching Notes
		public bool ShowManagerNotes { get; set; }
		public bool ShowCoachingNotes { get; set; }

		// Show Is CSE question
		//public bool ShowIsCseQuestion { get; set; }
		//// Show Is Coaching Required question
		//public bool ShowIsCoachingRequiredQuestion { get; set; }

		public bool IsReviewForm { get; set; }
		public bool IsReviewFinalForm { get; set; }

		public bool IsReadOnly { get; set; }

		public bool IsRegularPendingForm { get; set; }
		public bool IsResearchPendingForm { get; set; }
		public bool IsCsePendingForm { get; set; }
		public bool IsAcknowledgeForm { get; set; }
		public bool IsReinforceLog { get; set; }

		// To control display on Historical/Review
		public bool ShowViewCseText { get; set; }
		public bool ShowViewMgtNotes { get; set; }
		public bool ShowViewSupReviewInfo { get; set; }

		public bool Acknowledge { get; set; }

		public bool IsAckOpportunityLog { get; set; }
		public bool ShowCommentTextBox { get; set; }
		public bool ShowCommentDdl { get; set; }

		public IEnumerable<SelectListItem> CommentSelectList { get; set; }

		public ReviewViewModel()
		{
			this.LogDetail = new CoachingLogDetail();
			this.WarningLogDetail = new WarningLogDetail();
			this.MainReasonNotCoachableList = new List<SelectListItem>();
			this.EmployeeCommentsDdlList = new List<SelectListItem>();
		}

		public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
		{
			// TODO: based on the boolean show variables to decide which fields to be checked
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
				if (this.IsCse) // Confirmed cse
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
				IsCse = vm.IsCse,
				DateReviewed = vm.DateReviewed,
				ReasonNotCse = vm.ReasonNotCse,
				EmployeeComments = vm.EmployeeComments,
				//EmployeeCommentsTextBox = vm.EmployeeCommentsTextBox,
				//EmployeeCommentsDdl = vm.EmployeeCommentsDdl,
				IsRegularPendingForm = vm.IsRegularPendingForm,
				IsResearchPendingForm = vm.IsResearchPendingForm,
				IsCsePendingForm = vm.IsCsePendingForm,
				IsAckOpportunityLog = vm.IsAckOpportunityLog,
				IsReviewForm = vm.IsReviewForm,
				IsAcknowledgeForm = vm.IsAcknowledgeForm,
				IsReviewFinalForm = vm.IsReviewFinalForm,
				LogDetail = vm.LogDetail,
				WarningLogDetail = vm.WarningLogDetail,
				LogStatusLevel = vm.LogStatusLevel,
				IsReinforceLog = vm.IsReinforceLog,
				Acknowledge = vm.Acknowledge
			};
		}

	} // End class ReviewViewModel
}
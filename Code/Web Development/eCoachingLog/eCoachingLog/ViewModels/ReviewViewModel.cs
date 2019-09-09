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

		// Short Call - Confirm view by Manager - Comments
		[AllowHtml]
		public string Comments { get; set; }
		public DateTime? DateConfirmed { get; set; }

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
		public bool IsShortCallPendingSupervisorForm { get; set; }
		public bool IsShortCallPendingManagerForm { get; set; }
		public bool IsAcknowledgeForm { get; set; }
		public bool IsFollowupPendingSupervisorForm { get; set; }
		public bool IsFollowupPendingCsrForm { get; set; }
		public bool IsMoreReviewRequired { get; set; }
		public bool IsAckOverTurnedAppeal { get; set; }

		// To control display on Historical/Review
		public bool ShowConfirmedCseText { get; set; }
		public bool ShowConfirmedNonCseText { get; set; }
		public bool ShowViewMgtNotes { get; set; }
		public bool ShowViewSupReviewInfo { get; set; }

		public bool Acknowledge { get; set; }
		public bool ShowAckCheckbox { get; set; }
		public string AckCheckboxTitle { get; set; }
		public string AckCheckboxText { get; set; }
		public bool ShowCommentTextBox { get; set; }
		public bool ShowCommentDdl { get; set; }

		public string CommentTextboxLabel { get; set; }

		// Followup related
		public bool ShowFollowupInfo { get; set; }
		public bool IsFollowupCompleted { get; set; }
		public bool IsFollowupAcknowledged { get; set; }
		public bool IsFollowupDue { get; set; }
		public bool IsFollowupOverDue { get; set; }
		public string FollowupDueDateNoTime
		{
			get
			{
				if (!string.IsNullOrEmpty(this.LogDetail.FollowupDueDate))
				{
					return DateTime.Parse(this.LogDetail.FollowupDueDate.Replace("PDT", "")).ToString("MM/dd/yyyy");
				}

				return string.Empty;
			}
		}

		public DateTime? ActualFollowupDate { get; set; }
		[AllowHtml]
		public string FollowupDetails { get; set; } // Input textarea
		public IEnumerable<SelectListItem> CommentSelectList { get; set; }

		// short call list
		public IList<ShortCall> ShortCallList { get; set; }
		public string ShortCallBehaviorActionList { get; set; }
		public bool ShowEmployeeReviewInfo { get; set; }

		public ReviewViewModel()
		{
			this.LogDetail = new CoachingLogDetail();
			this.WarningLogDetail = new WarningLogDetail();
			this.MainReasonNotCoachableList = new List<SelectListItem>();
			this.EmployeeCommentsDdlList = new List<SelectListItem>();
			// Default to true
			this.IsCoachingRequired = true;
			this.ShortCallList = new List<ShortCall>();
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

				if ((this.IsAckOverTurnedAppeal || this.IsFollowupPendingCsrForm) && string.IsNullOrEmpty(this.Comment))
				{
					var ack = new[] { "Comment" };
					yield return new ValidationResult("Provide comment.", ack);
				}
			}

			// Short Calls: check behavior and coaching notes for each call
			if (this.IsShortCallPendingSupervisorForm)
			{
				for (int i = 0; i < this.ShortCallList.Count; i++)
				{
					if (this.ShortCallList[i].SelectedBehaviorId < 0)
					{
						var selectedBehaviorId = new[] { "ShortCallList[" + i + "].SelectedBehaviorId" };
						yield return new ValidationResult("", selectedBehaviorId);
					}

					if (string.IsNullOrEmpty(this.ShortCallList[i].CoachingNotes))
					{
						var coachingNotes = new[] { "ShortCallList[" + i + "].CoachingNotes" };
						yield return new ValidationResult("", coachingNotes);
					}
				}

				if (!this.DateCoached.HasValue)
				{
					var dateCoached = new[] { "DateCoached" };
					yield return new ValidationResult("", dateCoached);
				}

				if (string.IsNullOrEmpty(this.DetailsCoached))
				{
					var detailsCoached = new[] { "DetailsCoached" };
					yield return new ValidationResult("", detailsCoached);
				}
			}

			// Short Calls: check "Agree" radio button for each call
			if (this.IsShortCallPendingManagerForm)
			{
				for (int i = 0; i < this.ShortCallList.Count; i++)
				{
					var shortCall = this.ShortCallList[i];
					if (!shortCall.IsManagerAgreed.HasValue)
					{
						var isManagerAgreed = new[] { "ShortCallList[" + i + "].IsManagerAgreed" };
						yield return new ValidationResult("", isManagerAgreed);
					}
					// "No" was selected (Don't agree) but didn't enter comments
					else if (!shortCall.IsManagerAgreed.Value && string.IsNullOrEmpty(shortCall.Comments)) 
					{
						// Comments for each short call with "No" selected (Don't agree)
						var comments = new[] { "ShortCallList[" + i + "].Comments" };
						yield return new ValidationResult("Please enter comments.", comments);
					}
				}

				// Summary comments for this log
				if (string.IsNullOrEmpty(this.Comments))
				{
					var comments = new[] { "Comments" };
					yield return new ValidationResult("", comments);
				}

				if (!this.DateConfirmed.HasValue)
				{
					var dateConfirmed = new[] { "DateConfirmed" };
					yield return new ValidationResult("", dateConfirmed);
				}
			}

			// Followup
			if (this.IsFollowupPendingSupervisorForm)
			{
				if (!this.ActualFollowupDate.HasValue)
				{
					var followupDate = new[] { "ActualFollowupDate" };
					yield return new ValidationResult("Provide follow-up date.", followupDate);
				}

				if (string.IsNullOrEmpty(this.FollowupDetails))
				{
					var details = new[] { "FollowupDetails" };
					yield return new ValidationResult("Provide follow-up details.", details);
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
				IsFollowupPendingSupervisorForm = vm.IsFollowupPendingSupervisorForm,
				IsFollowupPendingCsrForm = vm.IsFollowupPendingCsrForm,
				IsAckOverTurnedAppeal = vm.IsAckOverTurnedAppeal,
				IsReviewForm = vm.IsReviewForm,
				IsAcknowledgeForm = vm.IsAcknowledgeForm,
				IsShortCallPendingManagerForm = vm.IsShortCallPendingManagerForm,
				IsShortCallPendingSupervisorForm = vm.IsShortCallPendingSupervisorForm,
				LogDetail = vm.LogDetail,
				WarningLogDetail = vm.WarningLogDetail,
				LogStatusLevel = vm.LogStatusLevel,
				IsMoreReviewRequired = vm.IsMoreReviewRequired,
				Acknowledge = vm.Acknowledge,
				ShortCallList = vm.ShortCallList,
				Comments = vm.Comments,
				DateConfirmed = vm.DateConfirmed,
				DateFollowup = vm.ActualFollowupDate,
				DetailsFollowup = vm.FollowupDetails
			};
		}

	} // End class ReviewViewModel
}
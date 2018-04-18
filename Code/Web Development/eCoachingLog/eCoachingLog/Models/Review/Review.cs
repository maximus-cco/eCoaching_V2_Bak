using System;

namespace eCoachingLog.Models.Review
{
	public class Review
	{
		// Common
		public DateTime? DateCoached { get; set; }
		public string DetailsCoached { get; set; }

		// Research related
		public bool IsCoachingRequired { get; set; }
		// result from dropdown list
		public string MainReasonNotCoachable { get; set; }
		public string DetailReasonNotCoachable { get; set; }
		public string DetailReasonCoachable { get; set; }
	
		// CSE related
		public bool IsCse { get; set; }
		public DateTime? DateReviewed { get; set; }
		public string ReasonNotCse { get; set; }
		// Pending employee review related
		public string EmployeeCommentsTextBox { get; set; }
		// result from dropdown list
		public string EmployeeCommentsDdl { get; set; }

		public bool ShowAcknowledgePartial { get; set; }
		public bool ShowReviewCoachingPartial { get; set; }

		public bool ShowReviewCoachingPending { get; set; }
		public bool ShowReviewCoachingResearch { get; set; }
		public bool ShowReviewCoachingCse { get; set; }
	}
}
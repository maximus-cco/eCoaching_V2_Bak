using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface IReviewRepository
	{
		IList<string> GetReasonsToSelect(string reportCode);
		bool CompleteRegularPendingReview(Review review, string nextStatus, User user);
		bool CompleteAckRegularReview(Review review, string nextStatus, User user);
		bool CompleteEmpAckReinforceReview(Review review, string nextStatus, User user);
		bool CompleteSupAckReview(long logId, string nextStatus, string comment, User user);
		bool CompleteResearchPendingReview(Review review, string nextStatus, User user);
		bool CompleteCsePendingReview(Review review, string nextStatus, User user);
	}
}

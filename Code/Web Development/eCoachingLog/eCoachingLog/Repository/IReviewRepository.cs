using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using System;

namespace eCoachingLog.Repository
{
	public interface IReviewRepository
	{
		bool CompleteRegularPendingReview(Review review, string nextStatus, User user);
		bool CompleteAckRegularReview(Review review, string nextStatus, User user);
		bool CompleteEmpAckReinforceReview(Review review, string nextStatus, User user);
		bool CompleteSupAckReinforceReview(long logId, string nextStatus, User user);
		bool CompleteResearchPendingReview(Review review, string nextStatus, User user);
		bool CompleteCsePendingReview(Review review, string nextStatus, User user);
	}
}

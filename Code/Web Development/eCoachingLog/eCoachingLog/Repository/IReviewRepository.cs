using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface IReviewRepository
	{
		IList<string> GetReasonsToSelect(string reportCode);
		IList<ShortCall> GetShortCallList(long logId);
		IList<ShortCall> GetShortCallEvalList(long longId);
		IList<Behavior> GetShortCallBehaviorList(bool isValid);
		IList<string> GetShortCallActions(string employeeId, int behaviorId);
		bool CompleteRegularPendingReview(Review review, string nextStatus, User user);
		bool CompleteAckRegularReview(Review review, string nextStatus, User user);
		bool CompleteEmpAckReinforceReview(Review review, string nextStatus, User user);
		bool CompleteSupAckReview(long logId, string nextStatus, string comment, User user);
		bool CompleteResearchPendingReview(Review review, string nextStatus, User user);
		bool CompleteCsePendingReview(Review review, string nextStatus, User user);
		bool CompleteShortCallsReview(Review review, string nextStatus, User user);
		bool CompleteShortCallsConfirm(Review review, string nextstatus, User user);
	}
}

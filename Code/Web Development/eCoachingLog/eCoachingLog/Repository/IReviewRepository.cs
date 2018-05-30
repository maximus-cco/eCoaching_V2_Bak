using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;

namespace eCoachingLog.Repository
{
	public interface IReviewRepository
	{
		bool CompleteRegularPendingReview(CoachingLogDetail log, string nextStatus, User user);
	}
}

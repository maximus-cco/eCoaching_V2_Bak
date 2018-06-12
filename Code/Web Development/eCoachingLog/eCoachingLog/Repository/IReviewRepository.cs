using eCoachingLog.Models.User;
using System;

namespace eCoachingLog.Repository
{
	public interface IReviewRepository
	{
		bool CompleteRegularPendingReview(long logId, DateTime? dateCoached, string DetailsCoached, string nextStatus, User user);
		bool CompleteAckRegularReview(long logId, bool isAcked, string ackNotes, string nextStatus, User user);
		bool CompleteEmpAckReinforceReview(long logId, bool isAcked, string ackNotes, string nextStatus, User user);
		bool CompleteSupAckReinforceReview(long logId, string nextStatus, User user);
	}
}

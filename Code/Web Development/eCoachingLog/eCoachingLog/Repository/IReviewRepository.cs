using eCoachingLog.Models.User;
using System;

namespace eCoachingLog.Repository
{
	public interface IReviewRepository
	{
		bool CompleteRegularPendingReview(long logId, DateTime? dateCoached, string DetailsCoached, string nextStatus, User user);
	}
}

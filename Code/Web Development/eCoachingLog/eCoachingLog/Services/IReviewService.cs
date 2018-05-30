using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.ViewModels;

namespace eCoachingLog.Services
{
	public interface IReviewService
	{
		bool IsAccessAllowed(int currentPage, BaseLogDetail logDetail, bool isCoaching, User user);
		string GetInstructionText(ReviewViewModel vm, User user);
		bool CompleteReview(ReviewViewModel vm, User user);
	}
}

using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using eCoachingLog.ViewModels;

namespace eCoachingLog.Services
{
	public interface IReviewService
	{
		bool IsAccessAllowed(int currentPage, BaseLogDetail logDetail, bool isCoaching, User user);
		string GetInstructionText(Review vm, User user);
		bool CompleteReview(Review vm, User user, string emailTempFileName, string logoFileName);
	}
}

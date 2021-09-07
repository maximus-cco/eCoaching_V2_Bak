using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface IReviewService
	{
		bool IsAccessAllowed(int currentPage, BaseLogDetail logDetail, bool isCoaching, User user);
		string GetInstructionText(Review vm, User user);
		IList<string> GetReasonsToSelect(CoachingLogDetail log);
		IList<ShortCall> GetShortCallList(long logId);
		IList<ShortCall> GetShortCallEvalList(long logId);
		IList<ShortCall> GetShortCallCompletedEvalList(long logId);
		IList<Behavior> GetShortCallBehaviorList(bool isValid);
		IList<string> GetShortCallActions(string employeeId, int behaviorId);
		bool CompleteReview(Review vm, User user, string emailTempFileName, int logIdInSession);

        bool SaveSummaryQn(long logId, string summary, string userLanId);
        bool SaveFollowupDecisionQn(long logId, long[] logsLinkedTo, bool isCoachingRequired, string comments, string userId);

        List<TextValue> GetPotentialFollowupMonitorLogsQn(long logId);
	}
}

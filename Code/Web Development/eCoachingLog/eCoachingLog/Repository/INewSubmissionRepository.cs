using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface INewSubmissionRepository
    {
        Tuple<string, string, bool, string, string> GetEmailRecipientsTitlesAndBodyText(int moduleId, int sourceId, bool isCse);
        int GetLogStatusToSet(int moduleId, int sourceId, bool isCse);
        List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect);
        IList<NewSubmissionResult> SaveCoachingLog(NewSubmission newSubmission, User user);
        IList<NewSubmissionResult> SaveWarningLog(NewSubmission newSubmission, User user);
        List<MailResult> SaveNotificationStatus(List<MailResult> mailResults, string userId);
    }
}

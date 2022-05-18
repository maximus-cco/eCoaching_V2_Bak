using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public interface INewSubmissionService
    {
        // Save NewSubmission to database
        string Save(NewSubmission newSubmission, User user, out bool isDuplicate);
        // Get source list by module id
        List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect);
        Tuple<string, string, bool, string, string> GetEmailRecipientsTitlesAndBodyText(int moduleId, int sourceId, bool isCse);
        void SaveNotificationStatus(List<MailResult> mailResults, string userId);
    }
}
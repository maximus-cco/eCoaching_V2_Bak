using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface INewSubmissionRepository
    {
        int GetLogStatusToSet(int moduleId, int sourceId, bool isCse);
        // Save Coaching Log to database
        string SaveCoachingLog(NewSubmission newSubmission, User user);
        // Save Warning Log to database
        string SaveWarningLog(NewSubmission newSubmission, User user, out bool isDuplicate);
        List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect);
        Tuple<string, string, bool, string, string> GetEmailRecipientsTitlesAndBodyText(int moduleId, int sourceId, bool isCse);
    }
}

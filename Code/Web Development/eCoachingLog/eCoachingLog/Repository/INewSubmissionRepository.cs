using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface INewSubmissionRepository
    {
        MailMetaData GetMailMetaData(int moduleId, int sourceId, bool isCse);
        int GetLogStatusToSet(int moduleId, int sourceId, bool isCse);
        List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect);
        IList<NewSubmissionResult> SaveCoachingLog(NewSubmission newSubmission, User user);
        IList<NewSubmissionResult> SaveWarningLog(NewSubmission newSubmission, User user);
    }
}

using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public interface INewSubmissionService
    {
        // Save NewSubmission Coaching to database
        IList<NewSubmissionResult> Save(NewSubmission newSubmission, User user);
        // Get source list by module id
        List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect);
        MailMetaData GetMailMetaData(int moduleId, int sourceId, bool isCse);
    }
}
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public interface INewSubmissionService
    {
        // Save NewSubmission to database
        string Save(NewSubmission newSubmission, User user, out bool isDuplicate);

        // Get source list by module id
        List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect);
    }
}
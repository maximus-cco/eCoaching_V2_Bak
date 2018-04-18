using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using log4net;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public class NewSubmissionService : INewSubmissionService
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private INewSubmissionRepository newSubmissionRepository;

        public NewSubmissionService(INewSubmissionRepository nsr)
        {
            this.newSubmissionRepository = nsr;
        }

        public string Save(NewSubmission submission, User user, out bool isDuplicate)
        {
            bool isWarning = submission.IsWarning.HasValue && submission.IsWarning.Value;
            isDuplicate = false;
            if (isWarning)
            {
                return newSubmissionRepository.SaveWarningLog(submission, user, out isDuplicate);
            }

            List<CoachingReason> crs = submission.CoachingReasons;
            // We only care about the selected reasons
            submission.CoachingReasons = crs.FindAll(x => x.IsChecked == true);
            return newSubmissionRepository.SaveCoachingLog(submission, user);
        }

        public List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect)
        {
            return newSubmissionRepository.GetSourceListByModuleId(moduleId, directOrIndirect);
        }
    }
}
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
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
				// No text input on warning page, we are safe.
                return newSubmissionRepository.SaveWarningLog(submission, user, out isDuplicate);
            }

			// Strip potential harmful characters entered by the user
			var submissionCleaned = CleanInputs(submission);
			List<CoachingReason> crs = submissionCleaned.CoachingReasons;
			// We only care about the selected reasons
			submissionCleaned.CoachingReasons = crs.FindAll(x => x.IsChecked == true);
            return newSubmissionRepository.SaveCoachingLog(submissionCleaned, user);
        }

        public List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect)
        {
            return newSubmissionRepository.GetSourceListByModuleId(moduleId, directOrIndirect);
        }

		private NewSubmission CleanInputs(NewSubmission submission)
		{
			submission.BehaviorDetail = eCoachingLogUtil.CleanInput(submission.BehaviorDetail);
			submission.Plans = eCoachingLogUtil.CleanInput(submission.Plans);
			return submission;
		}
    }
}
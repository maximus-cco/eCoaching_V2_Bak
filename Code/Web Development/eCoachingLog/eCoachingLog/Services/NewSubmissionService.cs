using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System;
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
			submission.BehaviorDetail = EclUtil.CleanInput(submission.BehaviorDetail);
			submission.Plans = EclUtil.CleanInput(submission.Plans);

			List<CoachingReason> crs = submission.CoachingReasons;
			// We only care about the selected reasons
			submission.CoachingReasons = crs.FindAll(x => x.IsChecked == true);
            return newSubmissionRepository.SaveCoachingLog(submission, user);
        }

        public List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect)
        {
            return newSubmissionRepository.GetSourceListByModuleId(moduleId, directOrIndirect);
        }

        public Tuple<string, string, bool, string, string> GetEmailRecipientsTitlesAndBodyText(int moduleId, int sourceId, bool isCse)
        {
            return this.newSubmissionRepository.GetEmailRecipientsTitlesAndBodyText(moduleId, sourceId, isCse);
        }

        public void SaveNotificationStatus(List<MailResult> mailResults, string userId)
        {
            var updateStatus = new List<MailResult>();
            try
            {
                updateStatus = newSubmissionRepository.SaveNotificationStatus(mailResults, userId);
            }
            catch (Exception ex)
            {
                logger.Warn(ex);
            }

            foreach (var m in mailResults)
            {
                var found = false;
                foreach (var u in updateStatus)
                {
                    if (m.LogName == u.LogName)
                    {
                        found = true;
                        if (m.Success != u.Success)
                        {
                            logger.Error($"Failed to save mail sent result [{m.LogName}]: mail sent [{m.Success}]");
                        }
                    }
                } // end foreach (var u in updateResults)

                if (!found)
                {
                    logger.Error($"Missing to save mail sent result [{m.LogName}]: mail sent [{m.Success}]");
                }
            } // end  foreach (var m in mailResults)
        }

    } // end public class NewSubmissionService : INewSubmissionService
}
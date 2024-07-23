using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;

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

        public IList<NewSubmissionResult> Save(NewSubmission submission, User user)
        {
            if (submission.IsWarning != null && submission.IsWarning.Value)
            {
                return newSubmissionRepository.SaveWarningLog(submission, user);
            }

            // Make sure ids in submission.EmployeeIdList are unique
            submission.EmployeeIdList = submission.EmployeeIdList.Distinct().ToList();
			// Strip potential harmful characters entered by the user
			submission.BehaviorDetail = EclUtil.CleanInput(submission.BehaviorDetail);
			submission.Plans = EclUtil.CleanInput(submission.Plans);
            
			List<CoachingReason> crs = submission.CoachingReasons;
			// We only care about the selected reasons
			submission.CoachingReasons = crs.FindAll(x => x.IsChecked == true);
            return newSubmissionRepository.SaveCoachingLog(submission, user);
        }

        public List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect, bool isSubcontracorSite)
        {
            var sourceList = newSubmissionRepository.GetSourceListByModuleId(moduleId, directOrIndirect);
            // No ASR logs for subcontractor
            if (isSubcontracorSite)
            {
                return sourceList.Where(x => x.Id != Constants.SOURCE_DIRECT_ASR && x.Id != Constants.SOURCE_INDIRECT_ASR).ToList<LogSource>();
            }

            return sourceList;
        }

        public MailMetaData GetMailMetaData(int moduleId, int sourceId, bool isCse)
        {
            return this.newSubmissionRepository.GetMailMetaData(moduleId, sourceId, isCse);
        }

    } // end public class NewSubmissionService : INewSubmissionService
}
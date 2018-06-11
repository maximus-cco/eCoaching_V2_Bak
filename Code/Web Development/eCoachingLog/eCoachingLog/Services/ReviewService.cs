using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;

namespace eCoachingLog.Services
{
	public class ReviewService : IReviewService
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		private readonly IReviewRepository reviewRepository;
		private readonly IEmailService emailService;

		public ReviewService(IReviewRepository reviewRepository, IEmailService emailService)
		{
			this.reviewRepository = reviewRepository;
			this.emailService = emailService;
		}

		public bool IsAccessAllowed(int currentPage, BaseLogDetail logDetail, bool isCoaching, User user)
		{
			var userJobCode = user.JobCode == null ? string.Empty : user.JobCode.ToUpper();
			// User is allowed to access his/her submissions
			if (Constants.PAGE_MY_SUBMISSION == currentPage)
			{
				return user.EmployeeId == logDetail.SubmitterEmpId;
			}

			if (Constants.PAGE_HISTORICAL_DASHBOARD == currentPage)
			{
				return (
					user.EmployeeId == logDetail.SubmitterEmpId
					|| user.EmployeeId == logDetail.EmployeeId
					|| user.EmployeeId == logDetail.SupervisorEmpId
					|| user.EmployeeId == logDetail.ManagerEmpId
					|| user.IsEcl
					|| user.Role == Constants.USER_ROLE_SR_MANAGER
					|| userJobCode.StartsWith("WHHR")
					|| userJobCode.StartsWith("WHER")
					|| userJobCode.StartsWith("WHRC")
				);
			}

			if (Constants.PAGE_MY_DASHBOARD == currentPage)
			{
				return (
					(user.EmployeeId == logDetail.SubmitterEmpId && user.Role != Constants.USER_ROLE_ARC)
					|| user.EmployeeId == logDetail.EmployeeId
					|| user.EmployeeId == logDetail.SubmitterEmpId
					|| user.EmployeeId == logDetail.ManagerEmpId
					|| (isCoaching && ((CoachingLogDetail)logDetail).IsCse && user.EmployeeId == logDetail.LogManagerEmpId)
					|| (isCoaching &&
							(user.EmployeeId == ((CoachingLogDetail)logDetail).ReassignedSupervisorName
								|| user.EmployeeId == ((CoachingLogDetail)logDetail).ReassignedManagerName)
						)
				);
			}

			// If it reaches here, it already passes authorization in Survey Controller 
			if (Constants.PAGE_SURVEY == currentPage)
			{
				// To be safe, check again
				return (
					user.EmployeeId == logDetail.EmployeeId
				);
			}

			return false;
		}

		public string GetInstructionText(ReviewViewModel vm, User user)
		{
			var log = vm.LogDetail;

			if ((user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
				&& vm.LogStatusLevel == 2)
			{
				if (log.IsEtsOae)
				{
					return Constants.REVIEW_ETS_OAE;
				}

				if (log.IsEtsOas)
				{
					return Constants.REVIEW_ETS_OAS;
				}

				if (log.IsTrainingShortDuration)
				{
					return Constants.REVIEW_TRAINING_SHORT_DURATION_REPORT_TEXT;
				}

				if (log.IsTrainingOverdue)
				{
					return Constants.REVIEW_TRAINING_OVERDUE_TRAINING_TEXT;
				}

				if (log.IsBrl)
				{
					return Constants.REVIEW_OMR_BREAK_TIME_EXCEEDED_TEXT;
				}
			}

			if (log.IsLowCsat)
			{
				return Constants.REVIEW_LCAST;
			}

			if (log.IsOmrShortCall)
			{
				return Constants.REVIEW_OMR_SHORT_CALL_TEXT;
			}

			if (log.IsHigh5Club)
			{
				return Constants.REVIEW_QUALITY_HIGH5_CLUB;
			}

			if (log.IsKudo)
			{
				return Constants.REVIEW_QUALITY_KUDO_CSR;
			}

			if (log.IsScorecardMsr)
			{
				return Constants.REVIEW_SCORECARD_MSR;
			}

			if (log.IsScorecardMsrs)
			{
				return Constants.REVIEW_SCORECARD_MSRS;
			}

			if ((log.IsEtsHnc || log.IsEtsIcc) && vm.LogStatusLevel == 2)
			{
				return Constants.REVIEW_HNC_ICC;
			}


			return string.Empty;
		}

		public bool CompleteReview(ReviewViewModel vm, User user, string emailTempFileName, string logoFileName)
		{
			if (vm.IsRegularPendingForm)
			{
				return CompleteRegularPendingReview(vm, user, emailTempFileName, logoFileName);
			}

			return false;
		}

		private bool CompleteRegularPendingReview(ReviewViewModel vm, User user, string emailTempFileName, string logoFileName)
		{
			string nextStatus = string.Empty;
			bool success = false;
			// Determine next status for the log
			if (vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT)
			{
				nextStatus = "Pending Employee Review";
			}
			else
			{
				nextStatus = "Completed";
			}

			success = reviewRepository.CompleteRegularPendingReview(vm.LogDetail.LogId, vm.DateCoached, vm.DetailsCoached, nextStatus, user);
			string moduleName = vm.LogDetail.ModuleName;
			// Email CSR's comments to supervisor and manager 
			if (success && !string.IsNullOrEmpty(moduleName) && moduleName.Trim().ToUpper() == "CSR" && nextStatus == "Completed")
			{
				this.emailService.SendComments(vm.LogDetail, vm.DetailsCoached, emailTempFileName, logoFileName);
			}

			return success;

		}
	}
}
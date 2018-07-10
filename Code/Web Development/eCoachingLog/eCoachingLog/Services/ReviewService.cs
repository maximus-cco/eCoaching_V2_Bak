using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;

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
					|| (user.IsEcl && isCoaching)
					|| user.Role == Constants.USER_ROLE_SR_MANAGER
					|| userJobCode.StartsWith("WHHR")
					|| userJobCode.StartsWith("WHER")
					|| userJobCode.StartsWith("WHRC")
				);
			}

			if (Constants.PAGE_MY_DASHBOARD == currentPage)
			{
				// Coaching log:
				if (isCoaching)
				{
					return (
						(user.EmployeeId == logDetail.SubmitterEmpId && user.Role != Constants.USER_ROLE_ARC)
						|| user.EmployeeId == logDetail.EmployeeId
						|| user.EmployeeId == logDetail.SupervisorEmpId
						|| user.EmployeeId == logDetail.ManagerEmpId
						|| user.EmployeeId == ((CoachingLogDetail)logDetail).ReassignedToEmpId
						|| (isCoaching && ((CoachingLogDetail)logDetail).IsLowCsat && user.EmployeeId == logDetail.LogManagerEmpId)
					);
				}
				// Warning log:
				else
				{
					return (
						user.EmployeeId == logDetail.SubmitterEmpId
						|| user.EmployeeId == logDetail.EmployeeId
						|| user.EmployeeId == logDetail.SupervisorEmpId
						|| user.EmployeeId == logDetail.ManagerEmpId
						|| user.Role == Constants.USER_ROLE_SR_MANAGER
					);
				}
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

		public string GetInstructionText(Review review, User user)
		{
			var log = review.LogDetail;

			if (user.EmployeeId == log.ManagerEmpId 
				|| (log.IsLowCsat && user.EmployeeId == log.LogManagerEmpId)
				|| user.EmployeeId == log.ReassignedToEmpId)
			{
				if (review.LogStatusLevel == 3)
				{
					if (log.IsCurrentCoachingInitiative || log.IsOmrException || log.IsLowCsat)
					{
						// Short Call
						if (log.IsOmrShortCall)
						{
							return Constants.REVIEW_OMR_SHORT_CALL_TEXT;
						}
						// Low Csat
						if (log.IsLowCsat)
						{
							return Constants.REVIEW_LCSAT;
						}
						// General
						return Constants.REVIEW_OMR;
					}
				}
			}

			if ((user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
				&& review.LogStatusLevel == 2)
			{
				if (log.IsOmrIae || log.IsOmrIaef || log.IsOmrIat)
				{
					return Constants.REVIEW_OMR;
				}

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

				if (log.IsBrl || log.IsBrn)
				{
					return Constants.REVIEW_OMR_BREAK_TIME_EXCEEDED_TEXT;
				}
			}

			if (log.IsHigh5Club)
			{
				return Constants.REVIEW_QUALITY_HIGH5_CLUB;
			}

			if (log.IsKudo)
			{
				if (user.EmployeeId == log.EmployeeId)
				{
					return Constants.REVIEW_QUALITY_KUDO_CSR;
				}

				return Constants.REVIEW_QUALITY_KUDO_SUPERVISOR;
			}

			if (log.IsScorecardMsr)
			{
				return Constants.REVIEW_SCORECARD_MSR;
			}

			if (log.IsScorecardMsrs)
			{
				return Constants.REVIEW_SCORECARD_MSRS;
			}

			if ((log.IsEtsHnc || log.IsEtsIcc) && review.LogStatusLevel == 2)
			{
				return Constants.REVIEW_HNC_ICC;
			}


			return string.Empty;
		}

		public IList<string> GetReasonsToSelect(CoachingLogDetail log)
		{
			string reportCode = string.Empty;

			if (log.IsBrl)
			{
				reportCode = Constants.LOG_REPORT_CODE_OMRBRL;
			}
			else if (log.IsBrn)
			{
				reportCode = Constants.LOG_REPORT_CODE_OMRBRN;
			}
			else if (log.IsOmrIae || log.IsOmrIaef)
			{
				reportCode = Constants.LOG_REPORT_CODE_OMRIAE;
			}
			else if (log.IsDtt)
			{
				reportCode = Constants.LOG_REPORT_CODE_OTHDTT;
			}
			else
			{
				reportCode = Constants.LOG_REPORT_CODE_OTHER;
			}

			return reviewRepository.GetReasonsToSelect(reportCode);
		}

		public bool CompleteReview(Review review, User user, string emailTempFileName, string logoFileName)
		{
			// Strip potential harmful characters entered by the user
			review.DetailsCoached = eCoachingLogUtil.CleanInput(review.DetailsCoached);
			review.EmployeeComments = eCoachingLogUtil.CleanInput(review.EmployeeComments);
			review.DetailReasonCoachable = eCoachingLogUtil.CleanInput(review.DetailReasonCoachable);
			review.DetailReasonNotCoachable = eCoachingLogUtil.CleanInput(review.DetailReasonNotCoachable);

			if (review.IsRegularPendingForm)
			{
				return CompleteRegularPendingReview(review, user, emailTempFileName, logoFileName);
			}

			if (review.IsAcknowledgeForm)
			{
				return CompleteAckReview(review, user, emailTempFileName, logoFileName);
			}

			if (review.IsResearchPendingForm)
			{
				return CompleteResearchPendingReview(review, user);
			}

			if (review.IsCsePendingForm)
			{
				return reviewRepository.CompleteCsePendingReview(review, GetNextStatus(review, user), user);
			}

			// unexpected pending form, should never reach here
			return false;
		}

		private bool CompleteRegularPendingReview(Review review, User user, string emailTempFileName, string logoFileName)
		{
			bool success = false;
			string nextStatus = "Pending Employee Review";
			review.DetailsCoached = FormatCoachingNotes(review, user);
			success = reviewRepository.CompleteRegularPendingReview(review, nextStatus, user);
			return success;
		}

		private bool CompleteAckReview(Review review, User user, string emailTempFileName, string logoFileName)
		{
			bool success = false;
			string nextStatus = string.Empty;

			// Opportunity
			if (!review.IsReinforceLog)
			{
				nextStatus = "Completed";
				success = reviewRepository.CompleteAckRegularReview(review, nextStatus, user);
			}
			// Reinforcement
			else
			{
				nextStatus = GetNextStatus(review, user);
				if (review.LogDetail.EmployeeId == user.EmployeeId)
				{
					success = reviewRepository.CompleteEmpAckReinforceReview(review, nextStatus, user);
				}
				else
				{
					success = reviewRepository.CompleteSupAckReinforceReview(review.LogDetail.LogId, nextStatus, user);
				}
			}

			// Email CSR's comments to supervisor and manager 
			if (success && review.LogDetail.ModuleId == Constants.MODULE_CSR && nextStatus == "Completed")
			{
				try
				{
					this.emailService.SendComments(review.LogDetail, review.EmployeeComments, emailTempFileName, logoFileName);
				}
				catch (Exception ex)
				{
					logger.Warn("Failed to send comments email for log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			}
			return success;
		}

		private bool CompleteResearchPendingReview(Review review, User user)
		{
			if (review.LogStatusLevel == 2)
			{
				if (review.IsCoachingRequired)
				{
					review.DetailReasonCoachable = FormatCoachingNotes(review, user);
				}
				else
				{
					review.DetailReasonNotCoachable = FormatCoachingNotes(review, user);
				}
				// Don't save date entered on the page in coaching_log.CoachingDate, it will be with coachingNotes.
				review.DateCoached = null;
			}
			return reviewRepository.CompleteResearchPendingReview(review, GetNextStatus(review, user), user);
		}

		private string FormatCoachingNotes(Review review, User user)
		{
			string notes = string.Empty;
			notes += user.Name;
			if (review.DateCoached.HasValue && review.DateCoached.Value != null)
			{
				notes += " (" + DateTime.Now + " PDT) - " + review.DateCoached.Value.ToString("MM/dd/yyyy");
			}
			else
			{
				notes += " (" + DateTime.Now + " PDT) - " + review.DateCoached;
			}

			if (!string.IsNullOrEmpty(review.DetailReasonNotCoachable))
			{
				notes += " " + review.DetailReasonNotCoachable;
			}
			else if (!string.IsNullOrEmpty(review.DetailReasonCoachable))
			{
				notes += " " + review.DetailReasonCoachable;
			}
			else
			{
				notes += " " + review.DetailsCoached;
			}

			if (string.IsNullOrEmpty(review.LogDetail.CoachingNotes))
			{
				return notes;
			}

			return eCoachingLogUtil.CleanInput(review.LogDetail.CoachingNotes + "<br />" + notes);
		}

		private string GetNextStatus(Review review, User user)
		{
			string nextStatus = "Unknown";
			int moduleId = review.LogDetail.ModuleId;
			// Positive (reinforced, met goal) Ack form
			if (review.IsAcknowledgeForm && review.IsReinforceLog)
			{
				if (review.LogDetail.EmployeeId == user.EmployeeId)
				{
					if (review.LogDetail.HasSupAcknowledged)
					{
						nextStatus = "Completed";
					}
					else
					{
						if (moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_TRAINING)
						{
							nextStatus = "Pending Supervisor Review";
						}
						else if (moduleId == Constants.MODULE_SUPERVISOR)
						{
							nextStatus = "Pending Manager Review";
						}
						else if (moduleId == Constants.MODULE_QUALITY)
						{
							nextStatus = "Pending Quality Lead Review";
						}
					}
				}
				else // user is not the log's employee
				{
					if(review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT)
					{
						nextStatus = "Pending Employee Review";
					}
					else
					{
						nextStatus = "Completed";
					}
				}

				return nextStatus;
			}

			// Research form
			if (review.IsResearchPendingForm)
			{
				// Coaching not required
				if (!review.IsCoachingRequired)
				{
					return "Inactive";
				}

				// Coaching is required
				var log = review.LogDetail;
				if(moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_TRAINING)
				{
					if (log.IsCurrentCoachingInitiative || log.IsOmrException || log.IsLowCsat)
					{
						nextStatus = "Pending Supervisor Review";
					}
					else if (log.IsOmrIae || log.IsOmrIaef || log.IsOmrIat || log.IsEtsOae || log.IsTrainingShortDuration || log.IsTrainingOverdue || log.IsBrl || log.IsBrn)
					{
						nextStatus = "Pending Employee Review";
					}

					if (user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
					{
						nextStatus = "Pending Employee Review";
					}
				}
				else if (moduleId == Constants.MODULE_SUPERVISOR)
				{
					if (log.IsCurrentCoachingInitiative || log.IsOmrException)
					{
						nextStatus = "Pending Manager Review";
					}
					else
					{
						nextStatus = "Pending Employee Review";
					}
				}
				else if (moduleId == Constants.MODULE_QUALITY)
				{
					if (log.IsCurrentCoachingInitiative || log.IsOmrException)
					{
						nextStatus = "Pending Quality Lead Review";
					}
					else
					{
						nextStatus = "Pending Employee Review";
					}
				}
				else // LSA, Program Analyst, Administration, Analytics Reporting, Production Planning
				{
					nextStatus = "Pending Employee Review";
				}

				return nextStatus;
			}

			// CSE form
			if (review.IsCsePendingForm)
			{
				if (moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_TRAINING)
				{
					nextStatus = "Pending Supervisor Review";
				}
				else if (moduleId == Constants.MODULE_SUPERVISOR)
				{
					nextStatus = "Pending Manager Review";
				}
				else if (moduleId == Constants.MODULE_QUALITY)
				{
					nextStatus = "Pending Quality Lead Review";
				}
			}

			// if nextStatus is unknown, then something must be wrong
			return nextStatus;
		}
	}
}
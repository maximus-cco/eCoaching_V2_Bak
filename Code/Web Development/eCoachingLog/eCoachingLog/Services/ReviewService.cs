using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Text;

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
					|| userJobCode.StartsWith("WHHR")
					|| userJobCode.StartsWith("WHER")
					|| userJobCode.StartsWith("WHRC")
					|| user.Role == Constants.USER_ROLE_DIRECTOR
					// 8/18/2020 - directors and senior managers
					|| user.EmployeeId == logDetail.SrMgrLevelOneEmpId
					|| user.EmployeeId == logDetail.SrMgrLevelTwoEmpId
					|| user.EmployeeId == logDetail.SrMgrLevelThreeEmpId
				);
			}

			if (Constants.PAGE_MY_DASHBOARD == currentPage)
			{
				// 8/18/2020 - directors and senior managers
				if (user.EmployeeId == logDetail.SrMgrLevelOneEmpId
					|| user.EmployeeId == logDetail.SrMgrLevelTwoEmpId
					|| user.EmployeeId == logDetail.SrMgrLevelThreeEmpId)
				{
					return true;
				}

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

		public string GetAdditionalText(Review review, User user)
		{
            var log = review.LogDetail;

            if (log.IsCpath
                && (user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
                && log.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW)
            {
                return log.AdditionalText;
            }

            if (log.IsQn 
                && (user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
                && (log.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW 
                      || log.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_PREPARATION)
               )
            {
                return log.AdditionalText;
            }

            if ((log.IsOmrAudio || log.IsNgdsLoginOutsideShift)
                && (user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
                && log.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW)
            {
                var additionalText = log.AdditionalText == null ? "" : log.AdditionalText.Replace("<p>", "").Replace("</p>","");
                return additionalText;
            }

            if (log.IsSurvey 
                && log.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW 
                && (user.IsSupervisor|| log.ReassignedToEmpId == user.EmployeeId))
            {
                return Constants.SURVEY;
            }

			if (user.EmployeeId == log.ManagerEmpId
				|| (log.IsLowCsat && user.EmployeeId == log.LogManagerEmpId)
				|| user.EmployeeId == log.ReassignedToEmpId)
			{
				if (review.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3)
				{
					// Don't display instruct text for manager since now the workflow is changed to 
					// Pending Supervisor Review --> Pending Manager Review
					if ((log.IsCurrentCoachingInitiative || log.IsOmrException || log.IsLowCsat) && !log.IsOmrShortCall)
					{
						// Low Csat
						if (log.IsLowCsat)
						{
							return Constants.REVIEW_LCSAT;
						}

						// General
                        if (user.IsSubcontractor)
                        {
                            return Constants.REVIEW_OMR_SUBCONTRACTOR;
                        }
						return Constants.REVIEW_OMR;
					}
				}
			}

			if ((user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
				&& review.LogStatusLevel == 2)
			{
				if (log.IsOmrShortCall)
				{
					return Constants.REVIEW_OMR_SHORT_CALL_TEXT;
				}

				if (log.IsOmrIae || log.IsOmrIaef || log.IsOmrIat)
				{
                    if (user.IsSubcontractor)
                    {
                        return Constants.REVIEW_OMR_SUBCONTRACTOR;
                    }
					return Constants.REVIEW_OMR;
				}

				if (log.IsEtsOae)
				{
                    if (user.IsSubcontractor)
                    {
                        return Constants.REVIEW_ETS_OAE_SUBCONTRACTOR;
                    }
					return Constants.REVIEW_ETS_OAE;
				}

				if (log.IsEtsOas)
				{
                    if (user.IsSubcontractor)
                    {
                        return Constants.REVIEW_ETS_OAE_SUBCONTRACTOR;
                    }
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
                    if (user.IsSubcontractor)
                    {
                        return Constants.REVIEW_OMR_BREAK_TIME_EXCEEDED_TEXT_SUBCONTRACTOR;
                    }
					return Constants.REVIEW_OMR_BREAK_TIME_EXCEEDED_TEXT;
				}
			}

			// OTH/APS and OTH/APW logs come in as Pending Acknowledgement
			// Display Review Static Text for Supervisors
			// Note: if csr/isg acks first, status will become "Pending Supervisor Review"
			if ((user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
					&& (review.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4 || review.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2))
			{
				if (log.IsOthAps)
				{
					return Constants.REVIEW_OTH_APS_TEXT;
				}

				if (log.IsOthApw)
				{
					return Constants.REVIEW_OTH_APW_TEXT;
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
                    if (user.IsSubcontractor)
                    {
                        return Constants.REVIEW_QUALITY_KUDO_CSR_SUBCONTRACTOR;
                    }
					return Constants.REVIEW_QUALITY_KUDO_CSR;
				}

                if (user.IsSubcontractor)
                {
                    return Constants.REVIEW_QUALITY_KUDO_SUPERVISOR_SUBCONTRACTOR;
                }
                return Constants.REVIEW_QUALITY_KUDO_SUPERVISOR;
			}

			//if (log.IsMsr)
			//{
			//	if (Constants.SOURCE_INTERNAL_CCO_REPORTING == log.SourceId)
			//	{
			//		return Constants.REVIEW_MSR_INTERNAL_CCO_REPORTING;
			//	}
			//	return Constants.REVIEW_MSR_PSCORECARD;
			//}

			//if (log.IsMsrs)
			//{
			//	return Constants.REVIEW_SCORECARD_MSRS;
			//}

			if ((log.IsEtsHnc || log.IsEtsIcc) && review.LogStatusLevel == 2)
			{
                if (user.IsSubcontractor)
                {
                    return Constants.REVIEW_HNC_ICC_SUBCONTRACTOR;
                }
				return Constants.REVIEW_HNC_ICC;
			}

			// PBH comes in as Pending Supervisor Review;
			// It goes to Pending Employee Review after;
			// Display for both Supervisors and CSRs/ISGs
			if (log.IsPbh)
			{
				return Constants.REVIEW_OMR_PBH;
			}

			// Incentives data feed: comes in as Pending Employee Review --> Complete
			if (log.IsIdd)
			{
                if (user.IsSubcontractor)
                {
                    return Constants.REVIEW_OMR_IDD_SUBCONTRACTOR;
                }
				return Constants.REVIEW_OMR_IDD;
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

		public IList<Behavior> GetShortCallBehaviorList(bool isValid)
		{
			return this.reviewRepository.GetShortCallBehaviorList(isValid);
		}

		public IList<string> GetShortCallActions(string employeeId, int behaviorId)
		{
			return this.reviewRepository.GetShortCallActions(employeeId, behaviorId);
		}

		public IList<ShortCall> GetShortCallList(long logId)
		{
			return this.reviewRepository.GetShortCallList(logId);
		}

		public IList<ShortCall> GetShortCallEvalList(long logId)
		{
			return this.reviewRepository.GetShortCallEvalList(logId);
		}

		public IList<ShortCall> GetShortCallCompletedEvalList(long logId)
		{
			return this.reviewRepository.GetShortCallCompletedEvalList(logId);
		}

		public bool CompleteReview(Review review, User user, string emailTempFileName,int logIdInSession)
		{
			// Warning
			if (!review.IsCoaching)
			{
				return CompleteWarning(review, user, emailTempFileName);
			}

			// Strip potential harmful characters entered by the user
			review.DetailsCoached = EclUtil.CleanInput(review.DetailsCoached);
            review.DetailsFollowup = EclUtil.CleanInput(review.DetailsFollowup);
            review.Comment = EclUtil.CleanInput(review.Comment);
			review.DetailReasonCoachable = EclUtil.CleanInput(review.DetailReasonCoachable);
			review.DetailReasonNotCoachable = EclUtil.CleanInput(review.DetailReasonNotCoachable);

            // QN log: 12->13
            if (review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_COACHING)
            {
                string nextStatus = Constants.LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW_TEXT;
                review.DetailsFollowup = review.DetailsCoached;
                return reviewRepository.CompleteSupervisorFollowup(review, nextStatus, user);
            }

            if (review.IsShortCallPendingSupervisorForm)
			{
				string nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
				review.DetailsCoached = FormatCoachingNotes(review, user);
				return reviewRepository.CompleteShortCallsReview(review, nextStatus, user);
			}

			if (review.IsShortCallPendingManagerForm)
			{
				return reviewRepository.CompleteShortCallsConfirm(review, Constants.LOG_STATUS_COMPLETED_TEXT, user);
			}

			if (review.IsRegularPendingForm)
			{
				return CompleteRegularPendingReview(review, user, emailTempFileName);
			}

			if (review.IsAcknowledgeForm)
			{
				if (review.IsFollowupPendingCsrForm)
				{
					string nextStatus = Constants.LOG_STATUS_COMPLETED_TEXT;
                    bool success = reviewRepository.CompleteEmployeeAckFollowup(review, nextStatus, user);

                    if (success && nextStatus == Constants.LOG_STATUS_COMPLETED_TEXT)
                    {
                        // Email supervisor and/or manager upon CSR/ISG completes qn log (Pending employee followup review -> Completed)
                        if (review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW)
                        {
                            var mailParameter = new MailParameter(review.LogDetail, review.Comment, "Quality Now Follow-up Completed", emailTempFileName, user.EmployeeId);
                            this.emailService.StoreNotification(mailParameter);
                        }
                        else
                        {
                            var employeeCoachingComment = string.IsNullOrEmpty(review.EmployeeCoachingComment) ? "" : review.EmployeeCoachingComment;
                            // review comment - this is the comment entered by employee on pending employee review page.
                            var allEmployeeComment = employeeCoachingComment + "<br>" + review.Comment;
                            var mailParameter = new MailParameter(review.LogDetail, allEmployeeComment, "eCoaching Log Follow-up Completed", emailTempFileName, user.EmployeeId);
                            this.emailService.StoreNotification(mailParameter);
                        }
                    }

                    return success;
                }

				return CompleteAckReview(review, user, emailTempFileName);
			}

			if (review.IsResearchPendingForm)
			{
				return CompleteResearchPendingReview(review, user);
			}

			if (review.IsCsePendingForm)
			{
				return reviewRepository.CompleteCsePendingReview(review, GetNextStatus(review, user), user);
			}

			if (review.IsFollowupPendingSupervisorForm)
			{
				string nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
				return reviewRepository.CompleteSupervisorFollowup(review, nextStatus, user);
			}

            // unexpected pending form, should never reach here
            StringBuilder sb = new StringBuilder("Unexpected review form: ");
			var userId = user == null ? "usernull" : user.EmployeeId;
			sb.Append("[").Append(userId).Append("]")
				.Append("|LogId[").Append(logIdInSession).Append("]");
			logger.Warn(sb);
			return false;
		}

		private bool CompleteWarning(Review review, User user, string emailTempFileName)
		{
			string nextStatus = "Completed";
			bool success = reviewRepository.CompleteAckRegularReview(review, nextStatus, user);
			string subject = "Warning Log Completed";

			// Email supervisor and/or manager upon CSR/ISG acknowledges the warning log
			if (success
					&& (review.WarningLogDetail.ModuleId == Constants.MODULE_CSR || review.WarningLogDetail.ModuleId == Constants.MODULE_ISG)
					&& nextStatus == Constants.LOG_STATUS_COMPLETED_TEXT
					&& review.WarningLogDetail.EmployeeId == user.EmployeeId)
			{
                var mailParameter = new MailParameter(review.WarningLogDetail, review.Comment, subject, emailTempFileName, user.EmployeeId);
                this.emailService.StoreNotification(mailParameter);
            }

			return success;
		}

		private bool CompleteRegularPendingReview(Review review, User user, string emailTempFileName)
		{
			bool success = false;
			string nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
            if (review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_COACHING)
            {
                nextStatus = Constants.LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW_TEXT;
            }
			review.DetailsCoached = FormatCoachingNotes(review, user);
			success = reviewRepository.CompleteRegularPendingReview(review, nextStatus, user);
			return success;
		}

		private bool CompleteAckReview(Review review, User user, string emailTempFileName)
		{
			bool success = false;
			string nextStatus = string.Empty;

            if (review.ShowCsrPromotionQuestion)
            {
                review.Comment += "<br>" + review.CsrPromotionSelected;
            }

            if (review.IsAckOverTurnedAppeal)
			{
				nextStatus = Constants.LOG_STATUS_COMPLETED_TEXT;
				return reviewRepository.CompleteSupAckReview(review.LogDetail.LogId, nextStatus, FormatCoachingNotes(review, user), user);
			}

            // Followup required; 
 			if (review.LogDetail.IsFollowupRequired)
			{
				// CSR/ISG completes review, set status to Pending Supervisor Followup
				if (review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW)
				{
					nextStatus = Constants.LOG_STATUS_PENDING_SUPERVISOR_FOLLOWUP_TEXT;
				}
				else if (review.IsFollowupPendingCsrForm)
				{
					nextStatus = Constants.COMPLETED;
				}
				else
				{
					// should never get to here
					// because when supervisor reviews the followup log, it is not ack form, it is review form
				}
				return reviewRepository.CompleteAckRegularReview(review, nextStatus, user);
			}

            // TODO: 1-eval log will follow current workflow;
            // 5-eval log will go to Pending Followup Preparation;
            if ( review.LogDetail.IsQn)
            {
                // use status instead, all an logs go to 11 after 4
                //if (review.LogDetail.LinkedLogs == null || review.LogDetail.LinkedLogs.Count < 2)
                if (review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW)
                {
                    //return reviewRepository.CompleteAckRegularReview(review, Constants.LOG_STATUS_COMPLETED_TEXT, user);
                    return reviewRepository.CompleteAckRegularReview(review, Constants.LOG_STATUS_PENDING_SUPERVISOR_FOLLOWUP_PREPARATION_TEXT, user);
                }
                return reviewRepository.CompleteAckRegularReview(review, Constants.LOG_STATUS_COMPLETED_TEXT, user);
            }

            // Go to Completed
            if (!review.IsMoreReviewRequired)
			{
				nextStatus = Constants.LOG_STATUS_COMPLETED_TEXT;
				success = reviewRepository.CompleteAckRegularReview(review, nextStatus, user);
			}
			// Might need more reviews
			else
			{
				nextStatus = GetNextStatus(review, user);
				if (review.LogDetail.EmployeeId == user.EmployeeId)
				{
					success = reviewRepository.CompleteEmpAcknowlegement(review, nextStatus, user);
				}
				else
				{
					// No coaching notes for reinforcement
					success = reviewRepository.CompleteSupAckReview(review.LogDetail.LogId, nextStatus, null, user);
				}
			}

			// Email CSR/ISG comments to supervisor and/or manager 
			if (success 
					&& (review.LogDetail.ModuleId == Constants.MODULE_CSR || review.LogDetail.ModuleId == Constants.MODULE_ISG)
                    && nextStatus == Constants.LOG_STATUS_COMPLETED_TEXT
					&& review.LogDetail.EmployeeId == user.EmployeeId)
			{
                var mailParameter = new MailParameter(review.LogDetail, review.Comment, "eCoaching Log Completed", emailTempFileName, user.EmployeeId);
                this.emailService.StoreNotification(mailParameter);
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
                notes += " (" + DateTime.Now + " " + Constants.TIMEZONE + ") - " + review.DateCoached.Value.ToString("MM/dd/yyyy");
            }
			else
			{
				notes += " (" + DateTime.Now + " " + Constants.TIMEZONE + ") - " + review.DateCoached;
			}

			if (!string.IsNullOrEmpty(review.DetailReasonNotCoachable))
			{
				notes += " " + review.DetailReasonNotCoachable;
			}
			else if (!string.IsNullOrEmpty(review.DetailReasonCoachable))
			{
				notes += " " + review.DetailReasonCoachable;
			}
			else if (!string.IsNullOrEmpty(review.DetailsCoached))
			{
				notes += " " + review.DetailsCoached;
			}

			// OTA log: notes captured as Comment
			if (review.IsAckOverTurnedAppeal)
			{
				notes += review.Comment;
			}

			if (string.IsNullOrEmpty(review.LogDetail.CoachingNotes))
			{
				return notes;
			}

			return EclUtil.CleanInput(review.LogDetail.CoachingNotes + "<br />" + notes);
		}

		private string GetNextStatus(Review review, User user)
		{
            if (review.LogDetail.IsSurvey)
            {
                return Constants.WORKFLOW_SURVEY[review.LogDetail.StatusId];
            }

			string nextStatus = Constants.LOG_STATUS_UNKNOWN_TEXT;
			int moduleId = review.LogDetail.ModuleId;
			// Positive (reinforced, met goal) Ack form
			if (review.IsAcknowledgeForm && review.IsMoreReviewRequired)
			{
				if (review.LogDetail.EmployeeId == user.EmployeeId)
				{
					if (review.LogDetail.HasSupAcknowledged) 
					{
						nextStatus = Constants.LOG_STATUS_COMPLETED_TEXT;
					}
					else
					{
						if (moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_ISG || moduleId == Constants.MODULE_TRAINING)
						{
							nextStatus = Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW_TEXT;
						}
						else if (moduleId == Constants.MODULE_SUPERVISOR)
						{
							// TFS 15063 - Quality BINGO (Supervisor Module) goes to COMPLETED
							// TFS 15600 - London Alternate Channel Bingo
							nextStatus = (review.LogDetail.IsBqns || review.LogDetail.IsBqm || review.LogDetail.IsBqms) ? 
								Constants.LOG_STATUS_COMPLETED_TEXT : Constants.LOG_STATUS_PENDING_MANAGER_REVIEW_TEXT;
						}
						else if (moduleId == Constants.MODULE_QUALITY)
						{
							nextStatus = Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW_TEXT;
						}
					}
				}
				else // user is not the log's employee
				{
					if(review.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT)
					{
						nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
					}
					else
					{
						nextStatus = Constants.LOG_STATUS_COMPLETED_TEXT;
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
					return Constants.LOG_STATUS_INACTIVE_TEXT;
				}

				// Coaching is required
				var log = review.LogDetail;
				if(moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_ISG || moduleId == Constants.MODULE_TRAINING)
				{
					//if (log.IsCurrentCoachingInitiative || log.IsOmrException || log.IsLowCsat) // current Pending Manager Review to determine if coaching is required
					if (log.StatusId == Constants.LOG_STATUS_PENDING_MANAGER_REVIEW)
					{
						nextStatus = Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW_TEXT;
					}
					// current Pending Supervisor Review to determine if coaching is required
					//else if (log.IsOmrIae || log.IsOmrIaef || log.IsOmrIat || log.IsEtsOae || log.IsTrainingShortDuration || log.IsTrainingOverdue || log.IsBrl || log.IsBrn)
					else //if (log.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW)
					{
						nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
					}
					//if (user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
					//{
					//	nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
					//}
				}
				else if (moduleId == Constants.MODULE_SUPERVISOR)
				{
					//if (log.IsCurrentCoachingInitiative || log.IsOmrException)
					if (log.StatusId == Constants.LOG_STATUS_PENDING_SRMANAGER_REVIEW)
					{
						nextStatus = Constants.LOG_STATUS_PENDING_MANAGER_REVIEW_TEXT;
					}
					else
					{
						nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
					}
				}
				else if (moduleId == Constants.MODULE_QUALITY)
				{
					//if (log.IsCurrentCoachingInitiative || log.IsOmrException)
					if (log.StatusId == Constants.LOG_STATUS_PENDING_DEPUTYPROGRAMMANAGER_REVIEW)
					{
						nextStatus = Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW_TEXT;
					}
					else
					{
						nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
					}
				}
				else // LSA, Program Analyst, Administration, Analytics Reporting, Production Planning
				{
					nextStatus = Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW_TEXT;
				}

				return nextStatus;
			}

			// CSE form
			if (review.IsCsePendingForm)
			{
				if (moduleId == Constants.MODULE_CSR || moduleId == Constants.MODULE_ISG || moduleId == Constants.MODULE_TRAINING)
				{
					nextStatus = Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW_TEXT;
				}
				else if (moduleId == Constants.MODULE_SUPERVISOR)
				{
					nextStatus = Constants.LOG_STATUS_PENDING_MANAGER_REVIEW_TEXT;
				}
				else if (moduleId == Constants.MODULE_QUALITY)
				{
					nextStatus = Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW_TEXT;
				}
			}

			// if nextStatus is unknown, then something must be wrong
			return nextStatus;
		}

        // Quality now - save summary 
        public bool SaveSummaryQn(long logId, string summary, string userLanId)
        {
            return this.reviewRepository.SaveSummaryQn(logId, summary, userLanId);
        }

        public bool SaveFollowupDecisionQn(long logId, long[] logsLinkedTo, bool isCoachingRequired, string comments, string userId)
        {
            return this.reviewRepository.SaveFollowupDecisionQn(logId, logsLinkedTo, isCoachingRequired, comments, userId);
        }

        public List<TextValue> GetPotentialFollowupMonitorLogsQn(long logId)
        {
            return this.reviewRepository.GetPotentialFollowupMonitorLogsQn(logId);
        }


    }
}
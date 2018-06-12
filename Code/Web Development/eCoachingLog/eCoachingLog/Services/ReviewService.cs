using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;

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

		public string GetInstructionText(Review vm, User user)
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

		public bool CompleteReview(Review vm, User user, string emailTempFileName, string logoFileName)
		{
			if (vm.IsRegularPendingForm)
			{
				return CompleteRegularPendingReview(vm, user, emailTempFileName, logoFileName);
			}

			if (vm.IsAcknowledgeForm)
			{
				return CompleteAckReview(vm, user, emailTempFileName, logoFileName);
			}

			if (vm.IsResearchPendingForm)
			{

			}

			if (vm.IsCsePendingForm)
			{

			}

			return false;
		}

		private bool CompleteRegularPendingReview(Review vm, User user, string emailTempFileName, string logoFileName)
		{
			bool success = false;
			string nextStatus = "Pending Employee Review";

			success = reviewRepository.CompleteRegularPendingReview(vm.LogDetail.LogId, vm.DateCoached, vm.DetailsCoached, nextStatus, user);
			return success;
		}

		private bool CompleteAckReview(Review vm, User user, string emailTempFileName, string logoFileName)
		{
			bool success = false;
			string nextStatus = string.Empty;

			// Opportunity
			if (!vm.IsReinforceLog)
			{
				string comments = string.Empty;
				// TODO: bind dropdown and txtbox to the same field EmployeeComment
				//if (vm.ShowCommentDdl)
				//{
				//	comments = vm.EmployeeCommentsDdl;
				//}
				//else
				//{
					comments = vm.EmployeeComments;
				//}

				nextStatus = "Completed";
				success = reviewRepository.CompleteAckRegularReview(vm.LogDetail.LogId, vm.AcknowledgeMonitor, comments, nextStatus, user);

			}
			// Reinforcement
			else
			{
				nextStatus = GetNextStatus(vm, user);
				if (vm.LogDetail.EmployeeId == user.EmployeeId)
				{
					success = reviewRepository.CompleteEmpAckReinforceReview(vm.LogDetail.LogId, vm.AcknowledgeMonitor, vm.EmployeeComments, nextStatus, user);
				}
				else
				{
					success = reviewRepository.CompleteSupAckReinforceReview(vm.LogDetail.LogId, nextStatus, user);
				}
			}

			string moduleName = vm.LogDetail.ModuleName;
			// Email CSR's comments to supervisor and manager 
			if (success && !string.IsNullOrEmpty(moduleName) && moduleName.Trim().ToUpper() == "CSR" && nextStatus == "Completed")
			{
				this.emailService.SendComments(vm.LogDetail, vm.DetailsCoached, emailTempFileName, logoFileName);
			}

			return success;
		}

		private bool CompleteResearchPendingReview(ReviewViewModel vm, User user)
		{
			//@nvcFormID Nvarchar(50),
			//@nvcFormStatus Nvarchar(30),
			//@nvcstrReasonNotCoachable Nvarchar(100),
			//@nvcReviewerLanID Nvarchar(20),
			//@dtmReviewAutoDate datetime,
			//@dtmReviewManualDate datetime,
			//@bitisCoachingRequired bit,
			//@nvcReviewerNotes Nvarchar(max),
			//@nvctxtReasonNotCoachable Nvarchar(max)

			bool success = false;
			string nextStatus = string.Empty;

			long formId = vm.LogDetail.LogId;
			nextStatus = GetNextStatus(vm, user);
			DateTime reviewAutoDate = DateTime.Now;
			bool bitisCoachingRequired = vm.IsCoachingRequired;
			DateTime? dtmReviewManualDate = null;
			if (vm.LogStatusLevel != 2)
			{
				dtmReviewManualDate = vm.DateCoached;
			}

			if (bitisCoachingRequired)
			{
				nextStatus = GetNextStatus(vm, user); // TODO:
				string nvcReviewerNotes = vm.DetailReasonCoachable;
				if (vm.LogStatusLevel == 2)
				{
					nvcReviewerNotes = FormatCoachingNotes(vm);
				}
			}
			else
			{
				nextStatus = "Inactive";
				string nvcstrReasonNotCoachable = vm.MainReasonNotCoachable;

				if (vm.LogStatusLevel == 2)
				{
					string supName = vm.LogDetail.SupervisorName;
					string reassignedTo = vm.LogDetail.ReassignedSupervisorName;

					nvcstrReasonNotCoachable = FormatCoachingNotes(vm);
				}
			}


			//success = reviewRepository.CompleteResearchPendingReview(vm.LogDetail.LogId, nextStatus, user.EmployeeId, 
			//	isCoachRequired, reasonNotCoachable, reasonCoachable, reviewNotes, reviewDate);


			return true;

		}

		private string FormatCoachingNotes(ReviewViewModel vm)
		{
			string notes = string.Empty;
			string supName = vm.LogDetail.SupervisorName;
			string reassignedTo = vm.LogDetail.ReassignedSupervisorName;

			if (string.IsNullOrEmpty(reassignedTo) || reassignedTo == "NA")
			{
				notes += supName;
			}
			else
			{
				notes += reassignedTo;
			}

			notes += " (" + DateTime.Now + " PDT) - " + vm.DateCoached + " " + vm.DetailReasonNotCoachable;

			if (string.IsNullOrEmpty(vm.LogDetail.CoachingNotes))
			{
				return notes;
			}

			return vm.LogDetail.CoachingNotes + "<br />" + notes;
		}

		private string GetNextStatus(Review vm, User user)
		{
			string nextStatus = string.Empty;
			string moduleName = string.IsNullOrEmpty(vm.LogDetail.ModuleName) ? string.Empty : vm.LogDetail.ModuleName.Trim().ToLower();

			if (vm.IsAcknowledgeForm && vm.IsReinforceLog)
			{
				// TODO: check if the sp for detail will return module id
				// TODO: pass back status id instead of text
				if (vm.LogDetail.EmployeeId == user.EmployeeId)
				{
					if (moduleName == "csr" || moduleName == "training")
					{
						nextStatus = "Pending Supervisor Review";
					}
					else if (moduleName == "supervisor")
					{
						nextStatus = "Pending Manager Review";
					}
					else if (moduleName == "quality")
					{
						nextStatus = "Pending Quality Lead Review";
					}
					else
					{
						nextStatus = "Completed";
					}
				}
				else
				{
					if(vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT)
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

			if (vm.IsResearchPendingForm)
			{
				var log = vm.LogDetail;
				if(moduleName == "csr" || moduleName == "training")
				{
					if (log.IsCurrentCoachingInitiative || log.IsOmrException || log.IsLowCsat)
					{
						nextStatus = "Pending Supervisor Review";
					}
					else if (log.IsOmrIae || log.IsOmrIat || log.IsEtsOae || log.IsTrainingShortDuration || log.IsTrainingOverdue || log.IsBrl || log.IsBrn)
					{
						nextStatus = "Pending Employee Review";
					}
				}
				else if (moduleName == "supervisor")
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
				else if (moduleName == "quality")
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

			return nextStatus;
		}
	}
}
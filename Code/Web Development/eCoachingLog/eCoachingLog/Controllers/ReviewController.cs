using eCoachingLog.Filters;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	[SessionCheck]
	public class ReviewController : LogBaseController
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		private readonly IReviewService reviewService;

		public ReviewController(IReviewService reviewService, IEmployeeLogService employeeLogService) : base(employeeLogService)
		{
			logger.Debug("Entered ReviewController(IEmployeeLogService)");
			this.reviewService = reviewService;
		}

		// GET: Review
		public ActionResult Index(int logId, bool isCoaching)
        {
			logger.Debug("Entered Review.Index: logId=" + logId + ", isCoaching=" + isCoaching);
			Session["reviewLogId"] = logId;

			var user = GetUserFromSession();
			if (user == null)
			{
				logger.Error("User is NULL!!!!!!");
			}

			int currentPage = (int)Session["currentPage"];
			BaseLogDetail logDetail = empLogService.GetLogDetail(logId, isCoaching);
			// Get coaching reasons for this log
			logDetail.Reasons = empLogService.GetReasonsByLogId(logId, isCoaching);

			// Check if the user is authorized to view the log detail
			bool isAuthorizedToView = this.reviewService.IsAccessAllowed(currentPage, logDetail, isCoaching, user);
			if (!isAuthorizedToView)
			{
				ViewBag.LogName = logDetail.FormName;
				return PartialView("_Unauthorized");
			}

			try
			{
				var vm = Init(user, currentPage, logDetail, isCoaching);
				return PartialView(vm.ReviewPageName, vm);
			}
			catch (Exception ex)
			{
				var userId = user == null ? "usernull" : user.EmployeeId;
				StringBuilder msg = new StringBuilder("Failed to load detail: ");
				msg.Append("[")
					.Append(userId)
					.Append("] ")
					.Append("Log[")
					.Append(logId)
					.Append("]: ")
					.Append(ex.Message)
					.Append(Environment.NewLine)
					.Append(ex.StackTrace);
				logger.Warn(msg);

				return PartialView("_Error");
			}
        }

		private ReviewViewModel Init(User user, int currentPage, BaseLogDetail logDetail, bool isCoaching)
		{
			// TODO: check if QualityNOW (multiple scorecards per eCL log)

			
			// Review - Read Only 
			// User clicks a log on Historical Dashboard, My Dashboard/My Submitted, Survey, or the log is warning
			if (Constants.PAGE_HISTORICAL_DASHBOARD == currentPage
				|| Constants.PAGE_SURVEY == currentPage
				|| Constants.PAGE_MY_SUBMISSION == currentPage
				// Warning
				|| !isCoaching
				// Completed
				|| logDetail.StatusId == Constants.LOG_STATUS_COMPLETED)
			{
				var reviewVM = new ReviewViewModel();
				if (isCoaching)
				{
					reviewVM.LogDetail = (CoachingLogDetail)logDetail;
				}
				else
				{
					reviewVM.WarningLogDetail = (WarningLogDetail)logDetail;
				}

				reviewVM.ShowConfirmedCseText = ShowConfirmedCseText(reviewVM.LogDetail);
				reviewVM.ShowConfirmedNonCseText = ShowConfirmedNonCseText(reviewVM.LogDetail);
				reviewVM.ShowViewMgtNotes = reviewVM.ShowConfirmedCseText && !string.IsNullOrEmpty(reviewVM.LogDetail.MgrNotes);

				if (reviewVM.LogDetail.IsIqs && reviewVM.LogDetail.StatusId == Constants.LOG_STATUS_COMPLETED)
				{
					reviewVM.LogDetail.EmployeeReviewLabel = "Reviewed and acknowledged Quality Monitor on ";
					reviewVM.ShowViewSupReviewInfo = true;
				}
				else
				{
					reviewVM.LogDetail.EmployeeReviewLabel = "Reviewed and acknowledged Coaching on ";
				}

				reviewVM.ReviewPageName = isCoaching ? "_ViewCoachingLog" : "_ViewWarningLog";
				return reviewVM;
			}

			// Review - Editable
			var vm = new ReviewViewModel();
			vm.LogDetail = (CoachingLogDetail)logDetail;
			vm.LogStatusLevel = GetLogStatusLevel(vm.LogDetail.ModuleId, vm.LogDetail.StatusId);

			// Determine to show/hide Managers Notes and Coaching Notes
			DetermineMgrSupNotesVisibility(vm);
			// Static text (instruction text)
			vm.InstructionText = this.reviewService.GetInstructionText(vm, user);

			if (IsAcknowledgeForm(vm)) // Load Acknowledge partial
			{
				vm.CommentTextBoxLabel = Constants.ACK_COMMENT_TEXTBOX_LABEL;
				vm.IsAcknowledgeForm = true;
				vm.IsReinforceLog = IsReinforceLog(vm);
				vm.IsReviewForm = false;
				vm.IsReadOnly = IsReadOnly(vm, user); // Higher management view only;
				// OverTurned Appeal log
				vm.IsAckOverTurnedAppeal = IsAckOverTurnAppeal(vm);
				if (vm.IsAckOverTurnedAppeal)
				{
					vm.ShowCommentTextBox = true;
					vm.CommentTextBoxLabel = Constants.ACK_OTA_COMMENT_TEXTBOX_LABEL;
				}

				if (user.EmployeeId == vm.LogDetail.EmployeeId)
				{
					vm.IsAckOpportunityLog = IsAckOpportunityLog(vm);
					vm.ShowCommentTextBox = ShowCommentTextBox(vm);
					vm.ShowCommentDdl = ShowCommentDdl(vm);
					if (vm.ShowCommentDdl)
					{
						// Load dtt comment dropdown
						IList<string> dttReasons = this.reviewService.GetReasonsToSelect(vm.LogDetail);
						IEnumerable<SelectListItem> dttReasonSelectList = new SelectList(dttReasons);
						vm.EmployeeCommentsDdlList = dttReasonSelectList;
					}
				}
			}
			// Load Review partial
			else
			{
				// Not completed, display review instead of final.
				vm.IsReviewForm = true;

				// There are 3 types of review forms.
				// Default all to false.
				vm.IsResearchPendingForm = false;   // Research Form - determine if research is required
				vm.IsCsePendingForm = false;        // CSE Form - determine if it is CSE
				vm.IsRegularPendingForm = false;    // Regular Pending Form - neither research nor CSE needed

				vm.IsResearchPendingForm = IsResearchPendingForm(vm, user);
				if (!vm.IsResearchPendingForm) // Not Research Form
				{
					vm.IsCsePendingForm = IsCsePendingForm(vm, user);
					if (!vm.IsCsePendingForm)   // Not Research Form, not CSE Form, so this is regular pending review form
					{
						vm.IsRegularPendingForm = true;    // Regular Pending Form.
						vm.IsReadOnly = IsReadOnly(vm, user); // Higher management view only;
					} // end if (!vm.IsCsePendingForm)
					else // CSE Form
					{
						vm.IsReadOnly = IsReadOnly(vm, user); // Higher management view only;
						vm.InstructionText = Constants.REVIEW_CSE;
					}
				}
				else // Research
				{ 
					vm.IsReviewByManager = string.CompareOrdinal(Constants.USER_ROLE_MANAGER, user.Role) == 0;
					vm.IsReadOnly = IsReadOnly(vm, user); // Higher management view only;
														  // Uncoachable reason Dropdown
					IList<string> uncoachableReasons = this.reviewService.GetReasonsToSelect(vm.LogDetail);
					IEnumerable<SelectListItem> uncoachableReasonSelectList = new SelectList(uncoachableReasons);
					vm.MainReasonNotCoachableList = uncoachableReasonSelectList;
				} // end if (!vm.IsResearchPendingForm)
			} // end if (ShowAckPartial(vm))

			if (vm.IsReadOnly)
			{
				vm.ReviewPageName = isCoaching ? "_ViewCoachingLog" : "_ViewWarningLog";
			}
			else
			{
				vm.ReviewPageName = isCoaching ? "_ReviewCoachingHome" : "_ReviewWarningHome";
			}

			return vm;
		}

		[HttpPost]
		public ActionResult Save(ReviewViewModel vm)
		{
			logger.Debug("!!!!!!!!!!Entered Save");

			bool success = false;
			User user = GetUserFromSession();
			if (ModelState.IsValid)
			{
				try
				{
					// Update database
					string logoFileName = Server.MapPath("~/Content/Images/ecl-logo-small.png");
					string emailTempFileName = Server.MapPath("~/EmailTemplates/LogCompleted.html");
					int logIdInSession = (int) Session["reviewLogId"];
					// Pass logIdInSession to log error if for some reason web form not posted back.
					success = this.reviewService.CompleteReview(vm, user, emailTempFileName, logoFileName, logIdInSession);
				} 
				catch (Exception ex)
				{
					var userId = user == null ? "usernull" : user.EmployeeId;
					var logId = vm.LogDetail == null ? "logidnull" : vm.LogDetail.LogId.ToString();
					StringBuilder msg = new StringBuilder("Exception: ");
					msg.Append("[").Append(userId).Append("]")
						.Append("|Failed to update log [").Append(logId).Append("]: ")
						.Append(ex.Message)
						.Append(Environment.NewLine)
						.Append(ex.StackTrace);
					logger.Warn(msg);
				}

				return Json(new
				{
					success = success,
					successMsg = "The log [" + vm.LogDetail.LogId + "] has been successfully updated.",
					errorMsg = "Failed to update the log [" + vm.LogDetail.LogId + "]."
				});
			}

			// ModelState not valid
			// Display validation message
			return Json(new
			{
				success = false,
				valid = false,
				errors = ModelState
				.Where(x => x.Value.Errors.Count > 0)
				.ToDictionary(
					kvp => kvp.Key,
					kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).FirstOrDefault()
				),
				allfields = ModelState.Keys
			}
			);
		}

		private bool IsReadOnly(ReviewViewModel vm, User user)
		{
			bool readOnly = false;
			if (vm.IsRegularPendingForm)
			{
				// if Pending Supervisor Review - Only Supervisor or reassigned to can enter data on review page
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				{
					readOnly = user.EmployeeId != vm.LogDetail.SupervisorEmpId
						&& user.EmployeeId != vm.LogDetail.ReassignedToEmpId;
				}
				// if Pending Employee Review - Only Employee can enter data on review page
				else if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1)
				{
					readOnly = user.EmployeeId != vm.LogDetail.EmployeeId;
				}
				// All other statuses - managers and above VIEW ONLY - they don't enter data for Regular Pending form
				else
				{
					readOnly = true;
				}
			}
			else if (vm.IsAcknowledgeForm)
			{
				// Only Supervisor or reassigned to or employee can enter data on review page
				if (user.EmployeeId != vm.LogDetail.SupervisorEmpId
					&& user.EmployeeId != vm.LogDetail.ReassignedToEmpId
					&& user.EmployeeId != vm.LogDetail.EmployeeId)
				{
					readOnly = true;
				}
			}

			// No need to check research form and cse form.
			// Research Form and CSE Form display only for managers, so the form will be editable, which means readOnly is false
			return readOnly;
		}

		private bool IsResearchPendingForm(ReviewViewModel vm, User user)
		{
			bool retVal = false;
			var log = vm.LogDetail;

			if (user.EmployeeId == log.SupervisorEmpId || user.EmployeeId == log.ReassignedToEmpId)
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				{
					if (log.IsEtsOae || log.IsEtsOas || log.IsOmrIat || log.IsOmrIae || log.IsOmrIaef || log.IsTrainingShortDuration || log.IsTrainingOverdue || log.IsBrn || log.IsBrl)
					{
						return true;
					}
				}
			}
			
			if (user.EmployeeId == log.ManagerEmpId // User is current manager
					|| (log.IsLowCsat && user.EmployeeId == log.LogManagerEmpId) // Log is low csat and user was supervisor when log submitted
					|| (user.EmployeeId == log.ReassignedToEmpId)) // Log got reassigned to user
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3)
				{
					if (log.IsCurrentCoachingInitiative || log.IsOmrException || log.IsLowCsat)
					{
						retVal = true;
					}
				}
			}

			return retVal;
		}

		private bool IsCsePendingForm(ReviewViewModel vm, User user)
		{
			bool retVal = false;
			var log = vm.LogDetail;

			if (user.EmployeeId == log.ManagerEmpId
				|| (log.IsLowCsat && user.EmployeeId == log.LogManagerEmpId)
				|| (user.EmployeeId == log.ReassignedToEmpId))
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3)
				{
					if (!log.IsCurrentCoachingInitiative && !log.IsOmrException && !log.IsLowCsat)
					{
						retVal = true;
					}
				} // end if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3)
			}

			return retVal;
		}

		private void DetermineMgrSupNotesVisibility(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// Initialize both to false
			vm.ShowManagerNotes = false;
			vm.ShowCoachingNotes = false;

			// Case 1:
			// User is the current supervisor of the employee, OR
			// User is the person to whom this log was reassigned
			if (userEmployeeId == vm.LogDetail.SupervisorEmpId ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				// Display Coaching notes always, manager notes if not blank
				vm.ShowCoachingNotes = true;
				if (!string.IsNullOrEmpty(vm.LogDetail.MgrNotes))
				{
					vm.ShowManagerNotes = true;
				}


				return;
			}

			// Case 2:
			// User is the current manager of the employee, OR
			// User was the manager of the employee when the log was submitted and the log is low csat, OR
			// User is the person to whom this log was reassgined
			if (userEmployeeId == vm.LogDetail.ManagerEmpId ||
				(userEmployeeId == vm.LogDetail.LogManagerEmpId && vm.LogDetail.IsLowCsat) ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				// Display coaching notes always
				vm.ShowCoachingNotes = true;

				if (vm.LogStatusLevel != Constants.LOG_STATUS_LEVEL_3)
				{
					vm.ShowManagerNotes = true;
				}

				return;
			}

			// Case 3:
			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				// Display Coaching Notes
				// Display Manager Notes if not empty
				vm.ShowCoachingNotes = true;
				if (!string.IsNullOrEmpty(vm.LogDetail.MgrNotes))
				{
					vm.ShowManagerNotes = true;
				}

				return;
			}

			// Case 4:
			// User is the log submitter, AND
			// User is not the employee of the log, AND
			// User is not the current supervisor of the employee, AND
			// User is not the current manager of the employee
			if (userEmployeeId == vm.LogDetail.SubmitterEmpId &&
				userEmployeeId != vm.LogDetail.EmployeeId &&
				userEmployeeId != vm.LogDetail.SupervisorEmpId &&
				userEmployeeId != vm.LogDetail.ManagerEmpId)
			{
				vm.ShowManagerNotes = true;
				vm.ShowCoachingNotes = true;

				return;
			}

			return;
		}

		private bool IsAcknowledgeForm(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// Quality Lead: Acknowledge an OverTurned Appeal log
			if (vm.LogDetail.IsOta)
			{
				return (userEmployeeId == vm.LogDetail.SupervisorEmpId && 
					vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW);
			}

			// User is the employee
			// TODO: QualityNOW - CSR reviewing
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				return vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1 ||
					vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4;
			}

			// Higher management 
			if (userEmployeeId == vm.LogDetail.ManagerEmpId)
			{
				return vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4;
			}

			// User is the Supervisor of the employee
			if (userEmployeeId == vm.LogDetail.SupervisorEmpId ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				return ((vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2 && vm.LogDetail.HasEmpAcknowledged) ||
					vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4);
			}

			return false;
		}

		private bool ShowCseQuestion(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			if (userEmployeeId == vm.LogDetail.ManagerEmpId ||
				(userEmployeeId == vm.LogDetail.LogManagerEmpId && vm.LogDetail.IsLowCsat) ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3 && 
					!vm.LogDetail.IsCurrentCoachingInitiative &&
					!vm.LogDetail.IsOmrException &&
					!vm.LogDetail.IsLowCsat)
				{
					return true;
				}
			}

			return false;
		}

		private bool ShowIsCoachingRequiredQuestion(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// Case 1:
			// User is the current manager of the employee, OR
			// User was the manager of the employee when the log was submitted and the log is low csat, OR
			// User is the person to whom this log was reassgined
			if (userEmployeeId == vm.LogDetail.ManagerEmpId ||
				(userEmployeeId == vm.LogDetail.LogManagerEmpId && vm.LogDetail.IsLowCsat) ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				return vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3 && 
					(vm.LogDetail.IsCurrentCoachingInitiative ||
						vm.LogDetail.IsOmrException ||
						vm.LogDetail.IsLowCsat);
			}

			// Case 2:
			// User is the current supervisor of the employee, OR
			// User is the person to whom this log was reassigned
			if (userEmployeeId == vm.LogDetail.SupervisorEmpId ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				return vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2 &&
					(!vm.LogDetail.IsIqs &&
						!vm.LogDetail.IsCtc &&
						!vm.LogDetail.IsHigh5Club &&
						!vm.LogDetail.IsKudo &&
						!vm.LogDetail.IsAttendance &&
						!vm.LogDetail.IsScorecardMsr &&
						!vm.LogDetail.IsScorecardMsrs) &&
					(vm.LogDetail.IsEtsOae ||
						vm.LogDetail.IsEtsOas ||
						vm.LogDetail.IsOmrIae ||
						vm.LogDetail.IsOmrIaef ||
						vm.LogDetail.IsOmrIat ||
						vm.LogDetail.IsTrainingShortDuration ||
						vm.LogDetail.IsTrainingOverdue ||
						vm.LogDetail.IsBrn ||
						vm.LogDetail.IsBrl);
			}

			return false;
		}

		private bool IsAckOverTurnAppeal(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;
			return (vm.LogDetail.IsOta && 
				userEmployeeId == vm.LogDetail.SupervisorEmpId &&
				vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW);
		}

		private bool IsReinforceLog(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// User is the current supervisor of the employee, OR
			// User is the person to whom this log was reassigned
			if (userEmployeeId == vm.LogDetail.SupervisorEmpId ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				return (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2 && vm.LogDetail.HasEmpAcknowledged) ||
					(vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4);
			}

			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				// Pending Acknowledgement
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4) 
				{
					return true;
				}
				// Pending Employee Review
				else if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1)
				{
					return !IsAckOpportunityLog(vm);
				}
			}

			return false;
		}

		private bool IsAckOpportunityLog(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1)
				{
					return (string.IsNullOrEmpty(vm.LogDetail.SupReviewedAutoDate)) ||
						(!vm.LogDetail.IsIqs &&
							!vm.LogDetail.IsCtc &&
							!vm.LogDetail.IsHigh5Club &&
							!vm.LogDetail.IsKudo &&
							!vm.LogDetail.IsAttendance &&
							!vm.LogDetail.IsScorecardMsr &&
							!vm.LogDetail.IsScorecardMsrs);
				}
			}

			return false;
		}

		private bool ShowCommentTextBox(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				return (!vm.LogDetail.IsDtt 
					&& (IsAckOpportunityLog(vm) || IsReinforceLog(vm))
				);
			}

			return false;
		}

		private bool ShowCommentDdl(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				return (IsAckOpportunityLog(vm) && vm.LogDetail.IsDtt);
			}

			return false;
		}

		private bool ShowConfirmedCseText(CoachingLogDetail logDetail)
		{
			return logDetail.IsSubmittedAsCse.HasValue 
				&& logDetail.IsConfirmedCse.HasValue
				&& logDetail.IsConfirmedCse.Value;
		}

		private bool ShowConfirmedNonCseText(CoachingLogDetail logDetail)
		{
			return logDetail.IsSubmittedAsCse.HasValue 
				&& logDetail.IsConfirmedCse.HasValue
				&& !logDetail.IsConfirmedCse.Value;
		}
	}
}
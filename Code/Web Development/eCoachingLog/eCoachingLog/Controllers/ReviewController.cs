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

		public JsonResult InitShortCallBehaviors(bool isValid)
		{
			IList<Behavior> behaviorList = GetShortCallBehaviorListFromSessionOrDB(isValid);
			IEnumerable<SelectListItem> behaviors = new SelectList(behaviorList, "Id", "Text");
			JsonResult result = Json(behaviors);
			result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
			return result;
		}

		private IList<Behavior> GetShortCallBehaviorListFromSessionOrDB(bool isValid)
		{
			IList<Behavior> behaviorList = new List<Behavior>();
			if (isValid)
			{
				if (Session["validBehaviorList"] == null)
				{
					behaviorList = this.reviewService.GetShortCallBehaviorList(isValid);
					behaviorList.Insert(0, new Behavior { Id = -2, Text = "Select a behavior" });
					Session["validBehaviorList"] = behaviorList;
				}
				else
				{
					behaviorList = (IList<Behavior>)Session["validBehaviorList"];
				}
			}
			else
			{
				if (Session["invalidBehaviorList"] == null)
				{
					behaviorList = this.reviewService.GetShortCallBehaviorList(isValid);
					behaviorList.Insert(0, new Behavior { Id = -2, Text = "Select a behavior" });
					Session["invalidBehaviorList"] = behaviorList;
				}
				else
				{
					behaviorList = (IList<Behavior>)Session["invalidBehaviorList"];
				}
			}

			return behaviorList;
		}

		public JsonResult GetEclAction(long logId, string employeeId, int behaviorId, bool isValidBehavior)
		{
			var user = GetUserFromSession();
			var actions = this.reviewService.GetShortCallActions(employeeId, behaviorId);
			var eclAction = string.Empty;
			var eclActionToDisplay = string.Empty;
			foreach (string action in actions)
			{
				eclAction += string.IsNullOrEmpty(eclAction) ? action : "; " + action;
				eclActionToDisplay += string.IsNullOrEmpty(eclActionToDisplay) ? action : ";<br />" + action;
			}

			return Json(new
						{
							eclActionToDisplay = eclActionToDisplay,
							eclAction = eclAction
						}, JsonRequestBehavior.AllowGet
					);
		}

		[HttpPost]
		public ActionResult Save(ReviewViewModel vm)
		{
			logger.Debug("!!!!!!!!!!Entered Save");

			if (ModelState.IsValid)
			{
				bool success = false;
				User user = GetUserFromSession();
				string logId = null;

				if (vm.IsWarning)
				{
					logId = vm.WarningLogDetail == null ? "logidnull" : vm.WarningLogDetail.LogId.ToString();
				}
				else
				{
					logId = vm.LogDetail == null ? "logidnull" : vm.LogDetail.LogId.ToString();
				}

				try
				{
					// Update database
					string emailTempFileName = Server.MapPath("~/EmailTemplates/LogCompleted.html");
					int logIdInSession = (int)Session["reviewLogId"];
					// Pass logIdInSession to log error if for some reason web form not posted back.
					success = this.reviewService.CompleteReview(vm, user, emailTempFileName, logIdInSession);
				}
				catch (Exception ex)
				{
					var userId = user == null ? "usernull" : user.EmployeeId;
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
					successMsg = "The log [" + logId + "] has been successfully updated.",
					errorMsg = "Failed to update the log [" + logId + "]."
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
			});
		}

		private ReviewViewModel Init(User user, int currentPage, BaseLogDetail logDetail, bool isCoaching)
		{
			var vm = new ReviewViewModel();
			if (isCoaching)
			{
				vm.LogDetail = (CoachingLogDetail)logDetail;
				vm.ShowConfirmedCseText = ShowConfirmedCseText(vm.LogDetail);
				vm.ShowConfirmedNonCseText = ShowConfirmedNonCseText(vm.LogDetail);
			}
			else
			{
				vm.WarningLogDetail = (WarningLogDetail)logDetail;
				// User reviews warning log
				if (user.EmployeeId == logDetail.EmployeeId && logDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW)
				{
					vm.IsReadOnly = false;
					vm.IsWarning = true;
					vm.InstructionText = this.reviewService.GetInstructionText(vm, user);
					vm.ReviewPageName = "_ReviewWarningHome";

					return vm;
				}
			}

			vm.ShowEmployeeReviewInfo = true;

			if (vm.LogDetail.IsFollowupRequired)
			{
				vm.ShowFollowupInfo = ShowFollowupInfo(vm, currentPage);
				// Completed by Supervisor
				vm.IsFollowupCompleted = vm.LogDetail.IsFollowupRequired && !string.IsNullOrEmpty(vm.LogDetail.FollowupActualDate);
				// After completed by supervisor, CSR has acknowledged
				vm.IsFollowupAcknowledged = vm.LogDetail.IsFollowupRequired && !string.IsNullOrEmpty(vm.LogDetail.FollowupEmpAutoDate);
				vm.IsFollowupDue = IsFollowupDue(vm);
				vm.IsFollowupOverDue = IsFollowupOverDue(vm);
			}

			// Load short call list
			if (vm.LogDetail.IsOmrShortCall)
			{
				vm.ShowEmployeeReviewInfo = false;
				// check if status is completed
				if (vm.LogDetail.StatusId != Constants.LOG_STATUS_COMPLETED)
				{
					vm.ShortCallList = this.reviewService.GetShortCallEvalList(vm.LogDetail.LogId);
				}
				else
				{
					vm.ShortCallList = this.reviewService.GetShortCallCompletedEvalList(vm.LogDetail.LogId); // with mgr review info
				}

				// format actions for each short call
				foreach (var sc in vm.ShortCallList)
				{
					sc.ActionsString = sc.ActionsString.Replace(";", ";<br />");
				}
			}

			// User clicks a log on Historical Dashboard, My Dashboard/My Submitted, Survey, or the log is warning
			if (Constants.PAGE_HISTORICAL_DASHBOARD == currentPage
				|| Constants.PAGE_SURVEY == currentPage
				|| Constants.PAGE_MY_SUBMISSION == currentPage
				// Warning
				|| (!isCoaching)
				|| logDetail.StatusId == Constants.LOG_STATUS_COMPLETED) // Completed
			{
				vm.IsReadOnly = true;
				vm.ShowViewMgtNotes = !string.IsNullOrEmpty(vm.LogDetail.MgrNotes);
				if (vm.LogDetail.IsIqs && vm.LogDetail.StatusId == Constants.LOG_STATUS_COMPLETED)
				{
					vm.LogDetail.EmployeeReviewLabel = "Reviewed and acknowledged Quality Monitor on ";
					vm.ShowViewSupReviewInfo = true;
				}
				else
				{
					vm.LogDetail.EmployeeReviewLabel = "Reviewed and acknowledged Coaching on ";
				}

				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}

			vm.LogStatusLevel = GetLogStatusLevel(vm.LogDetail.ModuleId, vm.LogDetail.StatusId);
			DetermineMgrSupNotesVisibility(vm);
			vm.InstructionText = this.reviewService.GetInstructionText(vm, user);

			// Init Acknowledge partial
			if (IsAcknowledgeForm(vm))
			{
				vm.IsAcknowledgeForm = true;
				return InitAckForm(vm, user, isCoaching);
			}

			// If it reaches here, it must be Review Form
			return InitReviewForm(vm, user, isCoaching);
		}

		private ReviewViewModel InitAckForm(ReviewViewModel vm, User user, bool isCoaching)
		{
			vm.IsAcknowledgeForm = true;
			vm.IsReviewForm = false;

			vm.IsReadOnly = IsReadOnly(vm, user);
			vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
			// Not editable, send user to Read Only page
			if (vm.IsReadOnly)
			{
				return vm;
			}

			// Default
			vm.IsAckOverTurnedAppeal = false;
			vm.IsMoreReviewRequired = false;
			vm.ShowCommentTextBox = false;
			vm.ShowCommentDdl = false;

			vm.AckCheckboxTitle = Constants.ACK_CHECKBOX_TITLE_GENERAL;
			vm.AckCheckboxText = Constants.ACK_CHECKBOX_TEXT_GENERAL;

			// Editable Form, send user to Ack (editable Review) page
			// Acknowledge Checkbox setup
			if (IsAckOverTurnAppeal(vm))
			{
				vm.IsAckOverTurnedAppeal = true;
			}
			else if (IsMoreReviewRequired(vm))
			{
				vm.IsMoreReviewRequired = true;
			}

			if (IsFollowupPendingCsr(vm))
			{
				vm.IsFollowupPendingCsrForm = true;
				vm.IsAckOverTurnedAppeal = false;
				vm.IsMoreReviewRequired = false;
			}
			// Checkbox display text
			if (vm.IsAckOverTurnedAppeal)
			{
				vm.AckCheckboxTitle = Constants.ACK_CHECKBOX_TITLE_OVERTURNED_APPEAL;
				vm.AckCheckboxText = Constants.ACK_CHECKBOX_TEXT_OVERTURNED_APPEAL;
			}
			else if (vm.IsFollowupPendingCsrForm)
			{
				vm.AckCheckboxTitle = Constants.ACK_CHECKBOX_TITLE_FOLLOWUP;
				vm.AckCheckboxText = Constants.ACK_CHECKBOS_TEXT_FOLLOWUP;
			}
			else
			{
				if (user.EmployeeId == vm.LogDetail.SupervisorEmpId 
					|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId
					|| vm.IsMoreReviewRequired)
				{
					vm.AckCheckboxTitle = Constants.ACK_CHECKBOX_TITLE_MONITOR;
				}
			}

			// Comment Textbox or Dropdown setup
			if (vm.IsAckOverTurnedAppeal || user.EmployeeId == vm.LogDetail.EmployeeId)
			{
				// Default
				vm.ShowCommentTextBox = true;
				vm.CommentTextboxLabel = Constants.ACK_COMMENT_TEXTBOX_LABEL;

				// Quality Lead Ack OTA (OverTurned Appeals) log
				if (vm.IsAckOverTurnedAppeal)
				{
					vm.CommentTextboxLabel = Constants.ACK_OTA_COMMENT_TEXTBOX_LABEL;
				}
				// Employee Ack log
				else
				{
					// DTT (Discrepancy Time Tracking) log - Show dropdown instead of textbox
					// DTT logs are Opportunity, not Reinforcement
					if (vm.LogDetail.IsDtt)
					{
						vm.ShowCommentTextBox = false;
						vm.ShowCommentDdl = true;
						// Load dtt comment dropdown
						IList<string> dttReasons = this.reviewService.GetReasonsToSelect(vm.LogDetail);
						IEnumerable<SelectListItem> dttReasonSelectList = new SelectList(dttReasons);
						vm.EmployeeCommentsDdlList = dttReasonSelectList;
					} // end if (vm.LogDetail.IsDtt && vm.IsAckOpportunity)
				} // end if (vm.IsAckOverTurnedAppeal)
			} // end if (vm.IsAckOverTurnedAppeal || user.EmployeeId == vm.LogDetail.EmployeeId)

			return vm;
		}

		private ReviewViewModel InitReviewForm(ReviewViewModel vm, User user, bool isCoaching )
		{
			vm.IsReviewForm = true;
			vm.IsAcknowledgeForm = false;

			vm.IsResearchPendingForm = false;            // Research Form        - determine if research is required
			vm.IsCsePendingForm = false;                 // CSE Form             - determine if it is CSE
			vm.IsRegularPendingForm = false;             // Regular Pending Form - neither research nor CSE needed
			vm.IsShortCallPendingSupervisorForm = false; // Short Call Form      - Supervisor reviewing
			vm.IsShortCallPendingManagerForm = false;	 // Short Call Form      - Manager reviewing
			vm.IsFollowupPendingSupervisorForm = false;

			// Followup - Pending Supervisor Followup
			if (IsFollowupPendingSupervisor(vm))
			{
				vm.IsFollowupPendingSupervisorForm = true;
				vm.IsReadOnly = IsReadOnly(vm, user);
				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}

			// Short Call - Pending Manager Review Form
			if (IsShortCallPendingManager(vm))
			{
				vm.IsShortCallPendingManagerForm = true;
				vm.IsReadOnly = IsReadOnly(vm, user);
				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}

			// Short Call - Pending Supervisor Review Form
			if (IsShortCallPendingSupervisor(vm))
			{
				vm.IsShortCallPendingSupervisorForm = true;
				vm.IsReadOnly = IsReadOnly(vm, user);
				vm.ShortCallList = this.reviewService.GetShortCallList(vm.LogDetail.LogId);

				var behaviorList = GetShortCallBehaviorListFromSessionOrDB(false); // default to invalid
				// Load Behavior dropdown for each short call
				foreach (ShortCall sc in vm.ShortCallList)
				{
					sc.Behaviors = (List<Behavior>) behaviorList;
					sc.SelectListBehaviors = new SelectList(sc.Behaviors, "Id", "Text");
				}

				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}

			// Research Form
			if (IsResearchPendingForm(vm))
			{
				vm.IsResearchPendingForm = true;
				vm.IsReviewByManager = string.CompareOrdinal(Constants.USER_ROLE_MANAGER, user.Role) == 0;
				vm.IsReadOnly = IsReadOnly(vm, user);
				IList<string> uncoachableReasons = this.reviewService.GetReasonsToSelect(vm.LogDetail);
				IEnumerable<SelectListItem> uncoachableReasonSelectList = new SelectList(uncoachableReasons);
				vm.MainReasonNotCoachableList = uncoachableReasonSelectList;

				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}

			// CSE Form
			if (IsCsePendingForm(vm))
			{
				vm.IsCsePendingForm = true;
				vm.InstructionText = Constants.REVIEW_CSE;
				vm.IsReadOnly = IsReadOnly(vm, user);

				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}
			
			// Regular Pending Form.
			vm.IsRegularPendingForm = true;
			vm.IsReadOnly = IsReadOnly(vm, user);

			vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
			return vm;
		}

		private bool IsAcknowledgeForm(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;
			var isUserReassignedTo = userEmployeeId == vm.LogDetail.ReassignedToEmpId;

			// Quality Lead (or reassigned to): Acknowledge an OverTurned Appeal log
			if (vm.LogDetail.IsOta)
			{
				return (userEmployeeId == vm.LogDetail.SupervisorEmpId || isUserReassignedTo)
					&& vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW;
			}

			// User is the employee
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				return vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1    // LOG_STATUS_PENDING_EMPLOYEE_REVIEW OR LOG_STATUS_PENDING_EMPLOYEE_ACK_FOLLOWUP
					|| vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4;   // LOG_STATUS_PENDING_ACKNOWLEDGEMENT
			}

			// User is the Supervisor or reassigned to
			if (userEmployeeId == vm.LogDetail.SupervisorEmpId || isUserReassignedTo)
			{
				return
					// LOG_STATUS_PENDING_SUPERVISOR_REVIEW and Employee has acknowledged and followup not required
					(vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2 && vm.LogDetail.HasEmpAcknowledged && !vm.LogDetail.IsFollowupRequired)
					// LOG_STATUS_PENDING_ACKNOWLEDGEMENT	
					|| vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4;
			}

			// User is the Manager or reassigned to
			if (userEmployeeId == vm.LogDetail.ManagerEmpId || isUserReassignedTo)
			{
				return vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4;   // LOG_STATUS_PENDING_ACKNOWLEDGEMENT
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

		private bool IsMoreReviewRequired(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// Quality Bingo - Reinforcement
			if (vm.LogDetail.IsBqns || vm.LogDetail.IsBqm || vm.LogDetail.IsBqms)
			{
				// log comes in as Pending Ack
				// return true so that both sup and csr has an a chance to review
				return true;
			}

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
					//return !IsAckOpportunityLog(vm);
					if (!string.IsNullOrEmpty(vm.LogDetail.SupReviewedAutoDate)
							&& (vm.LogDetail.IsIqs
									|| vm.LogDetail.IsCtc
									|| vm.LogDetail.IsHigh5Club 
									|| vm.LogDetail.IsKudo 
									|| vm.LogDetail.IsAttendance 
									|| vm.LogDetail.IsMsr 
									|| vm.LogDetail.IsMsrs))
					{
						return true;
					}
				}
			}

			return false;
		}

		//private bool IsAckOpportunityLog(ReviewViewModel vm)
		//{
		//	var userEmployeeId = GetUserFromSession().EmployeeId;

		//	// User is the employee of the log
		//	if (userEmployeeId == vm.LogDetail.EmployeeId)
		//	{
		//		if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1)
		//		{
		//			return (string.IsNullOrEmpty(vm.LogDetail.SupReviewedAutoDate)) ||
		//				(!vm.LogDetail.IsIqs &&
		//					!vm.LogDetail.IsCtc &&
		//					!vm.LogDetail.IsHigh5Club &&
		//					!vm.LogDetail.IsKudo &&
		//					!vm.LogDetail.IsAttendance &&
		//					!vm.LogDetail.IsMsr &&
		//					!vm.LogDetail.IsMsrs);
		//		}
		//	}

		//	return false;
		//}

		//private bool IsReinforceLog(ReviewViewModel vm)
		//{
		//	bool retVal = true;
		//	var reasons = vm.LogDetail.Reasons;

		//	foreach (var reason in reasons)
		//	{
		//		if (reason.Value.IndexOf("opportunity", StringComparison.OrdinalIgnoreCase) >= 0 
		//			|| reason.Value.IndexOf("did not meet goal", StringComparison.OrdinalIgnoreCase) >= 0
		//			|| reason.Value.IndexOf("research required", StringComparison.OrdinalIgnoreCase) >= 0
		//			|| reason.Value.IndexOf("n/a", StringComparison.OrdinalIgnoreCase) >= 0)
		//		{
		//			retVal = false;
		//		}
		//	}
		//	return retVal;
		//}

		private bool IsFollowupPendingCsr(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;
			return (userEmployeeId == vm.LogDetail.EmployeeId
				&& vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW
				&& !string.IsNullOrEmpty(vm.LogDetail.FollowupActualDate)); 
		}

		private bool IsFollowupPendingSupervisor(ReviewViewModel vm)
		{
			return vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP;
		}
		private bool IsShortCallPendingManager(ReviewViewModel vm)
		{
			return vm.LogDetail.IsOmrShortCall && vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_MANAGER_REVIEW;
		}

		private bool IsShortCallPendingSupervisor(ReviewViewModel vm)
		{
			return vm.LogDetail.IsOmrShortCall && vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW;
		}

		private bool IsResearchPendingForm(ReviewViewModel vm)
		{
			bool retVal = false;
			var log = vm.LogDetail;

			// Use Reason[i].Value to determine if Research Required
			var reasons = log.Reasons;
			foreach (var reason in reasons)
			{
				if (string.Equals(reason.Value, "Research Required", StringComparison.OrdinalIgnoreCase)
					&& log.StatusId != Constants.LOG_STATUS_COMPLETED // Not Completed
					&& log.StatusId != Constants.LOG_STATUS_INACTIVE) // Not Inactive
				{
					retVal = true;
					break;
				}
			}

			return retVal;
		}

		private bool IsCsePendingForm(ReviewViewModel vm)
		{
			bool retVal = false;
			var log = vm.LogDetail;

			// Submitted as CSE, but has not been confirmed yet, which means still PENDING
			// and is not inactivated either - if inactive, the log will not display in Pending sections at all.
			if (log.IsSubmittedAsCse.HasValue
				&& log.IsSubmittedAsCse.Value
				&& !log.IsConfirmedCse.HasValue
				&& log.StatusId != Constants.LOG_STATUS_INACTIVE)
			{
				retVal = true;
			}

			return retVal;
		}

		private bool IsReadOnly(ReviewViewModel vm, User user)
		{
			bool readOnly = true;

			if (vm.IsFollowupPendingSupervisorForm)
			{
				if (user.EmployeeId == vm.LogDetail.SupervisorEmpId
					|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
				{
					readOnly = false;
				}
				return readOnly;
			}
			if (vm.IsShortCallPendingManagerForm)
			{
				if (user.EmployeeId == vm.LogDetail.ManagerEmpId
					|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
				{
					readOnly = false;
				}
				return readOnly;
			}

			if (vm.IsShortCallPendingSupervisorForm)
			{
				if (user.EmployeeId == vm.LogDetail.SupervisorEmpId
					|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
				{
					readOnly = false;
				}
				return readOnly;
			}

			// Only Managers can do the CSE form
			if (vm.IsCsePendingForm)
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3)
				{
					if(user.EmployeeId == vm.LogDetail.ManagerEmpId
						|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
					{
						readOnly = false;
					}
				}
				return readOnly;
			}

			// Either Supervisors or Managers can do the Reasearch form based on log Status
			if (vm.IsResearchPendingForm)
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				{
					if(user.EmployeeId == vm.LogDetail.SupervisorEmpId
						|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
					{
						readOnly = false;
					}
				}
				else if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3)
				{

					if ( user.EmployeeId == vm.LogDetail.ManagerEmpId
						|| (vm.LogDetail.IsLowCsat && user.EmployeeId == vm.LogDetail.LogManagerEmpId) // if low csat, the "then (when log submitted) manager can review too
						|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
					{
						readOnly = false;
					}
				}
				return readOnly;
			}

			if (vm.IsRegularPendingForm)
			{
				// if Pending Supervisor Review - Only Supervisor or reassigned to can enter data on review page
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				{
					if(user.EmployeeId == vm.LogDetail.SupervisorEmpId
						|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
					{
						readOnly = false;
					}
				}
				// if Pending Employee Review - Only Employee can enter data on review page
				else if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_1)
				{
					if (user.EmployeeId == vm.LogDetail.EmployeeId)
					{
						readOnly = false;
					}
				}
				return readOnly;
			}

			if (vm.IsAcknowledgeForm)
			{
				// Employee
				if (user.EmployeeId == vm.LogDetail.EmployeeId)
				{
					return false;
				}
				
				// Supervisor	
				if (user.EmployeeId == vm.LogDetail.SupervisorEmpId || user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
				{
					// Supervisor module and bingo: manager (supervisor's supervisor) can view only - TFS 15063, 15600
					if (vm.LogDetail.ModuleId == Constants.MODULE_SUPERVISOR 
							&& (vm.LogDetail.IsBqns || vm.LogDetail.IsBqm || vm.LogDetail.IsBqms))
					{
						readOnly = true;
					}
					else
					{
						readOnly = false;
					}
				}
			}

			return readOnly;
		}

		private string GetReviewPageName(bool isReadOnly, bool isCoaching)
		{
			if (isReadOnly)
			{
				return isCoaching ? "_ViewCoachingLog" : "_ViewWarningLog";
			}

			return isCoaching ? "_ReviewCoachingHome" : "_ReviewWarningHome";
		}

		private void DetermineMgrSupNotesVisibility(ReviewViewModel vm)
		{
			var user = GetUserFromSession();
			var userEmployeeId = user.EmployeeId;

			// Initialize both to false
			vm.ShowManagerNotes = false;
			vm.ShowCoachingNotes = false;

			if (IsShortCallPendingSupervisor(vm))
			{
				return;
			}

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
			// It's not short call pending Manager review, AND either one of the below:
			// User is the current manager of the employee, OR
			// User was the manager of the employee when the log was submitted and the log is low csat, OR
			// User is the person to whom this log was reassgined
			if (IsShortCallPendingManager(vm) && (userEmployeeId == vm.LogDetail.ManagerEmpId ||
				(userEmployeeId == vm.LogDetail.LogManagerEmpId && vm.LogDetail.IsLowCsat) ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId))
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

		private bool ShowCseQuestion(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			if (userEmployeeId == vm.LogDetail.ManagerEmpId ||
				(userEmployeeId == vm.LogDetail.LogManagerEmpId && vm.LogDetail.IsLowCsat) ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_3 
					&& vm.IsCsePendingForm)
				{
					return true;
				}
			}

			return false;
		}

		private bool ShowConfirmedCseText(CoachingLogDetail logDetail)
		{
			return logDetail.IsSubmittedAsCse.HasValue 
				&& logDetail.IsSubmittedAsCse.Value
				&& logDetail.IsConfirmedCse.HasValue
				&& logDetail.IsConfirmedCse.Value;
		}

		private bool ShowConfirmedNonCseText(CoachingLogDetail logDetail)
		{
			return logDetail.IsSubmittedAsCse.HasValue 
				&& logDetail.IsSubmittedAsCse.Value
				&& logDetail.IsConfirmedCse.HasValue
				&& !logDetail.IsConfirmedCse.Value;
		}

		private bool ShowFollowupInfo(ReviewViewModel vm, int currentPage)
		{
			var user = GetUserFromSession();

			if (vm.LogDetail.ModuleId != Constants.MODULE_CSR || !vm.LogDetail.IsFollowupRequired)
			{
				return false;
			}

			if (currentPage == Constants.PAGE_HISTORICAL_DASHBOARD)
			{
				return true;
			}

			if (user.Role != null && string.Equals(user.Role.Trim(), Constants.USER_ROLE_DIRECTOR, StringComparison.OrdinalIgnoreCase))
			{
				return true;
			}

			if (user.EmployeeId == vm.LogDetail.EmployeeId
				|| user.EmployeeId == vm.LogDetail.SupervisorEmpId
				|| user.EmployeeId == vm.LogDetail.ManagerEmpId
				|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				return true;
			}

			return false;
		}

		private bool IsFollowupDue (ReviewViewModel vm)
		{
			if (!string.Equals(vm.LogDetail.Status.Trim(), Constants.LOG_STATUS_PENDING_SUPERVISOR_FOLLOWUP_TEXT, StringComparison.OrdinalIgnoreCase))
			{
				return false;
			}

			var today = DateTime.Now;
			var followupDueDate = DateTime.Parse(vm.LogDetail.FollowupDueDate.Replace("PDT", ""));
			return today.Date == followupDueDate.Date ;
		}

		private bool IsFollowupOverDue (ReviewViewModel vm)
		{
			if (string.Equals(vm.LogDetail.Status.Trim(), Constants.LOG_STATUS_COMPLETED_TEXT, StringComparison.OrdinalIgnoreCase)
					// Followup has happened
					|| !string.IsNullOrEmpty(vm.LogDetail.FollowupActualDate))
			{
				return false;
			}

			var today = DateTime.Now;
			var followupDueDate = DateTime.Parse(vm.LogDetail.FollowupDueDate.Replace("PDT", ""));
			return today.Date > followupDueDate.Date;
		}
	}

}
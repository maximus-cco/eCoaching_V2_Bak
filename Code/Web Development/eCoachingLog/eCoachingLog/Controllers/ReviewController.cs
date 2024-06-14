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

        private static readonly Dictionary<int, string> CSR_PROMOTION_QUESTIONS = new Dictionary<int, string>
        {
            { 0, "--- Select ---" },
            { 1, "I am interested in gaining a promotion and will apply at the earliest opportunity" },
            { 2, "I am not interested in a promotion because I do not feel ready or qualified" },
            { 3, "I am not interested in a promotion because I am concerned about limited time off" },
            { 4, "I am not interested in a promotion because I am concerned about schedule options" },
            { 5, "I am not interested in a promotion because of a reason not listed in these options" },
            { 6, "I am interested in gaining a promotion but would like to discuss further with my supervisor" }
        };

        private readonly IReviewService reviewService;

		public ReviewController(IReviewService reviewService, IEmployeeLogService employeeLogService) : base(employeeLogService)
		{
			logger.Debug("Entered ReviewController(IEmployeeLogService)");
			this.reviewService = reviewService;
		}

		// GET: Review
		public ActionResult Index(int logId, bool isCoaching, string action)
        {
			logger.Debug("Entered Review.Index: logId=" + logId + ", isCoaching=" + isCoaching);
			Session["reviewLogId"] = logId;

			var user = GetUserFromSession();
			if (user == null)
			{
				logger.Error("User is NULL!!!!!!");
			}

			int currentPage = (int)Session["currentPage"];
            action = Constants.PAGE_HISTORICAL_DASHBOARD == currentPage || Constants.PAGE_SURVEY == currentPage ? "view" : action;

            string selectedReasonText = Session["SelectedReason"] == null ? null : (string)Session["SelectedReason"];
            string selectedSubReasonText = Session["SelectedSubReason"] == null ? null : (string)Session["SelectedSubReason"];

            BaseLogDetail logDetail = empLogService.GetLogDetail(logId, isCoaching);
            
			// Get coaching reasons for this log
			logDetail.Reasons = empLogService.GetReasonsByLogId(logId, isCoaching, selectedReasonText, selectedSubReasonText);
            try
			{
				var vm = Init(user, currentPage, logDetail, isCoaching, action);
                vm.Action = action;
                if (isCoaching)
                {
                    // further set QN fields
                    vm = SetQnProperties(vm, (CoachingLogDetail)logDetail, user);
                }
 
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

        private ReviewViewModel SetQnProperties(ReviewViewModel vm, CoachingLogDetail logDetail, User user)
        {
            if (!logDetail.IsQn && !logDetail.IsQnSupervisor)
            {
                return vm;
            }

            if (logDetail.IsQn)
            {
                return HandleQn(vm, logDetail, user);
            }

            // Qns
            vm.ShowEvalDetail = ShowQnEvalDetail(logDetail, vm.Action, GetUserFromSession());
 
            // Qns - view
            if (IsReadOnly(vm, user))
            {
                vm.IsReadOnly = true;
                vm.ReviewPageName = "_ViewCoachingLog";
                return vm;
            }

            // Qns - Coach
            if (vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW)
            {
                vm.IsRegularPendingForm = true;
                vm.ShowCoachingNotes = false;
                vm.ShowEmployeeReviewInfo = false;
                vm.ReviewPageName = "_QnsCoach";
            }
            // Qns - csr/isg review/ack
            else if (vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW)
            {
                vm.IsAcknowledgeForm = true;
                vm.ShowCoachingNotes = true;
            }

            return vm;
        }

        private ReviewViewModel HandleQn(ReviewViewModel vm, CoachingLogDetail logDetail, User user)
        {
            if (!logDetail.IsQn)
            {
                return vm;
            }

            vm.QnSummaryEditable = GetQnSummary(logDetail.QnSummaryList, false);
            vm.QnSummaryReadOnly = GetQnSummary(logDetail.QnSummaryList, true);

            var action = vm.Action;

            // Supervisor edit quality now log summary
            // My Pending Review - Prepare - add/edit log summary
            // My Pending Follow-up Coaching - Prepare - edit log summary
            if (String.Equals(action, "editSummary", StringComparison.OrdinalIgnoreCase))
            {
                vm.IsReadOnly = false;
                vm.AllowCopy = true;
                vm.ReviewPageName = "_QnEditLogSummary";
            }
            // Supervisor coach (csr/isg) quliaty now log
            // My Pending Review - Coach
            // My Pending Follow-up Coaching - Coach
            else if (String.Equals(action, "coach", StringComparison.OrdinalIgnoreCase))
            {
                vm.IsReadOnly = false;
                if (logDetail.IsQnSupervisor || logDetail.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW) // status id 6: first round coaching, not notes yet
                {
                    vm.ShowCoachingNotes = false;
                }

                if (logDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_COACHING)
                {
                    vm.ShowSupervisorReviewInfo = true;
                    vm.ShowEmployeeReviewInfo = true;
                }
                // first round coaching, neither supervisor nor csr/isg has reviewed yet.
                else
                {
                    vm.ShowSupervisorReviewInfo = false;
                    vm.ShowEmployeeReviewInfo = false;
                }

                vm.ReviewPageName = "_QnCoach";
            }
            // CSR/ISG "My Pending" - Review
            else if (String.Equals(action, "csrReview", StringComparison.OrdinalIgnoreCase))
            {
                vm.IsReadOnly = false;
                vm.ShowEvalSummary = true;
                vm.ShowCoachingNotes = true;
            }
            // supervisor has listened to additional call(s), comes here to decide if more coaching is needed.
            // My Pending Follow-up Preparation - Review
            else if (String.Equals(action, "followupReview", StringComparison.OrdinalIgnoreCase))
            {
                vm.IsReadOnly = false;
                vm.AllowCopy = true;
                vm.ShowEvalSummary = true;
                vm.ShowCoachingNotes = true;
                vm.ReviewPageName = "_QnFollowupReview";
            }
            //else if (String.Equals(action, "viewLinkedQnsInCoachingSession", StringComparison.OrdinalIgnoreCase)
            //        || String.Equals(action, "viewLinkedQns", StringComparison.OrdinalIgnoreCase)
            //        || String.Equals(action, "viewQnsToLink", StringComparison.OrdinalIgnoreCase))
            //{
            //    vm.IsReadOnly = true;
            //    vm.ShowEvalSummary = false; // supervisors do NOT enter summary for qns
            //    vm.ShowCoachingNotes = true;
            //    vm.ReviewPageName = "_QnFollowupView";
            //}
            else if (String.Equals(action, "view", StringComparison.OrdinalIgnoreCase))
            {
                vm.IsReadOnly = true;
                vm.ShowEvalSummary = true;
            }
            else if (String.Equals(action, "coach", StringComparison.OrdinalIgnoreCase))
            {
                if (logDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_COACHING)
                {
                    vm.ShowSupervisorReviewInfo = true;
                    vm.ShowEmployeeReviewInfo = true;
                }
                // first round coaching, neither supervisor nor csr/isg has reviewed yet.
                else
                {
                    vm.ShowSupervisorReviewInfo = false;
                    vm.ShowEmployeeReviewInfo = false;
                }
            }

            if (action == "view")
            {
                if (!logDetail.IsQnSupervisor 
                    && !user.IsCsr 
                    && !user.IsArc
                    && !user.IsIsg
                    && (vm.LogDetail.StatusId == Constants.LOG_STATUS_COMPLETED || vm.LogDetail.StatusId > Constants.LOG_STATUS_PENDING_FOLLOWUP_PREPARATION))
                {
                    vm.ShowFollowupDecisionComments = true;
                }
            }

            vm.ShowEvalDetail = ShowQnEvalDetail(logDetail, action, GetUserFromSession());

            // supervisor links followup log(s) to the original QN log
            if (logDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_PREPARATION)
            {
                if (user.IsSupervisor)
                {
                    vm.AdditionalActivityLogs = GetPotentialFollowupMonitorLogsQn(vm.LogDetail.LogId);
                }
            }
            // followup logs are linked to the original QN log, since the orginal QN log is completed or pending followup coaching/pending followup employee review
            else if (logDetail.StatusId > Constants.LOG_STATUS_PENDING_FOLLOWUP_PREPARATION || logDetail.StatusId == Constants.LOG_STATUS_COMPLETED)
            {
                vm.AdditionalActivityLogs = vm.LogDetail.LinkedLogs;
            }

            return vm;
        }

        private bool ShowQnEvalDetail(CoachingLogDetail logDetail, string action, User user)
        {
            // do not show detail to csr, arc, and isg
            if (user.IsCsr || user.IsArc || user.IsIsg)
            {
                return false;
            }

            var userEmployeeId = user.EmployeeId == null ? "" : user.EmployeeId.Trim().ToLower();
            var logEmployeeId = logDetail.EmployeeId == null ? "" : logDetail.EmployeeId.Trim().ToLower();

            // do not show detail to the employee of the log
            if (userEmployeeId == logEmployeeId)
            {
                return false;
            }

            if (user.IsSupervisor)
            {
                // My Pending: Coach - csr/isg is in coaching session with supervisor
                // My Pending Followup-up Coaching: Coach - supervisor views linked QNS log with CSR/ISG during follow up coaching session
                return (!String.Equals(action, "coach", StringComparison.OrdinalIgnoreCase) 
                    && !String.Equals(action, "viewLinkedQnsInCoachingSession", StringComparison.OrdinalIgnoreCase));
            }
            else // for all other users, show evaluation detail
            {
                return true;
            }
        }

        private string GetQnSummary(List<LogSummary> summaryList, bool isReadOnly)
        {
            if (summaryList == null || summaryList.Count < 1)
            {
                return string.Empty;
            }

            StringBuilder summary = new StringBuilder();           
            foreach (var s in summaryList)
            {
                if (isReadOnly)
                {
                    if (s.IsReadOnly)
                    {
                        var temp = summary.Length > 0 ? ". " : "";
                        summary.Append(temp).Append(s.Summary);
                    }
                }
                else
                {
                    if (!s.IsReadOnly)
                    {
                        var temp = summary.Length > 0 ? ". " : "";
                        summary.Append(temp).Append(s.Summary);
                    }
                }

             } // end foreach

            return summary.ToString();
        }

        private List<TextValue> GetPotentialFollowupMonitorLogsQn(long logId)
        {
            return reviewService.GetPotentialFollowupMonitorLogsQn(logId);
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
        public ActionResult SaveSummaryQn(long logId, string summary)
        {
            logger.Debug("Entered SaveSummaryQn");

            bool success = false;
            User user = GetUserFromSession();

            success = this.reviewService.SaveSummaryQn(logId, summary, user.LanId);
            return Json(new
            {
                success = success,
                successMsg = success ? "Log [" + logId + "] summary has been successfully saved." : "Failed to save log summary."
            });
        }

        [HttpPost]
        public ActionResult SubmitFollowupReviewQn(long logId, long[] linkedTo, bool isCoachingRequired, string comments)
        {
            if (logger.IsDebugEnabled)
            {
                logger.Debug("Entered SubmitFollowupReviewQn");
                logger.Debug("logId:" + logId);
                if (linkedTo != null)
                {
                    for (int i = 0; i < linkedTo.Length; i++)
                        logger.Debug("linkedTo[" + i + "]:" + linkedTo[i]);
                } else
                {
                    logger.Debug("linkedTo is null!");
                }
                logger.Debug("isCoachingRequired:" + isCoachingRequired);
                logger.Debug("comments:" + comments);
            }

            bool success = false;
            User user = GetUserFromSession();
            success = this.reviewService.SaveFollowupDecisionQn(logId, linkedTo, isCoachingRequired, comments, user.LanId);
            return Json(new
            {
                success = success,
                successMsg = success ? "Log [" + logId + "] has been successfully updated." : "Failed to update log [" + logId + "]."
            });
        }


        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Save(ReviewViewModel vm)
		{
			logger.Debug("!!!!!!!!!!Entered Save");

			if (ModelState.IsValid)
			{
				bool success = false;
				User user = GetUserFromSession();
				string logId = null;
				string emailTempFileName = "";

				if (vm.IsWarning)
				{
					logId = vm.WarningLogDetail == null ? "logidnull" : vm.WarningLogDetail.LogId.ToString();
					emailTempFileName = Server.MapPath("~/EmailTemplates/WarningLogCompleted.html");
				}
				else
				{
					logId = vm.LogDetail == null ? "logidnull" : vm.LogDetail.LogId.ToString();
					emailTempFileName = Server.MapPath("~/EmailTemplates/CoachingLogCompleted.html");
				}

				try
				{
                    //if (vm.LogDetail.IsQualityNowLog)
                    //{
                    //    // set followup due date: today + 7 days (this is the first round followup due date)
                    //    //vm.Followup7DayDueDate
                    //}
					// Update database
					int logIdInSession = (int)Session["reviewLogId"];
                    if (ShowCsrPromotionQuestion(vm, user))
                    {
                        // capture what csr has selected
                        vm.CsrPromotionTextSelected = CSR_PROMOTION_QUESTIONS[vm.CsrPromotionValueSelected];
                    }
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
					successMsg = "Log [" + logId + "] has been successfully updated.",
					errorMsg = "Failed to update log [" + logId + "]."
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

		private ReviewViewModel Init(User user, int currentPage, BaseLogDetail logDetail, bool isCoaching, string action)
		{
			var vm = new ReviewViewModel();
            vm.Action = action;
            vm.LogStatusLevel = GetLogStatusLevel(logDetail.ModuleId, logDetail.StatusId);
            if (isCoaching)
			{
				vm.LogDetail = (CoachingLogDetail)logDetail;
                vm.ShowConfirmedCseText = ShowConfirmedCseText(vm.LogDetail);
                vm.ShowConfirmedNonCseText = ShowConfirmedNonCseText(vm.LogDetail);
                vm.AdditionalText = this.reviewService.GetAdditionalText(vm, user);
            }
			else
			{
				vm.WarningLogDetail = (WarningLogDetail)logDetail;
				vm.IsWarning = true;
				vm.AdditionalText = logDetail.AdditionalText;
				// User reviews warning log
				if (user.EmployeeId == logDetail.EmployeeId && logDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW)
				{
					vm.IsReadOnly = false;
					vm.ReviewPageName = "_ReviewWarningHome";

					return vm;
				}
			}

            vm.ShowPfdDate = ShowPfdDate(vm);
            vm.ShowEmployeeReviewInfo = true;

			if (vm.LogDetail.IsFollowupRequired)
			{
				vm.ShowFollowupInfo = ShowFollowupInfo(vm, currentPage);
				// Completed by Supervisor
				vm.IsFollowupCompleted = vm.LogDetail.IsFollowupRequired && !string.IsNullOrEmpty(vm.LogDetail.FollowupActualDate);
				// After completed by supervisor, CSR/ISG has acknowledged
				vm.IsFollowupAcknowledged = vm.LogDetail.IsFollowupRequired && !string.IsNullOrEmpty(vm.LogDetail.FollowupEmpAutoDate);
				vm.IsFollowupDue = IsFollowupDue(vm);
				vm.IsFollowupOverDue = IsFollowupOverDue(vm);
			}

            if (user.IsSupervisor)
            {
                vm.ShowFollowupReminder = true;
            }
            else
            {
                // do nothing
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

			// User clicks a log on Historical Dashboard, My Dashboard/My Submitted, Survey, or the log is warning, or log is completed
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

			DetermineMgrSupNotesVisibility(vm);

            // Init Acknowledge partial
            if ((String.IsNullOrEmpty(action) || (action != "viewQnsToLink") && action != "view") && IsAcknowledgeForm(vm))
            {
				vm.IsAcknowledgeForm = true;
				return InitAckForm(vm, user, isCoaching);
			}

			// If it reaches here, it must be Review Form
			return InitReviewForm(vm, user, isCoaching);
		}

        private bool ShowPfdDate(ReviewViewModel vm)
        {
            var show = false;
            var reasons = vm.LogDetail.Reasons;
            foreach (var r in reasons)
            {
                if (r.Description == Constants.COACHING_REASON_PFD) // pfd reason
                {
                    show = true;
                    break;
                }
            }
            return show;
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

            if (ShowCsrPromotionQuestion(vm, user))
            { 
                vm.ShowCsrPromotionQuestion = true;
                vm.CsrPromotionQuestions = new SelectList(CSR_PROMOTION_QUESTIONS.OrderBy(x => x.Key), "Key", "Value");
            }

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

        private bool ShowCsrPromotionQuestion(ReviewViewModel vm, User user)
        {
            return 
                vm.LogDetail.IsCpath
                && user.EmployeeId == vm.LogDetail.EmployeeId
                && !vm.LogDetail.HasEmpAcknowledged // this is the first round coaching, csr has not selected an answer yet
                && vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW;
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

            if (vm.LogDetail.IsCpath
                    && (user.EmployeeId == vm.LogDetail.SupervisorEmpId || user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
                    && vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW)
            {
                vm.ShowFollowupCoaching = true;
            }

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
				vm.IsReviewByManager = String.Equals(Constants.USER_ROLE_MANAGER, user.Role, StringComparison.OrdinalIgnoreCase);
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
				vm.AdditionalText = Constants.REVIEW_CSE;
				vm.IsReadOnly = IsReadOnly(vm, user);

				vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
				return vm;
			}
			
            // Qn - 1st round is done (6->4->11); just waiting for a new log to open (listening to more calls),
            // when the new log is done, close the original one (status 11)
            if (IsQnPendingMoreCalls(vm))
            {
                vm.IsReadOnly = true;
                vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
            }

			// Regular Pending Form.
			vm.IsRegularPendingForm = true;
			vm.IsReadOnly = IsReadOnly(vm, user);
			vm.ReviewPageName = GetReviewPageName(vm.IsReadOnly, isCoaching);
			return vm;
		}

        private bool IsQnPendingMoreCalls(ReviewViewModel vm)
        {
            return vm.LogDetail.IsQn && vm.LogDetail.StatusId == 11;
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
				// return true so that both sup and csr/isg has an a chance to review
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

        // Pending follow-up CSR/ISG (Employee) review
        private bool IsFollowupPendingCsr(ReviewViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;
            if (userEmployeeId == vm.LogDetail.EmployeeId 
                && vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW)
            {
                return true;
            }

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
            // HR and Director do NOT coach, so display as read only.
            if (user.IsDirector || user.IsHr)
            {
                return true;
            }

            var action = vm.Action;
            if (action == "view" || action == "viewQnsToLink" || action == "viewLinkedQns" || action == "viewLinkedQnsInCoachingSession") // view only
            {
                return true;
            }

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

					if ( (user.EmployeeId == vm.LogDetail.ManagerEmpId && !vm.LogDetail.IsLowCsat)
                        || (vm.LogDetail.IsLowCsat && user.EmployeeId == vm.LogDetail.LogManagerEmpId) // if low csat, the "then (when log submitted) manager should review
						|| user.EmployeeId == vm.LogDetail.ReassignedToEmpId)
					{
						readOnly = false;
					}
				}
				return readOnly;
			}

			if (vm.IsRegularPendingForm)
			{
				// CSR/ISG module (log was submitted for a CSR/ISG) - if Pending Supervisor Review - Only Supervisor or reassigned to can enter data on review page
                // Supervisor module (log was submitted for a supervisor) - if Pending Manager Review - Only Manager or reassigned to can enter data on review page
				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				{
                    // for supervisor module, SupervisorEmpId is actually manager id since manager is the supervisor for whome this log was submitted
                    if (user.EmployeeId == vm.LogDetail.SupervisorEmpId
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
            if (vm.LogDetail.IsQn)
            {
                return vm.LogDetail.IsFollowupRequired && (
                            vm.LogDetail.StatusId == Constants.LOG_STATUS_COMPLETED ||
                            vm.LogDetail.StatusId == Constants.LOG_STATUS_PENDING_FOLLOWUP_EMPLOYEE_REVIEW
                       );
            }

			var user = GetUserFromSession();

			if ((vm.LogDetail.ModuleId != Constants.MODULE_CSR && vm.LogDetail.ModuleId != Constants.MODULE_ISG)
                    || !vm.LogDetail.IsFollowupRequired)
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
			var followupDueDate = DateTime.Parse(vm.LogDetail.FollowupDueDate.Replace(Constants.TIMEZONE, ""));
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

            if (String.IsNullOrEmpty(vm.LogDetail.FollowupDueDate))
            {
                return false;
            }

			var today = DateTime.Now;
			var followupDueDate = DateTime.Parse(vm.LogDetail.FollowupDueDate.Replace(Constants.TIMEZONE, ""));
			return today.Date > followupDueDate.Date;
		}
	}

}
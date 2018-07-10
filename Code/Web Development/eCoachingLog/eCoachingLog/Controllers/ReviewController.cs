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
			if (User == null)
			{
				logger.Debug("User is NULL!!!!!");
			}

			var user = GetUserFromSession();
			int currentPage = (int)Session["currentPage"];
			BaseLogDetail logDetail = empLogService.GetLogDetail(logId, isCoaching);

			// Check if the user is authorized to view the log detail
			bool isAuthorizedToView = this.reviewService.IsAccessAllowed(currentPage, logDetail, isCoaching, user);
			if (!isAuthorizedToView)
			{
				ViewBag.LogName = logDetail.FormName;
				return PartialView("_Unauthorized");
			}

			// Get coaching reasons for this log
			logDetail.Reasons = empLogService.GetReasonsByLogId(logId, isCoaching);

			// View only if user clicks a log on Historical Dashboard, My Dashboard/My Submitted, Survey, or the log is warning
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

				reviewVM.ShowViewCseText = reviewVM.IsCseUnconfirmed && (reviewVM.IsCse.HasValue && reviewVM.IsCse.Value);
				reviewVM.ShowViewMgtNotes = reviewVM.ShowViewCseText && !string.IsNullOrEmpty(reviewVM.LogDetail.MgrNotes);

				if (reviewVM.LogDetail.IsIqs && reviewVM.LogDetail.StatusId == Constants.LOG_STATUS_COMPLETED)
				{
					reviewVM.LogDetail.EmployeeReviewLabel = "Reviewed and acknowledged Quality Monitor on ";
					reviewVM.ShowViewSupReviewInfo = true;
				}
				else
				{
					reviewVM.LogDetail.EmployeeReviewLabel = "Reviewed and acknowledged Coaching on ";
				}

				if (isCoaching)
				{
					return PartialView("_ViewCoachingLog", reviewVM);
				}
				else
				{
					return PartialView("_ViewWarningLog", reviewVM);
				}
			}

			var vm = new ReviewViewModel();
			vm.LogDetail = (CoachingLogDetail)logDetail;
			vm.LogStatusLevel = GetLogStatusLevel(vm.LogDetail.ModuleId, vm.LogDetail.StatusId);

			// Determine to show/hide Managers Notes and Coaching Notes
			DetermineMgrSupNotesVisibility(vm);
			// Static text (instruction text)
			vm.InstructionText = this.reviewService.GetInstructionText(vm, user);

			if (IsAcknowledgeForm(vm)) // Load Acknowledge partial
			{
				vm.IsAcknowledgeForm = true;
				vm.IsReinforceLog = IsReinforceLog(vm);
				vm.IsReviewForm = false;
				vm.IsReadOnly = IsReadOnly(vm, user); // Higher management view only;

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
				vm.IsResearchPendingForm = false;	// Research Form - determine if research is required
				vm.IsCsePendingForm = false;		// CSE Form - determine if it is CSE
				vm.IsRegularPendingForm = false;	// Regular Pending Form - neither research nor CSE needed

				vm.IsResearchPendingForm = IsResearchPendingForm(vm, user);
				if (!vm.IsResearchPendingForm) // Not Research Form
				{
					vm.IsCsePendingForm = IsCsePendingForm(vm, user);
					if (!vm.IsCsePendingForm)	// Not Research Form, not CSE Form, so this is regular pending review form
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

			if (!isCoaching)
			{
				return PartialView("_ReviewWarningHome", vm);
			}

			return PartialView("_ReviewCoachingHome", vm);
        }

		[HttpPost]
		public ActionResult Save(ReviewViewModel vm)
		{
			bool success = false;
			User user = GetUserFromSession();
			if (ModelState.IsValid)
			{
				try
				{
					// Update database
					string logoFileName = Server.MapPath("~/Content/Images/ecl-logo-small.png");
					string emailTempFileName = Server.MapPath("~/EmailTemplates/LogCompleted.html");
					success = this.reviewService.CompleteReview(vm, user, emailTempFileName, logoFileName);
				} 
				catch (Exception ex)
				{
					logger.Error(string.Format("Failed to update log [{0}].", vm.LogDetail.LogId));
					logger.Error(ex.Message);
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
				// Only Supervisor or reassigned to can enter data on review page
				if (user.EmployeeId != vm.LogDetail.SupervisorEmpId 
					&& user.EmployeeId != vm.LogDetail.ReassignedToEmpId)
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
				if (vm.LogStatusLevel == 2)
				{
					if (log.IsEtsOae || log.IsEtsOas || log.IsOmrIat || log.IsOmrIae || log.IsOmrIaef || log.IsTrainingShortDuration || log.IsTrainingOverdue || log.IsBrn || log.IsBrl)
					{
						retVal = true;
					}
				}
			}
			else
			if (user.EmployeeId == log.ManagerEmpId // User is current manager
					|| (log.IsLowCsat && user.EmployeeId == log.LogManagerEmpId) // Log is low csat and user was supervisor when log submitted
					|| (user.EmployeeId == log.ReassignedToEmpId)) // Log got reassigned to user
			{
				if (vm.LogStatusLevel == 3)
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
				if (vm.LogStatusLevel == 3)
				{
					if (!log.IsCurrentCoachingInitiative && !log.IsOmrException && !log.IsLowCsat)
					{
						retVal = true;
					}
				} // end if (vm.LogStatusLevel == 3)
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

				//if ((vm.LogDetail.IsCoachingRequired || vm.LogDetail.IsCse)&& !string.IsNullOrEmpty(vm.LogDetail.MgrNotes))
				//{
				//	vm.ShowManagerNotes = true;
				//}

				//if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				//{
				//	vm.ShowCoachingNotes = vm.LogDetail.IsIqs ||
				//		vm.LogDetail.IsCtc ||
				//		vm.LogDetail.IsHigh5Club ||
				//		vm.LogDetail.IsKudo ||
				//		vm.LogDetail.IsAttendance ||
				//		vm.LogDetail.IsScorecardMsr ||
				//		vm.LogDetail.IsScorecardMsrs;
				//}
				//else
				//{
				//	vm.ShowCoachingNotes = true;
				//}

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

			// User is the Supervisor of the employee
			if (userEmployeeId == vm.LogDetail.SupervisorEmpId ||
				userEmployeeId == vm.LogDetail.ReassignedToEmpId)
			{
				return ((vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2 && vm.LogDetail.HasEmpAcknowledged) ||
					vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_4);
			}

			// User is the employee
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

		private bool ShowViewCseText(ReviewViewModel vm)
		{
			return vm.IsCseUnconfirmed && (vm.IsCse.HasValue && vm.IsCse.Value);
		}
	}
}
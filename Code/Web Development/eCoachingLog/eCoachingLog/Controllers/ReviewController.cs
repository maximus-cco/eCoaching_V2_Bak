using eCoachingLog.Models.Common;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System.Linq;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{

	public class ReviewController : LogBaseController
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		public ReviewController(IEmployeeLogService employeeLogService) : base(employeeLogService)
		{
			logger.Debug("Entered ReviewController(IEmployeeLogService)");
		}

		// GET: Review
		public ActionResult Index(int logId, bool isCoaching)
        {
			int currentPage = (int) Session["currentPage"];
			BaseLogDetail logDetail = empLogService.GetLogDetail(logId, isCoaching);

			// Check if the user is authorized to view the log detail
			bool isAuthorizedToView = IsAuthorizedToView(currentPage, logDetail, isCoaching);
			if (!isAuthorizedToView)
			{
				ViewBag.LogName = logDetail.FormName;
				return PartialView("_Unauthorized");
			}

			// Get coaching reasons for this log
			logDetail.Reasons = empLogService.GetReasonsByLogId(logId, isCoaching);

			// View only if user clicks a log on Historical Dashboard
			if (Constants.PAGE_HISTORICAL_DASHBOARD == currentPage || Constants.PAGE_SURVEY == currentPage)
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

				reviewVM.ShowViewCseText = reviewVM.IsCseUnconfirmed && reviewVM.IsCse;
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

			var vm = new AcknowledgeViewModel();
			vm.LogDetail = (CoachingLogDetail)logDetail;

			var user = GetUserFromSession();
			// TODO: get user data from db
			user.EmployeeId = "222222";
			vm.LogDetail.SupervisorEmpId = "222222";
			vm.LogDetail.ModuleId = 1;

			vm.LogStatusLevel = 2; // GetLogStatusLevel(vm.LogDetail.ModuleId, vm.LogDetail.StatusId);

			// TODO: put instruction text (ie the static text) in db
			vm.InstructionText = "You are receiving this eCL record because an Employee on your team was identified in an Outlier Management Report (OMR). Please research this item in accordance with the latest <a href='https://cco.gdit.com/Resources/SOP/Contact Center Operations/Forms/AllItems.aspx' target='_blank'>" +
					"Contact Center Operations 46.0 Outlier Management Report(OMR): Outlier Research Process SOP</a> and provide the details in the record below.";
			// Determine to show/hide Managers Notes and Coaching Notes
			DetermineMgrSupNotesVisibility(vm);

			if (ShowAckPartial(vm)) // Load Acknowledge partial
			{
				vm.ShowAcknowledgePartial = false;
				vm.ShowReviewCoachingPartial = false;
				vm.ShowReviewCoachingFinalPartial = true;
				//vm.CommentSelectList = new SelectList<>();

				vm.ShowAckMontitor = ShowAckMonitor(vm);

				if (user.EmployeeId == vm.LogDetail.EmployeeId)
				{
					vm.ShowAckOpportunity = ShowAckOpportunity(vm);
					vm.ShowCommentTextBox = ShowCommentTextBox(vm);
					vm.ShowCommentDdl = ShowCommentDdl(vm);
				}
			}
			// Load Review partial
			else
			{
				// TODO: write functions to determine
				vm.ShowReviewCoachingResearch = false;
				vm.ShowReviewCoachingCse = false;
				vm.ShowReviewCoachingPending = false;

				// TODO: check status, if completed
				//vm.LogDetail.Status = "Completed";
				//if (vm.LogDetail.Status == "Completed")
				var status = (string)Session["CurrentViewLogStatus"];
				// TODO: Check current log status, what about submission? 
				if (status == "Completed" || status == "Submission")
				{
					vm.ShowReviewCoachingFinalPartial = true;
				}
				else
				{
					vm.ShowReviewCoachingPartial = true;
					//vm.ShowReviewCoachingPending = true;
					vm.ShowReviewCoachingResearch = true;
				}
			}

			if (!isCoaching)
			{
				return PartialView("_ReviewWarningHome", vm);
			}

			return PartialView("_ReviewCoachingHome", vm);
        }

		private bool IsAuthorizedToView(int currentPage, BaseLogDetail logDetail, bool isCoaching)
		{
			var user = GetUserFromSession();
			var userJobCode = user.JobCode == null ? string.Empty : user.JobCode.ToUpper();
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

		[HttpPost]
		public ActionResult Save(ReviewViewModel vm)
		{
			bool success = true;
			if (ModelState.IsValid)
			{
				// Update database

				// TODO: remove
				Session["review"] = "review";

				// TODO: don't hard code 11
				// If success, then count = count - 1
				return Json(new { success = success, count = 11 });
			}

			// ModelState not valid
			return Json(new { success = false,
							  valid = false,
							  errors = ModelState
									   .Where(x => x.Value.Errors.Count > 0)
									   .ToDictionary(
											kvp => kvp.Key,
											kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).FirstOrDefault()
									   ),
						      allfields = ModelState.Keys }
					);
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
				if (vm.LogDetail.IsCoachingRequired && string.IsNullOrEmpty(vm.LogDetail.MgrNotes))
				{
					vm.ShowManagerNotes = true;
				}

				if (vm.LogStatusLevel == Constants.LOG_STATUS_LEVEL_2)
				{
					vm.ShowCoachingNotes = vm.LogDetail.IsIqs ||
						vm.LogDetail.IsCtc ||
						vm.LogDetail.IsHigh5Club ||
						vm.LogDetail.IsKudo ||
						vm.LogDetail.IsAttendance ||
						vm.LogDetail.IsScorecardMsr ||
						vm.LogDetail.IsScorecardMsrs;
				}
				else
				{
					vm.ShowCoachingNotes = true;
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
				if (vm.LogStatusLevel != Constants.LOG_STATUS_LEVEL_3)
				{
					vm.ShowManagerNotes = true;
					vm.ShowCoachingNotes = true;
				}

				return;
			}

			// Case 3:
			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				// Display Coaching Notes only
				vm.ShowCoachingNotes = true;

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

		private bool ShowAckPartial(AcknowledgeViewModel vm)
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
						vm.LogDetail.IsOmrIat ||
						vm.LogDetail.IsTrainingShortDuration ||
						vm.LogDetail.IsTrainingOverdue ||
						vm.LogDetail.IsBrn ||
						vm.LogDetail.IsBrl);
			}

			return false;
		}

		private bool ShowAckMonitor(AcknowledgeViewModel vm)
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
					return !ShowAckOpportunity(vm);
				}
			}

			return false;
		}

		private bool ShowAckOpportunity(AcknowledgeViewModel vm)
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

		private bool ShowCommentTextBox(AcknowledgeViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				return (ShowAckOpportunity(vm) || ShowAckMonitor(vm));
			}

			return false;
		}

		private bool ShowCommentDdl(AcknowledgeViewModel vm)
		{
			var userEmployeeId = GetUserFromSession().EmployeeId;

			// User is the employee of the log
			if (userEmployeeId == vm.LogDetail.EmployeeId)
			{
				return (ShowAckOpportunity(vm) && vm.LogDetail.IsDtt);
			}

			return false;
		}

		private bool ShowViewCseText(ReviewViewModel vm)
		{
			return vm.IsCseUnconfirmed && vm.IsCse;
		}
	}
}
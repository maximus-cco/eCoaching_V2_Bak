using eCoachingLog.Models.Survey;
using eCoachingLog.Models.User;
using eCoachingLog.Services;
using eCoachingLog.Utils;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
	public class SurveyController : LogBaseController
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		private ISurveyService surveyService;
		private IUserService userService;

		public SurveyController(ISurveyService surveyService, IUserService userService, IEmployeeLogService empLogService) : base(empLogService)
		{
			logger.Debug("Entered SurveyController(ISurveyService, IEmployeeLogService)");
			this.surveyService = surveyService;
			this.userService = userService;
		}

		// GET: Suvey
		public ActionResult Index()
        {
			if (ShowMaintenancePage())
			{
				return new FilePathResult(System.Web.Hosting.HostingEnvironment.MapPath(Constants.MAINTENANCE_PAGE), "text/html");
			}

			string userLanId = User.Identity.Name;
			userLanId = userLanId.Replace(@"AD\", "");
			User user = this.userService.GetUserByLanId(userLanId);
			if (user == null)
			{
				return RedirectToAction("Index", "Unauthorized");
			}

			Session["AuthenticatedUser"] = user;

			var surveyId = Convert.ToInt64(Request.QueryString["id"]);
			Survey survey = this.surveyService.GetSurvey(surveyId);
			bool isSurveyValid = true;
			if (user.EmployeeId != survey.EmployeeId)
			{
				isSurveyValid = false;
				ViewBag.Message = "You are not authorized for this survey.";
			}
			else if (String.CompareOrdinal("Completed", survey.Status) == 0)
			{
				isSurveyValid = false;
				ViewBag.Message = "You have already completed this survey.";
			}
			else if (String.CompareOrdinal("Inactive", survey.Status) == 0)
			{
				isSurveyValid = false;
				ViewBag.Message = "This survey has expired.";
			}

			Session["currentPage"] = Constants.PAGE_SURVEY;

			if (!isSurveyValid)
			{
				return View("_Result");
			}

			survey.Questions = survey.Questions.OrderBy(x => x.DisplayOrder).ToList();
			SurveyViewModel vm = new SurveyViewModel(survey);

			return View(vm);
        }

		[HttpPost]
		public ActionResult Save(Survey survey)
		{
			// Try to avoid multiple submits
			if (Session["IsSubmitted"] != null) // Already submitted this survey
			{
				ViewBag.Message = "You have already submitted this survey [" + survey.Id + "].";
				return View("_Result");
			}

			Session["IsSubmitted"] = true;
			int retCode = -1;
			string retMsg = string.Empty;
			try
			{
				this.surveyService.Save(survey, out retCode, out retMsg);
			}
			catch (Exception ex)
			{
				// Something is wrong, log the exception
				User user = GetUserFromSession();
				var userId = user == null ? "usernull" : user.EmployeeId;
				StringBuilder msg = new StringBuilder("Failed to save survey");
				msg.Append("[").Append(userId).Append("]")
					.Append("|SurveyId").Append("[").Append(survey.Id).Append("]")
					.Append("|retCode").Append("[").Append(retCode).Append("]")
					.Append("|retMsg").Append("[").Append(retMsg).Append("]: ")
					.Append(ex.Message)
					.Append(Environment.NewLine)
					.Append(ex.StackTrace);
				logger.Warn(msg);
			}

			if (retCode != 0)
			{
				ViewBag.Message = "Failed to save your survey. Please try again later.";
			}
			else
			{
				ViewBag.Message = "Thank you for your time. You have successfully completed this survey.";
			}
			return View("_Result");
		} 
    }
}
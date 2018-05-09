using eCoachingLog.Models.Survey;
using eCoachingLog.Services;
using eCoachingLog.ViewModels;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace eCoachingLog.Controllers
{
    public class SurveyController : LogBaseController
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		private ISurveyService SurveyService;

		public SurveyController(ISurveyService surveyService, IEmployeeLogService empLogService) : base(empLogService)
		{
			logger.Debug("Entered SurveyController(ISurveyService, IEmployeeLogService)");
			this.SurveyService = surveyService;
		}
		// GET: Suvey
		public ActionResult Index()
        {
			Session["currentPage"] = "Survey";

			var surveyId = Convert.ToInt64(Request.QueryString["id"]);
			logger.Debug("SurveyID: " + surveyId);

			Survey survey = this.SurveyService.GetSurvey(surveyId);
			bool isSurveyValid = true;
			if (GetUserFromSession().EmployeeId != survey.EmployeeId)
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
			int retCode = -1;
			string retMsg = string.Empty;
			try
			{
				this.SurveyService.Save(survey, out retCode, out retMsg);
			}
			catch (Exception ex)
			{
				logger.Warn("Failed to save survey[" + survey.Id + "]");
				logger.Warn(ex.StackTrace);
			}

			if (retCode != 0)
			{
				ViewBag.Message = "Failed to save your survey. An error has occurred.";
			}
			else
			{
				ViewBag.Message = "Thank you for your time. You have successfully completed this survey.";
			}

			return View("_Result");
		} 
    }
}
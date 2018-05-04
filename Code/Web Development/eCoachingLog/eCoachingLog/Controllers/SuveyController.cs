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

			var surveyId = Request.QueryString["id"];
			Survey survey = this.SurveyService.GetSurvey(1);
			SurveyViewModel vm = new SurveyViewModel(survey);
			return View(vm);
        }
    }
}
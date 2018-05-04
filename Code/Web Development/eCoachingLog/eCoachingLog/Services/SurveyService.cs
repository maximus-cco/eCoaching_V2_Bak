using eCoachingLog.Models.Survey;
using eCoachingLog.Repository;
using log4net;
using System.Collections.Generic;
using System.Linq;

namespace eCoachingLog.Services
{
	public class SurveyService : ISurveyService
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		private readonly ISurveyRepository surveyRepository;

		public SurveyService(ISurveyRepository surveyRepository)
		{
			this.surveyRepository = surveyRepository;
		}

		public Survey GetSurvey(int surveyId)
		{
			Survey survey = this.surveyRepository.GetSurveyInfo(surveyId);
			IList<SingleChoice> allSingleChoices = this.surveyRepository.GetSingleChoices();
			survey.Questions = this.surveyRepository.GetQuestions(surveyId);
			foreach (Question q in survey.Questions)
			{
				q.SingleChoices = (from c in allSingleChoices
								   where c.QuestionId == q.Id
								   select c).ToList();
			}
			return survey;
		}
	}
}
using eCoachingLog.Models.Survey;

namespace eCoachingLog.Services
{
	public interface ISurveyService
	{
		Survey GetSurvey(int surveyId);
		void Save(Survey survey, out int retCode, out string retMsg);
	}
}
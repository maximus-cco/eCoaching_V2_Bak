using eCoachingLog.Models.Survey;

namespace eCoachingLog.Services
{
	public interface ISurveyService
	{
		Survey GetSurvey(int surveyId);
	}
}
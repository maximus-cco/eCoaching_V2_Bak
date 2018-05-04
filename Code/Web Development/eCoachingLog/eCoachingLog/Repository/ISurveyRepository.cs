using eCoachingLog.Models.Survey;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface ISurveyRepository
    {
		Survey GetSurveyInfo(int surveyId);
		IList<SingleChoice> GetSingleChoices();
		IList<Question> GetQuestions(int surveyId);
    }
}

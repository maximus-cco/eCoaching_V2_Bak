using eCoachingLog.Models.Survey;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface ISurveyRepository
    {
		Survey GetSurveyInfo(long surveyId);
		IList<SingleChoice> GetSingleChoices();
		IList<Question> GetQuestions(long surveyId);
		void Save(Survey survey, out int retCode, out string retMsg);
    }
}

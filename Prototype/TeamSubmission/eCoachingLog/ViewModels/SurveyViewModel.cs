using eCoachingLog.Models.Survey;
namespace eCoachingLog.ViewModels
{
	public class SurveyViewModel
	{
		public Survey Survey { get; set; }

		public SurveyViewModel(Survey survey)
		{
			this.Survey = survey;
		}
	}
}
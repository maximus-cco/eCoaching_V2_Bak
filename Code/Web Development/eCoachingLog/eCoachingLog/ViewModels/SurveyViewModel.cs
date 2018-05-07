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

		//public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
		//{
		//	// Go through all questions to make sure radio buttons selected
		//	foreach (Question q in this.Survey.Questions)
		//	{
		//		if (q.SingleChoiceSelected == -1)
		//		{
		//			var singleChoiceSelected = new[] { "SingleChoiceSelected" };
		//			yield return new ValidationResult("Please select a choice.", singleChoiceSelected);
		//		}
		//	}
		//}
	}
}
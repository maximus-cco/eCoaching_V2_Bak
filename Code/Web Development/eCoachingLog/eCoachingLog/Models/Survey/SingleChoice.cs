namespace eCoachingLog.Models.Survey
{
	public class SingleChoice
	{
		// Survey.DIM_QAnswer.ResponseValue
		public string Text { get; set; }
		// Survey.DIM_QAnswer.ResponseID
		public int Value { get; set; }
		// Survey_DIM_QAnswer.QuestionID
		public int QuestionId { get; set; } 

		public SingleChoice()
		{
			this.Text = string.Empty;
			this.Value = -1;
			this.QuestionId = -1;
		}
	}
}
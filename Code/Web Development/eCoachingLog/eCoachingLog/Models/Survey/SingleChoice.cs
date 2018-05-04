namespace eCoachingLog.Models.Survey
{
	public class SingleChoice
	{
		// Survey.DIM_QAnswer.ResponseID
		public int Id { get; set; }
		// Survey.DIM_QAnswer.ResponseValue
		public string Text;
		// Survey_DIM_QAnswer.QuestionID
		public int QuestionId { get; set; }

		public SingleChoice()
		{
			this.Id = -1;
			this.Text = string.Empty;
			this.QuestionId = -1;
		}
	}
}
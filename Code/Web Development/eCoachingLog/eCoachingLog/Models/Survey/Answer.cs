namespace eCoachingLog.Models.Survey
{
	public class Answer
	{
		public int Id { get; set; }
		public int SingleChoiceSelected { get; set; } 
		public string MultiLineText { get; set; }
		public int QuestionId { get; set; }

		public Answer()
		{
			this.Id = -1;
			this.SingleChoiceSelected = -1;
			this.MultiLineText = string.Empty;
			this.QuestionId = -1;
		}
	}
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.Models.Survey
{
	public class Question
	{
		public int Id { get; set; }
		public int DisplayOrder { get; set; } // TODO: check if needed
		public string Label { get; set; }
		public IList<SingleChoice> SingleChoices { get; set; }
		public string TexBoxLabel {get; set; }
		public Answer Answer { get; set; }
		public int SurveyId { get; set; } // TODO: check if needed
	}
}
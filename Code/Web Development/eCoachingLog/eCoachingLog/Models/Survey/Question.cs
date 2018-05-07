using System;
using System.Collections.Generic;

namespace eCoachingLog.Models.Survey
{
	public class Question
	{
		public int Id { get; set; }
		public int DisplayOrder { get; set; }
		public string Label { get; set; }
		public IList<SingleChoice> SingleChoices { get; set; }
		public string SingleChoiceSelected { get; set; }
		public string TextBoxLabel {get; set; }
		public string MultiLineText { get; set; }
	}
}
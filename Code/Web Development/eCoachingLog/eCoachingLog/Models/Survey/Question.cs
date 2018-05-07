using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCoachingLog.Models.Survey
{
	public class Question
	{
		public int Id { get; set; }
		public int DisplayOrder { get; set; }
		public string Label { get; set; }
		public IList<SingleChoice> SingleChoices { get; set; }
		[Required(ErrorMessage = "Please make a selection.")]
		public int SingleChoiceSelected { get; set; }
		public string TextBoxLabel {get; set; }
		public string MultiLineText { get; set; }

		public Question()
		{
			this.Id = -1;
			this.DisplayOrder = -1;
			this.Label = string.Empty;
			this.SingleChoices = new List<SingleChoice>();
			this.SingleChoiceSelected = -1;
			this.TextBoxLabel = string.Empty;
			this.MultiLineText = string.Empty;
		}
	}
}
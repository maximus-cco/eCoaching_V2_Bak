using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.ViewModels
{
	public class AcknowledgeViewModel : ReviewViewModel 
	{
		//public bool AcknowledgeMonitor { get; set; }
		//public bool AcknowledgeOpportunity { get; set; }

		//public bool ShowAckMontitor { get; set; }
		//public bool ShowAckOpportunity { get; set; }
		//public bool ShowCommentTextBox { get; set; }
		//public bool ShowCommentDdl { get; set; }


		public IEnumerable<SelectListItem> CommentSelectList { get; set; }
	}
}
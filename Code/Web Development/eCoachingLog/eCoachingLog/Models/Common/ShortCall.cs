using eCoachingLog.Utils;
using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.Models.Common
{
	public class ShortCall
	{
		public string VerintId { get; set; }
		public bool IsValidBehavior { get; set; }
		public string IsValidBehaviorText { get; set; }
		public List<Behavior> Behaviors { get; set; }
		public IEnumerable<SelectListItem> SelectListBehaviors { get; set; }
		public int SelectedBehaviorId { get; set; }
		public string SelectedBehaviorText { get; set; }
		public string Action { get; set; }
		public string CoachingNotes { get; set; }
		public bool IsLsaInformed { get; set; }
		public string IsLsaInformedText { get; set; }
		public bool? IsManagerAgreed { get; set; }
		public string Comments { get; set; }

		public string ManagerAgreedText
		{
			get
			{
				if (!IsManagerAgreed.HasValue)
				{
					return string.Empty;
				}
				else
				{
					if (IsManagerAgreed.Value)
						return "Yes";
					else
						return "No";
				}
			}
		}

		public ShortCall()
		{
			this.VerintId = Constants.LOG_STATUS_UNKNOWN_TEXT;
			this.IsValidBehavior = false;
			this.Behaviors = new List<Behavior>
			{
				new Behavior { Id = -1, Text = "Select a behavior..." },
				new Behavior { Id = 1, Text = "Intentionally disconnecting calls" },
				new Behavior { Id = 2, Text = "Incorrect blind transfer" },
				new Behavior { Id = 3, Text = "Not following call flow" },
				new Behavior { Id = 4, Text = "Incorrect phone status" },
				new Behavior { Id = 5, Text = "Not following procedure for disconnect by caller" },
				new Behavior { Id = 6, Text = "Calling Kudos Line" },
				new Behavior { Id = 7, Text = "CSR Technical Error" },
				new Behavior { Id = 8, Text = "Technical Error" },
				new Behavior { Id = 9, Text = "Other" }
			};
			this.SelectListBehaviors = new SelectList(this.Behaviors, "Id", "Text");
			this.Action = "";
			this.CoachingNotes = string.Empty;
			this.IsLsaInformed = false;
			this.IsManagerAgreed = null;
		}
	}
}
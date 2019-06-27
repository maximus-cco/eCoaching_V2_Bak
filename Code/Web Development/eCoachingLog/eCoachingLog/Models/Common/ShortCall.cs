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
			this.Behaviors = new List<Behavior>();
		}
	}
}
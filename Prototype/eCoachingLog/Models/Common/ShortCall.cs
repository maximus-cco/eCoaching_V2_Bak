using eCoachingLog.Utils;
using System.Collections.Generic;
using System.Web.Mvc;
using eCoachingLog.Models.Review;

namespace eCoachingLog.Models.Common
{
	public class ShortCall
	{
		public string VerintId { get; set; }
		public bool IsValidBehavior { get; set; }
		public List<Behavior> Behaviors { get; set; }
		public IEnumerable<SelectListItem> SelectListBehaviors { get; set; }
		public int SelectedBehaviorId { get; set; }
		public string SelectedBehaviorText { get; set; }
		public List<string> Actions { get; set; }
		public string CoachingNotes { get; set; }
		public bool IsLsaInformed { get; set; }
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

		public string IsValidBehaviorText
		{
			get
			{
				if (IsValidBehavior)
				{
					return "Yes";
				}
				else
				{
					if (string.IsNullOrEmpty(SelectedBehaviorText))
					{
						return string.Empty;
					}
					return "No";
				}
			}
		}

		public string ActionsString { get; set; }

		public string IsLsaInformedText
		{
			get
			{
				if (IsLsaInformed)
				{
					return "Yes";
				}
				else
				{
					if (string.IsNullOrEmpty(SelectedBehaviorText))
					{
						return string.Empty;
					}
					return "No";
				}
			}
		}

		public ShortCall()
		{
			this.VerintId = Constants.LOG_STATUS_UNKNOWN_TEXT;
			this.Behaviors = new List<Behavior>();
			this.Actions = new List<string>();
		}
	}
}
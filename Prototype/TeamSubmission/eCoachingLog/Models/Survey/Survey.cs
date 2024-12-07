﻿using System.Collections.Generic;
using System.Web.Mvc;

namespace eCoachingLog.Models.Survey
{
	public class Survey
	{
		public long Id { get; set; }
		public long LogId { get; set; }
		public string LogName { get; set; }
		public string EmployeeId { get; set; }
		public IList<Question> Questions { get; set; }
		[AllowHtml]
		public string Comment { get; set; }
		public bool HasHotTopic { get; set; }
		public string Status { get; set; }

		public Survey()
		{
			this.Id = -1;
			this.LogName = string.Empty;
			this.Questions = new List<Question>();
			this.Comment = string.Empty;
			this.HasHotTopic = false;
			this.Status = string.Empty;
		}
	}
}
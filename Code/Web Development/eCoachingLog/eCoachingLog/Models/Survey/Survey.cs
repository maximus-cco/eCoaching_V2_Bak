using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.Models.Survey
{
	public class Survey
	{
		public int Id { get; set; }
		public int LogId { get; set; }
		public string LogName { get; set; }
		public string EmployeeId { get; set; }
		public IList<Question> Questions { get; set; }
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
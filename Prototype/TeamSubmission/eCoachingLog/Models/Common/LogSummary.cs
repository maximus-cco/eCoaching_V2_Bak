using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCoachingLog.Models.Common
{
    public class LogSummary
    {
        public int SummaryId { get; set; }
        public int CoachingId { get; set; }
        public string Summary { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public string LastUpdateBy { get; set; }
        public bool IsReadOnly { get; set; }
    }
}
using System.Collections.Generic;

namespace eCLAdmin.Models
{
    public class Email
    {
        public List<string> To { get; set; }
        public List<string> CC { get; set; }
        public string From { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }

        public string LogId { get; set; }
        public string LogName { get; set; }
        public string FromDisplayName { get; set; }
        public bool IsBodyHtml { get; set; }
        public string StrTo { get; set; }
        public string StrCc { get; set; }
    }
}
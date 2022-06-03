namespace eCoachingLog.Models.Common
{
    public class Mail
    {
        public string LogId { get; set; }
        public string LogName { get; set; }

        public string To { get; set; }
        public string Cc { get; set; }
        public string From { get; set; }
        public string FromDisplayName { get; set; }
        public string Body { get; set; }
        public bool IsBodyHtml { get; set; }
        public string Subject { get; set; }

    }
}
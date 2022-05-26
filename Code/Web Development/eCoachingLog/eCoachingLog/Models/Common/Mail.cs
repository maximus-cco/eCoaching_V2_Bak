namespace eCoachingLog.Models.Common
{
    public class Mail
    {
        public long LogId { get; set; }
        public string LogName { get; set; }

        public string To { get; set; }
        public string Cc { get; set; }
        public string From { get; set; }
        public string Body { get; set; }
        public bool IsBodyHtml { get; set; }
        public string LogStatus { get; set; }
        public string Subject { get; set; }

        public Mail(string to, string cc, string body, string logStatus)
        {
            To = to;
            Cc = cc;
            Body = body;
            LogStatus = logStatus;
        }

        public Mail()
        {
        }
    }
}
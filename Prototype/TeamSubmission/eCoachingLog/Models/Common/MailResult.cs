namespace eCoachingLog.Models.Common
{
    public class MailResult
    {
        public string LogName { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public bool Success { get; set; }
        public string SentDateTime { get; set; }

        public MailResult(string logName, string to, string cc, string sentDateTime, bool success)
        {
            LogName = logName;
            To = to;
            Cc = cc;
            SentDateTime = sentDateTime;
            Success = success;
        }

        public MailResult(string logName, bool success)
        {
            LogName = logName;
            Success = success;
        }
    }
}
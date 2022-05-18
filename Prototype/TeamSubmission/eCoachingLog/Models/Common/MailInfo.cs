namespace eCoachingLog.Models.Common
{
    public class MailInfo
    {
        public string To { get; set; }
        public string Cc { get; set; }
        public string BodyText { get; set; }
        public string LogStatus { get; set; }

        public MailInfo(string to, string cc, string bodyText, string logStatus)
        {
            To = to;
            Cc = cc;
            BodyText = bodyText;
            LogStatus = logStatus;
        }

        public MailInfo()
        {
        }
    }
}
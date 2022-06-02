namespace eCoachingLog.Models.Common
{
    public class MailMetaData
    {
        public string ToTitle { get; set; }
        public string To { get; set; }
        public string CcTitle { get; set; }
        public string Cc { get; set; }
        public string PartialBody { get; set; }
        public string LogStatus { get; set; }
        public bool IsCc{ get; set; }

        public MailMetaData()
        { }

        public MailMetaData(string toTitle, string ccTitle, string partialBody, string logStatus)
        {
            this.ToTitle = toTitle;
            this.CcTitle = ccTitle;
            this.PartialBody = partialBody;
            this.LogStatus = logStatus;
        }
    }
}
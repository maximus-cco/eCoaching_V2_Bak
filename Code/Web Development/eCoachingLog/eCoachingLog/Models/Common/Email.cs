namespace eCoachingLog.Models.Common
{
    public class Email
    {
        public string ToAddress { get; set; }
        public string BccAddress { get; set; }
        public string FromAddress { get; set; }
        public string FromDisplayName { get; set; }
        public string Subject { get; set; }
        public string TextFromDb { get; set; }
        public string Body { get; set; }
        public string Logo { get; set; }
    }
}
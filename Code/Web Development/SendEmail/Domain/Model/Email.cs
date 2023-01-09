namespace SendEmail.Domain.Model
{
    class Email
    {
        public string MailId { get; set; }
        public string MailType { get; set; }
        public string LogId { get; set; }
        public string LogName { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public string From { get; set; }
        public string FromDisplayName { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public bool IsHtml { get; set; }

        public bool IsSuccess { get; set; }
        public string Error { get; set; }
    }
}

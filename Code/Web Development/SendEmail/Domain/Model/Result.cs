using System;

namespace SendEmail.Domain.Model
{
    public class Result
    {
        public string MailType { get; set; }
        public string LogId { get; set; }
        public string LogName { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public DateTime SentDateTime { get; set; }

        public bool IsSuccess { get; set; }
        public string Error { get; set; }
    }
}

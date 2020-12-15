using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace SharePointExtractor
{
    public class EmailTraceListener : TraceListener, IDisposable
    {
        private StringBuilder Message { get; set; }
        public string To { get; set; }
        public string From { get; set; }
        public string Host { get; set; }
        public string Environment { get; set; }
        public bool Success { get; set; }

        public EmailTraceListener()
        {
            Message = new StringBuilder();
            Success = true;
            //System.AppDomain.CurrentDomain.FriendlyName
        }

        public override void Write(string message)
        {
            Message.Append(message);
        }

        public override void WriteLine(string message)
        {
            Message.AppendLine(message);
        }

        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        new protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    if (Message.Length > 0)
                    {
                        if (From == null)
                            From = Environment + " " + System.AppDomain.CurrentDomain.FriendlyName + "@GDIT.com";

                        MailMessage mail = new MailMessage(From,To);
                        SmtpClient client = new SmtpClient();

                        client.Port = 25;
                        client.DeliveryMethod = SmtpDeliveryMethod.Network;
                        client.UseDefaultCredentials = true;
                        client.Host = Host;
                        mail.Subject = (Success ? "Success" : "FAILURE") + " " + Environment + "_" + System.AppDomain.CurrentDomain.FriendlyName + " ";
                        mail.Body = Message.ToString();
                        client.Send(mail);
                    }
                }

                disposedValue = true;
            }

            base.Dispose(disposing);
        }

        new public void Dispose()
        {
            Dispose(true);
            base.Dispose();
        }
        #endregion
    }
}

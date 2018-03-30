using eCLAdmin.Models;
using log4net;
using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;

namespace eCLAdmin.Services
{
    public class EmailService : IEmailService 
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(EmailService));

        private readonly IEmployeeService employeeService;
        private readonly IEmployeeLogService employeeLogService;

        public EmailService(IEmployeeService employeeService, IEmployeeLogService employeeLogService)
        {
            this.employeeService = employeeService;
            this.employeeLogService = employeeLogService;
        }

        public void Send(Email email, List<string> logNames, string webServerName)
        {
            // Replace {eCoachingUrl} based on environment
            string eCoachingUrl = null;
            eCoachingUrl = Constants.ECOACHING_URL_PROD;
            if (Constants.WEB_SERVER_NAME_ST == webServerName)
            {
                eCoachingUrl = Constants.ECOACHING_URL_ST;
            }
            email.Body = email.Body.Replace("{eCoachingUrl}", eCoachingUrl);

            // Replace {LogNameList} with the passed in values
            StringBuilder sbLogNames = new StringBuilder();
            foreach (string logName in logNames)
            {
                sbLogNames.Append(logName)
                        .Append("<br />");
            }
            email.Body = email.Body.Replace("{LogNameList}", sbLogNames.ToString());

            this.Send(email);
        }

        public void Send(Email email)
        {
            logger.Debug("Entered Send...");

            if (email == null || email.Body == null)
            {
                logger.Debug("Email is null or body is null. Failed to send email.");
                return;
            }

            var smtpClient = new SmtpClient(Constants.SMTP_CLIENT);
            MailMessage mailMessage = new MailMessage();
            mailMessage.Subject = email.Subject;
            mailMessage.From = new MailAddress(email.From, "eCoaching Log Admin");

            foreach (string to in email.To)
            {
                mailMessage.To.Add(new MailAddress(to));
            }

            if (email.CC != null)
            {
                foreach (string cc in email.CC)
                {
                    mailMessage.CC.Add(new MailAddress(cc));
                }
            }

            mailMessage.Body = email.Body;
            mailMessage.IsBodyHtml = true;

            // Embed logo
            var inline = new Attachment(email.Logo);
            inline.ContentId = Guid.NewGuid().ToString();
            inline.ContentDisposition.Inline = true;
            inline.ContentDisposition.DispositionType = DispositionTypeNames.Inline;
            mailMessage.Body = mailMessage.Body.Replace("{eCoachingLogo}", string.Format(@"<img src='cid:{0}'/>", inline.ContentId));
            mailMessage.Attachments.Add(inline);

            smtpClient.Send(mailMessage);

        }
    }
}
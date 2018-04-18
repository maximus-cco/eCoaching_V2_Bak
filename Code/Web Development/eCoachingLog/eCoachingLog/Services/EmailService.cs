using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using eCoachingLog.Utilities;
using log4net;
using System;
using System.Net.Mail;
using System.Net.Mime;

namespace eCoachingLog.Services
{
	public class EmailService : IEmailService 
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IEmployeeService employeeService;
        private readonly IEmployeeLogService employeeLogService;
        private readonly INewSubmissionRepository newSubmissionRepository;

        public EmailService(IEmployeeService employeeService, IEmployeeLogService employeeLogService,
            INewSubmissionRepository newSubmissionRepository)
        {
            this.employeeService = employeeService;
            this.employeeLogService = employeeLogService;
            this.newSubmissionRepository = newSubmissionRepository;
        }

        public bool Send(NewSubmission submission, string templateFileName, string logoFileName, string logName)
        {
            Email email = BuildEmail(submission);

            // Construct email body text
            string bodyText = FileUtil.ReadFile(templateFileName);
            string eCoachingUrl = eCoachingLogUtil.GetAppUrl();
            email.Body = bodyText.Replace("{eCoachingUrl}", eCoachingUrl);

            string textFromDb = email.TextFromDb.Replace("strPerson", submission.Employee.Name)
                                                .Replace("strDateTime", DateTime.Now.ToString());
            email.Body = email.Body.Replace("{textFromDb}", textFromDb)
                                   .Replace("{formName}", logName);
            email.Logo = logoFileName;

            return Send(email);
        }

        private Email BuildEmail(NewSubmission submission)
        {
            string env = System.Configuration.ConfigurationManager.AppSettings["environment"];
            string fromAddress = "eCoaching-Dev@gdit.com";
            string fromDisplayName = "eCoaching Log - Development";
            string subject = "eCL-Dev: ";

            if (string.CompareOrdinal("st", env) == 0)
            {
                fromAddress = "eCoaching-Test@gdit.com";
                fromDisplayName = "eCoaching Log - Test";
                subject = "eCL-Test: ";
            }
            else if (string.CompareOrdinal("prod", env) == 0)
            {
                fromAddress = "eCoaching@gdit.com";
                fromDisplayName = "eCoaching Log";
                subject = "eCL: ";
            }

            Email email = new Email();
            Tuple<string, string, string, string> recipientsAndText = GetRecipientsAndBodyTextFromDb(submission);
            string status = recipientsAndText.Item4;
            email.ToAddress = recipientsAndText.Item1; //recipientsAndText.Item1;
            email.BccAddress = recipientsAndText.Item2;
            email.TextFromDb = recipientsAndText.Item3;
            email.FromAddress = fromAddress;
            email.FromDisplayName = fromDisplayName;
            email.Subject = subject + status + string.Format(" ({0})", submission.Employee.Name);

            return email;
        }

        public bool Send(Email email)
        {
            logger.Debug("Entered Send(Email) ...");
			bool emailSent = false;

            if (email == null || email.Body == null)
            {
                logger.Warn("Email is null or body is null. Failed to send email.");
                return emailSent;
            }
            try
            {
                // https://msdn.microsoft.com/en-us/library/k1c4h6e2(v=vs.110).aspx
                // Initializes a new instance of the SmtpClient class by using configuration file settings.
                var smtpClient = new SmtpClient();
                MailMessage mailMessage = new MailMessage();
                mailMessage.Subject = email.Subject;
                mailMessage.From = new MailAddress(email.FromAddress, email.FromDisplayName);
                mailMessage.To.Add(new MailAddress(email.ToAddress));

				if (!string.IsNullOrEmpty(email.BccAddress))
                {
                    mailMessage.Bcc.Add(new MailAddress(email.BccAddress));
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

                logger.Debug("Sending email...");
                smtpClient.Send(mailMessage);
                logger.Debug("Email sent");

				emailSent = true;
            }
            catch (Exception ex)
            {
                logger.Warn(ex.StackTrace);
                logger.Warn(email.Body);
            }

			return emailSent;
        }

        private Tuple<string, string, string, string> GetRecipientsAndBodyTextFromDb(NewSubmission submission)
        {
            // Default recipient to the employee 
            string to = submission.Employee.Email;
            string cc = null;
            // Get email recipients titles
            bool isCse = submission.IsCse.HasValue ? submission.IsCse.Value : false;
            Tuple<string, string, bool, string, string> recipientsTitlesAndText = this.newSubmissionRepository.GetEmailRecipientsTitlesAndBodyText(submission.ModuleId, submission.SourceId, isCse);
            string toRecipientTitle = recipientsTitlesAndText.Item1;
            string ccRecipientTitle = recipientsTitlesAndText.Item2;
            bool isCc = recipientsTitlesAndText.Item3;
            string bodyText = recipientsTitlesAndText.Item4;
            string status = recipientsTitlesAndText.Item5;

            // Get "to" address
            if (string.CompareOrdinal("Manager", toRecipientTitle) == 0)
            {
                to = submission.Employee.ManagerEmail;
            }
            else if (string.CompareOrdinal("Supervisor", toRecipientTitle) == 0)
            {
                to = submission.Employee.SupervisorEmail;
            }

            if (isCc)
            {
                // Get "cc" address
                if (string.CompareOrdinal("Manager", ccRecipientTitle) == 0)
                {
                    cc = submission.Employee.ManagerEmail;
                }
                else if (string.CompareOrdinal("Supervisor", toRecipientTitle) == 0)
                {
                    cc = submission.Employee.SupervisorEmail;
                }
            }

            return new Tuple<string, string, string, string>(to, cc, bodyText, status);
        }

    }
}
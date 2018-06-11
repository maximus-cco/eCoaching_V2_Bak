using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
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

		public bool SendComments(CoachingLogDetail log, string comments, string emailTempFileName, string logoFileName)
		{
			string bodyText = FileUtil.ReadFile(emailTempFileName);
			MailMessage msg =new MailMessage();
			msg.Body = bodyText.Replace("{formName}", log.FormName);
			msg.Body = msg.Body.Replace("{comments}", comments);
			msg.To.Add(log.SupervisorEmail);
			msg.To.Add(log.ManagerEmail);
			msg.Subject = "eCoaching Log Completed (" + log.FormName + ")";

			return Send(msg, logoFileName);
		}

        public bool Send(NewSubmission submission, string templateFileName, string logoFileName, string logName)
        {
			string env = System.Configuration.ConfigurationManager.AppSettings["Environment"];
			string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
			string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
			string subject = "eCL: ";
			string eCoachingUrl = eCoachingLogUtil.GetAppUrl();

			MailMessage msg = new MailMessage();
			Tuple<string, string, string, string> recipientsAndText = GetRecipientsAndBodyTextFromDb(submission);
			string status = recipientsAndText.Item4;
			msg.Subject = subject + status + string.Format(" ({0})", submission.Employee.Name);
			msg.To.Add(recipientsAndText.Item1); //recipientsAndText.Item1;
			if (!string.IsNullOrEmpty(recipientsAndText.Item2))
			{
				msg.Bcc.Add(new MailAddress(recipientsAndText.Item2));
			}
			msg.From = new MailAddress(fromAddress, fromDisplayName);

			string txtFromDb = recipientsAndText.Item3;
			txtFromDb = txtFromDb.Replace("strPerson", submission.Employee.Name)
				.Replace("strDateTime", DateTime.Now.ToString());

			msg.Body = FileUtil.ReadFile(templateFileName);
			msg.Body = msg.Body.Replace("{eCoachingUrl}", eCoachingUrl)
				.Replace("{textFromDb}", txtFromDb)
				.Replace("{formName}", logName);

			return Send(msg, logoFileName);
        }

		private bool Send(MailMessage msg, string logo)
		{
			bool success = false;
			try
			{
				// https://msdn.microsoft.com/en-us/library/k1c4h6e2(v=vs.110).aspx
				// Initializes a new instance of the SmtpClient class by using configuration file settings.
				var smtpClient = new SmtpClient();
				msg.IsBodyHtml = true;

				// Embed logo
				var inline = new Attachment(logo);
				inline.ContentId = Guid.NewGuid().ToString();
				inline.ContentDisposition.Inline = true;
				inline.ContentDisposition.DispositionType = DispositionTypeNames.Inline;
				msg.Body = msg.Body.Replace("{eCoachingLogo}", string.Format(@"<img src='cid:{0}'/>", inline.ContentId));
				msg.Attachments.Add(inline);

				logger.Debug("Sending email...");
				smtpClient.Send(msg);
				logger.Debug("Email sent");

				success = true;
			}
			catch (Exception ex)
			{
				logger.Warn(ex.StackTrace);
				logger.Warn(msg.Body);
			}
			return success;
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
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Net.Mail;
using System.Text;

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

		public bool SendComments(BaseLogDetail log, string comments, string emailTempFileName, string subject)
		{
			MailMessage msg = new MailMessage();
			if (!string.IsNullOrEmpty(log.SupervisorEmail))
			{
				msg.To.Add(log.SupervisorEmail);
			}
			if (!string.IsNullOrEmpty(log.ManagerEmail))
			{
				msg.To.Add(log.ManagerEmail);
			}

			if (msg.To.Count < 1)
			{
				logger.Warn("Failed to send employee comments[" + log.LogId + "]: Both supervisor and manager emails are not available.");
				return false;
			}

			string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
			string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
			string bodyText = FileUtil.ReadFile(emailTempFileName);
			msg.IsBodyHtml = true;
			msg.Body = bodyText.Replace("{formName}", log.FormName);
			msg.Body = msg.Body.Replace("{comments}", comments);
			msg.From = new MailAddress(fromAddress, fromDisplayName);
			msg.Subject = subject + " (" + log.EmployeeName + ")";

			return Send(msg);
		}

        public bool Send(NewSubmission submission, string templateFileName, string logName)
        {
			return Send(CreateMailMessage(submission, templateFileName, logName));
        }

		private MailMessage CreateMailMessage(NewSubmission submission, string templateFileName, string logName)
		{
			string subject = (submission.IsWarning == null || !submission.IsWarning.Value) ? "eCL: " : "Warning Log: ";
			string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
			string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
			string eCoachingUrl = System.Configuration.ConfigurationManager.AppSettings["App.Url"];

			MailMessage msg = new MailMessage();
			msg.IsBodyHtml = true;
			Tuple<string, string, string, string> recipientsAndText = GetRecipientsAndBodyTextFromDb(submission);
			string status = recipientsAndText.Item4;
			msg.Subject = subject + status + string.Format(" ({0})", submission.Employee.Name.Trim());
			msg.To.Add(recipientsAndText.Item1);
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

			return msg;
		}

		private bool Send(MailMessage msg)
		{
			bool success = false;

			try
			{
				// https://msdn.microsoft.com/en-us/library/k1c4h6e2(v=vs.110).aspx
				// Initializes a new instance of the SmtpClient class by using configuration file settings.
				var smtpClient = new SmtpClient();

				logger.Debug("Sending email...");
				smtpClient.Send(msg);
				logger.Debug("Email sent");

				success = true;
			}
			catch (Exception ex)
			{
				StringBuilder info = new StringBuilder();
				info.Append("Failed to send email: ")
					.Append(ex.Message)
					.Append(Environment.NewLine)
					.Append(ex.StackTrace);

				StringBuilder to = new StringBuilder();
				foreach (var temp in msg.To)
				{
					to.Append(temp)
					  .Append(";");
				}

				logger.Warn(info);
				logger.Warn("Subject: " + msg.Subject);
				logger.Warn("To: " + to.ToString());
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
			int sourceId = submission.IsWarning != null && submission.IsWarning.Value ? Constants.WARNING_SOURCE_ID : submission.SourceId;
            Tuple<string, string, bool, string, string> recipientsTitlesAndText = this.newSubmissionRepository.GetEmailRecipientsTitlesAndBodyText(submission.ModuleId, sourceId, isCse);
            string toRecipientTitle = recipientsTitlesAndText.Item1;
            string ccRecipientTitle = recipientsTitlesAndText.Item2;
            bool isCc = recipientsTitlesAndText.Item3;
            string bodyText = recipientsTitlesAndText.Item4;
            string status = recipientsTitlesAndText.Item5;

            // Get "to" address
            if (String.Equals("Manager", toRecipientTitle, StringComparison.OrdinalIgnoreCase))
            {
                to = submission.Employee.ManagerEmail;
            }
            else if (String.Equals("Supervisor", toRecipientTitle, StringComparison.OrdinalIgnoreCase))
            {
                to = submission.Employee.SupervisorEmail;
            }

            if (isCc)
            {
                // Get "cc" address
                if (String.Equals("Manager", ccRecipientTitle, StringComparison.OrdinalIgnoreCase))
                {
                    cc = submission.Employee.ManagerEmail;
                }
                else if (String.Equals("Supervisor", toRecipientTitle, StringComparison.OrdinalIgnoreCase))
                {
                    cc = submission.Employee.SupervisorEmail;
                }
            }

            return new Tuple<string, string, string, string>(to, cc, bodyText, status);
        }

    }
}
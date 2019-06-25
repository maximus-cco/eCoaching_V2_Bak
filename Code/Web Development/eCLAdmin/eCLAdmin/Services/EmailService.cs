using eCLAdmin.Models;
using log4net;
using System;
using System.Collections.Generic;
using System.Net.Mail;
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
            string eCoachingUrl = Constants.ECOACHING_URL_DEV;
			string env = System.Configuration.ConfigurationManager.AppSettings["Environment"];

			if ("test".Equals(env, StringComparison.OrdinalIgnoreCase))
            {
                eCoachingUrl = Constants.ECOACHING_URL_ST;
            }
			else if ("uat".Equals(env, StringComparison.OrdinalIgnoreCase))
			{
				eCoachingUrl = Constants.ECOACHING_URL_UAT;
			}
			else if ("prod".Equals(env, StringComparison.OrdinalIgnoreCase))
			{
				eCoachingUrl = Constants.ECOACHING_URL_PROD;
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

			try
			{
				// https://msdn.microsoft.com/en-us/library/k1c4h6e2(v=vs.110).aspx
				// Initializes a new instance of the SmtpClient class by using configuration file settings.
				var smtpClient = new SmtpClient();
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

				smtpClient.Send(mailMessage);
			}
			catch (Exception ex)
			{
				StringBuilder info = new StringBuilder();
				info.Append("Failed to send email: ")
					.Append(ex.Message)
					.Append(Environment.NewLine)
					.Append(ex.StackTrace);

				logger.Warn(info);
			}
        }
    }
}
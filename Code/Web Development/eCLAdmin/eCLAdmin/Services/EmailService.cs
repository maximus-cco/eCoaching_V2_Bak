using eCLAdmin.Models;
using eCLAdmin.Repository;
using log4net;
using System;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public class EmailService : IEmailService 
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(EmailService));

        private readonly IEmployeeService employeeService;
        private readonly IEmployeeLogService employeeLogService;

        private readonly IEmailRepository emailRepository;

        public EmailService(IEmployeeService employeeService, IEmployeeLogService employeeLogService, IEmailRepository emailRepository)
        {
            this.employeeService = employeeService;
            this.employeeLogService = employeeLogService;
            this.emailRepository = emailRepository;
        }

        public void StoreEmail(Email email, List<string> logNames, string webServerName, string emailSource, string userId)
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
            email.Body = email.Body.Replace("{LogNameList}", String.Join("<br />", logNames));
            email.From = Constants.EMAIL_FROM;
            email.FromDisplayName = Constants.EMAIL_FROM_DISPLAY_NAME;
            email.StrTo = email.To != null && email.To.Count > 0 ? String.Join(" ", email.To) : "";
            email.StrCc = email.CC != null && email.CC.Count > 0 ? String.Join(" ", email.CC) : "";
            email.IsBodyHtml = true;
            // TODO: leave them as NULL, and set these 2 nullable in db table
            email.LogId = "-1";
            email.LogName = "na";

            this.emailRepository.Store(new List<Email> { email }, emailSource, userId);
        }
    }
}
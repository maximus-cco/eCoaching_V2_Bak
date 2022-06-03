using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading;

namespace eCoachingLog.Services
{
	public class EmailService : IEmailService 
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IEmployeeService employeeService;
        private readonly IEmployeeLogService employeeLogService;
        private readonly INewSubmissionService newSubmissionService;
        private readonly IEmailRepository emailRepository;

        private string from = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
        private string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];

        public EmailService(IEmployeeService employeeService, IEmployeeLogService employeeLogService,
            INewSubmissionService newSubmissionService, IEmailRepository emailRepository)
        {
            this.employeeService = employeeService;
            this.employeeLogService = employeeLogService;
            this.newSubmissionService = newSubmissionService;
            this.emailRepository = emailRepository;
        }

        public bool SendComment(BaseLogDetail log, string comments, string emailTempFileName, string subject)
        {
            logger.Debug("Entered SendComment...");

            if (String.IsNullOrEmpty(log.SupervisorEmail) && String.IsNullOrEmpty(log.ManagerEmail))
            {
                logger.Warn("Not able to send employee comments[" + log.LogId + "]: Both supervisor and manager emails are not available.");
                return false;
            }

            bool success = false;
            SmtpClient smtpClient = null;
            MailMessage mailMessage = null;
            try
            {
                // generate mail
                mailMessage = new MailMessage();
                if (!string.IsNullOrEmpty(log.SupervisorEmail))
                {
                    mailMessage.To.Add(log.SupervisorEmail);
                }
                if (!string.IsNullOrEmpty(log.ManagerEmail))
                {
                    mailMessage.To.Add(log.ManagerEmail);
                }

                string bodyText = FileUtil.ReadFile(emailTempFileName);
                mailMessage.IsBodyHtml = true;
                mailMessage.Body = bodyText.Replace("{formName}", log.FormName);
                mailMessage.Body = mailMessage.Body.Replace("{comments}", comments);
                mailMessage.From = new MailAddress(from, fromDisplayName);
                mailMessage.Subject = subject + " (" + log.EmployeeName + ")";
                // send mail
                smtpClient = new SmtpClient();
                smtpClient.Send(mailMessage);
                success = true;
            }
            catch (Exception ex)
            {
                LogEmailException(ex, mailMessage, log.FormName, false);
            }
            finally
            {
                if (mailMessage != null)
                {
                    mailMessage.Dispose();
                }
                if (smtpClient != null)
                {
                    smtpClient.Dispose();
                }
            }

            logger.Debug($"Csr comments sent [{log.FormName}]: {success}");
            return success;
        }

        private void LogEmailException(Exception ex, MailMessage message, string logName, bool isNewSubmission)
        {
            StringBuilder info = new StringBuilder();
            var whatMail = isNewSubmission ? "New Submission" : "Csr Comments";
            info.Append($"Failed to send {whatMail} email [{logName}]: ")
                .Append(ex.Message)
                .Append(Environment.NewLine)
                .Append(ex.StackTrace);
            logger.Warn(info);
            if (message == null)
            {
                return;
            }

            StringBuilder to = new StringBuilder();
            if (message.To != null)
            {
                foreach (var temp in message.To)
                {
                    to.Append(temp)
                      .Append(";");
                }
            }
            else
            {
                to.Append("NULL")
                  .Append(";");
            }

            logger.Warn("Subject: " + message.Subject);
            logger.Warn("To: " + to.ToString());
            logger.Warn(message.Body);
        }

        // In a seperate thread for better user experence
        // https://docs.microsoft.com/en-us/dotnet/standard/threading/creating-threads-and-passing-data-at-start-time
        public void StoreNotification(MailParameter mailParameter)
        {
            Thread thread = new Thread(new ParameterizedThreadStart(Store));
            thread.IsBackground = true;
            // The Start method returns immediately, often before the new thread has actually started. 
            thread.Start(mailParameter);
        }

        // Store emails in database, a backend process will pick them up and send...
        // one submission creates one log for each of the selected employees
        // moduleId: for which module is this submission
        // isWarning: is this submission warning?
        // isCse: is this submission Cse?
        // templateFileName: email tempmlate file name
        private void Store(Object mailParamter)
        {
            MailParameter mParameter = (MailParameter)mailParamter;
            var mailResults = InitMailResults(mParameter.NewSubmissionResult);
            if (mailResults.Count == 0)
            {
                return;
            }

            logger.Debug($"####### Start storing email [total: {mParameter.NewSubmissionResult.Count}");
            try
            { 
                var mailMetaData = GetMailMetaData(mParameter.ModuleId, mParameter.IsCse, mParameter.SourceId);
                var mailList = new List<Mail>();
                foreach (var sr in mParameter.NewSubmissionResult)
                {
                    if (mailResults.Where(x => x.LogName == sr.LogName).First().Success)
                    {
                        continue;
                    }

                    var mail = GenerateMail(mailMetaData, mParameter, sr);
                    mailList.Add(mail);

                    //logger.Debug(mail.Body);
                }

                this.emailRepository.Store(mailList, mParameter.UserId);
            }
            catch (Exception ex)
            {
                logger.Error("Failed to store email.", ex);
            }

            logger.Debug($"####### End storing email [total: {mParameter.NewSubmissionResult.Count}");
        }

        private List<MailResult> InitMailResults(List<NewSubmissionResult> newSubmissionResults)
        {
            var mailResults = new List<MailResult>();
            if (newSubmissionResults == null)
            {
                return mailResults;
            }
            foreach (var x in newSubmissionResults)
            {
                var m = new MailResult(x.LogName, false);
                mailResults.Add(m);
            }

            // one mail per log
            mailResults = mailResults
                .GroupBy(m => new { m.LogName, m.Success })
                .Select(x => x.First())
                .ToList();

            return mailResults;
        }

        private Mail InitMail(MailMetaData metaData, Employee employee)
        {
            var mail = new Mail();

            if (metaData == null)
            {
                return mail;
            }

            if (metaData.ToTitle == "Manager")
            {
                mail.To = employee.ManagerEmail;
            }
            else if (metaData.ToTitle == "Supervisor")
            {
                mail.To = employee.SupervisorEmail;
            }
            else if (metaData.To == "Employee")
            {
                mail.To = employee.Email;
            }
            else
            {
                mail.To = null;
            }

            if (metaData.Cc == "Manager")
            {
                mail.Cc = employee.ManagerEmail;
            }
            else if (metaData.Cc == "Supervisor")
            {
                mail.Cc = employee.SupervisorEmail;
            }
            else if (metaData.Cc == "Employee")
            {
                mail.Cc = employee.Email;
            }
            else
            {
                metaData.Cc = null;
            }

            mail.From = from;
            mail.FromDisplayName = fromDisplayName;

            return mail;
        }

        private Mail GenerateMail(MailMetaData mailMetaData, MailParameter mailParameter, NewSubmissionResult nsResult)
        {
            var subject = mailParameter.IsWarning ? "Warning Log: " : "eCL: ";
            var partialBodyFromDb = mailMetaData.PartialBody.Replace("strPerson", nsResult.Employee.Name)
                .Replace("strDateTime", nsResult.CreateDateTime);

            var mail = InitMail(mailMetaData, nsResult.Employee);
            mail.Subject = subject + mailMetaData.LogStatus + String.Format(" ({0})", nsResult.Employee.Name);
            mail.IsBodyHtml = true;
            mail.Body = FileUtil.ReadFile(mailParameter.TemplateFileName);
            mail.Body = mail.Body.Replace("{eCoachingUrl}", System.Configuration.ConfigurationManager.AppSettings["App.Url"])
                .Replace("{textFromDb}", partialBodyFromDb)
                .Replace("{formName}", nsResult.LogName);

            //msg.DeliveryNotificationOptions = System.Net.Mail.DeliveryNotificationOptions.OnFailure;
            //msg.Headers.Add("Disposition-Notification-To", "lilihuang@maximus.com");

            mail.LogId = nsResult.LogId;
            mail.LogName = nsResult.LogName;

			return mail;
		}

		private MailMetaData GetMailMetaData(int moduleId, bool isCse, int sourceId)
        {
            // Get email recipients titles
            return this.newSubmissionService.GetMailMetaData(moduleId, sourceId, isCse);
        }
    }
}
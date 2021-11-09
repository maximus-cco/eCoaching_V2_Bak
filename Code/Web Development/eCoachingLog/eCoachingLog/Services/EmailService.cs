using eCoachingLog.Models.Common;
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

        public EmailService(IEmployeeService employeeService, IEmployeeLogService employeeLogService,
            INewSubmissionService newSubmissionService)
        {
            this.employeeService = employeeService;
            this.employeeLogService = employeeLogService;
            this.newSubmissionService = newSubmissionService;
        }

		public bool SendComment(BaseLogDetail log, string comments, string emailTempFileName, string subject)
		{
            if (String.IsNullOrEmpty(log.SupervisorEmail) && String.IsNullOrEmpty(log.ManagerEmail))
            {
                logger.Warn("Not able to send employee comments[" + log.LogId + "]: Both supervisor and manager emails are not available.");
                return false;
            }

            bool success = true;
            using (var smtpClient = new SmtpClient())
            using (var message = CreateMailMessage(log, comments, emailTempFileName, subject))
            {
                try
                {
                    smtpClient.Send(message);
                }
                catch (Exception ex)
                {
                    success = false;
                    LogEmailException(ex, message, log.FormName);
                }
            }

            return success;
		}

        private MailMessage CreateMailMessage(BaseLogDetail log, string text, string emailTempFileName, string subject)
        {
            var message = new MailMessage();
            if (!string.IsNullOrEmpty(log.SupervisorEmail))
            {
                message.To.Add(log.SupervisorEmail);
            }
            if (!string.IsNullOrEmpty(log.ManagerEmail))
            {
                message.To.Add(log.ManagerEmail);
            }

            string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
            string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
            string bodyText = FileUtil.ReadFile(emailTempFileName);
            message.IsBodyHtml = true;
            message.Body = bodyText.Replace("{formName}", log.FormName);
            message.Body = message.Body.Replace("{comments}", text);
            message.From = new MailAddress(fromAddress, fromDisplayName);
            message.Subject = subject + " (" + log.EmployeeName + ")";

            return message;
        }

        private void LogEmailException(Exception ex, MailMessage message, string logName)
        {
            StringBuilder info = new StringBuilder();
            info.Append($"Failed to send email [{logName}]: ")
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

        // send mail in a seperate thread, so it will not freeze UI in case of sending large number of mail
        // https://docs.microsoft.com/en-us/dotnet/standard/threading/creating-threads-and-passing-data-at-start-time
        public void SendNotification(MailParameter mailParameter)
        {
            Thread thread = new Thread(new ParameterizedThreadStart(Send));
            thread.IsBackground = true;
            // The Start method returns immediately, often before the new thread has actually started. 
            thread.Start(mailParameter);
        }

        // send submission notification email, and save sent result in db if indicated to do so (MailParameter.SaveMailResult is true)
        // one submission creates one log for each selected employees
        // moduleId: for which module is this submission
        // isWarning: is this submission warning?
        // isCse: is this submission Cse?
        // templateFileName: email tempmlate file name
        private void Send(Object mailParamter)
        {
            MailParameter mParameter = (MailParameter)mailParamter;
            var mailResults = InitMailResults(mParameter.Employees);
            if (mailResults.Count == 0)
            {
                return;
            }

            SmtpClient smtpClient = new SmtpClient();
            try
            {
                var mailInfo = GetMailInfo(mParameter.ModuleId, mParameter.IsCse, mParameter.SourceId);
                foreach (var employee in mParameter.Employees)
                {
                    SetMailToCcAddress(mailInfo, employee);
                    var success = false;
                    MailMessage message = null;
                    if (mailResults.Where(x => x.LogName == employee.LogName).First().Success)
                    {
                       continue;
                    }

                    try
                    {
                        message = CreateMailMessage(mailInfo, mParameter.TemplateFileName, employee.LogName, mParameter.IsWarning, employee.Name);
                        smtpClient.Send(message);
                        // claim to be success if no exception thrown even though the email address doesn't exists (in this case, no exception thrown :-( )
                        success = true;
                    }
                    catch (Exception ex)
                    {
                        logger.Debug($"Failed to send email [{employee.LogName}] to [{mailInfo.To}]: {ex.Message}. Resend in 5 seconds.");                    
                        try
                        {
                            Thread.Sleep(5000);
                            logger.Debug("Resending...");
                            smtpClient.Send(message);
                            success = true;
                        }
                        catch (Exception exResend)
                        {
                            LogEmailException(exResend, message, employee.LogName);
                        }
                    }
                    finally
                    {
                        if (message != null)
                        {
                            message.Dispose();
                        }

                        var mailResult = mailResults.Where(x => x.LogName == employee.LogName).First();
                        mailResult.To = mailInfo.To;
                        mailResult.Cc = mailInfo.Cc;
                        mailResult.SentDateTime = DateTime.Now.ToString();
                        mailResult.Success = success;
                    } // end try smtpClient.send
                } // end foreach (var employee in employees)        
            }
            catch (Exception ex)
            {
                logger.Warn(ex);
            }
            finally
            {
                if (smtpClient != null)
                {
                    smtpClient.Dispose();
                }
            }

            // record mail result (success/fail) in db
            if (mParameter.SaveMailStatus)
            {
                this.newSubmissionService.SaveNotificationStatus(mailResults);
            }
        }

        private List<MailResult> InitMailResults(List<Employee> employees)
        {
            var mailResults = new List<MailResult>();
            if (employees == null)
            {
                return mailResults;
            }
            foreach (var e in employees)
            {
                var m = new MailResult(e.LogName, false);
                mailResults.Add(m);
            }

            // one mail per log
            mailResults = mailResults
                .GroupBy(m => new { m.LogName, m.Success })
                .Select(x => x.First())
                .ToList();

            return mailResults;
        }

        private void SetMailToCcAddress(MailInfo mailInfo, Employee employee)
        {
            if (mailInfo == null)
            {
                return;
            }

            if (mailInfo.To == "Manager")
            {
                mailInfo.To = employee.ManagerEmail;
            }
            else if (mailInfo.To == "Supervisor")
            {
                mailInfo.To = employee.SupervisorEmail;
            }
            else if (mailInfo.To == "Employee")
            {
                mailInfo.To = employee.Email;
            }
            else
            {
                mailInfo.To = null;
            }

            if (mailInfo.Cc == "Manager")
            {
                mailInfo.Cc = employee.ManagerEmail;
            }
            else if (mailInfo.Cc == "Supervisor")
            {
                mailInfo.Cc = employee.SupervisorEmail;
            }
            else if (mailInfo.Cc == "Employee")
            {
                mailInfo.Cc = employee.Email;
            }
            else
            {
                mailInfo.Cc = null;
            }
        }

		private MailMessage CreateMailMessage(MailInfo mailInfo, string templateFileName, string logName, bool isWarning, string employeeName)
		{
            string subject = isWarning ? "Warning Log: " : "eCL: ";
            string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
            string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
			string eCoachingUrl = System.Configuration.ConfigurationManager.AppSettings["App.Url"];
            string status = mailInfo.LogStatus;
            string txtFromDb = mailInfo.BodyText;
            txtFromDb = txtFromDb.Replace("strPerson", employeeName)
                .Replace("strDateTime", DateTime.Now.ToString());

            MailMessage msg = new MailMessage();
            msg.Subject = subject + status + String.Format(" ({0})", employeeName);
            msg.IsBodyHtml = true;
            msg.Body = FileUtil.ReadFile(templateFileName);
            msg.Body = msg.Body.Replace("{eCoachingUrl}", eCoachingUrl)
                .Replace("{textFromDb}", txtFromDb)
                .Replace("{formName}", logName);

            //msg.DeliveryNotificationOptions = System.Net.Mail.DeliveryNotificationOptions.OnFailure;
            //msg.Headers.Add("Disposition-Notification-To", "lilihuang@maximus.com");
            try
            {
                if (mailInfo.To != null)
                {
                    msg.To.Add(mailInfo.To);
                }
                if (mailInfo.Cc != null)
                {
                    msg.Bcc.Add(mailInfo.Cc);
                }
                msg.From = new MailAddress(fromAddress, fromDisplayName);
            }
            //catch (FormatException fe)
            //{
            //    logger.Warn(fe);
            //    logger.Warn($"Exception [{mailInfo.To}]: {fe.Message}");
            //}
            catch (Exception ex)
            {
                logger.Warn(ex);
                logger.Warn("Failed to create mail message:" + ex.Message);
                throw ex;
            }

			return msg;
		}

		private MailInfo GetMailInfo(int moduleId, bool isCse, int sourceId)
        {
            // Get email recipients titles
            Tuple<string, string, bool, string, string> recipientsTitlesAndText = this.newSubmissionService.GetEmailRecipientsTitlesAndBodyText(moduleId, sourceId, isCse);

            return new MailInfo(recipientsTitlesAndText.Item1, recipientsTitlesAndText.Item2, recipientsTitlesAndText.Item4, recipientsTitlesAndText.Item5);
        }
    }
}
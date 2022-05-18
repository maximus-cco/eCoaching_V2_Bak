using eCoachingLog.Models;
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
                string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
                string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
                string bodyText = FileUtil.ReadFile(emailTempFileName);
                mailMessage.IsBodyHtml = true;
                mailMessage.Body = bodyText.Replace("{formName}", log.FormName);
                mailMessage.Body = mailMessage.Body.Replace("{comments}", comments);
                mailMessage.From = new MailAddress(fromAddress, fromDisplayName);
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
            var mailResults = InitMailResults(mParameter.NewSubmissionResult);
            if (mailResults.Count == 0)
            {
                return;
            }

            logger.Debug("#######start: " + DateTime.Now);

            SmtpClient smtpClient = new SmtpClient();
            try
            {
                var mailInfo = GetMailInfo(mParameter.ModuleId, mParameter.IsCse, mParameter.SourceId);
                foreach (var newSubmissionResult in mParameter.NewSubmissionResult)
                {
                    logger.Debug("!!!!!!!!!!!!Start sending email: " + newSubmissionResult.Employee.Name);
                    SetMailToCcAddress(mailInfo, newSubmissionResult.Employee);
                    var success = false;
                    MailMessage message = null;
                    if (mailResults.Where(x => x.LogName == newSubmissionResult.LogName).First().Success)
                    {
                       continue;
                    }

                    try
                    {
                        // TODO: pass "CreateDateTime" passed back from database to CreateMailMessage(...)
                        message = CreateMailMessage(mailInfo, mParameter.TemplateFileName, newSubmissionResult.LogName, mParameter.IsWarning, newSubmissionResult.Employee.Name);
                        logger.Debug("%%%%%%%%%%%%%% BEFORE sending: " + newSubmissionResult.Employee.Name);
                        smtpClient.Send(message);
                        logger.Debug("%%%%%%%%%%%%%% AFTER sending: " + newSubmissionResult.Employee.Name);
                        // claim to be successful if no exception thrown even though the email address doesn't exists (in this case, no exception thrown)
                        success = true;
                    }
                    catch (Exception ex)
                    {
                        if (message != null)
                        {
                            logger.Debug($"Failed to send email [{newSubmissionResult.LogName}] to [{mailInfo.To}]: {ex.Message}. Resend in 5 seconds.");
                            try
                            {
                                Thread.Sleep(5000);
                                logger.Debug("Resending...");
                                smtpClient.Send(message);
                                success = true;
                            }
                            catch (Exception exResend)
                            {
                                LogEmailException(exResend, message, newSubmissionResult.LogName, true);
                            }
                        }
                        else
                        {
                            LogEmailException(ex, message, newSubmissionResult.LogName, true);
                        }
                    }
                    finally
                    {
                        if (message != null)
                        {
                            message.Dispose();
                        }

                        var mailResult = mailResults.Where(x => x.LogName == newSubmissionResult.LogName).First();
                        mailResult.To = mailInfo.To;
                        mailResult.Cc = mailInfo.Cc;
                        mailResult.SentDateTime = DateTime.Now.ToString();
                        mailResult.Success = success;
                        logger.Debug("############End sending email: " + newSubmissionResult.Employee.Name);
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

            logger.Debug("@@@@@@end: " + DateTime.Now);

            // record mail result (success/fail) in db
            if (mParameter.SaveMailStatus)
            {
                this.newSubmissionService.SaveNotificationStatus(mailResults, mParameter.UserId);
                logger.Debug("############Done with SaveNotificationStatus");
            }
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

        private void SetMailToCcAddress(MailInfo mailInfo, Employee employee)
        {
            mailInfo.To = "lilihuang@maximus.com";
            mailInfo.Cc = "lilihuang@maximus.com";

            //if (mailInfo == null)
            //{
            //    return;
            //}

            //if (mailInfo.To == "Manager")
            //{
            //    mailInfo.To = employee.ManagerEmail;
            //}
            //else if (mailInfo.To == "Supervisor")
            //{
            //    mailInfo.To = employee.SupervisorEmail;
            //}
            //else if (mailInfo.To == "Employee")
            //{
            //    mailInfo.To = employee.Email;
            //}
            //else
            //{
            //    mailInfo.To = null;
            //}

            //if (mailInfo.Cc == "Manager")
            //{
            //    mailInfo.Cc = employee.ManagerEmail;
            //}
            //else if (mailInfo.Cc == "Supervisor")
            //{
            //    mailInfo.Cc = employee.SupervisorEmail;
            //}
            //else if (mailInfo.Cc == "Employee")
            //{
            //    mailInfo.Cc = employee.Email;
            //}
            //else
            //{
            //    mailInfo.Cc = null;
            //}
        }

		private MailMessage CreateMailMessage(MailInfo mailInfo, string templateFileName, string logName, bool isWarning, string employeeName)
		{
            string subject = isWarning ? "Warning Log: " : "eCL: ";
            string fromAddress = System.Configuration.ConfigurationManager.AppSettings["Email.From.Address"];
            string fromDisplayName = System.Configuration.ConfigurationManager.AppSettings["Email.From.DisplayName"];
			string eCoachingUrl = System.Configuration.ConfigurationManager.AppSettings["App.Url"];
            string status = mailInfo.LogStatus;
            string txtFromDb = mailInfo.BodyText;
            // TODO: time should be CreatedDateTime in database, should return this 
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

            if (mailInfo.To != null)
            {
                msg.To.Add(mailInfo.To);
            }
            if (mailInfo.Cc != null)
            {
                msg.Bcc.Add(mailInfo.Cc);
            }
            msg.From = new MailAddress(fromAddress, fromDisplayName);

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
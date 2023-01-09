using log4net;
using SendEmail.Domain.Dao;
using SendEmail.Domain.Model;
using System;
using System.Collections.Generic;
using System.Net.Mail;

namespace SendEmail.Domain.Service
{
    class EmailService
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private EmailDao emailDao;

        public EmailService()
        {
            this.emailDao = new EmailDao();
        }

        public IEnumerable<Email> GetEmailList()
        {
            IEnumerable<Email> emailList = new List<Email>();

            try
            {
                emailList = this.emailDao.GetEmailList();
            }
            catch (Exception ex)
            {
                logger.Error("Failed to get email list from database: ", ex);
            }

            return emailList;
        }

        public IList<Result> Send(List<Email> emailList)
        {
            logger.Debug("Entered Send...........");
            var results = new List<Result>();
            SmtpClient smtpClient = new SmtpClient();
            try
            {
                foreach (var email in emailList )
                {
                    var result = new Result();
                    var isSuccess = false;
                    var error = "";
                    MailMessage msg = new MailMessage();
 
                    try
                    {
                        msg.To.Add(email.To);
                        if (!string.IsNullOrEmpty(email.Cc))
                        {
                            msg.CC.Add(email.Cc);
                        }
                        msg.From = new MailAddress(email.From, email.FromDisplayName);
                        msg.Subject = email.Subject;

                        msg.IsBodyHtml = email.IsHtml;
                        msg.Body = email.Body;

                        smtpClient.Send(msg);
                        isSuccess = true;
                    }
                    catch (Exception ex)
                    {
                        error = $"Faile to send [{email.LogId}]: {ex.Message}";
                        logger.Error(error);
                    }
                    finally
                    {
                        if (msg != null)
                        {
                            msg.Dispose();
                        }

                        result.MailType = email.MailType;
                        result.LogId = email.LogId;
                        result.LogName = email.LogName;
                        result.To = email.To;
                        result.Cc = email.Cc;
                        result.SentDateTime = DateTime.Now;
                        result.IsSuccess = isSuccess;
                        result.Error = error;

                        results.Add(result);
                    } // end try smtpClient.send
                } // end foreach (var email in emailList)
            }
            catch (Exception ex)
            {
                logger.Error($"Failed sending email: {ex.Message}", ex);
            }
            finally
            {
                if (smtpClient != null)
                {
                    smtpClient.Dispose();
                }
            }

            logger.Debug("Returning from Send..........");
            return results;
        }

        public void SaveResult(IList<Result> results)
        {
            try
            {
                emailDao.SaveResult(results);
            }
            catch (Exception ex)
            {
                logger.Error("Failed to save sending email result in database: ", ex);
            }
        }
    }
}
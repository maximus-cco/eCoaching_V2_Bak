using log4net;
using SendEmail.Domain.Model;
using SendEmail.Domain.Service;
using System.Linq;

namespace SendEmail
{
    class Program
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        static void Main(string[] args)
        {
            var service = new EmailService();
            var emailsToSend = service.GetEmailList().ToList<Email>();
            if (emailsToSend.Count > 0)
            {
                var results = service.Send(emailsToSend);
                service.SaveResult(results);
            }

            System.Environment.Exit(0);
        }

    }
}

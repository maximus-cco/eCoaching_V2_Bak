using eCoachingLog.Models.Common;

namespace eCoachingLog.Services
{
	public interface IEmailService
    {
        bool SendComment(BaseLogDetail log, string comments, string emailTempFileName, string subject);
        void SendNotification(MailParameter mailParameter);
    }
}

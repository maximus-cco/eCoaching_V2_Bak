using eCoachingLog.Models.Common;

namespace eCoachingLog.Services
{
	public interface IEmailService
    {
        void StoreNotification(MailParameter mailParameter);
    }
}

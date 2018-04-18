using eCoachingLog.Models;
using eCoachingLog.Models.Common;

namespace eCoachingLog.Services
{
	public interface IEmailService
    {
        bool Send(Email email);
        bool Send(NewSubmission newSubmission, string templateFileName, string logoFileName, string logName);
    }
}

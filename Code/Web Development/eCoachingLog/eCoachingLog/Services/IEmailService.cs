using eCoachingLog.Models;
using eCoachingLog.Models.Common;

namespace eCoachingLog.Services
{
	public interface IEmailService
    {
        bool Send(NewSubmission newSubmission, string templateFileName, string logName);
		bool SendComments(BaseLogDetail log, string comments, string emailTempFileName, string subject);
	}
}

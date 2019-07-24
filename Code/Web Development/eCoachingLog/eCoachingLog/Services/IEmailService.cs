using eCoachingLog.Models;
using eCoachingLog.Models.Common;

namespace eCoachingLog.Services
{
	public interface IEmailService
    {
        bool Send(NewSubmission newSubmission, string templateFileName, string logName);
		bool SendComments(CoachingLogDetail log, string comments, string emailTempFileName);
	}
}

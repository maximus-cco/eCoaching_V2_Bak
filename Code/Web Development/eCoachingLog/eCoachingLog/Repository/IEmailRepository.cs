using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface IEmailRepository
    {
        void Store(List<Mail> mailList);
    }
}

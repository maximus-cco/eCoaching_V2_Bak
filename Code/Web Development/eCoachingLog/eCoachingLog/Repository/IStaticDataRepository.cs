using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface IStaticDataRepository
    {
        IList<string> GetData(string key);
    }
}

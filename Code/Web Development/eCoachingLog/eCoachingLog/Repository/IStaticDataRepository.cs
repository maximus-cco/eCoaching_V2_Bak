using System.Collections.Generic;

namespace eCoachingLog.Repository
{
    public interface IStaticDataRepository
    {
        string GetData(string key);
    }
}

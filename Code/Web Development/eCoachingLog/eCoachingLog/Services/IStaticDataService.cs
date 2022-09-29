using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public interface IStaticDataService
    {
        IList<string> GetData(string data);
    }
}

using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface IStaticDataRepository
    {
        IList<string> GetData(string key);
    }
}

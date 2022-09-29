using System.Collections.Generic;

namespace eCLAdmin.Services
{
    public interface IStaticDataService
    {
        IList<string> GetData(string data);
    }
}

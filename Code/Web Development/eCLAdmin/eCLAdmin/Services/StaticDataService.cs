using eCLAdmin.Repository;
using log4net;

namespace eCLAdmin.Services
{
    public class StaticDataService : IStaticDataService
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IStaticDataRepository repository;

        public StaticDataService(IStaticDataRepository repository)
        {
            this.repository = repository;
        }

        public string Get(string key)
        {
            if (string.IsNullOrEmpty(key))
            {
                return null;
            }

            return repository.Get(key);
        }
    }
}
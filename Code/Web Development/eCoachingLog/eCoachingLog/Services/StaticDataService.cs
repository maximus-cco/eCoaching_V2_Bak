using eCoachingLog.Repository;
using log4net;
using System;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
    public class StaticDataService : IStaticDataService
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private IStaticDataRepository repository = new StaticDataRepository();

        public IList<string> GetData(string key)
        {
            var data = new List<String>();

            if (string.IsNullOrEmpty(key))
            {
                return data;
            }

            return repository.GetData(key);
        }
    }
}
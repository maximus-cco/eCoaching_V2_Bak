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

        public string Get(string key)
        {
            var data = new List<String>();

            if (string.IsNullOrEmpty(key))
            {
                return null;
            }

            return repository.GetData(key);
        }
    }
}
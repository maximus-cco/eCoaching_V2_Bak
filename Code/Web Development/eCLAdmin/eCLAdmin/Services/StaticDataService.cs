using eCLAdmin.Repository;
using log4net;
using System;
using System.Collections.Generic;

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
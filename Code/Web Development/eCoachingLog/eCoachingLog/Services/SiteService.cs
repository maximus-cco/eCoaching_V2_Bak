using eCoachingLog.Models.Common;
using eCoachingLog.Repository;
using log4net;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public class SiteService : ISiteService 
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private ISiteRepository siteRepository = new SiteRepository();

        public IList<Site> GetAllSites()
        {
            return siteRepository.GetAllSites();
        }

		public IList<Site> GetSites()
		{
			return siteRepository.GetSites();
		}
	}
}
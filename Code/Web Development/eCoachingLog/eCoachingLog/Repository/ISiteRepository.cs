using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface ISiteRepository
    {
        IList<Site> GetAllSites();
		IList<Site> GetSites();
    }
}

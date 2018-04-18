using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Repository
{
	public interface ISiteRepository
    {
        List<Site> GetAllSites();
    }
}

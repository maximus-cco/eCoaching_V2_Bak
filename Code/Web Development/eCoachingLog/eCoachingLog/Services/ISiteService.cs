using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface ISiteService
    {
        IList<Site> GetAllSites();
		IList<Site> GetSites();
    }
}
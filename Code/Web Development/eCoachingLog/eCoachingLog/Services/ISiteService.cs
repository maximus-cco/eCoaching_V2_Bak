using eCoachingLog.Models.Common;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface ISiteService
    {
        List<Site> GetAllSites();
    }
}
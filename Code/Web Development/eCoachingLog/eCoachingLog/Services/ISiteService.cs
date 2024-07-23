using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using System.Collections.Generic;

namespace eCoachingLog.Services
{
	public interface ISiteService
    {
        IList<Site> GetAllSites();
        IList<Site> GetAllSites(bool IsSubmission, User user);
        IList<Site> GetAllSubcontractorSites();
        IList<Site> GetSites();
        IList<Site> GetSites(bool IsSubmission, User user, int moduleId);
    }
}
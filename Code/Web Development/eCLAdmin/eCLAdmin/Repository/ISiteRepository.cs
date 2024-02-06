using eCLAdmin.Models;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface ISiteRepository
    {
        List<Site> GetAllActiveSites();
        List<Site> GetSites(string userId);
        List<Site> GetSiteForHierarchyRpt();
        List<Site> GetSiteForReport(string userId, int moduleId);
    }
}

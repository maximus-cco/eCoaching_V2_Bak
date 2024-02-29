using eCLAdmin.Models;
using eCLAdmin.Repository;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Services
{
    public class SiteService : ISiteService 
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(SiteService));
        private ISiteRepository siteRepository = new SiteRepository();

        public List<Site> GetAllActiveSites()
        {
            return siteRepository.GetAllActiveSites();
        }

        public List<Site> GetSites(string userId, bool excludeSubcontractorSites, bool excludeCcoSites)
        {
            var sites = siteRepository.GetSites(userId);
            if (excludeSubcontractorSites)
            {
                sites = sites.Where(x => !x.IsSubcontractor).ToList<Site>();
            }

            if (excludeCcoSites)
            {
                sites = sites.Where(x => x.IsSubcontractor).ToList<Site>();
            }
            return sites;
        }

        public List<Site> GetSiteForHierarchyRpt()
        {
            var sites = siteRepository.GetSiteForHierarchyRpt();
            if (sites.Count > 0 && sites[0].Id == "All")
            {
                sites.RemoveAt(0);
            }

            return sites;
        }

        public List<Site> GetSitesForReport(string userId, int moduleId)
        {
            return siteRepository.GetSiteForReport(userId, moduleId);
        }
    }
}
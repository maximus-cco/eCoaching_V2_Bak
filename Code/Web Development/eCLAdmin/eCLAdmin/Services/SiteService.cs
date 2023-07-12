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
        readonly ILog logger = LogManager.GetLogger(typeof(SiteService));
        private ISiteRepository siteRepository = new SiteRepository();

        public List<Site> GetSites()
        {
            return siteRepository.GetSites();
        }

        public List<Site> GetSites(string userId)
        {
            return siteRepository.GetSites(userId);
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
    }
}
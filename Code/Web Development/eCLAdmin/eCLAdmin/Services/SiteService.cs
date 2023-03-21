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
    }
}
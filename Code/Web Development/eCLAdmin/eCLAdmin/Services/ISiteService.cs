using eCLAdmin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Services
{
    public interface ISiteService
    {
        List<Site> GetSites();
        List<Site> GetSites(string userId);
    }
}
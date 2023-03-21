using eCLAdmin.Models;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public interface ISiteRepository
    {
        List<Site> GetSites();
        List<Site> GetSites(string userId);
    }
}

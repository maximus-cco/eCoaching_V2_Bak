﻿using eCLAdmin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace eCLAdmin.Services
{
    public interface ISiteService
    {
        List<Site> GetAllActiveSites(bool includeSubcontractorSites);
        List<Site> GetSites(string userId, bool excludeSubcontractorSites, bool excludeCcoSites);
        List<Site> GetSiteForHierarchyRpt();
        List<Site> GetSitesForReport(string userId, int moduleId);
    }
}
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Repository;
using log4net;
using System.Collections.Generic;
using System.Linq;

namespace eCoachingLog.Services
{
	public class SiteService : ISiteService 
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private ISiteRepository siteRepository = new SiteRepository();

        public IList<Site> GetAllSites()
        {
            return siteRepository.GetAllSites();
        }

		public IList<Site> GetSites()
		{
			return siteRepository.GetSites();
		}

        public IList<Site> GetAllSites(bool IsSubmission, User user)
        {
            return FilterSites(GetAllSites(), IsSubmission, user);
        }

        public IList<Site> GetSites(bool isSubmission, User user)
        {
            logger.Debug("@@@@@@@@IsSubmission:" + isSubmission);
            return FilterSites(GetSites(), isSubmission, user);
        }

        private IList<Site> FilterSites(IList<Site> sites, bool isSubmission, User user)
        {
            logger.Debug("######username=" + user.Name + ", isSub=" + user.IsSubcontractor + ", siteId=" + user.SiteId);
            // subcontractor can only access own site data
            if (user.IsSubcontractor)
            {
                return sites.Where(x => x.Id == user.SiteId).ToList<Site>();
            }

            // CCO users on New Submission page: 
            // CCO users with roles other than PMA, DIRPMA, ARC, and QUALITY not able to submit subcontractor logs
            if (isSubmission)
            {
                if (!user.IsPma && !user.IsDirPma && !user.IsArc) // todo: add user.IsQuality
                {
                    return sites.Where(x => !x.IsSubcontractorSite).ToList<Site>();
                }
                return sites;
            }

            // View subcontractor logs: 
            // CCO user with roles other than PM, PMA, DIRPM, DIRPMA, ARC, and Quality not able to view subcontractor logs
            if (!user.IsPm && !user.IsDirPm && !user.IsPma && !user.IsDirPma)// && !user.IsArc) // todo: add user.IsQuality - no need, this is historical page 
            {
                var nonSubcontractorSites = sites.Where(x => !x.IsSubcontractorSite).ToList<Site>();
                // sp returns "-1 All Sites	0" - siteId siteName isSub
                // -1: all cco sites + all sub sites
                // -4: all cco sites (aka non subcontractor sites)
                foreach (var x in nonSubcontractorSites)
                {
                    if (x.Id == Utils.Constants.ALL_SITES)
                    {
                        x.Id = Utils.Constants.ALL_SITES_CCO;
                        break;
                    }
                }

                return nonSubcontractorSites;
            }

            return sites;
        }
    }
}
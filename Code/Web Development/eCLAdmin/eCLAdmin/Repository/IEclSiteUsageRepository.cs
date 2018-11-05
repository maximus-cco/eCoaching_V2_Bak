using eCLAdmin.Models.EclSiteUsage;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
	public interface IEclSiteUsageRepository
	{
		IList<Statistic> GetPageCount(string byWhat, string startDay, string endDay);
	}
}

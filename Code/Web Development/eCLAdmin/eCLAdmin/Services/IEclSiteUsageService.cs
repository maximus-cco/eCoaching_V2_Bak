using eCLAdmin.Models.EclSiteUsage;
using System.Collections.Generic;

namespace eCLAdmin.Services
{
	public interface IEclSiteUsageService
	{
		IList<Statistic> GetStatistics(string byWhat, string startDate, string endDate);
	}
}

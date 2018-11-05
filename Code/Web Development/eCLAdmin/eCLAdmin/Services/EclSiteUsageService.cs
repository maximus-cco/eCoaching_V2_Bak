using eCLAdmin.Models.EclSiteUsage;
using eCLAdmin.Repository;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace eCLAdmin.Services
{
	public class EclSiteUsageService : IEclSiteUsageService
	{
		private readonly IEclSiteUsageRepository repository;

		public EclSiteUsageService(IEclSiteUsageRepository repository)
		{
			this.repository = repository;
		}

		public IList<Statistic> GetStatistics(string byWhat, string startDay, string endDay)
		{
			IList<Statistic> statistics = new List<Statistic>(); 
			IList<Statistic> pageCounts = new List<Statistic>();
			DateTime startDate;
			DateTime endDate;
			if (byWhat == Constants.BY_HOUR)
			{
				statistics = InitStatisticsByHourOfDay();
			}
			else if (byWhat == Constants.BY_DAY)
			{
				DateTime.TryParseExact(startDay, Constants.MMDDYYYY, CultureInfo.InvariantCulture, DateTimeStyles.None, out startDate);
				DateTime.TryParseExact(endDay, Constants.MMDDYYYY, CultureInfo.InvariantCulture, DateTimeStyles.None, out endDate);
				statistics = InitStatisticsByDay(startDate, endDate);
			}
			else if (byWhat == Constants.BY_WEEK)
			{
				DateTime.TryParseExact(startDay, Constants.MMDDYYYY, CultureInfo.InvariantCulture, DateTimeStyles.None, out startDate);
				DateTime.TryParseExact(endDay, Constants.MMDDYYYY, CultureInfo.InvariantCulture, DateTimeStyles.None, out endDate);
				statistics = InitStatisticsByWeek(startDate, endDate);
			}
			else if (byWhat == Constants.BY_MONTH)
			{
				DateTime.TryParseExact(startDay, Constants.MMYYYY, CultureInfo.InvariantCulture, DateTimeStyles.None, out startDate);
				DateTime.TryParseExact(endDay, Constants.MMYYYY, CultureInfo.InvariantCulture, DateTimeStyles.None, out endDate);
				statistics = InitStatisticsByMonth(startDate, endDate);
				startDay = startDate.ToString();
				endDay = endDate.AddMonths(1).AddDays(-1).ToString(); // last day of month
			}

			pageCounts = this.repository.GetPageCount(byWhat, startDay, endDay);
			var combined = from s in statistics
							   let pc = (from pc in pageCounts
										where pc.TimeSpan == s.TimeSpan
							            select pc).SingleOrDefault()
						       select pc ?? s;

			return combined.ToList();
		}

		private List<Statistic> InitStatisticsByHourOfDay()
		{
			var statistics = new List<Statistic>();

			for (int i = 0; i < 24; i++)
			{
				var s = new Statistic();
				string from = "";
				string to = "";

				if (i < 10)
				{
					from = "0" + i + ":00";
					if (i < 9)
					{
						to = "0" + (i + 1) + ":00";
					}
					else
					{
						to = (i + 1) + ":00";
					}
				}
				else
				{
					from = i.ToString() + ":00";
					to = (i + 1) + ":00";
				}
				s.TimeSpan = from + " - " + to;
				statistics.Add(s);
			}

			return statistics;
		}

		private List<Statistic> InitStatisticsByDay(DateTime startDate, DateTime endDate)
		{
			var statistics = new List<Statistic>();
			for (DateTime date = startDate; date <= endDate; date = date.AddDays(1))
			{
				var s = new Statistic();
				s.TimeSpan = date.ToString(Constants.MMDDYYYY);
				statistics.Add(s);
			}
			return statistics;
		}

		private List<Statistic> InitStatisticsByWeek(DateTime startDate, DateTime endDate)
		{
			var statistics = new List<Statistic>();
			for (DateTime date = startDate; date <= endDate; date = date.AddDays(7))
			{
				var s = new Statistic();
				var currentSaturday = date.AddDays(6);
				s.TimeSpan = date.ToString(Constants.MMDDYYYY) + " - " + currentSaturday.ToString(Constants.MMDDYYYY);
				statistics.Add(s);
			}
			return statistics;
		}

		private List<Statistic> InitStatisticsByMonth(DateTime startDate, DateTime endDate)
		{
			var statistics = new List<Statistic>();
			for (DateTime date = startDate; date <= endDate; date = date.AddMonths(1))
			{
				var s = new Statistic();
				s.TimeSpan = date.ToString(Constants.MMYYYY);
				statistics.Add(s);
			}
			return statistics;
		}
	}
}
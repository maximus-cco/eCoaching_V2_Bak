using eCLAdmin.Models.EclSiteUsage;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
	public class EclSiteUsageRepository : IEclSiteUsageRepository
	{
		readonly ILog logger = LogManager.GetLogger(typeof(UserRepository));
		string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

		public IList<Statistic> GetPageCount(string byWhat, string startDate, string endDate)
		{
			IList<Statistic> statistics = new List<Statistic>();
			string spName = GetStoredProcedureName(byWhat);
			try
			{
				using (SqlConnection connection = new SqlConnection(conn))
				using (SqlCommand command = new SqlCommand(spName, connection))
				{
					command.CommandType = System.Data.CommandType.StoredProcedure;
					if (byWhat == Constants.BY_HOUR)
					{
						command.Parameters.AddWithValue("@whichDay", startDate);
					}
					else
					{
						command.Parameters.AddWithValue("@startDay", startDate);
						command.Parameters.AddWithValue("@endDay", endDate);
					}
					// output parameters
					SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
					retCodeParam.Direction = ParameterDirection.Output;
					SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.NVarChar, 250);
					retMsgParam.Direction = ParameterDirection.Output;

					connection.Open();

					using (SqlDataReader dataReader = command.ExecuteReader())
					{
						while (dataReader.Read())
						{
							var s = new Statistic();
							s.TimeSpan = dataReader["TimeSpan"].ToString();
							s.TimeSpanXLabel = s.TimeSpan;
							// Hits
							s.TotalHitsHistorical = dataReader["HistoricalDashboardHits"].ToString() == ""? 0 : Convert.ToInt32(dataReader["HistoricalDashboardHits"].ToString());
							s.TotalHitsMyDashboard = dataReader["MyDashboardHits"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["MyDashboardHits"].ToString());
							s.TotalHitsNewSubmission = dataReader["NewSubmissionHits"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["NewSubmissionHits"].ToString());
							s.TotalHitsReview = dataReader["ReviewHits"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["ReviewHits"].ToString());
							// Users
							s.TotalUsersHistorical = dataReader["HistoricalDashboardUsers"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["HistoricalDashboardUsers"].ToString());
							s.TotalUsersMyDashboard = dataReader["MyDashboardUsers"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["MyDashboardUsers"].ToString());
							s.TotalUsersNewSubmission = dataReader["NewSubmissionUsers"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["NewSubmissionUsers"].ToString());
							s.TotalUsersReview = dataReader["ReviewUsers"].ToString() == "" ? 0 : Convert.ToInt32(dataReader["ReviewUsers"].ToString());

							statistics.Add(s);
						} // end while
					} // end using SqlDataReader

					int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
					string retMsg = command.Parameters["@returnMessage"].Value.ToString();
					if (retCode != 0)
					{
						var errorMsg = string.Format("{0}: return Code=", retMsg, retCode);
						throw new Exception(errorMsg);
					}
				} // end using SqlCommand
			}
			catch (Exception ex)
			{
				logger.Debug("Exception thrown: " + ex.Message);
				throw ex;
			}

			return statistics;
		}

		private string GetStoredProcedureName(string byWhat)
		{
			var spName = "[EC].[sp_GetPageCountByHourOfDay]"; // Default to by hour of day
			if (byWhat == "D")
			{
				spName = "[EC].[sp_GetPageCountByDay]";
			}
			else if (byWhat == "W")
			{
				spName = "[EC].[sp_GetPageCountByWeek]";
			}
			else if (byWhat == "M")
			{
				spName = "[EC].[sp_GetPageCountByMonth]";
			}

			return spName;
		}
	}
}
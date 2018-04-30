using eCoachingLog.Models.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class SiteRepository : ISiteRepository
    {
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public List<Site> GetAllSites()
        {
            var sites = new List<Site>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Sites_For_Dashboard]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
				connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Site site = new Site();
                        site.Id = Convert.ToInt32(dataReader["SiteID"]);
                        site.Name = dataReader["Site"].ToString();

                        sites.Add(site);
                    }
                }
            }

            return sites;
        }
    }
}
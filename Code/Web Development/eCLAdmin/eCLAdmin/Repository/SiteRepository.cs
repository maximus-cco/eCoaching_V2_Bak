using eCLAdmin.Models;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class SiteRepository : ISiteRepository
    {
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public List<Site> GetSites()
        {
            var sites = new List<Site>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("select distinct * from ec.DIM_Site where city != 'unknown' and isActive = 1 order by city", connection))
            {
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Site site = new Site();
                        site.Id = dataReader["SiteID"].ToString();
                        site.Name = dataReader["City"].ToString();

                        sites.Add(site);
                    }
                }
            }

            return sites;
        }
    }
}
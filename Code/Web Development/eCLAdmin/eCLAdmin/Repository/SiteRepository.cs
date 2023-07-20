using eCLAdmin.Extensions;
using eCLAdmin.Models;
using System.Collections.Generic;
using System.Data;
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

        public List<Site> GetSites(string userId)
        {
            var sites = new List<Site>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Sites_By_User]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@nvcEmpLanIDin", userId);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Site site = new Site();
                        site.Id = dataReader["SiteID"].ToString();
                        site.Name = dataReader["Site"].ToString();

                        sites.Add(site);
                    }
                    dataReader.Close();
                }
            }

            return sites;
        }

        public List<Site> GetSiteForHierarchyRpt()
        {
            var sites = new List<Site>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptHierarchySites]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Site site = new Site();
                        site.Id = dataReader["Site"].ToString();
                        site.Name = dataReader["Site"].ToString();

                        sites.Add(site);
                    }
                    dataReader.Close();
                }
            }

            return sites;
        }

        public List<Site> GetSiteForReport(string userId, int moduleId)
        {
            var sites = new List<Site>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptSitesByRole]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@LanID", userId);
                command.Parameters.AddWithValueSafe("@intModulein", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Site site = new Site();
                        site.Id = dataReader["SiteID"].ToString();
                        site.Name = dataReader["Site"].ToString();

                        sites.Add(site);
                    }
                    dataReader.Close();
                }
            }

            return sites;
        }
    }
}
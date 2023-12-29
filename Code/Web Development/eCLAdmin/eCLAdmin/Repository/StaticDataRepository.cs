using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Utilities;
using log4net;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class StaticDataRepository : IStaticDataRepository
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(StaticDataRepository));
        private string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public string Get(string key)
        {
            string data = null;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectRequestedUrl]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strName", key);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        data = dataReader["url"].ToString();
                        break;
                    }

                    dataReader.Close();
                }
            }

            return data;
        }
    }
}

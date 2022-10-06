using eCoachingLog.Extensions;
using eCoachingLog.Utils;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;


namespace eCoachingLog.Repository
{
    public class StaticDataRepository : IStaticDataRepository
    {
        private static string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public string GetData(string key)
        {
            string data = null;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectRequestedUrl]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@strName", key);
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
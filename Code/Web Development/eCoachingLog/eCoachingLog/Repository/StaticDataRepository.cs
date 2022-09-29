using eCoachingLog.Utils;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;


namespace eCoachingLog.Repository
{
    public class StaticDataRepository : IStaticDataRepository
    {
        private static string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public IList<string> GetData(string key)
        {
            var data = new List<string>();

            //using (SqlConnection connection = new SqlConnection(conn))
            //using (SqlCommand command = new SqlCommand("[EC].[sp_Select_StaticData]", connection))
            //{
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
            //    connection.Open();
            //    using (SqlDataReader dataReader = command.ExecuteReader())
            //    {
            //        while (dataReader.Read())
            //        {
            //            data.Add(dataReader["data"].ToString());
            //        }

            //        dataReader.Close();
            //    }
            //}

            data.Add(Constants.SUBMIT_TICKET_URL);

            return data;
        }
    }
}
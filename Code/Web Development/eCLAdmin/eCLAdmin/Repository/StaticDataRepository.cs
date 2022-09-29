using log4net;
using System.Collections.Generic;

namespace eCLAdmin.Repository
{
    public class StaticDataRepository : IStaticDataRepository
    {
        readonly ILog logger = LogManager.GetLogger(typeof(EmployeeRepository));
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public IList<string> GetData(string key)
        {
            var data = new List<string>();

            //using (SqlConnection connection = new SqlConnection(conn))
            //using (SqlCommand command = new SqlCommand("[EC].[sp_Select_StaticData]", connection))
            //{B
            //    command.CommandType = CommandType.StoredProcedure;
            //    command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
            //    connection.Open();
            //    using (SqlDataReader dataReader = command.ExecuteReader())
            //    {
            //        while (dataReader.Read())B
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
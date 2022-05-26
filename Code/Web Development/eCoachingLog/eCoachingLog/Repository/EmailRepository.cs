using eCoachingLog.Extensions;
using eCoachingLog.Models.Common;
using eCoachingLog.Utils;
using log4net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
    public class EmailRepository : IEmailRepository
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private static readonly string connString = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public void Store(List<Mail> mailList)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand comm = new SqlCommand("[EC].[sp_SaveEmail]", conn)) // todo: check sp name
            {
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                // todo: add input parameters
                comm.Parameters.AddMailTableType("@table", mailList); // todo: when sp is ready, check parameter name

                conn.Open();
                comm.ExecuteNonQuery();
            }
        }

    }
}
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

        public void Store(List<Mail> mailList, string userId, string mailSource)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand comm = new SqlCommand("[EC].[sp_InsertInto_Email_Notifications_Stage]", conn))
            {
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                comm.Parameters.AddMailStageTableType("@tableRecs", mailList);
                comm.Parameters.AddWithValueSafe("@nvcMailType", mailSource);
                comm.Parameters.AddWithValueSafe("@nvcUserID", userId);


                conn.Open();
                comm.ExecuteNonQuery();
            }
        }

    }
}
using eCLAdmin.Extensions;
using eCLAdmin.Models;
using log4net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class EmailRepository : IEmailRepository
    {
        readonly ILog logger = LogManager.GetLogger(typeof(EmployeeRepository));
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public void Store(List<Email> mailList, string mailSource, string userId)
        {
            using (SqlConnection connection = new SqlConnection(connStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Email_Notifications_Stage]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddMailStageTableType("@tableRecs", mailList);
                command.Parameters.AddWithValue("@nvcMailType", mailSource);
                command.Parameters.AddWithValue("@nvcUserID", userId);


                connection.Open();
                command.ExecuteNonQuery();
            }
        }
    }
}
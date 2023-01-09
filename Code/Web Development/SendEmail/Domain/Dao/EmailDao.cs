using log4net;
using SendEmail.Domain.Model;
using SendEmail.Extension;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
namespace SendEmail.Domain.Dao
{
    class EmailDao
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private static readonly string connString = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        private const int SQL_COMMAND_TIMEOUT = 300; // 5 minutes
        private const int SYSTEM_ID = 999999;

        public IEnumerable<Email> GetEmailList()
        {
            logger.Debug($"Database connection [{connString}]...");

            var emailList = new List<Email>();

            using (SqlConnection connection = new SqlConnection(connString))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Get_Staged_Notifications]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = SQL_COMMAND_TIMEOUT;
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var temp = new Email();
                        temp.MailId = dataReader["MailID"].ToString();
                        temp.MailType = dataReader["MailType"].ToString();
                        temp.LogId = dataReader["LogID"].ToString();
                        temp.LogName = dataReader["LogName"].ToString();
                        temp.From = dataReader["From"].ToString();
                        temp.FromDisplayName = dataReader["FromDisplayName"].ToString();
                        temp.To = dataReader["To"].ToString();
                        temp.Cc = dataReader["Cc"].ToString();
                        temp.Subject = dataReader["Subject"].ToString();
                        temp.Body = dataReader["Body"].ToString();
                        temp.IsHtml = (bool)dataReader["IsHtml"];

                        emailList.Add(temp);
                    }

                    dataReader.Close();
                }
            }

            return emailList;
        }

        public void SaveResult(IList<Result> results)
        {
            logger.Debug("Entered SaveResult...");

            using (SqlConnection connection = new SqlConnection(connString))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Email_Notifications_History]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = SQL_COMMAND_TIMEOUT;
                command.Parameters.AddMailHistoryTableType("@tableRecs", results);
                command.Parameters.AddWithValueSafe("@nvcUserID", SYSTEM_ID);

                try
                {
                    connection.Open();
                    int rowsUpdated = command.ExecuteNonQuery();
                    logger.Debug("rows updated=" + rowsUpdated);
                    if (rowsUpdated == 0)
                    {
                        throw new Exception("Failed to save sending email results.");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error(ex);
                }
            }

        } // end public void SaveResult(List<Result> results)

    }
}

using log4net;
using SendEmail.Domain.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace SendEmail.Extension
{
    public static class SqlExtension
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static SqlParameter AddWithValueSafe(this SqlParameterCollection parameters, string parameterName, object value)
        {
            return parameters.AddWithValue(parameterName, value ?? DBNull.Value);
        }

        public static SqlParameter AddMailHistoryTableType(this SqlParameterCollection target, string name, IList<Result> mailResults)
        {
            logger.Debug("Entered AddMailHistoryTableType... " + mailResults.Count);

            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("LogId", typeof(int));
            dataTable.Columns.Add("LogName", typeof(string));
            dataTable.Columns.Add("To", typeof(string));
            dataTable.Columns.Add("Cc", typeof(string));
            dataTable.Columns.Add("SendAttemptDate", typeof(string));
            dataTable.Columns.Add("Success", typeof(bool));

            foreach (var mr in mailResults)
            {
                dataTable.Rows.Add(mr.LogId, mr.LogName, mr.To, mr.Cc, mr.SentDateTime, mr.IsSuccess);
            }

            //foreach (DataRow row in dataTable.Rows)
            //{
            //    foreach (DataColumn dc in dataTable.Columns)
            //    {
            //        logger.Debug(row[dc].ToString());
            //    }
            //}

            SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
            sqlParameter.SqlDbType = SqlDbType.Structured;
            sqlParameter.TypeName = "EC.MailHistoryTableType"; // User Defined Type name in DB

            return sqlParameter;
        }
    }
}

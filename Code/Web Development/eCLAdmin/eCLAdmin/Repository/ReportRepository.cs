using eCLAdmin.Extensions;
using eCLAdmin.Models.Report;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class ReportRepository : IReportRepository
    {
        readonly ILog logger = LogManager.GetLogger(typeof(ReportRepository));
        string connectionStr = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public List<eCLAdmin.Models.EmployeeLog.Action> GetActions(string logType)
        {
            var actions = new List<eCLAdmin.Models.EmployeeLog.Action>();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptGetActionsforAdminType]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strTypein", logType);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 250);
                retMsgParam.Direction = ParameterDirection.Output;

                connection.Open();

                int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
                string retMessage = command.Parameters["@returnMessage"].Value == null ? "no return message" : command.Parameters["@returnMessage"].Value.ToString();

                if (retCode != 0)
                {
                    throw new Exception("[sp_rptGetActionsforAdminType] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    int id = 0;
                    while (dataReader.Read())
                    {
                        id++;
                        var action = new eCLAdmin.Models.EmployeeLog.Action(id, dataReader["Action"].ToString());
                        actions.Add(action);
                    }
                    // https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldatareader.close?view=netframework-4.8
                    dataReader.Close();
                }
            }

            return actions;
        }

        public List<string> GetLogNames(string logType, string action, string startDate, string endDate)
        {
            var logNames = new List<string>();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptGetFormNamesforAdminActivity]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strTypein", logType);
                command.Parameters.AddWithValueSafe("@strActivityin", action);
                command.Parameters.AddWithValueSafe("@strSDatein", startDate);
                command.Parameters.AddWithValueSafe("@strEDatein", endDate);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 250);
                retMsgParam.Direction = ParameterDirection.Output;

                connection.Open();

                int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
                string retMessage = command.Parameters["@returnMessage"].Value == null ? "no return message" : command.Parameters["@returnMessage"].Value.ToString();

                if (retCode != 0)
                {
                    throw new Exception("[sp_rptGetFormNamesforAdminActivity] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        logNames.Add(dataReader["Form Name"].ToString());
                    }
                    dataReader.Close();
                }
            }

            return logNames;
        }

        public List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName,
            int pageSize, int rowStartIndex, out int totalRows)
        {
            var activityList = new List<AdminActivity>();
            totalRows = 0;
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[a_Lili_sp_rptAdminActivitySummary]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strTypein", logType);
                command.Parameters.AddWithValueSafe("@strActivityin", action);
                command.Parameters.AddWithValueSafe("@strFormin", logName);
                command.Parameters.AddWithValueSafe("@strSearchin", logOrEmpName);
                command.Parameters.AddWithValueSafe("@strSDatein", startDate);
                command.Parameters.AddWithValueSafe("@strEDatein", endDate);
                command.Parameters.AddWithValueSafe("@PageSize", pageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", rowStartIndex);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 250);
                retMsgParam.Direction = ParameterDirection.Output;

                connection.Open();

                int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
                string retMessage = command.Parameters["@returnMessage"].Value == null ? "no return message" : command.Parameters["@returnMessage"].Value.ToString();

                if (retCode != 0)
                {
                    throw new Exception("[sp_rptAdminActivitySummary] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        totalRows = (int)dataReader["TotalRows"];

                        var activity = new AdminActivity();
                        activity.ModuleId = (int)dataReader["Module ID"];
                        activity.LogName = dataReader["Form Name"].ToString();
                        activity.ModuleName = dataReader["Module Name"].ToString();
                        activity.LastKnownStatus = dataReader["Last Known Status"].ToString();
                        activity.Action = dataReader["Action"].ToString();
                        activity.ActionDate = dataReader["Action Date"].ToString();
                        activity.RequesterId = dataReader["Requester ID"].ToString();
                        activity.RequesterName = dataReader["Requester Name"].ToString();
                        activity.AssignedToId = dataReader["Assigned To ID"].ToString();
                        activity.AssignedToName = dataReader["Assigned To Name"].ToString();
                        activity.Reason = dataReader["Reason"].ToString();
                        activity.RequesterComments = dataReader["Requester Comments"].ToString();

                        activityList.Add(activity);
                    }
                    dataReader.Close();
                }
            }

            return activityList;
        }

        public DataSet GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName)
        {
            DataSet dt = new DataSet();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[a_Lili_sp_rptAdminActivitySummary]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strTypein", logType);
                command.Parameters.AddWithValueSafe("@strActivityin", action);
                command.Parameters.AddWithValueSafe("@strFormin", logName);
                command.Parameters.AddWithValueSafe("@strSearchin", logOrEmpName);
                command.Parameters.AddWithValueSafe("@strSDatein", startDate);
                command.Parameters.AddWithValueSafe("@strEDatein", endDate);
                command.Parameters.AddWithValueSafe("@PageSize", Int32.MaxValue - 1);
                command.Parameters.AddWithValueSafe("@startRowIndex", 1);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 250);
                retMsgParam.Direction = ParameterDirection.Output;

                connection.Open();

                using (SqlDataAdapter sda = new SqlDataAdapter(command))
                {
                    sda.Fill(dt);
                }
            }
            return dt;
        }

    }
}

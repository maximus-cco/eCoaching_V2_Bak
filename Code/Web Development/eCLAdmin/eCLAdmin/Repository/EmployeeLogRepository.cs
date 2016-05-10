using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Utilities;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class EmployeeLogRepository : IEmployeeLogRepository
    {
        readonly ILog logger = LogManager.GetLogger(typeof(EmployeeLogRepository));

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public List<Module> GetModules(string userLanId)
        {
            var modules = new List<Module>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Modules_By_LanID]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@nvcEmpLanIDin", userLanId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Module module = new Module();
                        module.Id = (int)dataReader["ModuleId"];
                        module.Name = dataReader["Module"].ToString();

                        modules.Add(module);
                    }
                }
            }

            return modules;
        }

        public List<Status> GetPendingStatuses(int moduleId)
        {
            List<Status> statuses = new List<Status>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Status_By_Module]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIdin", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Status status = new Status();
                        status.Id = (int)dataReader["StatusId"];
                        status.Description = dataReader["Status"].ToString();

                        statuses.Add(status);
                    }
                }
            }

            return statuses;
        }

        public List<EmployeeLog> GetLogsByEmpIdAndAction(int logTypeId, string employeeId, string action)
        {
            string logType = EclAdminUtil.GetLogTypeNameById(logTypeId);
            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Logs_Inactivation_Reactivation]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strTypein", logType);
                command.Parameters.AddWithValue("@strActionin", action);
                command.Parameters.AddWithValue("@strEmployeein", employeeId);

                logger.Debug("typein=" + logType);
                logger.Debug("action=" + action);
                logger.Debug("empId=" + employeeId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        EmployeeLog cl = new EmployeeLog();
                        cl.ID = (long) dataReader["LogID"];
                        cl.FormName = dataReader["strFormName"].ToString();
                        cl.EmployeeName = dataReader["strEmpName"].ToString();
                        cl.SupervisorName = dataReader["strSupName"].ToString();
                        cl.ManagerName = dataReader["strMgrName"].ToString();
                        cl.Status = dataReader["Status"].ToString();
                        //cl.StatusId = (int)dataReader["StatusID"];
                        if (action.Equals(Constants.LOG_ACTION_REACTIVATE))
                        {
                            cl.PreviousStatusId = (int)dataReader["LastKnownStatus"];
                        }
                        cl.CreatedDate = dataReader["strCreatedDate"].ToString();

                        employeeLogs.Add(cl);
                    }
                }
            }
            
            return employeeLogs;
        }

        public List<EmployeeLog> GetPendingLogsByReviewerEmpId(int moduleId, int statusId, string reviewerEmpId)
        {
            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Logs_Reassign]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIdin", moduleId);
                command.Parameters.AddWithValue("@istrOwnerin", reviewerEmpId);
                command.Parameters.AddWithValue("@intStatusIdin", statusId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        EmployeeLog cl = new EmployeeLog();
                        cl.ID = (long)dataReader["CoachingID"];
                        cl.FormName = dataReader["strFormName"].ToString();
                        cl.EmployeeName = dataReader["strEmpName"].ToString();
                        cl.SupervisorName = dataReader["strSupName"].ToString();
                        cl.ManagerName = dataReader["strMgrName"].ToString();
                        cl.Status = dataReader["Status"].ToString();
                        //cl.StatusId = (int)dataReader["StatusID"];
                        cl.CreatedDate = dataReader["strCreatedDate"].ToString();

                        employeeLogs.Add(cl);
                    }
                }
            }

            return employeeLogs;
        }

        public List<Reason> GetReasons(int logTypeId, string action)
        {
            string logType = EclAdminUtil.GetLogTypeNameById(logTypeId);
            var reasons = new List<Reason>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Action_Reasons]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strType", logType);
                command.Parameters.AddWithValue("@strAction", action);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Reason reason = new Reason();
                        reason.Id = (int)dataReader["ReasonID"];
                        reason.Description = dataReader["Reason"].ToString();

                        reasons.Add(reason);
                    }
                }
            }
  
            return reasons;
        }

        public void ProcessActivation(string userLanId, string action, int employeeLogType, List<long> employeeLogIds, int reasonId, string otherReasonText, string comment)
        {
            string storedProcedureName = "[EC].[sp_AT_Coaching_Inactivation_Reactivation]";

            if ((int)EmployeeLogType.Warning == employeeLogType)
            {
                storedProcedureName = "[EC].[sp_AT_Warning_Inactivation_Reactivation]";
            }

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;

                command.Parameters.AddWithValue("@strRequesterLanId", userLanId);
                command.Parameters.AddWithValue("@strAction", action);
                command.Parameters.AddIdsTableType("@tableIds", employeeLogIds);
                command.Parameters.AddWithValue("@intReasonId", reasonId);
                command.Parameters.AddWithValue("@strReasonOther", otherReasonText);
                command.Parameters.AddWithValue("@strComments", comment);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 30);
                retMsgParam.Direction = ParameterDirection.Output;

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();

                    int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
                    string retMsg = command.Parameters["@returnMessage"].Value.ToString();

                    if (retCode != 0)
                    {
                        throw new Exception("Exception thrown: " + retMsg);
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public void ProcessReassignment(string userLanId, List<long> employeeLogIds, string assignedToEmployeeId, int reasonId, string otherReasonText, string comment)
        {
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Coaching_Reassignment]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;

                command.Parameters.AddWithValue("@strRequesterLanId", userLanId);
                command.Parameters.AddIdsTableType("@tableIds", employeeLogIds);
                command.Parameters.AddWithValue("@strAssignedId", assignedToEmployeeId);
                command.Parameters.AddWithValue("@intReasonId", reasonId);
                command.Parameters.AddWithValue("@strReasonOther", otherReasonText);
                command.Parameters.AddWithValue("@strComments", comment);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 30);
                retMsgParam.Direction = ParameterDirection.Output;

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();

                    int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
                    string retMsg = command.Parameters["@returnMessage"].Value.ToString();

                    if (retCode != 0)
                    {
                        throw new Exception("Exception thrown: " + retMsg);
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }
    }
}
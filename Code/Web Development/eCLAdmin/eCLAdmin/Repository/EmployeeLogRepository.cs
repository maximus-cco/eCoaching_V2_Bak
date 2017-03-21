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

        public List<Module> GetModules(string userLanId, int logTypeId)
        {
            var modules = new List<Module>();
            string logType = EclAdminUtil.GetLogTypeNameById(logTypeId);

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Modules_By_LanID]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@nvcEmpLanIDin", userLanId);
                command.Parameters.AddWithValue("@strTypein", logType);

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

        public List<EmployeeLog> GetLogsByEmpIdAndAction(int moduleId, int logTypeId, string employeeId, string action)
        {
            string logType = EclAdminUtil.GetLogTypeNameById(logTypeId);
            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Logs_Inactivation_Reactivation]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIdin", moduleId);
                command.Parameters.AddWithValue("@strTypein", logType);
                command.Parameters.AddWithValue("@strActionin", action);
                command.Parameters.AddWithValue("@strEmployeein", employeeId);

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
                        cl.SubmitterName = dataReader["strSubmitter"].ToString();
                        //cl.StatusId = (int)dataReader["StatusID"];
                        if (string.Equals(action, Constants.LOG_ACTION_REACTIVATE, StringComparison.OrdinalIgnoreCase))
                        {
                            cl.PreviousStatusId = (int)dataReader["LastKnownStatus"];
                            cl.Status = dataReader["LKStatus"].ToString();
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
                        cl.SubmitterName = dataReader["strSubmitter"].ToString();
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


        public List<EmployeeLog> GetLogsByLogName(string logName)
        {
            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();

            if (String.IsNullOrWhiteSpace(logName))
            {
                return employeeLogs;
            }

            logName = logName.Trim().Replace("'", "''");
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectReviewFrom_Coaching_Log_For_Delete]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strFormIDin", logName);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        EmployeeLog cl = new EmployeeLog();
                        cl.ID = (long)dataReader["CoachingID"];
                        cl.FormName = dataReader["FormName"].ToString();
                        cl.EmployeeLanId = dataReader["EmpLanID"].ToString();
                        cl.EmployeeId = dataReader["EmpID"].ToString();
                        //cl.Source = dataReader["SourceID"].ToString();
                        // TODO: get it from database
                        cl.IsCoaching = dataReader["isCoaching"].ToString() == "1" ? true : false ;

                        employeeLogs.Add(cl);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return employeeLogs;
        }

        public CoachingLogDetail GetCoachingDetail(long logId)
        {
            CoachingLogDetail logDetail = new CoachingLogDetail();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Review]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intFormIDin", logId);
                command.Parameters.AddWithValue("@bitisCoaching", true);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        logDetail.LogId = (long)dataReader["numID"];
                        logDetail.FormName = dataReader["strFormID"].ToString();
                        logDetail.Source = dataReader["strSource"].ToString();
                        logDetail.Status = dataReader["strFormStatus"].ToString();
                        logDetail.Type = dataReader["strFormType"].ToString();
                        logDetail.CreatedDate = EclAdminUtil.AppendPdt(dataReader["SubmittedDate"].ToString());
                        logDetail.CoachingDate = EclAdminUtil.AppendPdt(dataReader["CoachingDate"].ToString());
                        logDetail.EventDate = EclAdminUtil.AppendPdt(dataReader["EventDate"].ToString());
                        logDetail.SubmitterName = dataReader["strSubmitterName"].ToString();
                        logDetail.EmployeeName = dataReader["strCSRName"].ToString();
                        logDetail.EmployeeSite = dataReader["strCSRSite"].ToString();

                        logDetail.IsVerintMonitor = Convert.ToBoolean(dataReader["isVerintMonitor"].ToString());
                        logDetail.VerintId = dataReader["strVerintID"].ToString();
                        logDetail.VerintFormName = dataReader["VerintFormName"].ToString();
                        logDetail.CoachingMonitor = dataReader["isCoachingMonitor"].ToString();

                        logDetail.IsBehaviorAnalyticsMonitor = Convert.ToBoolean(dataReader["isBehaviorAnalyticsMonitor"].ToString());
                        logDetail.BehaviorAnalyticsId = dataReader["strBehaviorAnalyticsID"].ToString();

                        logDetail.IsNgdActivityId = Convert.ToBoolean(dataReader["isNGDActivityID"].ToString());
                        logDetail.NgdActivityId = dataReader["strNGDActivityID"].ToString();

                        logDetail.IsUcid = Convert.ToBoolean(dataReader["isUCID"].ToString());
                        logDetail.Ucid = dataReader["strUCID"].ToString();

                        logDetail.SupervisorName = dataReader["strCSRSupName"].ToString();
                        logDetail.ReassignedSupervisorName = dataReader["strReassignedSupName"].ToString();
                        logDetail.ManagerName = dataReader["strCSRMgrName"].ToString();
                        logDetail.ReassignedManagerName = dataReader["strReassignedMgrName"].ToString();

                        logDetail.Reasons = dataReader["strCoachingReason"].ToString();
                        logDetail.SubReasons = dataReader["strSubCoachingReason"].ToString();
                        logDetail.Value = dataReader["strValue"].ToString();

                        logDetail.CoachingNotes = dataReader["txtCoachingNotes"].ToString();
                        logDetail.Behavior = dataReader["txtDescription"].ToString();

                        logDetail.MgrNotes = dataReader["txtMgrNotes"].ToString();

                        logDetail.EmployeeComments = dataReader["txtCSRComments"].ToString();
                        logDetail.EmployeeReviewDate = EclAdminUtil.AppendPdt(dataReader["CSRReviewAutoDate"].ToString());

                        logDetail.SupReviewedAutoDate = EclAdminUtil.AppendPdt(dataReader["SupReviewedAutoDate"].ToString());
                        logDetail.MgrReviewAutoDate = EclAdminUtil.AppendPdt(dataReader["MgrReviewAutoDate"].ToString());

                        logDetail.ReviewedSupervisorName = dataReader["strreviewsup"].ToString();
                        logDetail.ReviewedManagerName = dataReader["strreviewmgr"].ToString();
                        break;
                    }
                }
            }

            return logDetail;
        }

        public WarningLogDetail GetWarningDetail(long logId)
        {
            WarningLogDetail logDetail = new WarningLogDetail();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Review]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intFormIDin", logId);
                command.Parameters.AddWithValue("@bitisCoaching", false);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        logDetail.LogId = (long)dataReader["numID"];
                        logDetail.FormName = dataReader["strFormID"].ToString();
                        logDetail.Source = dataReader["strSource"].ToString();
                        logDetail.Status = dataReader["strFormStatus"].ToString();
                        logDetail.Type = dataReader["strFormType"].ToString();
                        logDetail.CreatedDate = EclAdminUtil.AppendPdt(dataReader["SubmittedDate"].ToString());
                        logDetail.EventDate = EclAdminUtil.AppendPdt(dataReader["warningDate"].ToString());
                        logDetail.SubmitterName = dataReader["strSubmitterName"].ToString();
                        logDetail.EmployeeName = dataReader["strCSRName"].ToString();
                        logDetail.EmployeeSite = dataReader["strCSRSite"].ToString();

                        logDetail.SupervisorName = dataReader["strCSRSupName"].ToString();
                        logDetail.ManagerName = dataReader["strCSRMgrName"].ToString();

                        logDetail.Reasons = dataReader["strCoachingReason"].ToString();
                        logDetail.SubReasons = dataReader["strSubCoachingReason"].ToString();
                        logDetail.Value = dataReader["strValue"].ToString();

                        break;
                    }
                }
            }

            return logDetail;
        }

        public bool Delete(long logId, bool isCoaching)
        {
            bool retVal = false;
            string sqlDeleteReason = "delete from [ec].[Coaching_Log_Reason] where [CoachingID] = @logId";
            string sqlDeleteLog = "delete from [ec].[Coaching_Log] where [CoachingID] = @logId";
            if (!isCoaching)
            {
                sqlDeleteReason = "delete from [ec].[Warning_Log_Reason] where [WarningID] = @logId";
                sqlDeleteLog = "delete from [ec].[Warning_Log] where [WarningID] = @logId";
            }

            SqlConnection connection = null;
            SqlTransaction transaction = null;
            try
            {
                connection = new SqlConnection(conn);
                connection.Open();
                transaction = connection.BeginTransaction();

                // Delete from coaching_log_reason/warning_log_reason table
                SqlCommand deleteReasonCommand = new SqlCommand(sqlDeleteReason, connection, transaction);
                deleteReasonCommand.Parameters.Add("@logId", SqlDbType.Int);
                deleteReasonCommand.Parameters["@logId"].Value = logId;
                deleteReasonCommand.ExecuteNonQuery();

                // Delete from coaching_log/warning_log table
                SqlCommand deleteLogCommand = new SqlCommand(sqlDeleteLog, connection, transaction);
                deleteLogCommand.Parameters.Add("@logId", SqlDbType.Int);
                deleteLogCommand.Parameters["@logId"].Value = logId;
                deleteLogCommand.ExecuteNonQuery();

                transaction.Commit();
                retVal = true;
            }
            catch (Exception ex)
            {
                string logType = isCoaching ? "Coaching" : "Warning";
                logger.Info("Failed to delete " + logType + " log [" + logId + "]. Exception: " + ex.Message);

                transaction.Rollback();
            }
            finally
            {
                if (connection != null)
                {
                    connection.Close();
                }
            }

            return retVal;
        }

    }
}
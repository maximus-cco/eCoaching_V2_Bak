using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.Report;
using eCLAdmin.Models.User;
using eCLAdmin.ViewModels.Reports;
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

        public List<Status> GetWarningLogStates()
        {
            var states = new List<Status>();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_States_For_Dashboard]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Status s = new Status();
                        s.Id = Convert.ToInt16(dataReader["StateValue"]);
                        s.Description = dataReader["StateText"].ToString();
                        states.Add(s);
                    }
                    dataReader.Close();
                }
            }

            return states;
        }

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
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptAdminActivitySummary]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strTypein", logType);
                command.Parameters.AddWithValueSafe("@strActivityin", action);
                command.Parameters.AddWithValueSafe("@strFormin", "All"); // removed Log Name dropdown on the page, so pass "All" always
                command.Parameters.AddWithValueSafe("@strSearchin", logOrEmpName == null ? "" : logOrEmpName);
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
                        activity.ModuleId = (int)dataReader["Employee Level ID"];
                        activity.LogName = dataReader["Form Name"].ToString();
                        activity.ModuleName = dataReader["Employee Level"].ToString();
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
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptAdminActivitySummary]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strTypein", logType);
                command.Parameters.AddWithValueSafe("@strActivityin", action);
                command.Parameters.AddWithValueSafe("@strFormin", "All");
                command.Parameters.AddWithValueSafe("@strSearchin", logOrEmpName == null ? "" : logOrEmpName);
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

        public List<EmployeeHierarchy> GetEmployeeHierarchy(string site, string employeeId, int pageSize, int rowStartIndex, out int totalRows)
        {
            var employeeHierarchyList = new List<EmployeeHierarchy>();
            totalRows = 0;
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptHierarchySummary]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strEmpSitein", site);
                command.Parameters.AddWithValueSafe("@strEmpin", employeeId);
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
                    throw new Exception("[sp_rptHierarchySummary] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        totalRows = (int)dataReader["TotalRows"];

                        var temp = new EmployeeHierarchy();
                        temp.EmployeeId = dataReader["Employee ID"].ToString();
                        temp.EmployeeName = dataReader["Employee Name"].ToString();
                        temp.SiteName = dataReader["Site"].ToString();
                        temp.EmployeeJobCode = dataReader["Employee Job Code"].ToString();
                        temp.EmployeeJobDescription = dataReader["Employee Job Description"].ToString();
                        temp.Program = dataReader["Program"].ToString();
                        temp.SupervisorEmployeeID = dataReader["Supervisor Employee ID"].ToString();
                        temp.SupervisorName = dataReader["Supervisor Name"].ToString();
                        temp.SupervisorJobCode = dataReader["Supervisor Job Code"].ToString();
                        temp.SupervisorJobDescription = dataReader["Supervisor Job Description"].ToString();
                        temp.ManagerEmployeeID = dataReader["Manager Employee ID"].ToString();
                        temp.ManagerName = dataReader["Manager Name"].ToString();
                        temp.ManagerJobCode = dataReader["Manager Job Code"].ToString();
                        temp.ManagerJobDescription = dataReader["Manager Job Description"].ToString();
                        temp.StartDate = dataReader["Start Date"].ToString();
                        temp.EndDate = dataReader["End Date"].ToString();
                        temp.Status = dataReader["Status"].ToString();
                        temp.AspectJobTitle = dataReader["Aspect Job Title"].ToString();
                        temp.AspectSkill = dataReader["Aspect Skill"].ToString();
                        temp.AspectStatus = dataReader["Aspect Status"].ToString();

                        employeeHierarchyList.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return employeeHierarchyList;
        }

        public DataSet GetEmployeeHierarchy(string site, string employeeId)
        {
            DataSet dt = new DataSet();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptHierarchySummary]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@strEmpSitein", site);
                command.Parameters.AddWithValueSafe("@strEmpin", employeeId);
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

        public List<Module> GetEmployeeLevels(User user)
        {
            var levels = new List<Module>();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptModulesByRole]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@LanID", user.EmployeeId);
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
                    throw new Exception("[sp_rptModulesByRole] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var temp = new Module();
                        temp.Id = (int) dataReader["ModuleID"];
                        temp.Name = dataReader["Module"].ToString();
                        levels.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return levels;
        }

        public List<Reason> GetReasonsByModuleId(int moduleId, bool isWarning)
        {
            var reasons = new List<Reason>();
            var storedProcedure = isWarning ? "[EC].[sp_rptWarningReasonByModuleId]" : "[EC].[sp_rptCoachingReasonByModuleId]";
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand(storedProcedure, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModuleId", moduleId);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var temp = new Reason();
                        temp.Id = Int32.Parse(dataReader["ReasonID"].ToString());
                        temp.Description = dataReader["Reason"].ToString();
                        reasons.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return reasons;
        }

        public List<Reason> GetSubreasons(int reasonId, bool isWarning)
        {
            var subreasons = new List<Reason>();
            var storedProcedure = isWarning ? "[EC].[sp_rptWarningSubreason]" : "[EC].[sp_rptCoachingSubreason]";
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand(storedProcedure, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intReasonId", reasonId);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var temp = new Reason();
                        temp.Id = Int32.Parse(dataReader["SubReasonID"].ToString());
                        temp.Description = dataReader["SubReason"].ToString();
                        subreasons.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return subreasons;
        }

        public List<Status> GetLogStatusList(int moduleId, bool isWarning)
        {
            var statusList = new List<Status>();
            var storedProcedure = isWarning ? "[EC].[sp_rptWarningLogStatusByModuleId]" : "[EC].[sp_rptLogStatusByModuleId]";
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand(storedProcedure, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModuleId", moduleId);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var temp = new Status();
                        temp.Id = Int32.Parse(dataReader["StatusID"].ToString());
                        temp.Description = dataReader["Status"].ToString();
                        statusList.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return statusList;
        }

        public List<CoachingLog> GetCoachingLogs(CoachingSearchViewModel search, out int totalRows)
        {
            logger.Debug("****************hireDate=" + search.HireDate);

            var logList = new List<CoachingLog>();
            totalRows = 0;
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptCoachingSummary]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModulein", search.SelectedEmployeeLevel);
                command.Parameters.AddWithValueSafe("@intStatusin", search.SelectedLogStatus);
                command.Parameters.AddWithValueSafe("@intSitein", search.SelectedSite);
                command.Parameters.AddWithValueSafe("@strEmpin", search.SelectedEmployee);
                command.Parameters.AddWithValueSafe("@intCoachReasonin", search.SelectedCoachingReason);
                command.Parameters.AddWithValueSafe("@intSubCoachReasonin", search.SelectedCoachingSubReason);
                command.Parameters.AddWithValueSafe("@strSDatein", search.StartDate);
                command.Parameters.AddWithValueSafe("@strEDatein", search.EndDate);
                // sp is checking hireDate null, not checking empty string, so if hireDate is empty, pass in null
                command.Parameters.AddWithValue("@strHDatein", string.IsNullOrEmpty(search.HireDate) ? null : search.HireDate);
                command.Parameters.AddWithValueSafe("@PageSize", search.PageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", search.RowStartIndex);
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
                    throw new Exception("[sp_rptCoachingSummary] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        if (totalRows == 0)
                        {
                            totalRows = (int)dataReader["TotalRows"];
                        }
                        var temp = new CoachingLog();
                        temp.ModuleId = dataReader["Employee Level ID"].ToString();
                        temp.ModuleName = dataReader["Employee Level Name"].ToString();
                        temp.CoachingID = dataReader["Coaching ID"].ToString();
                        temp.LogName = dataReader["Log Name"].ToString();
                        temp.LogStatus = dataReader["Status"].ToString();
                        temp.EmployeeId = dataReader["Employee ID"].ToString();
                        temp.EmployeeName = dataReader["Employee Name"].ToString();
                        temp.EmployeeHireDate = dataReader["Employee Hire Date"].ToString();
                        temp.SiteName = dataReader["Site"].ToString();
                        temp.SupervisorEmployeeID = dataReader["Supervisor Employee ID"].ToString();
                        temp.SupervisorName = dataReader["Supervisor Name"].ToString();
                        temp.ManagerEmployeeID = dataReader["Manager Employee ID"].ToString();
                        temp.ManagerName = dataReader["Manager Name"].ToString();
                        temp.CurrentSupervisorEmployeeID = dataReader["Current Supervisor Employee ID"].ToString();
                        temp.CurrentSupervisorName = dataReader["Current Supervisor Name"].ToString();
                        temp.CurrentManagerEmployeeID = dataReader["Current Manager Employee ID"].ToString();
                        temp.CurrentManagerName = dataReader["Current Manager Name"].ToString();
                        temp.ReviewSupervisorEmployeeID = dataReader["Review Supervisor Employee ID"].ToString();
                        temp.ReviewSupervisorName = dataReader["Review Supervisor Name"].ToString();
                        temp.ReviewManagerEmployeeID = dataReader["Review Manager Employee ID"].ToString();
                        temp.ReviewManagerName = dataReader["Review Manager Name"].ToString();
                        temp.Description = dataReader["Description"].ToString();
                        temp.CoachingNotes = dataReader["Coaching Notes"].ToString();
                        temp.EventDate = dataReader["Event Date"].ToString();
                        temp.CoachingDate = dataReader["Coaching Date"].ToString();
                        temp.SubmittedDate = dataReader["Submitted Date"].ToString();
                        temp.PFDCompletedDateDate = dataReader["PFD CompletedDate Date"].ToString();
                        temp.CoachingSource = dataReader["Coaching Source"].ToString();
                        temp.SubCoachingSource = dataReader["Sub Coaching Source"].ToString();
                        temp.CoachingReason = dataReader["Coaching Reason"].ToString();
                        temp.SubCoachingSource = dataReader["SubCoaching Reason"].ToString();
                        temp.Value = dataReader["Value"].ToString();
                        temp.SubmitterID = dataReader["Submitter ID"].ToString();
                        temp.SubmitterName = dataReader["Submitter Name"].ToString();
                        temp.SupervisorReviewedDate = dataReader["Supervisor Reviewed Date"].ToString();
                        temp.ManagerReviewedManualDate = dataReader["Manager Reviewed Manual Date"].ToString();
                        temp.ManagerReviewedAutoDate = dataReader["Manager Reviewed Auto Date"].ToString();
                        temp.ManagerNotes = dataReader["Manager Notes"].ToString();
                        temp.EmployeeReviewedDate = dataReader["Employee Reviewed Date"].ToString();
                        temp.EmployeeComments = dataReader["Employee Comments"].ToString();
                        temp.ProgramName = dataReader["ProgramName"].ToString();
                        temp.Behavior = dataReader["Behavior"].ToString();
                        temp.ReportCode = dataReader["Report Code"].ToString();
                        temp.VerintID = dataReader["Verint ID"].ToString();
                        temp.VerintFormName = dataReader["Verint Form Name"].ToString();
                        temp.CoachingMonitor = dataReader["Coaching Monitor"].ToString();

                        logList.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return logList;
        }

        public DataSet GetCoachingLogs(CoachingSearchViewModel search)
        {
            DataSet dt = new DataSet();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptCoachingSummary]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModulein", search.SelectedEmployeeLevel);
                command.Parameters.AddWithValueSafe("@intStatusin", search.SelectedLogStatus);
                command.Parameters.AddWithValueSafe("@intSitein", search.SelectedSite);
                command.Parameters.AddWithValueSafe("@strEmpin", search.SelectedEmployee);
                command.Parameters.AddWithValueSafe("@intCoachReasonin", search.SelectedCoachingReason);
                command.Parameters.AddWithValueSafe("@intSubCoachReasonin", search.SelectedCoachingSubReason);
                command.Parameters.AddWithValueSafe("@strSDatein", search.StartDate);
                command.Parameters.AddWithValueSafe("@strEDatein", search.EndDate);
                // sp is checking hireDate null, not checking empty string, so if hireDate is empty, pass in null
                command.Parameters.AddWithValue("@strHDatein", string.IsNullOrEmpty(search.HireDate) ? null : search.HireDate);
                command.Parameters.AddWithValueSafe("@PageSize", search.PageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", search.RowStartIndex);
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

        public List<CoachingLogQn> GetCoachingLogQns(QualityNowSearchViewModel search, out int totalRows)
        {
            var logQnList = new List<CoachingLogQn>();
            totalRows = 0;
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptQNCoachingSummary]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModulein", search.SelectedEmployeeLevel);
                command.Parameters.AddWithValueSafe("@intStatusin", search.SelectedLogStatus);
                command.Parameters.AddWithValueSafe("@intSitein", search.SelectedSite);
                command.Parameters.AddWithValueSafe("@strEmpin", search.SelectedEmployee);
                command.Parameters.AddWithValueSafe("@intCoachReasonin", search.SelectedCoachingReason);
                command.Parameters.AddWithValueSafe("@intSubCoachReasonin", search.SelectedCoachingSubReason);
                command.Parameters.AddWithValueSafe("@strSDatein", search.StartDate);
                command.Parameters.AddWithValueSafe("@strEDatein", search.EndDate);
                command.Parameters.AddWithValueSafe("@PageSize", search.PageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", search.RowStartIndex);
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
                    throw new Exception("[sp_rptQNCoachingSummary] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        if (totalRows == 0)
                        {
                            totalRows = (int)dataReader["TotalRows"];
                        }
                        var temp = new CoachingLogQn();
                        temp.ModuleId = dataReader["Employee Level ID"].ToString();
                        temp.ModuleName = dataReader["Employee Level Name"].ToString();
                        temp.CoachingID = dataReader["Coaching ID"].ToString();
                        temp.LogName = dataReader["Log Name"].ToString();
                        temp.QualityNowBatchID = dataReader["Quality Now Batch ID"].ToString();
                        temp.QualityNowBatchStatus = dataReader["Quality Now Batch Status"].ToString();
                        temp.Status = dataReader["Status"].ToString();
                        temp.EmployeeID = dataReader["Employee ID"].ToString();
                        temp.EmployeeName = dataReader["Employee Name"].ToString();
                        temp.Site = dataReader["Site"].ToString();
                        temp.SupervisorEmployeeID = dataReader["Supervisor Employee ID"].ToString();
                        temp.SupervisorName = dataReader["Supervisor Name"].ToString();
                        temp.ManagerEmployeeID = dataReader["Manager Employee ID"].ToString();
                        temp.ManagerName = dataReader["Manager Name"].ToString();
                        temp.CurrentSupervisorEmployeeID = dataReader["Current Supervisor Employee ID"].ToString();
                        temp.CurrentSupervisorName = dataReader["Current Supervisor Name"].ToString();
                        temp.CurrentManagerEmployeeID = dataReader["Current Manager Employee ID"].ToString();
                        temp.CurrentManagerName = dataReader["Current Manager Name"].ToString();
                        temp.ReviewSupervisorEmployeeID = dataReader["Review Supervisor Employee ID"].ToString();
                        temp.ReviewSupervisorName = dataReader["Review Supervisor Name"].ToString();
                        temp.ReviewManagerEmployeeID = dataReader["Review Manager Employee ID"].ToString();
                        temp.ReviewManagerName = dataReader["Review Manager Name"].ToString();
                        temp.StrengthandOpportunities = dataReader["Strength and Opportunities"].ToString();
                        temp.EvaluationSummary = dataReader["Evaluation Summary"].ToString();
                        temp.CoachingNotes = dataReader["Coaching Notes"].ToString();
                        temp.EventDate = dataReader["Event Date"].ToString();
                        temp.CoachingDate = dataReader["Coaching Date"].ToString();
                        temp.SubmittedDate = dataReader["Submitted Date"].ToString();
                        temp.CoachingSource = dataReader["Coaching Source"].ToString();
                        temp.SubCoachingSource = dataReader["Sub Coaching Source"].ToString();
                        temp.CoachingReason = dataReader["Coaching Reason"].ToString();
                        temp.SubCoachingReason = dataReader["SubCoaching Reason"].ToString();
                        temp.Value = dataReader["Value"].ToString();
                        temp.SubmitterID = dataReader["Submitter ID"].ToString();
                        temp.SubmitterName = dataReader["Submitter Name"].ToString();
                        temp.SupervisorReviewedDate = dataReader["Supervisor Reviewed Date"].ToString();
                        temp.ManagerReviewedManualDate = dataReader["Manager Reviewed Manual Date"].ToString();
                        temp.ManagerReviewedAutoDate = dataReader["Manager Reviewed Auto Date"].ToString();
                        temp.ManagerNotes = dataReader["Manager Notes"].ToString();
                        temp.EmployeeReviewedDate = dataReader["Employee Reviewed Date"].ToString();
                        temp.EmployeeComments = dataReader["Employee Comments"].ToString();
                        temp.FollowupRequired = dataReader["Follow-up Required"].ToString();
                        temp.FollowupDate = dataReader["Follow-up Date"].ToString();
                        temp.FollowupCoachingDate = dataReader["Follow-up Coaching Date"].ToString();
                        temp.FollowupCoachingNotes = dataReader["Follow-up Coaching Notes"].ToString();
                        temp.SupervisorFollowupAutoDate = dataReader["Supervisor Follow-up Auto Date"].ToString();
                        temp.CSRFollowupAcknowledged = dataReader["CSR Follow-up Acknowledged"].ToString();
                        temp.CSRFollowupAutoDate = dataReader["CSR Follow-up Auto Date"].ToString();
                        temp.CSRFollowupComments = dataReader["CSR Follow-up Comments"].ToString();
                        temp.FollowupSupervisorID = dataReader["Follow-up Supervisor ID"].ToString();
                        temp.SupervisorFollowupReviewAutoDate = dataReader["Supervisor Follow-up Review Auto Date"].ToString();
                        temp.SupervisorFollowupReviewCoachingNotes = dataReader["Supervisor Follow-up Review Coaching Notes"].ToString();
                        temp.FollowupReviewMonitoredLogs = dataReader["Follow-up Review Monitored Logs"].ToString();
                        temp.FollowupReviewSupervisorID = dataReader["Follow-up Review Supervisor ID"].ToString();
                        temp.Program = dataReader["Program"].ToString();
                        temp.Channel = dataReader["Channel"].ToString();
                        temp.VerintID = dataReader["Verint ID"].ToString();
                        temp.ActivityID = dataReader["ActivityID"].ToString();
                        temp.DCN = dataReader["DCN"].ToString();
                        temp.VerintFormName = dataReader["Verint Form Name"].ToString();
                        temp.CoachingMonitor = dataReader["Coaching Monitor"].ToString();
                        temp.EvaluationStatus = dataReader["Evaluation Status"].ToString();
                        temp.ReasonForContact = dataReader["Reason For Contact"].ToString();
                        temp.ReasonForContactComments = dataReader["Reason For Contact Comments"].ToString();
                        temp.BusinessProcess = dataReader["Business Process"].ToString();
                        temp.BusinessProcessReason = dataReader["Business Process Reason"].ToString();
                        temp.BusinessProcessComment = dataReader["Business Process Comment"].ToString();
                        temp.InfoAccuracy = dataReader["Info Accuracy"].ToString();
                        temp.InfoAccuracyReason = dataReader["Info Accuracy Reason"].ToString();
                        temp.InfoAccuracyComment = dataReader["Info Accuracy Comment"].ToString();
                        temp.PrivacyDisclaimers = dataReader["Privacy Disclaimers"].ToString();
                        temp.PrivacyDisclaimersReason = dataReader["Privacy Disclaimers Reason"].ToString();
                        temp.PrivacyDisclaimersComment = dataReader["Privacy Disclaimers Comment"].ToString();
                        temp.IssueResolution = dataReader["Issue Resolution"].ToString();
                        temp.IssueResolutionComment = dataReader["Issue Resolution Comment"].ToString();
                        temp.BusinessCorrespondence = dataReader["Business Correspondence"].ToString();
                        temp.BusinessCorrespondenceComment = dataReader["Business Correspondence Comment"].ToString();
                        temp.CallEfficiency = dataReader["Call Efficiency"].ToString();
                        temp.CallEfficiencyComment = dataReader["Call Efficiency Comment"].ToString();
                        temp.ChatEfficiency = dataReader["Chat Efficiency"].ToString();
                        temp.ChatEfficiencyComment = dataReader["Chat Efficiency Comment"].ToString();
                        temp.ActiveListening = dataReader["Active Listening"].ToString();
                        temp.ActiveListeningComment = dataReader["Active Listening Comment"].ToString();
                        temp.IssueDiagnosis = dataReader["Issue Diagnosis"].ToString();
                        temp.IssueDiagnosisComment = dataReader["Issue Diagnosis Comment"].ToString();
                        temp.PersonalityFlexing = dataReader["Personality Flexing"].ToString();
                        temp.PersonalityFlexingComment = dataReader["Personality Flexing Comment"].ToString();
                        temp.ProfessionalCommunication = dataReader["Professional Communication"].ToString();
                        temp.ProfessionalCommunicationComment = dataReader["Professional Communication Comment"].ToString();
                        temp.CustomerTempStart = dataReader["Customer Temp Start"].ToString();
                        temp.CustomerTempStartComment = dataReader["Customer Temp Start Comment"].ToString();
                        temp.CustomerTempEnd = dataReader["Customer Temp End"].ToString();
                        temp.CustomerTempEndComment = dataReader["Customer Temp End Comment"].ToString();

                        logQnList.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return logQnList;
        }

        public DataSet GetCoachingLogQns(QualityNowSearchViewModel search)
        {
            DataSet dt = new DataSet();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptQNCoachingSummary]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModulein", search.SelectedEmployeeLevel);
                command.Parameters.AddWithValueSafe("@intStatusin", search.SelectedLogStatus);
                command.Parameters.AddWithValueSafe("@intSitein", search.SelectedSite);
                command.Parameters.AddWithValueSafe("@strEmpin", search.SelectedEmployee);
                command.Parameters.AddWithValueSafe("@intCoachReasonin", search.SelectedCoachingReason);
                command.Parameters.AddWithValueSafe("@intSubCoachReasonin", search.SelectedCoachingSubReason);
                command.Parameters.AddWithValueSafe("@strSDatein", search.StartDate);
                command.Parameters.AddWithValueSafe("@strEDatein", search.EndDate);
                command.Parameters.AddWithValueSafe("@PageSize", search.PageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", search.RowStartIndex);
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

        public List<WarningLog> GetWarningLogs(WarningSearchViewModel search, out int totalRows)
        {
            var logList = new List<WarningLog>();
            totalRows = 0;
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptWarningSummary]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModulein", search.SelectedEmployeeLevel);
                command.Parameters.AddWithValueSafe("@intStatusin", search.SelectedLogStatus);
                command.Parameters.AddWithValueSafe("@intSitein", search.SelectedSite);
                command.Parameters.AddWithValueSafe("@strEmpin", search.SelectedEmployee);
                command.Parameters.AddWithValueSafe("@intWarnReasonin", search.SelectedWarningReason);
                command.Parameters.AddWithValueSafe("@intSubWarnReasonin", search.SelectedWarningSubReason);
                command.Parameters.AddWithValueSafe("@strSDatein", search.StartDate);
                command.Parameters.AddWithValueSafe("@strEDatein", search.EndDate);
                command.Parameters.AddWithValueSafe("@strActive", search.SelectedLogState);
                // sp is checking hireDate null, not checking empty string, so if hireDate is empty, pass in null
                command.Parameters.AddWithValue("@strHDatein", string.IsNullOrEmpty(search.HireDate) ? null : search.HireDate);
                command.Parameters.AddWithValueSafe("@PageSize", search.PageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", search.RowStartIndex);
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
                    throw new Exception("[sp_rptWarningSummary] failed to return data: " + retMessage);
                }

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        if (totalRows == 0)
                        {
                            totalRows = (int)dataReader["TotalRows"];
                        }
                        var temp = new WarningLog();
                        temp.ModuleId = dataReader["Module ID"].ToString();
                        temp.ModuleName = dataReader["Module Name"].ToString();
                        temp.WarningID = dataReader["Warning ID"].ToString();
                        temp.LogName = dataReader["Form Name"].ToString();
                        temp.Status = dataReader["Status"].ToString();
                        temp.EmployeeID = dataReader["Employee ID"].ToString();
                        temp.EmployeeName = dataReader["Employee Name"].ToString();
                        temp.EmployeeHireDate = dataReader["Employee Hire Date"].ToString();
                        temp.Site = dataReader["Site"].ToString();
                        temp.SupervisorEmployeeID = dataReader["Supervisor Employee ID"].ToString();
                        temp.SupervisorName = dataReader["Supervisor Name"].ToString();
                        temp.ManagerEmployeeID = dataReader["Manager Employee ID"].ToString();
                        temp.ManagerName = dataReader["Manager Name"].ToString();
                        temp.CurrentSupervisorEmployeeID = dataReader["Current Supervisor Employee ID"].ToString();
                        temp.CurrentSupervisorName = dataReader["Current Supervisor Name"].ToString();
                        temp.CurrentManagerEmployeeID = dataReader["Current Manager Employee ID"].ToString();
                        temp.CurrentManagerName = dataReader["Current Manager Name"].ToString();
                        temp.WarningGivenDate = dataReader["Warning given Date"].ToString();
                        temp.SubmittedDate = dataReader["Submitted Date"].ToString();
                        temp.CSRReviewDate = dataReader["CSR Review Date"].ToString();
                        temp.CSRComments = dataReader["CSR Comments"].ToString();
                        temp.ExpirationDate = dataReader["Expiration Date"].ToString();
                        temp.WarningSource = dataReader["Warning Source"].ToString();
                        temp.SubWarningSource = dataReader["Sub Warning Source"].ToString();
                        temp.WarningReason = dataReader["Warning Reason"].ToString();
                        temp.WarningSubReason = dataReader["Warning SubReason"].ToString();
                        temp.Value = dataReader["Value"].ToString();
                        temp.SubmitterID = dataReader["Submitter ID"].ToString();
                        temp.SubmitterName = dataReader["Submitter Name"].ToString();
                        temp.ProgramName = dataReader["Program Name"].ToString();
                        temp.Behavior = dataReader["Behavior"].ToString();
                        temp.State = dataReader["State"].ToString();

                        logList.Add(temp);
                    }
                    dataReader.Close();
                }
            }

            return logList;
        }

        public DataSet GetWarningLogs(WarningSearchViewModel search)
        {
            DataSet dt = new DataSet();
            using (SqlConnection connection = new SqlConnection(connectionStr))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptWarningSummary]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModulein", search.SelectedEmployeeLevel);
                command.Parameters.AddWithValueSafe("@intStatusin", search.SelectedLogStatus);
                command.Parameters.AddWithValueSafe("@intSitein", search.SelectedSite);
                command.Parameters.AddWithValueSafe("@strEmpin", search.SelectedEmployee);
                command.Parameters.AddWithValueSafe("@intWarnReasonin", search.SelectedWarningReason);
                command.Parameters.AddWithValueSafe("@intSubWarnReasonin", search.SelectedWarningSubReason);
                command.Parameters.AddWithValueSafe("@strSDatein", search.StartDate);
                command.Parameters.AddWithValueSafe("@strEDatein", search.EndDate);
                command.Parameters.AddWithValueSafe("@strActive", search.SelectedLogState);
                // sp is checking hireDate null, not checking empty string, so if hireDate is empty, pass in null
                command.Parameters.AddWithValue("@strHDatein", string.IsNullOrEmpty(search.HireDate) ? null : search.HireDate);
                command.Parameters.AddWithValueSafe("@PageSize", search.PageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", search.RowStartIndex);
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
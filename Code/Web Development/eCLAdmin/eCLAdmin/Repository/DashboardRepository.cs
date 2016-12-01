using eCLAdmin.Models.Dashboard;
using eCLAdmin.Models.EmployeeLog;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class DashboardRepository : IDashboardRepository 
    {
        readonly ILog logger = LogManager.GetLogger(typeof(DashboardRepository));

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public int GetLogCount(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime)
        {
            int count = -1;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Count]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                // Input parameters
                command.Parameters.AddWithValue("@strEMPSRMGRin", userLanId);
                command.Parameters.AddWithValue("@bitisCoaching", isCoaching);
                command.Parameters.AddWithValue("@strStatus", status);
                command.Parameters.AddWithValue("@strSDatein", startTime);
                command.Parameters.AddWithValue("@strEDatein", endTime);
                // Output parameter
                SqlParameter countParam = command.Parameters.Add("@Count", SqlDbType.Int);
                countParam.Direction = ParameterDirection.Output;

                connection.Open();
                command.ExecuteNonQuery();

                count = Convert.ToInt32(command.Parameters["@Count"].Value);
            }

            return count;
        }

        public List<EmployeeLog> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search)
        {
            List<EmployeeLog> employeeLogs = new List<EmployeeLog>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Details]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strEMPSRMGRin", userLanId);
                command.Parameters.AddWithValue("@bitisCoaching", isCoaching);
                command.Parameters.AddWithValue("@strStatus", status);
                command.Parameters.AddWithValue("@strSDatein", startTime);
                command.Parameters.AddWithValue("@strEDatein", endTime);
                command.Parameters.AddWithValue("@PageSize", pageSize);
                command.Parameters.AddWithValue("@startRowIndex", startRowIndex);
                command.Parameters.AddWithValue("@sortBy", sortBy);
                command.Parameters.AddWithValue("@sortASC", sortAsc );
                command.Parameters.AddWithValue("@searchBy", search);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        EmployeeLog log = new EmployeeLog();
                        log.ID = (long)dataReader["strID"];
                        log.FormName = dataReader["strFormID"].ToString();
                        log.EmployeeName = dataReader["strEmpName"].ToString();
                        log.SupervisorName = dataReader["strEMPSupName"].ToString();
                        log.ManagerName = dataReader["strEMPMgrName"].ToString();
                        log.Status = dataReader["strFormStatus"].ToString();
                        log.SubmitterName = dataReader["strSubmitterName"].ToString();
                        log.Source = dataReader["strSource"].ToString();
                        log.Reasons = dataReader["strCoachingReason"].ToString();
                        log.SubReasons = dataReader["strSubCoachingReason"].ToString();
                        log.Value = dataReader["strValue"].ToString();
                        log.CreatedDate = dataReader["SubmittedDate"].ToString() + " PDT";

                        employeeLogs.Add(log);
                    }
                }
            }

            return employeeLogs;
        }

        public CoachingLogDetail GetCoachingDetail(long id)
        {
            CoachingLogDetail logDetail = new CoachingLogDetail();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Review]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intFormIDin", id);
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
                        logDetail.CreatedDate = dataReader["SubmittedDate"].ToString() + " PDT";
                        logDetail.EventDate = dataReader["CoachingDate"].ToString() + " PDT";
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
                        logDetail.EmployeeReviewDate = dataReader["CSRReviewAutoDate"].ToString() + " PDT";

                        logDetail.SupReviewedAutoDate = dataReader["SupReviewedAutoDate"].ToString() + " PDT";
                        logDetail.MgrReviewAutoDate = dataReader["MgrReviewAutoDate"].ToString() + " PDT";

                        logDetail.ReviewedSupervisorName = dataReader["strreviewsup"].ToString();
                        logDetail.ReviewedManagerName = dataReader["strreviewmgr"].ToString();
                        break;
                    }
                }
            }

            return logDetail;
        }

        public WarningLogDetail GetWarningDetail(long id)
        {
            WarningLogDetail logDetail = new WarningLogDetail();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Review]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intFormIDin", id);
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
                        logDetail.CreatedDate = dataReader["SubmittedDate"].ToString() + " PDT";
                        logDetail.EventDate = dataReader["warningDate"].ToString() + " PDT";
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

        public List<ChartCoachingCompleted> GetChartDataCoachingCompleted(string userLanId, DateTime startTime, DateTime endTime)
        {
            List<ChartCoachingCompleted> chartDatas = new List<ChartCoachingCompleted>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Completed_CoachingByWeek]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strEMPSRMGRin", userLanId);
                command.Parameters.AddWithValue("@strSDatein", startTime);
                command.Parameters.AddWithValue("@strEDatein", endTime);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    int currentWeek = 0;
                    ChartCoachingCompleted chartData = null;

                    while (dataReader.Read())
                    {
                        int week = (int)dataReader["WeekNum"];
                        if (week != currentWeek)
                        {
                            currentWeek = week;

                            chartData = new ChartCoachingCompleted();
                            chartDatas.Add(chartData);

                            chartData.x = "Week" + dataReader["WeekNum"];
                        }
                        string description = dataReader["Value"].ToString();
                        int count = (int)dataReader["LogCount"];
                        if (description == "Did not meet goal")
                        {
                            chartData.a = count;
                        }
                        else if (description == "Met goal")
                        {
                            chartData.b = count;
                        }
                        else if (description == "Opportunity")
                        {
                            chartData.c = count;
                        }
                        else if (description == "Reinforcement")
                        {
                            chartData.d = count;
                        } // end if
                    } // end while (dataReader.Read())
                } // end using (SqlDataReader dataReader = command.ExecuteReader())
            } // end using

            return chartDatas;
        }

        public List<ChartCoachingPending> GetChartDataCoachingPending(string userLanId, DateTime startTime, DateTime endTime)
        {
            List<ChartCoachingPending> chartDatas = new List<ChartCoachingPending>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Pending_CoachingByWeek]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strEMPSRMGRin", userLanId);
                command.Parameters.AddWithValue("@strSDatein", startTime);
                command.Parameters.AddWithValue("@strEDatein", endTime);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    int currentWeek = 0;
                    ChartCoachingPending chartData = null;

                    while (dataReader.Read())
                    {
                        int week = (int)dataReader["WeekNum"];
                        if (week != currentWeek)
                        {
                            currentWeek = week;

                            chartData = new ChartCoachingPending();
                            chartDatas.Add(chartData);

                            chartData.x = "Week" + dataReader["WeekNum"];
                        }
                        string description = dataReader["Status"].ToString();
                        int count = (int)dataReader["LogCount"];
                        if (description == "Pending Acknowledgement")
                        {
                            chartData.a = count;
                        }
                        else if (description == "Pending Employee Review")
                        {
                            chartData.b = count;
                        }
                        else if (description == "Pending Manager Review")
                        {
                            chartData.c = count;
                        }
                        else if (description == "Pending Sr. Manager Review")
                        {
                            chartData.d = count;
                        } 
                        else if (description == "Pending Supervisor Review")
                        {
                            chartData.e = count;
                        } // end if
                    } // end while (dataReader.Read())
                } // end using (SqlDataReader dataReader = command.ExecuteReader())
            } // end using

            return chartDatas;
        }

        public List<ChartWarningActive> GetChartDataWarningActive(string userLanId, DateTime startTime, DateTime endTime)
        {
            List<ChartWarningActive> chartDatas = new List<ChartWarningActive>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Active_WarningByWeek]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strEMPSRMGRin", userLanId);
                command.Parameters.AddWithValue("@strSDatein", startTime);
                command.Parameters.AddWithValue("@strEDatein", endTime);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    int currentWeek = 0;
                    ChartWarningActive chartData = null;

                    while (dataReader.Read())
                    {
                        int week = (int)dataReader["WeekNum"];
                        if (week != currentWeek)
                        {
                            currentWeek = week;

                            chartData = new ChartWarningActive();
                            chartDatas.Add(chartData);

                            chartData.x = "Week" + dataReader["WeekNum"];
                        }
                        string description = dataReader["CoachingReason"].ToString();
                        int count = (int)dataReader["LogCount"];
                        if (description == "Final Written Warning")
                        {
                            chartData.a = count;
                        }
                        else if (description == "Verbal Warning")
                        {
                            chartData.b = count;
                        }
                        else if (description == "Written Warning")
                        {
                            chartData.c = count;
                        } // end if
                    } // end while (dataReader.Read())
                } // end using (SqlDataReader dataReader = command.ExecuteReader())
            } // end using

            return chartDatas;
        }

        public int GetLogListTotal(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, string search)
        {
            int count = -1;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_SRMGR_Detail_Count]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                // Input parameters
                command.Parameters.AddWithValue("@strEMPSRMGRin", userLanId);
                command.Parameters.AddWithValue("@bitisCoaching", isCoaching);
                command.Parameters.AddWithValue("@strStatus", status);
                command.Parameters.AddWithValue("@strSDatein", startTime);
                command.Parameters.AddWithValue("@strEDatein", endTime);
                command.Parameters.AddWithValue("@searchBy", search);
                // Output parameter
                SqlParameter countParam = command.Parameters.Add("@Count", SqlDbType.Int);
                countParam.Direction = ParameterDirection.Output;

                connection.Open();
                command.ExecuteNonQuery();

                count = Convert.ToInt32(command.Parameters["@Count"].Value);
            }

            return count;
        }
    }
}
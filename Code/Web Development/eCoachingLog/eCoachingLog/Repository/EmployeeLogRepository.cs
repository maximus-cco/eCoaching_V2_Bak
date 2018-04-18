using eCoachingLog.Extensions;
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.User;
using eCoachingLog.Utilities;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
    public class EmployeeLogRepository : IEmployeeLogRepository
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public List<Module> GetModules(string userLanId, int logTypeId)
        {
            var modules = new List<Module>();
            string logType = eCoachingLogUtil.GetLogTypeNameById(logTypeId);

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Modules_By_LanID]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@nvcEmpIDin", "365226");
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

        // TODO: should it be renamed to spGetModulesByUserLanId?
        public List<Module> GetModules(User user)
        {
            var modules = new List<Module>();
            string logType = eCoachingLogUtil.GetLogTypeNameById(1);

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Modules_By_Job_Code]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@nvcEmpIDin", user.EmployeeId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Module module = new Module();
                        // TODO: return module id
                        //module.Id = i; // (int)dataReader["ModuleId"];
                        module.Name = dataReader["Module"].ToString();
                        module.Id = eCoachingLogUtil.GetModuleIdByName(module.Name);
                        modules.Add(module);
                    }
                }
            }

            return modules;
        }


        public List<LogBase> GetLogsByLogName(string logName)
        {
            List<LogBase> logs = new List<LogBase>();

            if (String.IsNullOrWhiteSpace(logName))
            {
                return logs;
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
						LogBase cl = new LogBase();
                        cl.ID = (long)dataReader["CoachingID"];
                        cl.FormName = dataReader["FormName"].ToString();
                        cl.EmployeeLanId = dataReader["EmpLanID"].ToString();
                        cl.EmployeeId = dataReader["EmpID"].ToString();
                        //cl.Source = dataReader["SourceID"].ToString();
                        // TODO: get it from database
                        cl.IsCoaching = dataReader["isCoaching"].ToString() == "1" ? true : false ;

                        logs.Add(cl);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return logs;
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
                        logDetail.CreatedDate = eCoachingLogUtil.AppendPdt(dataReader["SubmittedDate"].ToString());
                        logDetail.CoachingDate = eCoachingLogUtil.AppendPdt(dataReader["CoachingDate"].ToString());
                        logDetail.EventDate = eCoachingLogUtil.AppendPdt(dataReader["EventDate"].ToString());
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

                        logDetail.IsUcId = Convert.ToBoolean(dataReader["isUCID"].ToString());
                        logDetail.UcId = dataReader["strUCID"].ToString();

                        logDetail.SupervisorName = dataReader["strCSRSupName"].ToString();
                        logDetail.ReassignedSupervisorName = dataReader["strReassignedSupName"].ToString();
                        logDetail.ManagerName = dataReader["strCSRMgrName"].ToString();
                        logDetail.ReassignedManagerName = dataReader["strReassignedMgrName"].ToString();

						//logDetail.Reasons = " ARC Issue| ARC Issue| ARC Issue| ARC Issue| ARC Issue| ARC Issue| ARC Issue| ARC Issue";//dataReader["strCoachingReason"].ToString();
						//logDetail.SubReasons = " Casework Adhoc requests from CMS| Casework Bene Letter| Casework CTM| Casework Inappropriate ARC Escalation| Casework ISG Escalation| Complaints Research| Special Projects| Other: Specify reason under coaching details.";//dataReader["strSubCoachingReason"].ToString();
						//logDetail.Value = " Enhancement| Enhancement| Enhancement| Enhancement| Enhancement| Enhancement| Enhancement| Enhancement";// dataReader["strValue"].ToString();

                        logDetail.CoachingNotes = dataReader["txtCoachingNotes"].ToString();
                        logDetail.Behavior = dataReader["txtDescription"].ToString();

                        logDetail.MgrNotes = dataReader["txtMgrNotes"].ToString();

                        logDetail.EmployeeComments = dataReader["txtCSRComments"].ToString();
                        logDetail.EmployeeReviewDate = eCoachingLogUtil.AppendPdt(dataReader["CSRReviewAutoDate"].ToString());

                        logDetail.SupReviewedAutoDate = eCoachingLogUtil.AppendPdt(dataReader["SupReviewedAutoDate"].ToString());
                        logDetail.MgrReviewAutoDate = eCoachingLogUtil.AppendPdt(dataReader["MgrReviewAutoDate"].ToString());

                        logDetail.ReviewedSupervisorName = dataReader["strreviewsup"].ToString();
                        logDetail.ReviewedManagerName = dataReader["strreviewmgr"].ToString();

                        break;
                    }
                }
            }

            return logDetail;
        }

		public List<Tuple<string, string, string>> GetReasonsByLogId(long logId)
		{
			var reasons = new List<Tuple<string, string, string>>();
			Tuple<string, string, string> reason;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]", connection))
			{
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.CommandTimeout = 300;
				command.Parameters.AddWithValue("@strFormIDin", "eCL-365226-98027");

				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						reason = new Tuple<string, string, string>(
							dataReader["CoachingReason"].ToString(),
							dataReader["SubCoachingReason"].ToString(),
							dataReader["value"].ToString());

						reasons.Add(reason);
					} // end while
				} // end using SqlDataReader
			} // end using SqlCommand

			return reasons;
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
                        logDetail.CreatedDate = eCoachingLogUtil.AppendPdt(dataReader["SubmittedDate"].ToString());
                        logDetail.EventDate = eCoachingLogUtil.AppendPdt(dataReader["warningDate"].ToString());
                        logDetail.SubmitterName = dataReader["strSubmitterName"].ToString();
                        logDetail.EmployeeName = dataReader["strCSRName"].ToString();
                        logDetail.EmployeeSite = dataReader["strCSRSite"].ToString();

                        logDetail.SupervisorName = dataReader["strCSRSupName"].ToString();
                        logDetail.ManagerName = dataReader["strCSRMgrName"].ToString();

                        //logDetail.Reasons = dataReader["strCoachingReason"].ToString();
                        //logDetail.SubReasons = dataReader["strSubCoachingReason"].ToString();
                        //logDetail.Value = dataReader["strValue"].ToString();

                        break;
                    }
                }
            }

            return logDetail;
        }

        public List<CallType> GetCallTypes(int moduleId)
        {
            var callTypes = new List<CallType>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_CallID_By_Module]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        CallType callType = new CallType();
                        callType.Name = dataReader["CallIdType"].ToString();
                        callType.IdPattern = dataReader["IdFormat"].ToString();

                        callTypes.Add(callType);
                    }
                }
            }

            return callTypes;
        }

        // TODO: moduleId should be int, not "CSR"...
        public List<WarningType> GetWarningTypes(int moduleId, string source, bool isSpecialReason, int reasonPriority, string employeeId, string userId)
        {
            List<WarningType> warningTypes = new List<WarningType>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_CoachingReasons_By_Module]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);
                command.Parameters.AddWithValue("@strSourcein", source); // TODO: change sp to source id
                command.Parameters.AddWithValue("@isSplReason", isSpecialReason);
                command.Parameters.AddWithValue("@splReasonPrty", reasonPriority);
                command.Parameters.AddWithValue("@strEmpIDin", employeeId);
                command.Parameters.AddWithValue("@strSubmitterIDin", userId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        WarningType wt = new WarningType();
                        wt.Id = (int)dataReader["CoachingReasonID"];
                        wt.Text= dataReader["CoachingReason"].ToString();

                        warningTypes.Add(wt);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return warningTypes;
        }

        // TODO: Pass in moduleId instead of moduleName
        public List<WarningReason> GetWarningReasons(int reasonId, string directOrIndirect, int moduleId, string employeeId)
        {
            List<WarningReason> warningReasons = new List<WarningReason>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_SubCoachingReasons_By_Reason]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intReasonIDin", reasonId);
                command.Parameters.AddWithValue("@strSourcein", directOrIndirect);
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);
                command.Parameters.AddWithValue("@nvcEmpIDin", employeeId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        WarningReason wr = new WarningReason();
                        wr.Id = (int)dataReader["SubCoachingReasonID"];
                        wr.Text = dataReader["SubCoachingReason"].ToString();

                        warningReasons.Add(wr);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return warningReasons;
        }

        public List<CoachingReason> GetCoachingReasons(string directOrIndirect, int moduleId, string userId, string employeeId, bool isSpecialResaon, int specialReasonPriority)
        {
            List<CoachingReason> coachingReasons = new List<CoachingReason>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_CoachingReasons_By_Module]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@strSourcein", directOrIndirect);
                command.Parameters.AddWithValueSafe("@isSplReason", isSpecialResaon);
                command.Parameters.AddWithValueSafe("@splReasonPrty", specialReasonPriority);
                command.Parameters.AddWithValueSafe("@strEmpIDin", employeeId);
                command.Parameters.AddWithValueSafe("@strSubmitterIDin", userId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        CoachingReason cr = new CoachingReason();
                        cr.ID = (int)dataReader["CoachingReasonID"];
                        cr.Text = dataReader["CoachingReason"].ToString();

                        coachingReasons.Add(cr);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return coachingReasons;
        }

        public List<string> GetValues(int reasonId, string directOrIndirect, int moduleId)
        {
            List<string> valueOptions = new List<string>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Values_By_Reason]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@intReasonIDin", reasonId);
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);
                command.Parameters.AddWithValue("@strSourcein", directOrIndirect);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        string valueOption = dataReader["Value"].ToString();
                        valueOptions.Add(valueOption);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return valueOptions;
        }

        public List<CoachingSubReason> GetCoachingSubReasons(int reasonId, int moduleId, string directOrIndirect, string employeeId)
        {
            List<CoachingSubReason> subReasons = new List<CoachingSubReason>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_SubCoachingReasons_By_Reason]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@intReasonIDin", reasonId);
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);
                command.Parameters.AddWithValue("@strSourcein", directOrIndirect);
                command.Parameters.AddWithValue("@nvcEmpIDin", employeeId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        CoachingSubReason csr = new CoachingSubReason();
                        csr.ID = (int)dataReader["SubCoachingReasonID"];
                        csr.Text = dataReader["SubCoachingReason"].ToString();

                        subReasons.Add(csr);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return subReasons;
        }

        public List<Behavior> GetBehaviors(int moduleId)
        {
            List<Behavior> behaviors = new List<Behavior>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Behaviors]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Behavior behavior = new Behavior();
                        behavior.Id = (int)dataReader["BehaviorID"];
						behavior.Text = dataReader["Behavior"].ToString();

                        behaviors.Add(behavior);
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            return behaviors;
        }

		public List<LogBase> GetLogList(string userLanId, string status, bool isCoaching, DateTime startTime, DateTime endTime, int pageSize, int startRowIndex, string sortBy, string sortAsc, string search)
		{
			List<LogBase> employeeLogs = new List<LogBase>();

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
				command.Parameters.AddWithValue("@sortASC", sortAsc);
				command.Parameters.AddWithValue("@searchBy", search);

				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogBase log = new LogBase();
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
						log.CreatedDate = eCoachingLogUtil.AppendPdt(dataReader["SubmittedDate"].ToString());

						log.WarningType = "Written";
						log.WarningReasons = "reason";

						employeeLogs.Add(log);
					}
				}
			}

			return employeeLogs;
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

				//count = Convert.ToInt32(command.Parameters["@Count"].Value);
				count = 0;
			}

			return count;
		}

		public IList<LogStatus> GetAllLogStatuses()
		{
			var statuses = new List<LogStatus>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Statuses_For_Dashboard]", connection))
			{
				command.CommandType = System.Data.CommandType.StoredProcedure;
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogStatus status = new LogStatus();
						status.Id = dataReader["StatusValue"].ToString();;
						status.Description = dataReader["StatusText"].ToString();
						statuses.Add(status);
					}
				}
			}

			return statuses;
		}

		public IList<LogSource> GetAllLogSources(string userLanId)
		{
			var sources = new List<LogSource>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Sources_For_Dashboard]", connection))
			{
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.CommandTimeout = 300;
				command.Parameters.AddWithValue("@strUserin", userLanId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogSource source = new LogSource();
						source.Id = dataReader["SourceValue"].ToString();
						source.Name = dataReader["SourceText"].ToString();
						sources.Add(source);
					}
				}
			}

			return sources;
		}

		public IList<LogValue> GetAllLogValues()
		{
			var logValues = new List<LogValue>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Values_For_Dashboard]", connection))
			{
				command.CommandType = System.Data.CommandType.StoredProcedure;
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogValue logValue = new LogValue();
						logValue.Id = dataReader["ValueValue"].ToString();
						logValue.Description = dataReader["ValueText"].ToString();
						logValues.Add(logValue);
					}
				}
			}
			return logValues;
		}

		public DataTable GetLogDataTable(LogFilter logFilter)
		{
			DataTable dt = new DataTable();

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Historical_Export]", connection))
			{
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@strSourcein", logFilter.SourceId);
				command.Parameters.AddWithValue("@strCSRSitein", logFilter.SiteId);
				command.Parameters.AddWithValue("@strCSRin", logFilter.EmployeeId);
				command.Parameters.AddWithValue("@strSUPin", logFilter.SupervisorId);
				command.Parameters.AddWithValue("@strMGRin", logFilter.ManagerId);
				command.Parameters.AddWithValue("@strSubmitterin", logFilter.SubmitterId);
				command.Parameters.AddWithValue("@strSDatein", "4/1/2015");
				command.Parameters.AddWithValue("@strEDatein", "4/9/2018");
				command.Parameters.AddWithValue("@strStatusin", logFilter.StatusId);
				command.Parameters.AddWithValue("@strvalue", logFilter.ValueId);

				using (SqlDataAdapter sda = new SqlDataAdapter(command))
				{
					sda.Fill(dt);

					int count = dt.Rows.Count;
				}
			}
			return dt;	
		}
	}
}
using eCoachingLog.Extensions;
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.User;
using eCoachingLog.Utils;
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
		private static readonly string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        // TODO: should it be renamed to spGetModulesByUserId?
        public List<Module> GetModules(User user)
        {
            var modules = new List<Module>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Modules_By_Job_Code]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@nvcEmpIDin", user.EmployeeId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Module module = new Module();
                        module.Id = Convert.ToInt16(dataReader["ModuleID"]);
						module.Name = dataReader["Module"].ToString();
						modules.Add(module);
                    }
                }
            }
            return modules;
        }

        public CoachingLogDetail GetCoachingDetail(long logId)
        {
            CoachingLogDetail logDetail = new CoachingLogDetail();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectReviewFrom_Coaching_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@intLogId", logId);
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
						logDetail.IsVerintMonitor = dataReader["isVerintMonitor"] == DBNull.Value ? false : (bool) dataReader["isVerintMonitor"];
                        logDetail.VerintId = dataReader["strVerintID"].ToString();
                        logDetail.VerintFormName = dataReader["VerintFormName"].ToString();
                        logDetail.CoachingMonitor = dataReader["isCoachingMonitor"].ToString(); // nvarchar(3): NULL, NA, No, Yes
						logDetail.IsBehaviorAnalyticsMonitor = dataReader["isBehaviorAnalyticsMonitor"] == DBNull.Value ? false : (bool)dataReader["isBehaviorAnalyticsMonitor"];
                        logDetail.BehaviorAnalyticsId = dataReader["strBehaviorAnalyticsID"].ToString();
						logDetail.IsNgdActivityId = dataReader["isNGDActivityID"] == DBNull.Value ? false : (bool)dataReader["isNGDActivityID"];
                        logDetail.NgdActivityId = dataReader["strNGDActivityID"].ToString();
                        logDetail.IsUcId = dataReader["isUCID"] == DBNull.Value ? false : (bool)dataReader["isUCID"]; ;
                        logDetail.UcId = dataReader["strUCID"].ToString();
                        logDetail.SupervisorName = dataReader["strCSRSupName"].ToString();
                        logDetail.ReassignedSupervisorName = dataReader["strReassignedSupName"].ToString();
                        logDetail.ManagerName = dataReader["strCSRMgrName"].ToString();
                        logDetail.ReassignedManagerName = dataReader["strReassignedMgrName"].ToString();
                        logDetail.CoachingNotes = dataReader["txtCoachingNotes"].ToString();
                        logDetail.Behavior = dataReader["txtDescription"].ToString();
                        logDetail.MgrNotes = dataReader["txtMgrNotes"].ToString();
                        logDetail.EmployeeComments = dataReader["txtCSRComments"].ToString();
                        logDetail.EmployeeReviewDate = eCoachingLogUtil.AppendPdt(dataReader["CSRReviewAutoDate"].ToString());
                        logDetail.SupReviewedAutoDate = eCoachingLogUtil.AppendPdt(dataReader["SupReviewedAutoDate"].ToString());
                        logDetail.MgrReviewAutoDate = eCoachingLogUtil.AppendPdt(dataReader["MgrReviewAutoDate"].ToString());
						// TODO: find out if these 2 are returning
						//logDetail.ReviewedSupervisorName = dataReader["strreviewsup"];
						//logDetail.ReviewedManagerName = dataReader["strreviewmgr"];
						logDetail.IsCse = dataReader["isCse"] == DBNull.Value ? false : (bool) dataReader["isCse"];
						logDetail.IsCseUnconfirmed = Convert.ToInt16(dataReader["Customer Service Escalation"]) == 0 ? false : true;

						break;
                    } // End while
                } // End using SqlDataReader
            } // End using SqlCommand
            return logDetail;
        }

		public List<Tuple<string, string, string>> GetReasonsByLogId(long logId, bool isCoaching)
		{
			var spName = "[EC].[sp_SelectReviewFrom_Coaching_Log_Reasons]";
			var reasons = new List<Tuple<string, string, string>>();
			Tuple<string, string, string> reason;

			if (!isCoaching)
			{
				spName = "[EC].[sp_SelectReviewFrom_Warning_Log_Reasons]";
			}

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand(spName, connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@intLogId", logId);
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
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectReviewFrom_Warning_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@intLogId", logId);
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
                        logDetail.EventDate = eCoachingLogUtil.AppendPdt(dataReader["EventDate"].ToString());
                        logDetail.SubmitterName = dataReader["strSubmitterName"].ToString();
                        logDetail.EmployeeName = dataReader["strCSRName"].ToString();
                        logDetail.EmployeeSite = dataReader["strCSRSite"].ToString();
                        logDetail.SupervisorName = dataReader["strCSRSupName"].ToString();
                        logDetail.ManagerName = dataReader["strCSRMgrName"].ToString();
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
                command.CommandType = CommandType.StoredProcedure;
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

        public List<WarningType> GetWarningTypes(int moduleId, string source, bool isSpecialReason, int reasonPriority, string employeeId, string userId)
        {
            List<WarningType> warningTypes = new List<WarningType>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_CoachingReasons_By_Module]", connection))
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);
                command.Parameters.AddWithValue("@strSourcein", source);
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

        public List<WarningReason> GetWarningReasons(int reasonId, string directOrIndirect, int moduleId, string employeeId)
        {
            List<WarningReason> warningReasons = new List<WarningReason>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_SubCoachingReasons_By_Reason]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
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
                command.CommandType = CommandType.StoredProcedure;
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
                command.CommandType = CommandType.StoredProcedure;
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

		public List<LogBase> GetLogList(LogFilter logFilter, string userId, int pageSize, int rowStartIndex, string sortBy, string sortDirection, string search)
		{
			List<LogBase> logs = new List<LogBase>();
			using (SqlConnection connection = new SqlConnection(conn))
			// TODO: have a driver sp to take care of all searches (my dashboard, historical dashboard)
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Historical]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@nvcUserIdin", userId);
				command.Parameters.AddWithValue("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValue("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValue("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValue("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValue("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValue("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValue("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValue("strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValue("@nvcValue", logFilter.ValueId);
				command.Parameters.AddWithValue("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValue("@intEmpActive", logFilter.ActiveEmployee);
				command.Parameters.AddWithValue("@PageSize", pageSize);
				command.Parameters.AddWithValue("@startRowIndex", rowStartIndex);
				command.Parameters.AddWithValue("@sortBy", sortBy);
				command.Parameters.AddWithValue("@sortASC", sortDirection);
				command.Parameters.AddWithValue("@nvcSearch", search);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogBase log = new LogBase();
						//log.RowNumber = (long)dataReader["RowNumber"];
						log.ID = (long)dataReader["strCoachingID"];
						log.FormName = dataReader["strFormID"].ToString();
						log.EmployeeName = dataReader["strCSRName"].ToString(); // csr ==> emp name
						log.SupervisorName = dataReader["strCSRSupName"].ToString(); // csr ==> emp
						log.ManagerName = dataReader["strCSRMgrName"].ToString();
						log.Status = dataReader["strFormStatus"].ToString();
						log.SubmitterName = dataReader["strSubmitterName"].ToString();
						log.Source = dataReader["strSource"].ToString();
						log.Reasons = dataReader["strCoachingReason"].ToString();
						log.SubReasons = dataReader["strSubCoachingReason"].ToString();
						log.Value = dataReader["strValue"].ToString();
						log.CreatedDate = eCoachingLogUtil.AppendPdt(dataReader["SubmittedDate"].ToString());
						log.IsCoaching = !string.IsNullOrEmpty(log.Source) && log.Source != "Warning" ? true : false;

						logs.Add(log);
					}
				}
			}
			return logs;
		}

		public int GetLogListTotal(LogFilter logFilter, string userId, string search)
		{
			int count = -1;
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Historical_Count]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@nvcUserIdin", userId);
				command.Parameters.AddWithValue("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValue("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValue("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValue("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValue("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValue("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValue("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValue("strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValue("@nvcValue", logFilter.ValueId);
				command.Parameters.AddWithValue("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValue("@intEmpActive", logFilter.ActiveEmployee);
				command.Parameters.AddWithValue("@nvcSearch", search);
				connection.Open();
				command.ExecuteNonQuery();
				count = (int) command.ExecuteScalar();
			}
			return count;
		}

		public IList<LogStatus> GetAllLogStatuses()
		{
			var statuses = new List<LogStatus>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Statuses_For_Dashboard]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogStatus status = new LogStatus();
						status.Id = Convert.ToInt16(dataReader["StatusId"]);
						status.Description = dataReader["Status"].ToString();
						statuses.Add(status);
					}
				}
			}
			return statuses;
		}

		public IList<LogSource> GetAllLogSources(string userEmpId)
		{
			var sources = new List<LogSource>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Sources_For_Dashboard]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@nvcEmpID", userEmpId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogSource source = new LogSource();
						source.Id = Convert.ToInt16(dataReader["SourceId"]);
						source.Name = dataReader["Source"].ToString();
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
				command.CommandType = CommandType.StoredProcedure;
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogValue logValue = new LogValue();
						logValue.Id = dataReader["ValueValue"].ToString();
						logValue.Description = dataReader["Value"].ToString();
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
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@nvcUserIdin", "365226");
				command.Parameters.AddWithValue("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValue("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValue("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValue("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValue("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValue("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValue("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValue("@strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValue("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValue("@nvcValue", logFilter.ValueId);
				command.Parameters.AddWithValue("@intEmpActive", logFilter.ActiveEmployee);

				using (SqlDataAdapter sda = new SqlDataAdapter(command))
				{
					sda.Fill(dt);
				}
			}
			return dt;	
		}
	}
}
using eCoachingLog.Extensions;
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.EmployeeLog;
using eCoachingLog.Models.MyDashboard;
using eCoachingLog.Models.User;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpIDin", user.EmployeeId);

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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intLogId", logId);
				connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        logDetail.LogId = (long)dataReader["numID"];
						logDetail.FormName = dataReader["strFormID"].ToString();
						logDetail.ModuleName = dataReader["Module"].ToString();
						logDetail.ModuleId = (int)dataReader["ModuleId"];
						logDetail.Source = dataReader["strSource"].ToString();
						logDetail.SourceId = (int)dataReader["sourceid"];
                        logDetail.Status = dataReader["strFormStatus"].ToString();
						logDetail.StatusId = Convert.ToInt16(dataReader["strStatusID"].ToString());
						logDetail.Type = dataReader["strFormType"].ToString();
                        logDetail.CreatedDate = EclUtil.AppendTimeZone(dataReader["SubmittedDate"].ToString());
                        logDetail.CoachingDate = EclUtil.AppendTimeZone(dataReader["CoachingDate"].ToString());
                        logDetail.EventDate = EclUtil.AppendTimeZone(dataReader["EventDate"].ToString());
                        logDetail.SubmitterName = dataReader["strSubmitterName"].ToString().Trim();
						logDetail.SubmitterEmpId = dataReader["strSubmitterID"].ToString().Trim().ToUpper();
                        logDetail.EmployeeName = dataReader["strEmpName"].ToString().Trim();
						logDetail.EmployeeId = dataReader["strEmpID"].ToString().Trim().ToUpper();
                        logDetail.EmployeeSite = dataReader["strEmpSite"].ToString();
						logDetail.IsVerintMonitor = dataReader["isVerintMonitor"] == DBNull.Value ? false : (bool) dataReader["isVerintMonitor"];
                        logDetail.VerintId = dataReader["strVerintID"].ToString();
                        logDetail.VerintFormName = dataReader["VerintFormName"].ToString();
                        logDetail.CoachingMonitor = dataReader["isCoachingMonitor"].ToString(); // nvarchar(3): NULL, NA, No, Yes
						logDetail.IsBehaviorAnalyticsMonitor = dataReader["isBehaviorAnalyticsMonitor"] == DBNull.Value ? false : (bool)dataReader["isBehaviorAnalyticsMonitor"];
                        logDetail.BehaviorAnalyticsId = dataReader["strBehaviorAnalyticsID"].ToString();
						logDetail.IsNgdActivityId = dataReader["isNGDActivityID"] == DBNull.Value ? false : (bool)dataReader["isNGDActivityID"];
                        logDetail.NgdActivityId = dataReader["strNGDActivityID"].ToString();
                        logDetail.IsUcId = dataReader["isUCID"] == DBNull.Value ? false : (bool)dataReader["isUCID"];
                        logDetail.UcId = dataReader["strUCID"].ToString();
                        logDetail.SupervisorName = dataReader["strEmpSupName"].ToString();
						logDetail.SupervisorEmpId = dataReader["strEmpSupID"].ToString().Trim().ToUpper();
                        logDetail.ReassignedSupervisorName = dataReader["strReassignedSupName"].ToString();
						logDetail.ReassignedToEmpId = dataReader["ReassignedToID"] == DBNull.Value ? null : dataReader["ReassignedToID"].ToString().Trim().ToUpper();
						logDetail.ManagerName = dataReader["strEmpMgrName"].ToString();
						logDetail.ManagerEmpId = dataReader["strEmpMgrID"].ToString().Trim().ToUpper();
						logDetail.LogManagerEmpId = dataReader["strCLMgrID"].ToString().Trim().ToUpper();
                        logDetail.ReassignedManagerName = dataReader["strReassignedMgrName"].ToString();
                        logDetail.CoachingNotes = UpdatePdtToEst(dataReader["txtCoachingNotes"].ToString());;
						logDetail.Behavior = dataReader["txtDescription"].ToString();
						logDetail.MgrNotes = dataReader["txtMgrNotes"].ToString();
                        logDetail.Comment = dataReader["txtCSRComments"].ToString();
                        logDetail.EmployeeReviewDate = EclUtil.AppendTimeZone(dataReader["CSRReviewAutoDate"].ToString());
                        logDetail.SupReviewedAutoDate = EclUtil.AppendTimeZone(dataReader["SupReviewedAutoDate"].ToString());
                        logDetail.MgrReviewAutoDate = EclUtil.AppendTimeZone(dataReader["MgrReviewAutoDate"].ToString());
						logDetail.ReviewedSupervisorName = dataReader["strReviewSupervisor"].ToString();
						logDetail.ReviewedManagerName = dataReader["strReviewManager"].ToString();
						logDetail.IsConfirmedCse = Convert.IsDBNull(dataReader["ConfirmedCSE"]) ? null : (bool?)dataReader["ConfirmedCSE"];
						logDetail.IsSubmittedAsCse = Convert.IsDBNull(dataReader["SubmittedCSE"]) ? null : (bool?)dataReader["SubmittedCSE"];

						logDetail.IsOmrShortCall = Convert.ToInt16(dataReader["OMR / ISQ"]) == 0 ? false : true;
						logDetail.IsOmrIae = Convert.ToInt16(dataReader["OMR / IAE"]) == 0 ? false : true;
						logDetail.IsOmrIaef = Convert.ToInt16(dataReader["OMR / IAEF"]) == 0 ? false : true;
						logDetail.IsOmrIat = Convert.ToInt16(dataReader["OMR / IAT"]) == 0 ? false : true;
						logDetail.IsOmrException = Convert.ToInt16(dataReader["OMR / Exceptions"]) == 0 ? false : true;
						logDetail.IsBrl = Convert.ToInt16(dataReader["OMR / BRL"]) == 0 ? false : true;
						logDetail.IsBrn = Convert.ToInt16(dataReader["OMR / BRN"]) == 0 ? false : true;
						logDetail.IsPbh = Convert.ToInt16(dataReader["OMR / PBH"]) == 0 ? false : true;
						logDetail.IsIdd = Convert.ToInt16(dataReader["OMR / IDD"]) == 0 ? false : true;

						logDetail.IsCurrentCoachingInitiative = Convert.ToInt16(dataReader["Current Coaching Initiative"]) == 0 ? false : true;
						logDetail.IsLowCsat = Convert.ToInt16(dataReader["LCS"]) == 0 ? false : true;
						logDetail.IsCoachingRequired = dataReader["isCoachingRequired"] == DBNull.Value ? false : (bool)dataReader["isCoachingRequired"];
						logDetail.IsIqs = Convert.ToInt16(dataReader["isIQS"]) == 0 ? false : true;
						logDetail.HasEmpAcknowledged = dataReader["isCSRAcknowledged"] == DBNull.Value ? false : (bool)dataReader["isCSRAcknowledged"];
						logDetail.HasSupAcknowledged = Convert.ToInt16(dataReader["isSupAcknowledged"].ToString()) == 0 ? false : true;

						logDetail.IsEtsHnc = Convert.ToInt16(dataReader["ETS / HNC"]) == 0 ? false : true;
						logDetail.IsEtsIcc = Convert.ToInt16(dataReader["ETS / ICC"]) == 0 ? false : true;
						logDetail.IsEtsOae = Convert.ToInt16(dataReader["ETS / OAE"]) == 0 ? false : true;
						logDetail.IsEtsOas = Convert.ToInt16(dataReader["ETS / OAS"]) == 0 ? false : true;

						logDetail.IsTrainingShortDuration = Convert.ToInt16(dataReader["Training / SDR"]) == 0 ? false : true;
						logDetail.IsTrainingOverdue = Convert.ToInt16(dataReader["Training / ODT"]) == 0 ? false : true;

						logDetail.IsCtc = Convert.ToInt16(dataReader["Quality / CTC"]) == 0 ? false : true;
						logDetail.IsHigh5Club = Convert.ToInt16(dataReader["Quality / HFC"]) == 0 ? false : true;
						logDetail.IsKudo = Convert.ToInt16(dataReader["Quality / KUD"]) == 0 ? false : true;
						logDetail.IsOta = Convert.ToInt16(dataReader["Quality / OTA"]) == 0 ? false : true;
						logDetail.IsBqns = Convert.ToInt16(dataReader["Quality / BQNS"]) == 0 ? false : true;
						logDetail.IsBqm = Convert.ToInt16(dataReader["Quality / BQM"]) == 0 ? false : true;
						logDetail.IsBqms = Convert.ToInt16(dataReader["Quality / BQMS"]) == 0 ? false : true;

						logDetail.IsAttendance = Convert.ToInt16(dataReader["OTH / SEA"]) == 0 ? false : true;
						logDetail.IsDtt = Convert.ToInt16(dataReader["OTH / DTT"]) == 0 ? false : true;
						logDetail.IsOthAps = Convert.ToInt16(dataReader["OTH / APS"]) == 0 ? false : true;
						logDetail.IsOthApw = Convert.ToInt16(dataReader["OTH / APW"]) == 0 ? false : true;

						logDetail.IsMsr = Convert.ToInt16(dataReader["PSC / MSR"]) == 0 ? false : true;
						logDetail.IsMsrs = Convert.ToInt16(dataReader["PSC / MSRS"]) == 0 ? false : true;

						logDetail.SupervisorEmail = dataReader["strEmpSupEmail"].ToString();
						logDetail.ManagerEmail = dataReader["strEmpMgrEmail"].ToString();

						logDetail.IsQn = Convert.ToInt16(dataReader["isIQSQN"]) == 1 ? true : false;
                        logDetail.IsQnSupervisor = Convert.ToInt16(dataReader["isIQSQNS"]) == 1 ? true : false;
                        logDetail.BatchId = dataReader["strQNBatchId"].ToString();
						logDetail.StrengthOpportunity = dataReader["strQNStrengthsOpportunities"].ToString();

						if (string.IsNullOrEmpty(dataReader["IsFollowupRequired"].ToString()))
						{
							logDetail.IsFollowupRequired = false;
						}
						else  
						{
							logDetail.IsFollowupRequired = Convert.ToInt16(dataReader["IsFollowupRequired"]) == 1 ? true : false;
						}

						if (logDetail.IsFollowupRequired || logDetail.IsQn)
						{
							logDetail.FollowupSupName = dataReader["strFollowupSupervisor"].ToString();
							logDetail.FollowupSupAutoDate = EclUtil.AppendTimeZone(dataReader["SupFollowupAutoDate"].ToString());
							logDetail.FollowupDueDate = EclUtil.AppendTimeZone(dataReader["FollowupDueDate"].ToString());
							logDetail.FollowupActualDate = EclUtil.AppendTimeZone(dataReader["FollowupActualDate"].ToString());
							logDetail.FollowupDetails = dataReader["SupFollowupCoachingNotes"].ToString();

							logDetail.FollowupEmpAutoDate = EclUtil.AppendTimeZone(dataReader["EmpAckFollowupAutoDate"].ToString());
							logDetail.FollowupEmpComments = dataReader["EmpAckFollowupComments"].ToString();
						}

                        logDetail.FollowupDecisionComments = dataReader["SupFollowupReviewCoachingNotes"].ToString();

                        logDetail.PfdCompletedDate = EclUtil.AppendTimeZone(dataReader["PFDCompletedDate"].ToString());

                        // directors and senior managers
                        logDetail.SrMgrLevelOneEmpId = dataReader["strEmpSrMgrLvl1ID"].ToString().Trim().ToUpper();
						logDetail.SrMgrLevelTwoEmpId = dataReader["strEmpSrMgrLvl2ID"].ToString().Trim().ToUpper();
						logDetail.SrMgrLevelThreeEmpId = dataReader["strEmpSrMgrLvl3ID"].ToString().Trim().ToUpper();

                        // load 2nd resultset - qn linked logs
                        dataReader.NextResult();
                        var linkedLogs = new List<TextValue>();
                        while (dataReader.Read())
                        {
                            var temp = new TextValue(
                                    dataReader["QNLinkedFormName"].ToString(),
                                    dataReader["QNLinkedID"].ToString()
                                );
                            linkedLogs.Add(temp);
                        }
                        logDetail.LinkedLogs = linkedLogs;

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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intLogId", logId);
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intLogId", logId);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        logDetail.LogId = (long)dataReader["numID"];
                        logDetail.FormName = dataReader["strFormID"].ToString();
                        logDetail.Source = dataReader["strSource"].ToString();
                        logDetail.Status = dataReader["strFormStatus"].ToString();
						logDetail.StatusId = (int)dataReader["StatusId"];
						logDetail.Type = dataReader["strFormType"].ToString();
                        logDetail.CreatedDate = EclUtil.AppendTimeZone(dataReader["SubmittedDate"].ToString());
                        logDetail.EventDate = EclUtil.AppendTimeZone(dataReader["EventDate"].ToString());
                        logDetail.SubmitterName = dataReader["strSubmitterName"].ToString();
						logDetail.SubmitterEmpId = dataReader["strSubmitterID"].ToString().Trim().ToUpper();
						logDetail.EmployeeName = dataReader["strEmpName"].ToString().Trim();
						logDetail.EmployeeId = dataReader["strEmpID"].ToString().Trim().ToUpper();
                        logDetail.EmployeeSite = dataReader["strEmpSite"].ToString();
                        logDetail.SupervisorName = dataReader["strEmpSupName"].ToString();
						logDetail.SupervisorEmpId = dataReader["strEmpSupID"].ToString().Trim().ToUpper();
                        logDetail.ManagerName = dataReader["strEmpMgrName"].ToString();
						logDetail.ManagerEmpId = dataReader["strEmpMgrID"].ToString().Trim().ToUpper();

						logDetail.ModuleId = (int)dataReader["ModuleID"];
						logDetail.SupervisorEmail = dataReader["strEmpSupEmail"].ToString();
						logDetail.ManagerEmail = dataReader["strEmpMgrEmail"].ToString();

						logDetail.IsFormalAttendanceHours = dataReader["FC/ ATTH"].ToString() == "0" ? false : true;
						logDetail.IsFormalAttendanceTrends = dataReader["FC / ATTT"].ToString() == "0" ? false : true;
						logDetail.InstructionText = dataReader["strStaticText"].ToString();
						logDetail.EmployeeReviewDate = EclUtil.AppendTimeZone(dataReader["CSRReviewAutoDate"].ToString());
						logDetail.Comment = dataReader["CSRComments"].ToString();

						// directors and senior managers
						logDetail.SrMgrLevelOneEmpId = dataReader["strEmpSrMgrLvl1ID"].ToString().Trim().ToUpper();
						logDetail.SrMgrLevelTwoEmpId = dataReader["strEmpSrMgrLvl2ID"].ToString().Trim().ToUpper();
						logDetail.SrMgrLevelThreeEmpId = dataReader["strEmpSrMgrLvl3ID"].ToString().Trim().ToUpper();

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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
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
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@strSourcein", source);
                command.Parameters.AddWithValueSafe("@isSplReason", isSpecialReason);
                command.Parameters.AddWithValueSafe("@splReasonPrty", reasonPriority);
                command.Parameters.AddWithValueSafe("@strEmpIDin", employeeId);
                command.Parameters.AddWithValueSafe("@strSubmitterIDin", userId);
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intReasonIDin", reasonId);
                command.Parameters.AddWithValueSafe("@strSourcein", directOrIndirect);
                command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@nvcEmpIDin", employeeId);
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@strSourcein", directOrIndirect);
                command.Parameters.AddWithValueSafe("@isSplReason", isSpecialResaon);
                command.Parameters.AddWithValueSafe("@splReasonPrty", specialReasonPriority);
                command.Parameters.AddWithValueSafe("@strEmpIDin", employeeId);
                command.Parameters.AddWithValueSafe("@strSubmitterIDin", userId);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
					int index = 0;
					while (dataReader.Read())
                    {
                        CoachingReason cr = new CoachingReason();
                        cr.ID = (int)dataReader["CoachingReasonID"];
                        cr.Text = dataReader["CoachingReason"].ToString();
						cr.Index = index;
                        coachingReasons.Add(cr);
						index++;
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intReasonIDin", reasonId);
                command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@strSourcein", directOrIndirect);
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intReasonIDin", reasonId);
                command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@strSourcein", directOrIndirect);
                command.Parameters.AddWithValueSafe("@nvcEmpIDin", employeeId);
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
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
			using (SqlCommand command = new SqlCommand("[EC].[sp_Search_For_Dashboards_Details]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcUserIdin", userId);
                command.Parameters.AddWithValueSafe("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValueSafe("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValueSafe("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValueSafe("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValueSafe("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValueSafe("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValueSafe("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValueSafe("strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValueSafe("@nvcValue", logFilter.ValueId);
                command.Parameters.AddWithValueSafe("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValueSafe("@intEmpActive", logFilter.ActiveEmployee);
				command.Parameters.AddWithValueSafe("@PageSize", pageSize);
				command.Parameters.AddWithValueSafe("@startRowIndex", rowStartIndex);
				command.Parameters.AddWithValueSafe("@sortBy", sortBy);
				command.Parameters.AddWithValueSafe("@sortASC", sortDirection);
				command.Parameters.AddWithValueSafe("@nvcSearch", search);
                command.Parameters.AddWithValueSafe("@nvcWhichDashboard", logFilter.LogType);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogBase log = new LogBase();
						//log.RowNumber = (long)dataReader["RowNumber"];
						log.ID = (long)dataReader["strLogID"];
						log.FormName = dataReader["strFormID"].ToString();
						log.EmployeeName = dataReader["strEmpName"].ToString().Trim();
						log.SupervisorName = dataReader["strEmpSupName"].ToString();
						log.ManagerName = dataReader["strEmpMgrName"].ToString();
						log.Status = dataReader["strFormStatus"].ToString();
						log.SubmitterName = dataReader["strSubmitterName"].ToString();
						log.Source = dataReader["strSource"].ToString();
						log.Reasons = dataReader["strCoachingReason"].ToString();
						log.SubReasons = dataReader["strSubCoachingReason"].ToString();
						log.Value = dataReader["strValue"].ToString();
						log.CreatedDate = dataReader["SubmittedDate"].ToString();
						log.IsCoaching = !string.IsNullOrEmpty(log.Source) && log.Source != "Warning" ? true : false;

						// the sp to return my team's warning is not returning these 3 fields
						// the sp to return log list for Director Dashboard is not returing these 3 fields
						if (logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_TEAM_WARNING
							&& logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_SITE_PENDING
							&& logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_SITE_WARNING
							&& logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_SITE_COMPLETED)
						{
							log.IsFollowupRequired = dataReader["IsFollowupRequired"].ToString().ToLower().Equals("yes") ? true : false;
							log.FollowupDueDate = dataReader["FollowupDueDate"].ToString();
							log.HasFollowupHappened = dataReader["IsFollowupCompleted"].ToString().ToLower().Equals("yes") ? true : false;
						}

						logs.Add(log);
					}
				}
			}
			return logs;
		}

		public int GetLogListTotal(LogFilter logFilter, User user, string search)
		{
			int count = -1;
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Search_For_Dashboards_Count]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcUserIdin", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValueSafe("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValueSafe("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValueSafe("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValueSafe("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValueSafe("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValueSafe("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValueSafe("@strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValueSafe("@nvcValue", logFilter.ValueId);
				command.Parameters.AddWithValueSafe("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValueSafe("@intEmpActive", logFilter.ActiveEmployee);
				command.Parameters.AddWithValueSafe("@nvcSearch", search);
				command.Parameters.AddWithValueSafe("@nvcWhichDashboard", logFilter.LogType);

				try
				{
					connection.Open();
					count = (int)command.ExecuteScalar();
				}
				catch (Exception ex)
				{
					logger.Error("Failed to get log total: " + ex.Message);
                    logger.Error(ex);

                    LogGetLogListTotal(logFilter, user, search);
                    
					throw ex;
				}
                finally
                {
                    if (connection == null)
                    {
                        logger.Error("!!!!!!!!!!! connection is null !!!!!!!!!!!!!!");
                    }
                }
			}
			return count;
		}

        private void LogGetLogListTotal(LogFilter logFilter, User user, string search)
        {
            if (logFilter == null)
            {
                logger.Error("###logFilter is null!!!");
                return;
            }

            var userId = user == null ? "usernull" : user.EmployeeId;
            var msg = $"user[{userId}],role[{user.Role}],src[{logFilter.SourceId}],type[{logFilter.LogType}],site[{logFilter.SiteId}],";
            msg += $"sup[{logFilter.SupervisorId}],mgr[{logFilter.ManagerId}],submitter[{logFilter.SubmitterId}],";
            msg += $"from[{logFilter.SubmitDateFrom}],to[{logFilter.SubmitDateTo}],val[{logFilter.ValueId}],";
            msg += $"status[{logFilter.StatusId}],active[{logFilter.ActiveEmployee}],search[{search}]";

            logger.Error("&&&&&LogGetLogListTotal:" + msg);
        }

        public List<LogBase> GetLogListQn(LogFilter logFilter, string userId, int pageSize, int rowStartIndex, string sortBy, string sortDirection, string search)
        {
            List<LogBase> logs = new List<LogBase>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Search_For_Dashboards_Details_QN]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@nvcUserIdin", userId);
                command.Parameters.AddWithValueSafe("@intSourceIdin", logFilter.SourceId);
                command.Parameters.AddWithValueSafe("@intSiteIdin", logFilter.SiteId);
                command.Parameters.AddWithValueSafe("@nvcEmpIdin", logFilter.EmployeeId);
                command.Parameters.AddWithValueSafe("@nvcSupIdin", logFilter.SupervisorId);
                command.Parameters.AddWithValueSafe("@nvcMgrIdin", logFilter.ManagerId);
                command.Parameters.AddWithValueSafe("@nvcSubmitterIdin", logFilter.SubmitterId);
                command.Parameters.AddWithValueSafe("@strSDatein", logFilter.SubmitDateFrom);
                command.Parameters.AddWithValueSafe("@strEDatein", logFilter.SubmitDateTo);
                command.Parameters.AddWithValueSafe("@nvcValue", logFilter.ValueId);
                command.Parameters.AddWithValueSafe("@intStatusIdin", logFilter.StatusId);
                command.Parameters.AddWithValueSafe("@intEmpActive", logFilter.ActiveEmployee);
                command.Parameters.AddWithValueSafe("@PageSize", pageSize);
                command.Parameters.AddWithValueSafe("@startRowIndex", rowStartIndex);
                command.Parameters.AddWithValueSafe("@sortBy", sortBy);
                command.Parameters.AddWithValueSafe("@sortASC", sortDirection);
                command.Parameters.AddWithValueSafe("@nvcSearch", search);
                command.Parameters.AddWithValueSafe("@nvcWhichDashboard", logFilter.LogType);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        LogBase log = new LogBase();
                        //log.RowNumber = (long)dataReader["RowNumber"];
                        log.ID = (long)dataReader["strLogID"];
                        log.FormName = dataReader["strFormID"].ToString();
                        log.EmployeeName = dataReader["strEmpName"].ToString().Trim();
                        log.SupervisorName = dataReader["strEmpSupName"].ToString();
                        log.ManagerName = dataReader["strEmpMgrName"].ToString();
                        log.Status = dataReader["strFormStatus"].ToString();
                        log.SubmitterName = dataReader["strSubmitterName"].ToString();
                        log.Source = dataReader["strSource"].ToString();
                        log.Reasons = dataReader["strCoachingReason"].ToString();
                        log.SubReasons = dataReader["strSubCoachingReason"].ToString();
                        log.Value = dataReader["strValue"].ToString();
                        log.CreatedDate = dataReader["SubmittedDate"].ToString();
                        log.IsCoaching = !string.IsNullOrEmpty(log.Source) && log.Source != "Warning" ? true : false;

                        // the sp to return my team's warning is not returning these 3 fields
                        // the sp to return log list for Director Dashboard is not returing these 3 fields
                        if (logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_TEAM_WARNING
                            && logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_SITE_PENDING
                            && logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_SITE_WARNING
                            && logFilter.LogType != Constants.LOG_SEARCH_TYPE_MY_SITE_COMPLETED)
                        {
                            log.IsFollowupRequired = dataReader["IsFollowupRequired"].ToString().ToLower().Equals("yes") ? true : false;
                            log.FollowupDueDate = dataReader["FollowupDueDate"].ToString();
                            log.HasFollowupHappened = dataReader["IsFollowupCompleted"].ToString().ToLower().Equals("yes") ? true : false;
                        }

                        logs.Add(log);
                    }
                }
            }
            return logs;
        }

        public int GetLogListTotalQn(LogFilter logFilter, User user, string search)
        {
            int count = -1;
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Search_For_Dashboards_Count_QN]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@nvcUserIdin", user.EmployeeId);
                command.Parameters.AddWithValueSafe("@intSourceIdin", logFilter.SourceId);
                command.Parameters.AddWithValueSafe("@intSiteIdin", logFilter.SiteId);
                command.Parameters.AddWithValueSafe("@nvcEmpIdin", logFilter.EmployeeId);
                command.Parameters.AddWithValueSafe("@nvcSupIdin", logFilter.SupervisorId);
                command.Parameters.AddWithValueSafe("@nvcMgrIdin", logFilter.ManagerId);
                command.Parameters.AddWithValueSafe("@nvcSubmitterIdin", logFilter.SubmitterId);
                command.Parameters.AddWithValueSafe("@strSDatein", logFilter.SubmitDateFrom);
                command.Parameters.AddWithValueSafe("@strEDatein", logFilter.SubmitDateTo);
                command.Parameters.AddWithValueSafe("@nvcValue", logFilter.ValueId);
                command.Parameters.AddWithValueSafe("@intStatusIdin", logFilter.StatusId);
                command.Parameters.AddWithValueSafe("@intEmpActive", logFilter.ActiveEmployee);
                command.Parameters.AddWithValueSafe("@nvcSearch", search);
                command.Parameters.AddWithValueSafe("@nvcWhichDashboard", logFilter.LogType);

                try
                {
                    connection.Open();
                    count = (int)command.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    logger.Error("Failed to get QN log total: " + ex.Message);
                    logger.Error(ex);

                    LogGetLogListTotal(logFilter, user, search);

                    throw ex;
                }
                finally
                {
                    if (connection == null)
                    {
                        logger.Error("########## connection is null !!!!!!!!!!!!!!");
                    }
                }
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpID", userEmpId);
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
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
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

		// Historical Dashboard - export to excel
		public DataSet GetLogDataTableToExport(LogFilter logFilter, string userId)
		{
			DataSet dataSet = new DataSet();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Historical_Export]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcUserIdin", userId);
				command.Parameters.AddWithValueSafe("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValueSafe("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValueSafe("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValueSafe("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValueSafe("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValueSafe("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValueSafe("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValueSafe("@strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValueSafe("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValueSafe("@nvcValue", logFilter.ValueId);
				command.Parameters.AddWithValueSafe("@intEmpActive", logFilter.ActiveEmployee);

				using (SqlDataAdapter sda = new SqlDataAdapter(command))
				{
					sda.Fill(dataSet);
				}
			}
			return dataSet;	
		}

		// Historical Dashboard - export to excel - records count
		public int GetLogCountToExport(LogFilter logFilter, string userId)
		{
			int count = -1;
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Historical_Export_Count]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcUserIdin", userId);
				command.Parameters.AddWithValueSafe("@intSourceIdin", logFilter.SourceId);
				command.Parameters.AddWithValueSafe("@intSiteIdin", logFilter.SiteId);
				command.Parameters.AddWithValueSafe("@nvcEmpIdin", logFilter.EmployeeId);
				command.Parameters.AddWithValueSafe("@nvcSupIdin", logFilter.SupervisorId);
				command.Parameters.AddWithValueSafe("@nvcMgrIdin", logFilter.ManagerId);
				command.Parameters.AddWithValueSafe("@nvcSubmitterIdin", logFilter.SubmitterId);
				command.Parameters.AddWithValueSafe("@strSDatein", logFilter.SubmitDateFrom);
				command.Parameters.AddWithValueSafe("@strEDatein", logFilter.SubmitDateTo);
				command.Parameters.AddWithValueSafe("@nvcValue", logFilter.ValueId);
				command.Parameters.AddWithValueSafe("@intStatusIdin", logFilter.StatusId);
				command.Parameters.AddWithValueSafe("@intEmpActive", logFilter.ActiveEmployee);

				try
				{
					connection.Open();
					count = (int)(command.ExecuteScalar());
				}
				catch (Exception ex)
				{
					logger.Error("Failed to get log total: " + ex.Message);
					throw ex;
				}
			}
			return count;
		}

		// Get logs for director that the director is in charge of, for the specified site, status, start/end dates
		public DataSet GetLogDataTableToExport(int siteId, string status, string start, string end, string userId)
		{
			DataSet dt = new DataSet();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Director_Site_Export]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcUserIdin", userId);
				command.Parameters.AddWithValueSafe("@intSiteIdin", siteId);
				command.Parameters.AddWithValueSafe("@nvcStatus", status);
				command.Parameters.AddWithValueSafe("@strSDatein", start);
				command.Parameters.AddWithValueSafe("@strEDatein", end);

				using (SqlDataAdapter sda = new SqlDataAdapter(command))
				{
					sda.Fill(dt);
				}
			}
			return dt;
		}

		// My Dashboard - director - export to excel - records count
		public int GetLogCountToExport(int siteId, string status, string start, string end, string userId)
		{
			int count = -1;
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Director_Site_Export_Count]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcUserIdin", userId);
				command.Parameters.AddWithValueSafe("@intSiteIdin", siteId);
				command.Parameters.AddWithValueSafe("@nvcStatus", status);
				command.Parameters.AddWithValueSafe("@strSDatein", start);
				command.Parameters.AddWithValueSafe("@strEDatein", end);

				try
				{
					connection.Open();
					count = (int)command.ExecuteScalar();
				}
				catch (Exception ex)
				{
					logger.Error("Failed to get log total: " + ex.Message);
					throw ex;
				}
			}
			return count;
		}

		public IList<LogState> GetWarningStatuses(User user)
		{
			var logStates = new List<LogState>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_States_For_Dashboard]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogState state = new LogState();
						state.Id = Convert.ToInt16(dataReader["StateValue"]);
						state.Name = dataReader["StateText"].ToString();
						logStates.Add(state);
					}
				}
			}
			return logStates;
		}

		public IList<LogCount> GetLogCounts(User user)
		{
			var logCounts = new List<LogCount>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Summary_Count]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpID", user.EmployeeId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogCount lc = new LogCount();
						lc.Description = dataReader["CountType"].ToString();
						lc.Count = Convert.ToInt32(dataReader["LogCount"]);
						logCounts.Add(lc);
					}
				}
			}
			return logCounts;
		}

		public IList<LogCountForSite> GetLogCountsForSites(User user, DateTime start, DateTime end)
		{
			var logCountsForSites = new List<LogCountForSite>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Director_Summary_Count]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@strSDatein", start);
				command.Parameters.AddWithValueSafe("strEDatein", end);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogCountForSite logCountForSite = new LogCountForSite();
						logCountForSite.SiteName = dataReader["City"].ToString();
						logCountForSite.SiteId = Convert.ToInt32(dataReader["SiteID"]);
						logCountForSite.TotalPending = Convert.ToInt32(dataReader["PendingCount"]);
						logCountForSite.TotalCompleted = Convert.ToInt32(dataReader["CompletedCount"]);
						logCountForSite.TotalWarning = Convert.ToInt32(dataReader["WarningCount"]);
						logCountsForSites.Add(logCountForSite);
					}
				}
			}
			return logCountsForSites;
		}

        public IList<LogCount> GetLogCountsQn(User user)
        {
            var logCounts = new List<LogCount>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Summary_Count_QN]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@nvcEmpID", user.EmployeeId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        LogCount lc = new LogCount();
                        lc.Description = dataReader["CountType"].ToString();
                        lc.Count = Convert.ToInt32(dataReader["LogCount"]);
                        logCounts.Add(lc);
                    }
                }
            }
            return logCounts;
        }

        public IList<ChartDataset> GetChartDataSets(User user)
		{
			var chartDatasets = new List<ChartDataset>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Summary_Count_ByStatus]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpID", user.EmployeeId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						ChartDataset cds = new ChartDataset();
						cds.label = dataReader["Status"].ToString();
						cds.data.Add(Convert.ToInt32(dataReader["LogCount"]));
						chartDatasets.Add(cds);
					}
				}
			}

			return chartDatasets;
		}

		public IList<LogCountByStatusForSite> GetLogCountByStatusForSites(User user, DateTime start, DateTime end)
		{
			var logCountByStatusForSites = new List<LogCountByStatusForSite>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Director_Summary_Count_ByStatus]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@strSDatein", start);
				command.Parameters.AddWithValueSafe("strEDatein", end);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						LogCountByStatusForSite lcs = new LogCountByStatusForSite();
						lcs.SiteName = dataReader["Site"].ToString();
						lcs.Status = dataReader["CountType"].ToString();
						lcs.Count = Convert.ToInt32(dataReader["LogCount"]);
						logCountByStatusForSites.Add(lcs);
					}
				}
			}
			return logCountByStatusForSites;
		}

        public CoachingLogDetail GetScorecardsAndSummary(long logId)
        {
            var log = new CoachingLogDetail();
            var scList = new List<Scorecard>();
            var summaryList = new List<LogSummary>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_SelectReviewFrom_Coaching_Log_Quality_Now]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@intLogId", logId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Scorecard sc = new Scorecard();
                        sc.EvalId = dataReader["Evaluation ID"].ToString();
                        sc.EvalName = dataReader["Evaluation"].ToString();
                        sc.ScorecardName = dataReader["Form Name"].ToString();
                        sc.VerintId = dataReader["Call ID"].ToString();
                        sc.CoachingMonitor = dataReader["Coaching Monitor"].ToString();
                        sc.DateOfEvent = dataReader["Date Of Event"].ToString();
                        sc.Program = dataReader["strProgram"].ToString();
                        sc.SubmitterName = dataReader["Submitter"].ToString();
                        sc.BusinessProcess = dataReader["Business Process"].ToString().Replace("<br />", "");
                        sc.BusinessProcessComment = dataReader["Business Process Comments"].ToString();
                        sc.InfoAccuracy = dataReader["Info Accuracy"].ToString().Replace("<br />", ""); ;
                        sc.InfoAccuracyComment = dataReader["Info Accuracy Comments"].ToString();
                        sc.PrivacyDisclaimers = dataReader["Privacy Disclaimers"].ToString().Replace("<br />", ""); ;
                        sc.PrivacyDisclaimersComment = dataReader["Privacy Disclaimers Comments"].ToString();
                        sc.IssueResolution = dataReader["Issue Resolution"].ToString().Replace("<br />", ""); ;
                        sc.IssueResolutionComment = dataReader["Issue Resolution Comments"].ToString();
                        sc.CallEfficiency = dataReader["Call Efficiency"].ToString().Replace("<br />", ""); ;
                        sc.CallEfficiencyComment = dataReader["Call Efficiency Comments"].ToString();
                        sc.ActiveListening = dataReader["Active Listening"].ToString().Replace("<br />", ""); ;
                        sc.ActiveListeningComment = dataReader["Active Listening Comments"].ToString();
                        sc.PersonalityFlexing = dataReader["Personality Flexing"].ToString().Replace("<br />", ""); ;
                        sc.PersonalityFlexingComment = dataReader["Personality Flexing Comments"].ToString();
                        sc.StartTemperature = dataReader["Start Temperature"].ToString().Replace("<br />", ""); ;
                        sc.StartTemperatureComment = dataReader["Start Temperature Comments"].ToString();
                        sc.EndTemperature = dataReader["End Temperature"].ToString().Replace("<br />", ""); ;
                        sc.EndTemperatureComment = dataReader["End Temperature Comments"].ToString();
                        sc.Channel = dataReader["Channel"].ToString();
                        sc.ActivityId = dataReader["Activity ID"].ToString();
                        sc.ContactReason = dataReader["Reason For Contact"].ToString();

                        scList.Add(sc);
                    }

                    // load 2nd resultset - summary
                    dataReader.NextResult();
                    while (dataReader.Read())
                    {
                        var temp = new LogSummary();
                        temp.Summary = dataReader["EvalSummaryNotes"].ToString();
                        temp.IsReadOnly = dataReader["IsReadOnly"] == DBNull.Value ? false : (bool)dataReader["IsReadOnly"];
                        summaryList.Add(temp);
                    }

                }
            }

            log.Scorecards = scList;
            log.QnSummaryList = summaryList;
            return log;
        }

        public IList<QnStatistic> GetPast3MonthStatisticQn(User user)
        {
            var statistics = new List<QnStatistic>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Dashboard_Summary_Performance_QN]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddWithValueSafe("@nvcUserId", user.EmployeeId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        QnStatistic temp = new QnStatistic();
                        temp.Name = dataReader.GetString(1); // EmpName
                        temp.ThisMonthMinus1Improved = dataReader.GetInt32(6);            
                        temp.ThisMonthMinus1Followup = dataReader.GetInt32(7);
                        temp.ThisMonthMinus2Improved = dataReader.GetInt32(4);
                        temp.ThisMonthMinus2Followup = dataReader.GetInt32(5);
                        temp.ThisMonthMinus3Improved = dataReader.GetInt32(2);
                        temp.ThisMonthMinus3Followup = dataReader.GetInt32(3);

                        statistics.Add(temp);
                    }
                }
            }
            return statistics;
        }

        private string UpdatePdtToEst(string str)
        {
            if (String.IsNullOrEmpty(str) || str.IndexOf("PDT)") < 0)
            {
                return str;
            }

            return str.Replace("PDT)", Constants.TIMEZONE + ")");
        }

    }
}
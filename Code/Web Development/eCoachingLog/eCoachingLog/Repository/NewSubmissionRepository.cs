using eCoachingLog.Extensions;
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace eCoachingLog.Repository
{
	public class NewSubmissionRepository : INewSubmissionRepository
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public List<LogSource> GetSourceListByModuleId(int moduleId, string directOrIndirect)
        {
            var sourceList = new List<LogSource>();

			using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Source_By_Module]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId); 
                command.Parameters.AddWithValueSafe("@strSourcein", directOrIndirect);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        LogSource source = new LogSource();
						source.Id = (int)dataReader["SourceID"];
                        source.Name = (string)dataReader["Source"];

                        sourceList.Add(source);
                    }

                    dataReader.Close();
                }
            }
            return sourceList;
        }

        public IList<NewSubmissionResult> SaveCoachingLog(NewSubmission submission, User user)
        {
            var ret = new List<NewSubmissionResult>();

            // multi logs per submission - return "employee id, employee name, log name, create date, error"; 
            // log name will be null if failed so the page will display those failed employee names 
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Coaching_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddStringTableType("@tableEmpIDs", submission.EmployeeIdList); 
                // Should be no program for LSA module
                if (submission.ModuleId == Constants.MODULE_LSA)
                {
                    submission.ProgramName = "NA";
                }
                command.Parameters.AddWithValueSafe("@nvcProgramName", submission.ProgramName);
                command.Parameters.AddWithValueSafe("@Behaviour", submission.BehaviorName); 
                command.Parameters.AddWithValueSafe("@intSourceID", submission.SourceId); // How was the coaching identifed?
                command.Parameters.AddWithValueSafe("@nvcSubmitterID", user.EmployeeId);

                var startDate = submission.CoachingDate;
                if (submission.IsDirect.HasValue && submission.IsDirect.Value)
                {
                    command.Parameters.AddWithValueSafe("@dtmEventDate", null);
                    command.Parameters.AddWithValueSafe("@dtmCoachingDate", submission.CoachingDate);
                }
                else
                {
                    command.Parameters.AddWithValueSafe("@dtmEventDate", submission.CoachingDate);
                    command.Parameters.AddWithValueSafe("@dtmCoachingDate", null);
                    startDate = submission.CoachingDate;
                }

                command.Parameters.AddWithValueSafe("@dtmPFDCompletedDate", submission.PfdCompletedDate); 

                // Call Type and Call ID
                bool isAvokeId = false;
                string avokeId = null;
                bool isVerintId = false;
                string verintId = null;
                bool isUcId = false;
                string ucId = null;
                bool isNgdId = false;
                string ngdId = null;
                if (submission.IsCallAssociated)
                {
                    switch (submission.CallTypeName)
                    { 
                        case Constants.CALL_TYPE_AVOKE:
                            isAvokeId = true;
                            avokeId = submission.CallId;
                            break;
                        case Constants.CALL_TYPE_VERINT:
                            isVerintId = true;
                            verintId = submission.CallId;
                            break;
                        case Constants.CALL_TYPE_UCID:
                            isUcId = true;
                            ucId = submission.CallId;
                            break;
                        case Constants.CALL_TYPE_NGDID:
                            isNgdId = true;
                            ngdId = submission.CallId;
                            break;
                    }
                }
                command.Parameters.AddWithValueSafe("@bitisAvokeID", isAvokeId);
                command.Parameters.AddWithValueSafe("@nvcAvokeID", avokeId);
                command.Parameters.AddWithValueSafe("@bitisVerintID", isVerintId);
                command.Parameters.AddWithValueSafe("@nvcVerintID", verintId);
                command.Parameters.AddWithValueSafe("@bitisUCID", isUcId);
                command.Parameters.AddWithValueSafe("@nvcUCID", ucId);
                command.Parameters.AddWithValueSafe("@bitisNGDActivityID", isNgdId);
                command.Parameters.AddWithValueSafe("@nvcNGDActivityID", ngdId);

                // Coaching Reasons
                // TODO: pass in using UserTableType 
                int count = 0;
                List<CoachingReason> crs = submission.CoachingReasons;
                foreach(CoachingReason cr in crs)
                {
                    count++;
                    command.Parameters.AddWithValueSafe("@intCoachReasonID" + count, cr.ID);
                    string temp = cr.IsOpportunity.Value ? "Opportunity" : "Reinforcement";
                    command.Parameters.AddWithValueSafe("@nvcValue" + count, temp);
                    // Conconcate all sub reason ids using ","
                    command.Parameters.AddWithValueSafe("@nvcSubCoachReasonID" + count, String.Join(",", cr.SubReasonIds));
                }
                // Maximum number of reasons is 12.                 
                for (int i = count + 1; i <= Constants.MAX_NUMBER_OF_COACHING_REASONS; i++)
                {
                    command.Parameters.AddWithValueSafe("@intCoachReasonID" + i,  "");
                    command.Parameters.AddWithValueSafe("@nvcValue" + i, "");
                    command.Parameters.AddWithValueSafe("@nvcSubCoachReasonID" + i, "");
                }

                command.Parameters.AddWithValueSafe("@nvcDescription", submission.BehaviorDetail);
                command.Parameters.AddWithValueSafe("@nvcCoachingNotes", submission.Plans);
                command.Parameters.AddWithValueSafe("@bitisVerified", true);
                command.Parameters.AddWithValueSafe("@dtmSubmittedDate", DateTime.Now);
                command.Parameters.AddWithValueSafe("@dtmStartDate", startDate);
                command.Parameters.AddWithValueSafe("@bitisCSE", submission.IsCse);
                command.Parameters.AddWithValueSafe("@ModuleID", submission.ModuleId);
                command.Parameters.AddWithValueSafe("@bitisFollowupRequired", submission.IsFollowupRequired);
                command.Parameters.AddWithValueSafe("@dtmFollowupDueDate", submission.FollowupDueDate);

                try
                {
                    connection.Open();
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            var r = new NewSubmissionResult();
                            r.LogId = dataReader["LogId"].ToString();
                            r.LogName = dataReader["LogName"].ToString();
                            r.Employee.Name = dataReader["EmployeeName"].ToString();
                            r.CreateDateTime = dataReader["CreateDateTime"].ToString();
                            r.Employee.Email = dataReader["EmpEmail"].ToString();
                            r.Employee.SupervisorEmail = dataReader["SupEmail"].ToString();
                            r.Employee.ManagerEmail = dataReader["MgrEmail"].ToString();
                            r.Error = dataReader["ErrorReason"].ToString();

                            ret.Add(r);
                        } // end while

                        dataReader.Close();
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("Failed to save coaching log: " + ex.Message);
                    throw new Exception(ex.Message);
                }
            } // end Using 

            return ret;
        }

        public IList<NewSubmissionResult> SaveWarningLog(NewSubmission ns, User user)
        {
            var ret = new List<NewSubmissionResult>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Warning_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                command.Parameters.AddStringTableType("@tableEmpIDs", ns.EmployeeIdList);
                command.Parameters.AddWithValueSafe("@nvcProgramName", ns.ProgramName);
				command.Parameters.AddWithValueSafe("@nvcSubmitterID", user.EmployeeId);
                command.Parameters.AddWithValueSafe("@dtmEventDate", ns.WarningDate);
                command.Parameters.AddWithValueSafe("@intCoachReasonID1", ns.WarningTypeId);
                command.Parameters.AddWithValueSafe("@nvcSubCoachReasonID1", ns.WarningReasonId);
                command.Parameters.AddWithValueSafe("@dtmSubmittedDate", DateTime.Now);
                command.Parameters.AddWithValueSafe("@ModuleID", ns.ModuleId);
                command.Parameters.AddWithValueSafe("@nvcBehavior", ns.BehaviorName);

                try
                {
                    connection.Open();
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            var r = new NewSubmissionResult();
                            r.LogId = dataReader["LogId"].ToString();
                            r.LogName = dataReader["LogName"].ToString();
                            r.Employee.Name = dataReader["EmployeeName"].ToString();
                            r.CreateDateTime = dataReader["CreateDateTime"].ToString();
                            r.Error = dataReader["ErrorReason"].ToString();
                            r.Employee.Email = dataReader["EmpEmail"].ToString();
                            r.Employee.SupervisorEmail = dataReader["SupEmail"].ToString();
                            r.Employee.ManagerEmail = dataReader["MgrEmail"].ToString();

                            ret.Add(r);
                            break; // one warning log per submission
                        } // end while

                        dataReader.Close();
                    } // end SqlDataReader

                }
                catch (Exception ex)
                {
                    logger.Warn("[" + user.EmployeeId + "] Failed to save warning log: " + ex.Message);
					throw new Exception(ex.Message);
				}
            } // end Using 

            return ret;
        }

        public MailMetaData GetMailMetaData(int moduleId, int sourceId, bool isCse)
        {
            var mailMetaData = new MailMetaData();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Email_Attributes]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId); 
                command.Parameters.AddWithValueSafe("@intSourceIDin", sourceId);
                command.Parameters.AddWithValueSafe("@bitisCSEin", isCse);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        mailMetaData.ToTitle = (string)dataReader["Receiver"];
                        mailMetaData.CcTitle = (string)dataReader["CCReceiver"];
                        mailMetaData.IsCc = (bool)dataReader["isCCReceiver"];
                        mailMetaData.PartialBody = (string)dataReader["EmailText"];
                        mailMetaData.LogStatus = (string)dataReader["StatusName"];
                        break;
                    }

                    dataReader.Close();
                }
            }

            return mailMetaData;
        }

        public int GetLogStatusToSet(int moduleId, int sourceId, bool isCse)
        {
            int logStatusId = -1;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Email_Attributes]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
                command.Parameters.AddWithValueSafe("@intSourceIDin", sourceId);
                command.Parameters.AddWithValueSafe("@bitisCSEin", isCse);
                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        logStatusId = (int)dataReader["StatusID"];
                        break;
                    }

                    dataReader.Close();
                }
            }
            return logStatusId;
        }

    }
}
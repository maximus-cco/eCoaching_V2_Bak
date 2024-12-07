﻿using eCoachingLog.Extensions;
using eCoachingLog.Models;
using eCoachingLog.Models.Common;
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
                }
            }
            return sourceList;
        }

        public IList<NewSubmissionResult> SaveCoachingLog(NewSubmission submission, User user)
        {
            var empIds = submission.EmployeeIdList;
            int total = empIds.Count;

            logger.Debug("Entered SaveCoachingLog ...");

            var temp = new List<NewSubmissionResult>();
            for (int i = 0; i < total; i++)
            {
                var a = new NewSubmissionResult();
                var e = new Employee();
                e.Id = i + "";
                e.Name = "employee" + i;
                a.LogName = "log" + i;
                a.Error = null;
                e.Email = "lilihuang@maximus.com";
                e.SupervisorEmail = "lilihuang@maximus.com";
                e.ManagerEmail = "lilihuang@maximus.com";
                temp.Add(a);
            }
            return temp;


            // multi logs per submission - return resultset "employee id, employee name, log name, error"; log name will be null if failed
/*
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Coaching_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                // TODO: submission.EmployeeIdList as user defined table type
				command.Parameters.AddWithValueSafe("@nvcEmpID", submission.Employee.Id); //////// TODO: change to a table so i can pass in a list of employee id
				// Should be no program for LSA module
				if (submission.ModuleId == Constants.MODULE_LSA)
				{
					submission.ProgramName = "NA";
				}
                command.Parameters.AddWithValueSafe("@nvcProgramName", submission.ProgramName);
                command.Parameters.AddWithValueSafe("@Behaviour", submission.BehaviorName); 
                command.Parameters.AddWithValueSafe("@intSourceID", submission.SourceId); // How was the coaching identifed?
				if (submission.ModuleId == Constants.MODULE_CSR)
				{
					command.Parameters.AddWithValueSafe("@SiteID", submission.SiteId);
				}
				else
				{
					command.Parameters.AddWithValueSafe("@SiteID", null); // Modules other than CSR have no site selection
				}
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
                command.Parameters.AddWithValueSafe("@dtmSupReviewedAutoDate", null);
                command.Parameters.AddWithValueSafe("@bitisCSE", submission.IsCse);
                command.Parameters.AddWithValueSafe("@dtmMgrReviewManualDate", null);
                command.Parameters.AddWithValueSafe("@dtmMgrReviewAutoDate", null);
                command.Parameters.AddWithValueSafe("@nvcMgrNotes", null);
                command.Parameters.AddWithValueSafe("@bitisCSRAcknowledged", null);
                command.Parameters.AddWithValueSafe("@dtmCSRReviewAutoDate", null);
                command.Parameters.AddWithValueSafe("@nvcCSRComments", null);
                command.Parameters.AddWithValueSafe("@ModuleID", submission.ModuleId);
				command.Parameters.AddWithValueSafe("@bitisFollowupRequired", submission.IsFollowupRequired);
				command.Parameters.AddWithValueSafe("@dtmFollowupDueDate", submission.FollowupDueDate);

                // Output parameter
                SqlParameter newFormNameParam = command.Parameters.Add("@nvcNewFormName", SqlDbType.VarChar, 30);
                newFormNameParam.Direction = ParameterDirection.Output;
				// Return Value
                SqlParameter returnParam = command.Parameters.Add("@return_value", SqlDbType.Int);
                returnParam.Direction = ParameterDirection.ReturnValue;
                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();

                    int returnValue = -1;
                    returnValue = (int)returnParam.Value;

                    if (returnValue != 0)
                    {
                        throw new Exception("Failed to save new submission.");
                    }

                    logNameSaved = (string)newFormNameParam.Value;
                }
                catch (Exception ex)
                {
                    logger.Error("Failed to save coaching log: " + ex.Message);
					throw new Exception(ex.Message);
                }
            } // end Using 

            return logNameSaved;*/
        }

        // multi logs per submission - return resultset "employee id, employee name, log name, error"; log name will be null if failed
        // same as SaveCoachingLog
        public IList<NewSubmissionResult> SaveWarningLog(NewSubmission ns, User user)
        {
            string logNameSaved = "";
            //isDuplicate = false;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Warning_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcEmpID", ns.Employee.Id);
				command.Parameters.AddWithValueSafe("@nvcProgramName", ns.ProgramName);
				if (ns.ModuleId == Constants.MODULE_CSR)
				{
					command.Parameters.AddWithValueSafe("@SiteID", ns.SiteId);
				}
				else
				{
					command.Parameters.AddWithValueSafe("@SiteID", null); // Modules other than CSR have no site selection
				}
				command.Parameters.AddWithValueSafe("@nvcSubmitterID", user.EmployeeId);
                command.Parameters.AddWithValueSafe("@dtmEventDate", ns.WarningDate);
                command.Parameters.AddWithValueSafe("@intCoachReasonID1", ns.WarningTypeId);
                command.Parameters.AddWithValueSafe("@nvcSubCoachReasonID1", ns.WarningReasonId);
                command.Parameters.AddWithValueSafe("@dtmSubmittedDate", DateTime.Now);
                command.Parameters.AddWithValueSafe("@ModuleID", ns.ModuleId);
                command.Parameters.AddWithValueSafe("@nvcBehavior", ns.BehaviorName);

                // Output parameters
                SqlParameter isDupParam = command.Parameters.Add("@isDup", SqlDbType.Bit);
                isDupParam.Direction = ParameterDirection.Output;
                SqlParameter newFormNameParam = command.Parameters.Add("@nvcNewFormName", SqlDbType.VarChar, 30);
                newFormNameParam.Direction = ParameterDirection.Output;
				// Return value
                SqlParameter returnParam = command.Parameters.Add("@return_value", SqlDbType.Int);
                returnParam.Direction = ParameterDirection.ReturnValue;

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();

                    int returnValue = -1;
                    returnValue = (int)returnParam.Value;
					//isDuplicate = (bool)isDupParam.Value;
					//if (returnValue != 0 || isDuplicate)
     //               {
					//	string msg = "The warning log you are trying to submit already exists.";
					//	if (returnValue != 0)
					//	{
					//		msg = "Return value from sp_InsertInto_Warning_Log: " + returnValue;
					//	}
					//	throw new Exception(msg);
     //               }

                    logNameSaved = (string)newFormNameParam.Value;
                }
                catch (Exception ex)
                {
                    logger.Warn("[" + user.EmployeeId + "] Failed to save warning log: " + ex.Message);
					throw new Exception(ex.Message);
				}
            } // end Using 

            return new List<NewSubmissionResult>();
        }

        public Tuple<string, string, bool, string, string> GetEmailRecipientsTitlesAndBodyText(int moduleId, int sourceId, bool isCse)
        {
            string toRecipientTitle = "";
            string ccRecipientTitle = "";
            string text = "";
            bool isCc = false;
            string status = "";

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
                        toRecipientTitle = (string)dataReader["Receiver"];
                        ccRecipientTitle = (string)dataReader["CCReceiver"];
                        isCc = (bool)dataReader["isCCReceiver"];
                        text = (string)dataReader["EmailText"];
                        status = (string)dataReader["StatusName"];
                        break;
                    }
                }
            }

            return new Tuple<string, string, bool, string, string>(toRecipientTitle, ccRecipientTitle, isCc, text, status);
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
                }
            }
            return logStatusId;
        }

        // Save mail sent result
        public List<MailResult> SaveNotificationStatus(List<MailResult> mailResults, string userId)
        {
            logger.Debug("Entered SaveNotificationStatus...");

            var resultsSaved = new List<MailResult>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand comm = new SqlCommand("[EC].[sp_InsertInto_Email_Notifications_History]", connection))
            {
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
                comm.Parameters.AddMailHistoryTableType("@tableRecs", mailResults);
                comm.Parameters.AddWithValueSafe("@nvcUserID", userId);
                connection.Open();
                using (SqlDataReader dataReader = comm.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var temp = dataReader["Success"].ToString().ToLower();
                        resultsSaved.Add(new MailResult(
                            dataReader["FormName"].ToString(),
                            dataReader["To"].ToString(),
                            dataReader["Cc"].ToString(),
                            dataReader["SendattemptDate"].ToString(),
                            (temp == "1" || temp == "true") ? true : false)
                        );
                    } // end while
                } // end using SqlDataReader
            } // end using SqlCommand

            logger.Debug("Leaving SaveNotificationStatus...");
            return resultsSaved;
        }
    }
}
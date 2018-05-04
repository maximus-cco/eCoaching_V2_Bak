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
                command.Parameters.AddWithValue("@intModuleIDin", moduleId); 
                command.Parameters.AddWithValue("@strSourcein", directOrIndirect);
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

        // Return the log name saved 
        public string SaveCoachingLog(NewSubmission submission, User user)
        {
            logger.Debug("Entered SaveCoachingLog ...");
            string logNameSaved = null;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Coaching_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@nvcEmpID", submission.Employee.Id);
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
                command.Parameters.AddWithValue("@nvcSubmitterID", user.EmployeeId);

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
                command.Parameters.AddWithValue("@bitisAvokeID", isAvokeId);
                command.Parameters.AddWithValueSafe("@nvcAvokeID", avokeId);
                command.Parameters.AddWithValue("@bitisVerintID", isVerintId);
                command.Parameters.AddWithValueSafe("@nvcVerintID", verintId);
                command.Parameters.AddWithValue("@bitisUCID", isUcId);
                command.Parameters.AddWithValueSafe("@nvcUCID", ucId);
                command.Parameters.AddWithValue("@bitisNGDActivityID", isNgdId);
                command.Parameters.AddWithValueSafe("@nvcNGDActivityID", ngdId);

                // Coaching Reasons
                // TODO: pass in using UserTableType 
                int count = 0;
                List<CoachingReason> crs = submission.CoachingReasons;
                foreach(CoachingReason cr in crs)
                {
                    count++;
                    command.Parameters.AddWithValue("@intCoachReasonID" + count, cr.ID);
                    string temp = cr.IsOpportunity.Value ? "Opportunity" : "Reinforcement";
                    command.Parameters.AddWithValue("@nvcValue" + count, temp);
                    // Conconcate all sub reason ids using ","
                    command.Parameters.AddWithValue("@nvcSubCoachReasonID" + count, String.Join(",", cr.SubReasonIds));
                }
				// Maximum number of reasons is 12. 
                for (int i = count + 1; i <= Constants.MAX_NUMBER_OF_COACHING_REASONS; i++)
                {
                    command.Parameters.AddWithValue("@intCoachReasonID" + i,  "");
                    command.Parameters.AddWithValue("@nvcValue" + i, "");
                    command.Parameters.AddWithValue("@nvcSubCoachReasonID" + i, "");
                }

                command.Parameters.AddWithValueSafe("@nvcDescription", submission.BehaviorDetail);
                command.Parameters.AddWithValueSafe("@nvcCoachingNotes", submission.Plans);
                command.Parameters.AddWithValue("@bitisVerified", true);
                command.Parameters.AddWithValue("@dtmSubmittedDate", DateTime.Now);
                command.Parameters.AddWithValue("@dtmStartDate", startDate);
                command.Parameters.AddWithValueSafe("@dtmSupReviewedAutoDate", null);
                command.Parameters.AddWithValueSafe("@bitisCSE", submission.IsCse);
                command.Parameters.AddWithValueSafe("@dtmMgrReviewManualDate", null);
                command.Parameters.AddWithValueSafe("@dtmMgrReviewAutoDate", null);
                command.Parameters.AddWithValueSafe("@nvcMgrNotes", null);
                command.Parameters.AddWithValueSafe("@bitisCSRAcknowledged", null);
                command.Parameters.AddWithValueSafe("@dtmCSRReviewAutoDate", null);
                command.Parameters.AddWithValueSafe("@nvcCSRComments", null);
                command.Parameters.AddWithValue("@bitEmailSent", "True");
                command.Parameters.AddWithValue("@ModuleID", submission.ModuleId);

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

            return logNameSaved;
        }

        // Return the log name saved 
        public string SaveWarningLog(NewSubmission ns, User user, out bool isDuplicate)
        {
            string logNameSaved = "";
            isDuplicate = false;

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_InsertInto_Warning_Log]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@nvcEmpID", ns.Employee.Id);
				command.Parameters.AddWithValue("@nvcProgramName", ns.ProgramName);
                command.Parameters.AddWithValue("@SiteID", ns.SiteId);
                command.Parameters.AddWithValue("@nvcSubmitterID", user.EmployeeId);
                command.Parameters.AddWithValue("@dtmEventDate", ns.WarningDate);
                command.Parameters.AddWithValue("@intCoachReasonID1", ns.WarningTypeId);
                command.Parameters.AddWithValue("@nvcSubCoachReasonID1", ns.WarningReasonId);
                command.Parameters.AddWithValue("@dtmSubmittedDate", DateTime.Now);
                command.Parameters.AddWithValue("@ModuleID", ns.ModuleId);
                command.Parameters.AddWithValueSafe("nvcBehavior", ns.BehaviorName);

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

                    if (returnValue != 0)
                    {
                        throw new Exception("Failed to save new submission.");
                    }

                    isDuplicate = (bool)isDupParam.Value;
                    if (!isDuplicate)
                    {
                        logNameSaved = (string)newFormNameParam.Value;
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("Failed to save warning log: " + ex.Message);
					throw new Exception(ex.Message);
				}
            } // end Using 

            return logNameSaved;
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
                command.Parameters.AddWithValue("@intModuleIDin", moduleId); 
                command.Parameters.AddWithValue("@intSourceIDin", sourceId);
                command.Parameters.AddWithValue("@bitisCSEin", isCse);
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
                command.Parameters.AddWithValue("@intModuleIDin", moduleId);
                command.Parameters.AddWithValue("@intSourceIDin", sourceId);
                command.Parameters.AddWithValue("@bitisCSEin", isCse);
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
    }
}
using eCoachingLog.Extensions;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.Review;
using eCoachingLog.Models.User;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class ReviewRepository : IReviewRepository
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

		public IList<string> GetReasonsToSelect(string reportCode)
		{
			var reasons = new List<string>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Reasons_By_ReportCode]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcReportCode", reportCode);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						reasons.Add(dataReader["Reason"].ToString());
					}
				}
			}
			return reasons;
		}

		public IList<string> GetShortCallActions(string employeeId, int behaviorId)
		{

			var actions = new List<string>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_Get_Actions]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@EmpId", employeeId);
				command.Parameters.AddWithValueSafe("@intBehaviorId", behaviorId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						var action = dataReader["ActionText"].ToString().Trim();
						actions.Add(action);
					}
				} // end using SqlDataReader
			} // end using SqlCommand

			return actions;
		}

		public IList<ShortCall> GetShortCallEvalList(long logId)
		{
			var shortCallList = new List<ShortCall>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_Get_SupReviewDetails]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intLogId", logId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						ShortCall shortCall = new ShortCall();
						shortCall.VerintId = dataReader["VerintCallID"].ToString();
						shortCall.IsValidBehavior = (dataReader["valid"] != DBNull.Value && Convert.ToInt16(dataReader["valid"]) == 1) ? true : false;
						shortCall.SelectedBehaviorText = dataReader["Behavior"].ToString();
						shortCall.ActionsString = dataReader["Action"].ToString();
						shortCall.CoachingNotes = dataReader["CoachingNotes"].ToString();
						shortCall.IsLsaInformed = (dataReader["LSAInformed"] != DBNull.Value && Convert.ToInt16(dataReader["LSAInformed"]) == 1) ? true : false;
						shortCallList.Add(shortCall);
					}
				}
			}
			return shortCallList;
		}

		public IList<ShortCall> GetShortCallList(long logId)
		{
			var shortCallList = new List<ShortCall>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_Get_CallList]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intLogId", logId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						ShortCall shortCall = new ShortCall();
						shortCall.VerintId = dataReader["VerintId"].ToString();
						shortCallList.Add(shortCall);
					}
				}
			}
			return shortCallList;
		}

		public IList<Behavior> GetShortCallBehaviorList(bool isValid)
		{
			var behaviorList = new List<Behavior>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_Get_BehaviorList]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@isValid", isValid);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Behavior behavior = new Behavior();
						behavior.Id = Convert.ToInt16(dataReader["BehaviorId"]);
						behavior.Text = dataReader["BehaviorText"].ToString();
						behaviorList.Add(behavior);
					}
				}
			}
			return behaviorList;
		}

		public string GetShortCallAction(string employeeId, int behaviorId)
		{
			var action = string.Empty;
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_Get_Actions]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@intBehaviorId", behaviorId);
				command.Parameters.AddWithValueSafe("@EmpId", employeeId);
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						action = string.IsNullOrEmpty(action) ? dataReader["ActionText"].ToString().Trim() : "; " + dataReader["ActionText"].ToString().Trim();
					}
				}
			}
			return action;
		}

		public bool CompleteRegularPendingReview(Review review, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteRegularPendingReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Supervisor_Pending]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcFormID", review.LogDetail.LogId);
				command.Parameters.AddWithValueSafe("@nvcReviewSupID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus);
				command.Parameters.AddWithValueSafe("@dtmSupReviewedAutoDate", DateTime.Now);
				command.Parameters.AddWithValueSafe("@nvctxtCoachingNotes", review.DetailsCoached);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			} // end Using 
			return success;
		}

		public bool CompleteEmpAckReinforceReview(Review review, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteEmpAckReinforceReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Employee_Acknowledge]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcFormID", review.LogDetail.LogId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@bitisCSRAcknowledged", review.Acknowledge);
				command.Parameters.AddWithValueSafe("@dtmCSRReviewAutoDate", DateTime.Now);
				command.Parameters.AddWithValueSafe("@nvcCSRComments", review.Comment);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			} // end Using 
			return success;
		}

		public bool CompleteSupAckReview(long logId, string nextStatus, string comment, User user)
		{
			logger.Debug("Entered CompleteSupAckReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Supervisor_Acknowledge]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcFormID", logId);
				command.Parameters.AddWithValueSafe("@nvcReviewSupID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus);
				command.Parameters.AddWithValueSafe("@nvcCoachingNotes", comment);
				command.Parameters.AddWithValueSafe("@dtmSUPReviewAutoDate", DateTime.Now);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + logId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + logId + "]: " + ex.Message);
				}
			} // end Using 
			return success;
		}

		public bool CompleteAckRegularReview(Review review, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteEmpAckReinforceReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Employee_Pending]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcFormID", review.LogDetail.LogId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@bitisCSRAcknowledged", review.Acknowledge);
				command.Parameters.AddWithValueSafe("@dtmCSRReviewAutoDate", DateTime.Now);
				command.Parameters.AddWithValueSafe("@nvcCSRComments", review.Comment);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			} // end Using 
			return success;
		}

		public bool CompleteResearchPendingReview(Review review, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteResearchPendingReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Manager_Pending_Research]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcFormID", review.LogDetail.LogId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@nvcstrReasonNotCoachable", review.MainReasonNotCoachable);
				command.Parameters.AddWithValueSafe("@nvcReviewerID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@dtmReviewAutoDate", DateTime.Now);
				command.Parameters.AddWithValueSafe("@dtmReviewManualDate", review.DateCoached);
				command.Parameters.AddWithValueSafe("@bitisCoachingRequired", review.IsCoachingRequired);
				command.Parameters.AddWithValueSafe("@nvcReviewerNotes", review.DetailReasonCoachable);
				command.Parameters.AddWithValueSafe("@nvctxtReasonNotCoachable", review.DetailReasonNotCoachable);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			} // end Using 
			return success;
		}

		public bool CompleteCsePendingReview(Review review, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteCsePendingReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Manager_Pending_CSE]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValueSafe("@nvcFormID", review.LogDetail.LogId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@nvcReviewMgrID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("@dtmMgrReviewAutoDate", DateTime.Now);
				// coaching_log.MgrReviewManualDate
				var manualDate = review.DateReviewed;
				var notes = review.ReasonNotCse;
				if (review.IsConfirmedCse.HasValue && review.IsConfirmedCse.Value)
				{
					manualDate = review.DateCoached;
					notes = review.DetailsCoached;
				}
				command.Parameters.AddWithValueSafe("@dtmMgrReviewManualDate", manualDate);
				command.Parameters.AddWithValueSafe("@ConfirmedCSE", review.IsConfirmedCse);
				command.Parameters.AddWithValueSafe("@nvcMgrNotes", notes);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			} // end Using 
			return success;
		}

		// Short Call - Supervisor Review
		public bool CompleteShortCallsReview(Review review, string nextStatus, User user)
		{
			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_SupReview_Submit]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;

				command.Parameters.AddWithValue("@strUserLanId", user.LanId);
				command.Parameters.AddWithValue("@intLogId", review.LogDetail.LogId);
				// User Defined Type
				command.Parameters.AddShortCallReviewTableType("@tableSCSupReview", review.ShortCallList);
				// Output parameter
				SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
				retCodeParam.Direction = ParameterDirection.Output;
				SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 100);
				retMsgParam.Direction = ParameterDirection.Output;

				////////////////////
				try
				{
					connection.Open();
					command.ExecuteNonQuery();
					var retMsg = (string)retMsgParam.Value;

					if (retMsg.IndexOf("success") < 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			}
			return success;
		}

		// Short Call - Managers Confirm
		public bool CompleteShortCallsConfirm(Review review, string nextStatus, User user)
		{
			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_ShortCalls_MgrReview_Submit]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;

				command.Parameters.AddWithValue("@strUserLanId", user.LanId);
				command.Parameters.AddWithValue("@intLogId", review.LogDetail.LogId);
				command.Parameters.AddWithValue("@dtConfirmed", review.DateConfirmed);
				command.Parameters.AddWithValue("@strMgrNotes", review.Comments);
				// User Defined Type
				command.Parameters.AddShortCallConfirmTableType("@tableSCMgrReview", review.ShortCallList);
				// Output parameter
				SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
				retCodeParam.Direction = ParameterDirection.Output;
				SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 100);
				retMsgParam.Direction = ParameterDirection.Output;

				////////////////////
				try
				{
					connection.Open();
					command.ExecuteNonQuery();

					var retMsg = (string)retMsgParam.Value;

					if (retMsg.IndexOf("success") < 0)
					{
						throw new Exception("Couldn't update log [" + review.LogDetail.LogId + "].");
					}

					success = true;
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + review.LogDetail.LogId + "]: " + ex.Message);
				}
			}
			return success;
		}
	}
}
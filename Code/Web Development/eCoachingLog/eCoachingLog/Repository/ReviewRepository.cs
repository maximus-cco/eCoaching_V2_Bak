using eCoachingLog.Extensions;
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

		public bool CompleteSupAckReview(long logId, string nextStatus, User user)
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
				if (review.IsCse.HasValue && review.IsCse.Value)
				{
					manualDate = review.DateCoached;
					notes = review.DetailsCoached;
				}
				command.Parameters.AddWithValueSafe("@dtmMgrReviewManualDate", manualDate);
				command.Parameters.AddWithValueSafe("@bitisCSE", review.IsCse);
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
	}
}
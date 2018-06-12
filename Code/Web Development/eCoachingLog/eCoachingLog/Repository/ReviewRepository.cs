using eCoachingLog.Extensions;
using eCoachingLog.Models.User;
using log4net;
using System;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class ReviewRepository : IReviewRepository
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

		string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

		public bool CompleteRegularPendingReview(long logId, DateTime? dateCoached, string detailsCoached, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteRegularPendingReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Supervisor_Pending]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@nvcFormID", logId);
				command.Parameters.AddWithValueSafe("@nvcReviewSupLanID", user.LanId); // TODO: emp id
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@dtmSupReviewedAutoDate", dateCoached);
				command.Parameters.AddWithValueSafe("@nvctxtCoachingNotes", detailsCoached);

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

		public bool CompleteEmpAckReinforceReview(long logId, bool isAcked, string ackNotes, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteEmpAckReinforceReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Employee_Acknowledge]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@nvcFormID", logId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@bitisCSRAcknowledged", isAcked);
				command.Parameters.AddWithValueSafe("@dtmCSRReviewAutoDate", DateTime.Now);
				command.Parameters.AddWithValueSafe("@nvcCSRComments", ackNotes);

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

		public bool CompleteSupAckReinforceReview(long logId, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteSupAckReinforceReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Supervisor_Acknowledge]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@nvcFormID", logId);
				command.Parameters.AddWithValueSafe("@nvcReviewSupLanID", user.LanId); // TODO: --> empId
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
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

		//bool CompleteAckRegularReview(long logId, string ackNotes, string nextStatus, User user);
		public bool CompleteAckRegularReview(long logId, bool isAcked, string ackNotes, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteEmpAckReinforceReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update_Review_Coaching_Log_Employee_Pending]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@nvcFormID", logId);
				command.Parameters.AddWithValueSafe("@nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("@bitisCSRAcknowledged", isAcked);
				command.Parameters.AddWithValueSafe("@dtmCSRReviewAutoDate", DateTime.Now);
				command.Parameters.AddWithValueSafe("@nvcCSRComments", ackNotes);

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
	}
}
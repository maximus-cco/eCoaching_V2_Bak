using eCoachingLog.Extensions;
using eCoachingLog.Models.Common;
using eCoachingLog.Models.User;
using eCoachingLog.Utils;
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

		public bool CompleteRegularPendingReview(CoachingLogDetail log, string nextStatus, User user)
		{
			logger.Debug("Entered CompleteRegularPendingReview ...");

			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Update7Review_Coaching_Log]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@nvcFormID", log.LogId);
				command.Parameters.AddWithValueSafe("nvcReviewSupLanID", user.EmployeeId);
				command.Parameters.AddWithValueSafe("nvcFormStatus", nextStatus); // next status;
				command.Parameters.AddWithValueSafe("dtmSUPReviewAutoDate", DateTime.Now);

				try
				{
					connection.Open();
					int rowsUpdated = command.ExecuteNonQuery();

					if (rowsUpdated == 0)
					{
						throw new Exception("Couldn't update log [" + log.LogId + "].");
					}

					success = true;
					// TODO: send email in ReviewController
					//// Send email if it is CSR module and next status is complete
					//if (log.ModuleId == Constants.MODULE_CSR && nextStatus == "completed")
					//{
					//	EmailComment(log.FormName, comment);
					//}
				}
				catch (Exception ex)
				{
					logger.Error("Failed to update log [" + log.LogId + "]: " + ex.Message);
				}
			} // end Using 

			return success;
		}
	}
}
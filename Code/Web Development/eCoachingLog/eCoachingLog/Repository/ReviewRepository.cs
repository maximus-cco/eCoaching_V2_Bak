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

		public IList<Behavior> GetShortCallBehaviorList(bool isValid)
		{
			return GetBehaviorListToRemove(isValid);
		}

		// TODO: get from database when db piece is ready
		public string GetShortCallAction(long logId, string employeeId, int behaviorId)
		{
		
			//var action = String.Empty;
			//using (SqlConnection connection = new SqlConnection(conn))
			//using (SqlCommand command = new SqlCommand("[EC].[sp_XXXXXXX]", connection))
			//{
			//	command.CommandType = CommandType.StoredProcedure;
			//	command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
			//	command.Parameters.AddWithValueSafe("@logId", logId);
			//	command.Parameters.AddWithValueSafe("@employeeId", employeeId);
			//	command.Parameters.AddWithValueSafe("@behaviorId", behaviorId);
			//	connection.Open();
			//	using (SqlDataReader dataReader = command.ExecuteReader())
			//	{
			//		if (dataReader.Read())
			//		{
			//			action = dataReader["action"].ToString().Trim();
			//		}
			//	} // end using SqlDataReader
			//} // end using SqlCommand

			//return action;

			return "Coach to the behavior and describe the progressive disciplinary course";
		}

		public IList<ShortCall> GetShortCallList(long logId)
		{
			return GetShortCallListToRemove(logId);
		}

		public IList<ShortCall> GetShortCallEvalList(long logId)
		{
			return GetShortCallEvalListToRemove(logId);
		}

		// TODO: get from database when db piece is ready
		private IList<ShortCall> GetShortCallEvalListToRemove(long logId)
		{
			Random generator = new Random();
			var shortCallEvals = new List<ShortCall>();
			var sc1 = new ShortCall();
			sc1.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc1.IsValidBehaviorText = "Yes";
			sc1.SelectedBehaviorText = "Good Call";
			sc1.Action = "action 1";
			sc1.CoachingNotes = "display coaching notes here";
			sc1.IsLsaInformedText = "No";
			shortCallEvals.Add(sc1);

			var sc2 = new ShortCall();
			sc2.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc2.IsValidBehaviorText = "No";
			sc2.SelectedBehaviorText = "Not following procedure for disconnect by caller";
			sc2.Action = "action 2";
			sc2.CoachingNotes = "display coaching notes here";
			sc2.IsLsaInformedText = "No";
			shortCallEvals.Add(sc2);

			var sc3 = new ShortCall();
			sc3.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc3.IsValidBehaviorText = "Yes";
			sc3.SelectedBehaviorText = "Valid Password Reset";
			sc3.Action = "action 3";
			sc3.CoachingNotes = "display coaching notes here";
			sc3.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc3);

			var sc4 = new ShortCall();
			sc4.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc4.IsValidBehaviorText = "No";
			sc4.SelectedBehaviorText = "CSR Technical Error";
			sc4.Action = "action 4";
			sc4.CoachingNotes = "display coaching notes here";
			sc4.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc4);

			var sc5 = new ShortCall();
			sc5.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc5.IsValidBehaviorText = "Yes";
			sc5.SelectedBehaviorText = "Technical Issue";
			sc5.Action = "action 5";
			sc5.CoachingNotes = "display coaching notes here";
			sc5.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc5);

			var sc6 = new ShortCall();
			sc6.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc6.IsValidBehaviorText = "Yes";
			sc6.SelectedBehaviorText = "Technical Issue";
			sc6.Action = "action 6";
			sc6.CoachingNotes = "display coaching notes here";
			sc6.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc6);

			var sc7 = new ShortCall();
			sc7.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc7.IsValidBehaviorText = "Yes";
			sc7.SelectedBehaviorText = "Technical Issue";
			sc7.Action = "action 7";
			sc7.CoachingNotes = "display coaching notes here";
			sc7.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc7);

			var sc8 = new ShortCall();
			sc8.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc8.IsValidBehaviorText = "Yes";
			sc8.SelectedBehaviorText = "Technical Issue";
			sc8.Action = "action 8";
			sc8.CoachingNotes = "display coaching notes here";
			sc8.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc8);

			var sc9 = new ShortCall();
			sc9.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc9.IsValidBehaviorText = "Yes";
			sc9.SelectedBehaviorText = "Technical Issue";
			sc9.Action = "action 9";
			sc9.CoachingNotes = "display coaching notes here";
			sc9.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc9);

			var sc10 = new ShortCall();
			sc10.VerintId = generator.Next(0, 1000000000).ToString("D9");
			sc10.IsValidBehaviorText = "Yes";
			sc10.SelectedBehaviorText = "Technical Issue";
			sc10.Action = "action 10";
			sc10.CoachingNotes = "display coaching notes here";
			sc10.IsLsaInformedText = "Yes";
			shortCallEvals.Add(sc10);

			return shortCallEvals;
		}

		// TODO: get from database when db piece is ready
		private IList<ShortCall> GetShortCallListToRemove(long logId)
		{
			Random generator = new Random();
			var shortCallList = new List<ShortCall>();
			var sc1 = new ShortCall();
			sc1.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc1);

			var sc2 = new ShortCall();
			sc2.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc2);

			var sc3 = new ShortCall();
			sc3.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc3);

			var sc4 = new ShortCall();
			sc4.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc4);

			var sc5 = new ShortCall();
			sc5.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc5);

			var sc6 = new ShortCall();
			sc6.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc6);
			var sc7 = new ShortCall();
			sc7.VerintId = generator.Next(0, 1000000000).ToString("D9");
			shortCallList.Add(sc7);

			//var sc8 = new ShortCall();
			//sc8.VerintId = generator.Next(0, 1000000000).ToString("D9");
			//shortCallList.Add(sc8);
			//var sc9 = new ShortCall();
			//sc9.VerintId = generator.Next(0, 1000000000).ToString("D9");
			//shortCallList.Add(sc9);

			//var sc10 = new ShortCall();
			//sc10.VerintId = generator.Next(0, 1000000000).ToString("D9");
			//shortCallList.Add(sc10);

			// populate behavior dropdown
			// default to invalid
			IList<Behavior> behaviorList = GetBehaviorListToRemove(false);
			foreach (ShortCall sc in shortCallList)
			{
				//sc.SelectListBehaviors = new SelectList(behaviorList, "Id", "Text");
				sc.Behaviors = (List<Behavior>) behaviorList;
			}

			return shortCallList;
		}

		// TODO: get from database when db piece is ready
		private IList<Behavior> GetBehaviorListToRemove(bool isValid)
		{
			if (isValid)
			{
				return new List<Behavior>
				{
					new Behavior { Id = -1, Text = "Select a behavior..." },
					new Behavior { Id = 1, Text = "Spanish Transfer" },
					new Behavior { Id = 2, Text = "Valid Password Reset" },
					new Behavior { Id = 3, Text = "Technical Issue" },
					new Behavior { Id = 4, Text = "SSA Transfer" }
				};
			}
			else
			{
				return new List<Behavior>
				{
					new Behavior { Id = -1, Text = "Select a behavior..." },
					new Behavior { Id = 1, Text = "Intentionally disconnecting calls" },
					new Behavior { Id = 2, Text = "Incorrect blind transfer" },
					new Behavior { Id = 3, Text = "Not following call flow" },
					new Behavior { Id = 4, Text = "Incorrect phone status" },
					new Behavior { Id = 5, Text = "Not following procedure for disconnect by caller" },
					new Behavior { Id = 6, Text = "Calling Kudos Line" },
					new Behavior { Id = 7, Text = "CSR Technical Error" },
					new Behavior { Id = 8, Text = "Technical Error" },
					new Behavior { Id = 9, Text = "Other" }
				};
			}
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
		// TODO: finish up when db piece is ready
		public bool CompleteShortCallsReview(Review review, string nextStatus, User user)
		{
			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			// TODO: need new SP
			using (SqlCommand command = new SqlCommand("[EC].[sp_XXX]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;

				command.Parameters.AddWithValue("@strRequesterLanId", user.LanId);
				command.Parameters.AddWithValue("@intCoachingId", review.LogDetail.LogId);
				// User Defined Type
				command.Parameters.AddShortCallReviewTableType("@tableShortCallReview", review.ShortCallList);

				////////////////////
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
			}
			return success;
		}

		// Short Call - Managers Confirm
		// TODO: finish up when db piece is ready
		public bool CompleteShortCallsConfirm(Review review, string nextStatus, User user)
		{
			bool success = false;

			using (SqlConnection connection = new SqlConnection(conn))
			// TODO: need new SP
			using (SqlCommand command = new SqlCommand("[EC].[sp_XXX]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;

				command.Parameters.AddWithValue("@strRequesterLanId", user.LanId);
				command.Parameters.AddWithValue("@intCoachingId", review.LogDetail.LogId);
				// User Defined Type
				command.Parameters.AddShortCallConfirmTableType("@tableShortCallConfirm", review.ShortCallList);

				////////////////////
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
			}
			return success;
		}
	}
}
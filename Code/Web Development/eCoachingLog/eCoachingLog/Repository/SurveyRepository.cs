using eCoachingLog.Extensions;
using eCoachingLog.Models.Survey;
using eCoachingLog.Utils;
using log4net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class SurveyRepository : ISurveyRepository
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		private static readonly string connString = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

		public Survey GetSurveyInfo(long surveyId)
		{
			Survey survey = new Survey();

			using (SqlConnection conn = new SqlConnection(connString))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_SurveyDetails_By_SurveyID]", conn))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValue("@intSurveyID", surveyId);
				conn.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						survey.Id = surveyId;
						survey.LogId = (long) dataReader["CoachingID"];
						survey.EmployeeId = dataReader["EmpID"].ToString().Trim().ToUpper();
						survey.LogName = dataReader["FormName"].ToString();
						survey.Status = dataReader["Status"].ToString();
						bool hasHotTopic = false;
						bool.TryParse(dataReader["hasHotTopic"].ToString(), out hasHotTopic);
						survey.HasHotTopic = hasHotTopic;
					}
				}
			}
			return survey;
		}

		public IList<Question> GetQuestions(long surveyId)
		{
			IList<Question> questions = new List<Question>();

			using (SqlConnection conn = new SqlConnection(connString))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Questions_For_Survey]", conn))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValue("@intSurveyID", surveyId);
				conn.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Question q = new Question();
						q.Id = (int)dataReader["QuestionID"];
						q.DisplayOrder = (int)dataReader["DisplayOrder"];
						string combinedLabel = dataReader["Description"].ToString();
						// Element 0 is the question label; element 1 is the question textbox label
						string[] temp = combinedLabel.Split('|');
						q.Label = temp[0];
						q.TextBoxLabel = temp[1];

						questions.Add(q);
					}
				}
			}
			return questions;
		}

		public IList<SingleChoice> GetSingleChoices()
		{
			IList<SingleChoice> singleChoices = new List<SingleChoice>();

			using (SqlConnection conn = new SqlConnection(connString))
			// The word "Responses" in the sp name actually means the standard radio button questions
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Responses_By_Question]", conn))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				conn.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						SingleChoice sc = new SingleChoice();
						sc.QuestionId = (int)dataReader["QuestionID"];
						sc.Text = dataReader["ResponseValue"].ToString(); // Displayed text
						sc.Value = (int)dataReader["ResponseID"];

						singleChoices.Add(sc);
					}
				}
			}
			return singleChoices;
		}

		public void Save(Survey survey, out int retCode, out string retMsg)
		{
			using (SqlConnection conn = new SqlConnection(connString))
			using (SqlCommand comm = new SqlCommand("[EC].[sp_Update_Survey_Response]", conn))
			{
				comm.CommandType = CommandType.StoredProcedure;
				comm.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				comm.Parameters.AddWithValue("@intSurveyID", survey.Id);
				comm.Parameters.AddWithValueSafe("@nvcUserComments", survey.Comment);
				comm.Parameters.AddSurveyResponseTableType("@tableSR", survey);
				// Output parameter
				SqlParameter retCodeParam = comm.Parameters.Add("@returnCode", SqlDbType.Int);
				retCodeParam.Direction = ParameterDirection.Output;
				SqlParameter retMsgParam = comm.Parameters.Add("@returnMessage", SqlDbType.VarChar, 100);
				retMsgParam.Direction = ParameterDirection.Output;

				conn.Open();
				comm.ExecuteNonQuery();

				retCode = (int)retCodeParam.Value;
				retMsg = (string)retMsgParam.Value;
			}
		}

	}
}
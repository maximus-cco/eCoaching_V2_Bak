using eCoachingLog.Models.Survey;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class SurveyRepository : ISurveyRepository
	{
		private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
		private static readonly string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

		public Survey GetSurveyInfo(int surveyId)
		{
			Survey survey = new Survey();

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_SurveyDetails_By_SurveyID]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@intSurveyID", surveyId);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						survey.Id = surveyId;
						survey.LogId = 54863;
						survey.EmployeeId = dataReader["EmpID"].ToString();
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

		public IList<Question> GetQuestions(int surveyId)
		{
			IList<Question> questions = new List<Question>();

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Questions_For_Survey]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@intSurveyID", surveyId);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Question q = new Question();
						q.SurveyId = surveyId;
						q.Id = (int)dataReader["QuestionID"];
						q.DisplayOrder = (int)dataReader["DisplayOrder"];
						string combinedLabel = dataReader["Description"].ToString();
						// Element 0 is the question label; element 1 is the question textbox label
						string[] temp = combinedLabel.Split('|');
						q.Label = temp[0];
						q.TexBoxLabel = temp[1];

						questions.Add(q);
					}
				}
			}
			return questions;
		}

		public IList<SingleChoice> GetSingleChoices()
		{
			IList<SingleChoice> singleChoices = new List<SingleChoice>();

			using (SqlConnection connection = new SqlConnection(conn))
			// The word "Responses" in the sp name actually means the standard radio button questions
			using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Responses_By_Question]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						SingleChoice sc = new SingleChoice();
						sc.QuestionId = (int)dataReader["QuestionID"];
						sc.Id = (int)dataReader["ResponseID"];
						sc.Text = dataReader["ResponseValue"].ToString();

						singleChoices.Add(sc);
					}
				}
			}
			return singleChoices;
		}
	}
}
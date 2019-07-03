using eCoachingLog.Models.Common;
using eCoachingLog.Models.Survey;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Extensions
{
    public static class SqlExtension
    {
        public static SqlParameter AddWithValueSafe(this SqlParameterCollection parameters, string parameterName, object value)
        {
            return parameters.AddWithValue(parameterName, value ?? DBNull.Value);
        }

		public static SqlParameter AddIdsTableType(this SqlParameterCollection target, string name, List<long> values)
		{
			DataTable dataTable = new DataTable();
			dataTable.Columns.Add("ID", typeof(long));
			foreach (long value in values)
			{
				dataTable.Rows.Add(value);
			}

			SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
			sqlParameter.SqlDbType = SqlDbType.Structured;
			sqlParameter.TypeName = "EC.IdsTableType";

			return sqlParameter;
		}

		public static SqlParameter AddSurveyResponseTableType(this SqlParameterCollection target, string name, Survey survey)
		{
			DataTable dataTable = new DataTable();
			dataTable.Columns.Add("QuestionID", typeof(int));
			dataTable.Columns.Add("ResponseID", typeof(int));
			dataTable.Columns.Add("Comments", typeof(string));

			foreach (Question q in survey.Questions)
			{
				dataTable.Rows.Add(q.Id, q.SingleChoiceSelected, q.MultiLineText);
			}

			SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
			sqlParameter.SqlDbType = SqlDbType.Structured;
			sqlParameter.TypeName = "EC.ResponsesTableType";

			return sqlParameter;
		}

		public static SqlParameter AddShortCallReviewTableType(this SqlParameterCollection target, string name, IList<ShortCall> shortCallList)
		{
			DataTable dataTable = new DataTable();
			dataTable.Columns.Add("VerintCallID", typeof(string));
			dataTable.Columns.Add("Valid", typeof(bool));
			dataTable.Columns.Add("BehaviorId", typeof(int));
			dataTable.Columns.Add("Action", typeof(string));
			dataTable.Columns.Add("CoachingNotes", typeof(string));
			dataTable.Columns.Add("LSAInformed", typeof(bool));

			foreach (ShortCall sc in shortCallList)
			{
				dataTable.Rows.Add(sc.VerintId, 
					sc.IsValidBehavior,
					sc.SelectedBehaviorId, 
					sc.ActionsString, 
					sc.CoachingNotes, 
					sc.IsLsaInformed);
			}
			SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
			sqlParameter.SqlDbType = SqlDbType.Structured;
			sqlParameter.TypeName = "EC.SCSupReviewTableType"; // User Defined Type name in DB

			return sqlParameter;
		}

		public static SqlParameter AddShortCallConfirmTableType(this SqlParameterCollection target, string name, IList<ShortCall> shortCallList)
		{
			DataTable dataTable = new DataTable();
			dataTable.Columns.Add("VerintCallID", typeof(string));
			dataTable.Columns.Add("MgrAgreed", typeof(bool));
			dataTable.Columns.Add("MgrComments", typeof(string));

			foreach (ShortCall sc in shortCallList)
			{
				dataTable.Rows.Add(sc.VerintId, sc.IsManagerAgreed, sc.Comments);
			}
			SqlParameter sqlParameter = target.AddWithValue(name, dataTable);
			sqlParameter.SqlDbType = SqlDbType.Structured;
			sqlParameter.TypeName = "EC.SCMgrReviewTableType"; // User Defined Type name in DB

			return sqlParameter;
		}
	}
}
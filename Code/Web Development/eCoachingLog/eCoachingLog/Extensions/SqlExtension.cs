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
	}
}
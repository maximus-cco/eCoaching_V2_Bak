using System;
using System.Data.SqlClient;

namespace eCoachingLog.Extensions
{
    public static class SqlExtensionMethos
    {
        public static SqlParameter AddWithValueSafe(this SqlParameterCollection parameters, string parameterName, object value)
        {
            return parameters.AddWithValue(parameterName, value ?? DBNull.Value);
        }
    }
}
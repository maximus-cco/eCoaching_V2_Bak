using System;
using System.Data;
using System.Data.SqlClient;

namespace SOIBean
{
    /// <summary>
    /// Extensions for DataRow class
    /// </summary>
    public static class DataRowExtensions
    {
        /// <summary>
        /// Gets the value of a column in a data row, with a default value returned for DBNull values.
        /// </summary>
        /// <typeparam name="T">Type of which to return the value</typeparam>
        /// <param name="row">Data row to process</param>
        /// <param name="columnName">Name of column to access</param>
        /// <param name="defaultVal">Default value to return if value is DBNull.</param>
        /// <returns>Column value converted to desired type, or specified default value if it is DBNull</returns>
        public static T GetValueWithDefault<T>(this DataRow row, string columnName, T defaultVal) where T : struct
        {
            T? value = row.Field<T?>(columnName);
            return value ?? defaultVal;
        }
    }

    /// <summary>
    /// Extensions for SqlConnection class
    /// </summary>
    public static class SqlConnectionExtensions
    {
        /// <summary>
        /// Configures error message event handling for the connection.
        /// </summary>
        /// <param name="conn">Connection to which to configure event handling.</param>
        /// <param name="sqlException">SQL exception that will be null if no critical errors; otherwise it will be set 
        /// to the last critical error.</param>
        /// <param name="logTrace">Log4Net log trace listener to which to write</param>
        public static void ConfigureErrorMessageEvent(this SqlConnection conn, Exception sqlException, 
            SharePointToolBox.Log4NetTraceListener logTrace )
        {
            sqlException = null;

            conn.FireInfoMessageEventOnUserErrors = true;
            conn.InfoMessage += new SqlInfoMessageEventHandler((o, smea) =>
            {
                foreach (SqlError e in smea.Errors)
                {
                    var msg = String.Format("Database Message Line {1} Message {0}", e.Message, e.LineNumber);

                    if (e.Class > 10)
                    {
                        sqlException = new Exception(msg);
                    }
                    else
                    {
                        logTrace.Logger.Debug(msg);
                    }
                }
            });
        }
    }
}

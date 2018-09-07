using eCoachingLog.Models.User;
using eCoachingLog.Utils;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class UserRepository : IUserRepository
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public List<User> GetAllUsers()
        {
            List<User> users = new List<User>();

            return users;
        }

        public User GetUserByLanId(string lanId)
        {
            User user = null;
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Employee_Details]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				command.Parameters.AddWithValue("@nvcEmpLanin", lanId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    if (dataReader.Read())
                    {
                        user = new User();
						user.LanId = lanId;
						user.EmployeeId = dataReader["Emp_ID"].ToString().Trim().ToUpper();
                        user.Name = dataReader["Emp_Name"].ToString();
						user.JobCode = dataReader["Emp_Job_Code"].ToString();
						user.Role = dataReader["Role"].ToString();
						user.IsEcl = (dataReader["ECLUser"] == DBNull.Value) ? false : (bool)dataReader["ECLUser"];
						user.IsAccessNewSubmission = (dataReader["NewSubmission"] == DBNull.Value) ? false : (bool)dataReader["NewSubmission"];
						user.IsAccessMyDashboard = (dataReader["MyDashboard"] == DBNull.Value) ? false : (bool)dataReader["MyDashboard"];
						user.IsAccessHistoricalDashboard = (dataReader["HistoricalDashboard"] == DBNull.Value) ? false : (bool)dataReader["HistoricalDashboard"];
						user.IsExportExcel = (dataReader["ExcelExport"] == DBNull.Value) ? false : (bool)dataReader["ExcelExport"];
					}
                }
            }
			return user;
        }
    }
}
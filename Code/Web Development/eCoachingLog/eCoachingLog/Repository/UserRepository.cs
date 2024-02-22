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
                        user.SiteId = Convert.ToInt32(dataReader["Emp_SiteID"]);
                        user.SiteName = dataReader["Emp_Site"].ToString();
                        user.IsSubcontractor = (dataReader["isSub"] == DBNull.Value) ? false : (bool)dataReader["isSub"];
                        user.IsCsrRelated = (dataReader["CSRRelated"] == DBNull.Value) ? false : (bool)dataReader["CSRRelated"];
                        user.IsEcl = (dataReader["ECLUser"] == DBNull.Value) ? false : (bool)dataReader["ECLUser"];
                        user.IsPm = (dataReader["PMUser"] == DBNull.Value) ? false : (bool)dataReader["PMUser"];
                        user.IsPma = (dataReader["PMAUser"] == DBNull.Value) ? false : (bool)dataReader["PMAUser"];
                        user.IsDirPm = (dataReader["DIRPMUser"] == DBNull.Value) ? false : (bool)dataReader["DIRPMUser"];
                        user.IsDirPma = (dataReader["DIRPMAUser"] == DBNull.Value) ? false : (bool)dataReader["DIRPMAUser"];
                        user.IsAccessNewSubmission = (dataReader["NewSubmission"] == DBNull.Value) ? false : (bool)dataReader["NewSubmission"];
						user.IsAccessMyDashboard = (dataReader["MyDashboard"] == DBNull.Value) ? false : (bool)dataReader["MyDashboard"];
						user.IsAccessHistoricalDashboard = (dataReader["HistoricalDashboard"] == DBNull.Value) ? false : (bool)dataReader["HistoricalDashboard"];
						user.IsExportExcel = (dataReader["ExcelExport"] == DBNull.Value) ? false : (bool)dataReader["ExcelExport"];
						user.ShowFollowup = (dataReader["FollowupDisplay"] == DBNull.Value) ? false : (bool)dataReader["FollowupDisplay"];
					}

                    dataReader.Close();
                }
            }
			return user;
        }

		public IList<User> GetLoadTestUsers()
		{
			IList<User> users = new List<User>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_LoadTestGetUsers]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = Constants.SQL_COMMAND_TIMEOUT;
				// Output parameter
				SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
				retCodeParam.Direction = ParameterDirection.Output;
				SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 100);
				retMsgParam.Direction = ParameterDirection.Output;
				connection.Open();
				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						User user = new User();
						user.LanId = dataReader["UserLanID"].ToString().Trim().ToUpper();
						user.Name = dataReader["UserName"].ToString();
						user.Role = dataReader["Role"].ToString();
						users.Add(user);
					}

                    dataReader.Close();
                }
			}
			return users;
		}


	}
}
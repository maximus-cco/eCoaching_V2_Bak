using eCLAdmin.Models.User;
using log4net;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class UserRepository : IUserRepository
    {
        readonly ILog logger = LogManager.GetLogger(typeof(UserRepository));
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;



        public List<User> GetAllUsers()
        {
            List<User> users = new List<User>();

            return users;
        }

        public List<Entitlement> GetEntitlementsByUserLanId(string lanId)
        {
            List<Entitlement> entitlements = new List<Entitlement>();
            try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Check_Entitlements]", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandTimeout = 300;
                    command.Parameters.AddWithValue("@nvcEmpLanIDin", lanId);

                    connection.Open();
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            Entitlement entitlement = new Entitlement();
                            entitlement.Id = (int)dataReader["EntitlementId"];
                            entitlement.Name = dataReader["EntitlementDescription"].ToString();

                            entitlements.Add(entitlement);
                        }
                    }
                }
            }
            catch(Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message );
                throw ex;
            }

            return entitlements;
        }

        public User GetUserByLanId(string lanId)
        {
            User user = null;
			var userQuery = "[EC].[sp_AT_Select_User_Details]";
			try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(userQuery, connection))
                {
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.Parameters.AddWithValue("@userLanId", lanId);
                    connection.Open();

                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        if (dataReader.Read())
                        {
                            user = new User();
                            user.EmployeeId = dataReader["UserId"].ToString();
                            user.LanId = dataReader["UserLanID"].ToString();
                            user.Name = dataReader["UserName"].ToString();
                            user.JobCode = dataReader["EmpJobCode"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);

                throw ex;
            }

            return user;
        }

        public List<eCoachingAccessControl> GetEcoachingAccessControlList()
        {
            List<eCoachingAccessControl> users = new List<eCoachingAccessControl>();
			var sql = "[EC].[sp_Select_Users_Historical_Dashboard_ACL]";
            try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
					command.CommandType = System.Data.CommandType.StoredProcedure;
					connection.Open();
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            eCoachingAccessControl user = new eCoachingAccessControl();
                            user.RowId = (int)dataReader["Row_ID"];
                            user.LanId = dataReader["User_LanID"].ToString();
                            user.Name = dataReader["User_Name"].ToString();
                            user.Role = dataReader["Role"].ToString();

                            users.Add(user);
                        } // end while
                    } // end using SqlDataReader
                } // end using SqlCommand
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return users;
        }

        public List<NameLanId> GetEcoachingAccessControlsToAdd(string siteId)
        {
            List<NameLanId> users = new List<NameLanId>();
			var sql = "[EC].[sp_Select_Employees_BySite_NotIn_Hist_ACL]";
			try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.Parameters.AddWithValue("@siteId", siteId);
                    connection.Open();
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            NameLanId user = new NameLanId();
                            user.LanId = dataReader["Emp_LanID"].ToString();
                            user.Name = dataReader["Emp_Name"].ToString();

                            users.Add(user);
                        } // end while
                    } // end using SqlDataReader
                } // end using SqlCommand
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return users;
        }

        public bool DeleteEcoachingAccessControl(int rowId, string deletedBy)
        {
            bool success = false;
			var sql = "[EC].[sp_UpdateHistorical_Dashboard_ACL_EndDate]";
            try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.Parameters.AddWithValue("@updatedBy", deletedBy);
                    command.Parameters.AddWithValue("@endDate", DateTime.Now.ToString("yyyyMMdd"));
                    command.Parameters.AddWithValue("@rowId", rowId);
                    connection.Open();

                    int rowsUpdated = command.ExecuteNonQuery();
                    if (rowsUpdated > 0)
                    {
                        success = true;
                    }
                } // end using SqlCommand
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return success;
        }

        public eCoachingAccessControl GetEcoachingAccessControl(int rowId)
        {
            eCoachingAccessControl user = new eCoachingAccessControl();
			var sql = "[EC].[sp_Select_Row_Historical_Dashboard_ACL]";
			try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.Parameters.AddWithValue("@rowId", rowId);
                    connection.Open();

                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            user.RowId = rowId;
                            user.LanId = dataReader["User_LanID"].ToString();
                            user.Name = dataReader["User_Name"].ToString();
                            user.Role = dataReader["Role"].ToString();
                        } // end while
                    } // end using SqlDataReader
                } // end using SqlCommand
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return user;
        }

        public bool UpdateEcoachingAccessControl(eCoachingAccessControl user)
        {
            bool success = false;
			var sql = "[EC].[sp_UpdateHistorical_Dashboard_ACL_Role]";
			try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
					command.CommandType = System.Data.CommandType.StoredProcedure;
					command.Parameters.AddWithValue("@rowId", user.RowId);
                    command.Parameters.AddWithValue("@role", user.Role);
                    command.Parameters.AddWithValue("@updatedBy", user.UpdatedBy);

                    connection.Open();

                    int rowsUpdated = command.ExecuteNonQuery();
                    if (rowsUpdated > 0)
                    {
                        success = true;
                    }
                } // end using SqlCommand
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return success;
        }

        public int AddEcoachingAccessControl(eCoachingAccessControl user)
        {
            int rowId = -1;

            try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand("[EC].[sp_HistoricalDashboardAclInsert]", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.CommandTimeout = 300;
                    command.Parameters.AddWithValue("@userLanId", user.LanId);
                    command.Parameters.AddWithValue("@userName", user.Name);
                    command.Parameters.AddWithValue("@userRole", user.Role);
                    command.Parameters.AddWithValue("@createdBy", user.UpdatedBy);

                    // rowid
                    SqlParameter paramRowId = new SqlParameter("@rowId", SqlDbType.Int);
                    paramRowId.Direction = ParameterDirection.Output;
                    command.Parameters.Add(paramRowId);
                    // return code
                    SqlParameter paramRetCode = command.Parameters.Add("@returnCode", SqlDbType.Int);
                    paramRetCode.Direction = ParameterDirection.Output;
                    // return message
                    SqlParameter paramRetMsg = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 100);
                    paramRetMsg.Direction = ParameterDirection.Output;

                    connection.Open();
                    command.ExecuteNonQuery();

                    int retCode = Convert.ToInt32(command.Parameters["@returnCode"].Value);
                    string retMessage = command.Parameters["@returnMessage"].Value.ToString();

                    if (retCode == 0)
                    {
                        rowId = Int32.Parse(command.Parameters["@rowId"].Value.ToString());
                    }
                    else
                    {
                        logger.Info("sp_HistoricalDashboardAclInsert returned with error code[" + retCode.ToString() + "]" + " and error message[" + retMessage +"]") ;
                        // Duplicate key: select * from sys.messages where message_id=2627
                        if (retCode == 2627)
                        {
                            rowId = Constants.DUPLICATE_RECORD;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Debug("Exception thrown: " + ex.Message);
                throw ex;
            }

            return rowId;
        }
    }
}
using eCLAdmin.Models.User;
using log4net;
using System;
using System.Collections.Generic;
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
            var userQuery = "select * from EC.AT_User where UserLanID = @userLanId and Active = 1";
            try
            {
                using (SqlConnection connection = new SqlConnection(conn))
                using (SqlCommand command = new SqlCommand(userQuery, connection))
                {
                    command.Parameters.AddWithValue("userLanId", lanId);
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
    }
}
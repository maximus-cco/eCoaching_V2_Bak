using eCoachingLog.Models.User;
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

        public List<Entitlement> GetEntitlementsByUserLanId(string lanId)
        {
            List<Entitlement> entitlements = new List<Entitlement>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Check_Entitlements]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
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

            return entitlements;
        }

        public User GetUserByLanId(string lanId)
        {
            User user = null;
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Employee_Details]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@nvcEmpLanin", lanId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    if (dataReader.Read())
                    {
                        user = new User();
						user.LanId = lanId;
						user.EmployeeId = dataReader["Emp_ID"].ToString();
                        user.Name = dataReader["Emp_Name"].ToString();
						user.JobCode = "WISO12"; //dataReader["Emp_Job_Code"].ToString();
                        // TODO: hardcode for now, get from database later
                        var roleId = 3;
                        switch (roleId)
                        {
                            case 1:
                                user.Role = UserRole.Manager;
                                break;
                            case 2:
                                user.Role = UserRole.Supervisor;
                                break;
                            case 3:
                                user.Role = UserRole.Employee;
                                break;
                            case 4:
                                user.Role = UserRole.Other;
                                break;
                            default:
                                user.Role = UserRole.Unknown;
                                break;
                        }
                    }
                }
            }


			//// Remove later because all dbs have encrytion 
			//user = new User();
			//user.EmployeeId = "";
			//user.LanId = "lili.huang";
			//user.Name = "lili huang";
			//user.JobCode = "wiso12";
			//// TODO: hardcode for now, get from database later
			//var myRoleId = 1;
			//switch (myRoleId)
			//{
			//	case 1:
			//		user.Role = UserRole.Manager;
			//		break;
			//	case 2:
			//		user.Role = UserRole.Supervisor;
			//		break;
			//	case 3:
			//		user.Role = UserRole.Employee;
			//		break;
			//	case 4:
			//		user.Role = UserRole.Other;
			//		break;
			//	default:
			//		user.Role = UserRole.Unknown;
			//		break;
			//}
			//// End remove

			return user;
        }
    }
}
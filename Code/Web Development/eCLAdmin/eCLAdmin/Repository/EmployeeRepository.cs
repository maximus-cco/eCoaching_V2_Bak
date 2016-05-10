using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using log4net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class EmployeeRepository : IEmployeeRepository
    {
        readonly ILog logger = LogManager.GetLogger(typeof(EmployeeRepository));

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public List<Employee> GetEmployees()
        {
            var employees = new List<Employee>();
            var query = "select top 500 Emp_ID, emp_name from EC.Employee_Hierarchy where Active = 'A' order by Emp_Name";
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Employee emp = new Employee();
                        emp.Id = dataReader["Emp_ID"].ToString();
                        emp.Name = dataReader["Emp_Name"].ToString();

                        employees.Add(emp);
                    }
                }
            }

            return employees;
        }

        public Employee GetEmployee(string employeeId)
        {
            Employee employee = new Employee();
            var query = "select Emp_ID, Emp_Name, Emp_Email, Sup_Name, Sup_Email, Mgr_Name, Mgr_Email from EC.Employee_Hierarchy where Emp_ID=@employeeId";

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("employeeId", employeeId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        employee.Id = dataReader["Emp_ID"].ToString();
                        employee.Name = dataReader["Emp_Name"].ToString();
                        employee.Email = dataReader["Emp_Email"].ToString();
                        employee.SupervisorName = dataReader["Sup_Name"].ToString();
                        employee.SupervisorEmail = dataReader["Sup_Email"].ToString();
                        employee.ManagerName = dataReader["Mgr_Name"].ToString();
                        employee.ManagerEmail = dataReader["Mgr_Email"].ToString();

                        break;
                    }
                }
            }

            return employee;
        }

        public List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action)
        {
            string logType = null;
            var employees = new List<Employee>();

            // Set log type
            if (logTypeId == (int)EmployeeLogType.Coaching)
            {
                logType = EmployeeLogType.Coaching.ToDescription();
            }
            else if (logTypeId == (int)EmployeeLogType.Warning)
            {
                logType = EmployeeLogType.Warning.ToDescription();
            }
            else
            {
                logType = "unknown";
            }

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Employees_Inactivation_Reactivation]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strRequesterLanId", userLanId);
                command.Parameters.AddWithValue("@strTypein", logType);
                command.Parameters.AddWithValue("@strActionin", action);
                command.Parameters.AddWithValue("@intModulein", moduleId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Employee employee = new Employee();
                        employee.Id = dataReader["Emp_ID"].ToString();
                        employee.Name = dataReader["Emp_Name"].ToString();

                        employees.Add(employee);
                    }
                }
            }

            return employees;
        }

        public List<Employee> GetPendingReviewers(string userLanId, int moduleId, int logStatusId)
        {
            var employees = new List<Employee>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_ReassignFrom_Users]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strRequesterin", userLanId);
                command.Parameters.AddWithValue("@intModuleIdin", moduleId);
                command.Parameters.AddWithValue("@intStatusIdin", logStatusId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Employee employee = new Employee();
                        employee.Id = dataReader["UserID"].ToString();
                        employee.Name = dataReader["UserName"].ToString();

                        employees.Add(employee);
                    }
                }
            }

            return employees;
        }

        public List<Employee> GetAssignToList(string userLanId, int moduleId, int logStatusId, string originalReviewer)
        {
            var employees = new List<Employee>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_ReassignTo_Users]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strRequesterin", userLanId);
                command.Parameters.AddWithValue("@intModuleIdin", moduleId);
                command.Parameters.AddWithValue("@intStatusIdin", logStatusId);
                command.Parameters.AddWithValue("@strFromUserIdin", originalReviewer);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Employee employee = new Employee();
                        employee.Id = dataReader["UserID"].ToString();
                        employee.Name = dataReader["UserName"].ToString();

                        employees.Add(employee);
                    }
                }
            }

            return employees;
        }

    }
}
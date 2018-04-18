using eCoachingLog.Extensions;
using eCoachingLog.Models.Common;
using log4net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCoachingLog.Repository
{
	public class EmployeeRepository : IEmployeeRepository
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public List<Employee> GetEmployeesByModule(int moduleId, int siteId)
        {
            var employees = new List<Employee>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Employees_By_Module_And_Site]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@intModuleIDin", moduleId);
				command.Parameters.AddWithValue("@intSiteIDin", siteId);
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

        // !!!TODO: need new stored procedure
		// Get all employees who report to userLanId
        public List<Employee> GetEmployeesByModule(int moduleId, string userLanId)
        {
            var employees = new List<Employee>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_Employees_Coaching_Inactivation_Reactivation]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                // TODO: replace these parameters with real ones
                command.Parameters.AddWithValue("@intModulein", 1);
                command.Parameters.AddWithValue("@strActionin", "Inactivation");
                command.Parameters.AddWithValue("@strRequesterLanId", "lili.huang");

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

        public Employee GetEmployee(string employeeId)
        {
            Employee employee = new Employee();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Rec_Employee_Hierarchy]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("employeeId", employeeId);
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        employee.Id = dataReader["Emp_ID"].ToString();
                        employee.Name = dataReader["Emp_Name"].ToString();
                        employee.Email = dataReader["Emp_Email"].ToString();
						employee.LanId = dataReader["Emp_LanID"].ToString();
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

		public IList<Employee> GetEmployeesBySiteAndTitle(int siteId, int titleId) // TODO: change int to EmployeeTitle
		{
			var employees = new List<Employee>();

			// TODO: change
			var sp = "[EC].[sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All]";
			switch (titleId)
			{
				case (int)EmployeeTitle.Employee:
					sp = "[EC].[sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All]";
					break;
				case (int)EmployeeTitle.Supervisor:
					sp = "[EC].[sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All]";
					break;
			}

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand(sp, connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Employee employee = new Employee();

						switch (titleId)
						{
							case (int)EmployeeTitle.Manager:
								employee.Id = dataReader["MGRValue"].ToString();
								employee.Name = dataReader["MGRText"].ToString();
								break;
							case (int)EmployeeTitle.Supervisor:
								employee.Id = dataReader["SUPValue"].ToString();
								employee.Name = dataReader["SUPText"].ToString();
								break;
							case (int)EmployeeTitle.Employee:
								employee.Id = dataReader["CSRValue"].ToString();
								employee.Name = dataReader["CSRText"].ToString();
								break;
						}
						employees.Add(employee);
					}
				}
			}
			return employees;
		}

		public IList<Employee> GetAllSubmitters()
		{
			var employees = new List<Employee>();

			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Employee employee = new Employee();
						employee.Id = dataReader["SubmitterValue"].ToString();
						employee.Name = dataReader["SubmitterText"].ToString();
						employees.Add(employee);
					}
				}
			}
			return employees;
		}
	}
}
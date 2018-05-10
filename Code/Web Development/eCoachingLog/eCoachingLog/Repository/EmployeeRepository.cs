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
        private static readonly string conn = System.Configuration.ConfigurationManager.ConnectionStrings["dbConnectionString"].ConnectionString;

        public IList<Employee> GetEmployeesByModule(int moduleId, int siteId, string userEmpId)
        {
            var employees = new List<Employee>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Employees_By_Module_And_Site]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@intModuleIDin", moduleId);
				command.Parameters.AddWithValueSafe("@intSiteIDin", siteId);
				command.Parameters.AddWithValueSafe("@nvcUserEmpIDin", userEmpId);
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
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_Select_Rec_Employee_Hierarchy]", connection))
            {
				command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValueSafe("employeeId", employeeId);
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
						employee.SupervisorId = dataReader["Sup_ID"].ToString();
                        employee.SupervisorEmail = dataReader["Sup_Email"].ToString();
                        employee.ManagerName = dataReader["Mgr_Name"].ToString();
						employee.ManagerId = dataReader["Mgr_ID"].ToString();
                        employee.ManagerEmail = dataReader["Mgr_Email"].ToString();

                        break;
                    }
                }
            }
            return employee;
        }

		public IList<Employee> GetManagersBySite(int siteId)
		{
			var managers = new List<Employee>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_MGR_BySite]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@intSiteID", siteId);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Employee manager = new Employee();
						manager.Id = dataReader["ManagerId"].ToString();
						manager.Name = dataReader["Manager"].ToString();
						managers.Add(manager);
					}
				}
			}
			return managers;
		}

		public IList<Employee> GetSupervisorsByMgr(string mgrId)
		{
			var supervisors = new List<Employee>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Sup_ByMgr]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@nvcMgrID", mgrId);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Employee supervisor = new Employee();
						supervisor.Id = dataReader["SupervisorId"].ToString();
						supervisor.Name = dataReader["Supervisor"].ToString();
						supervisors.Add(supervisor);
					}
				}
			}
			return supervisors;
		}

		public IList<Employee> GetEmployeesBySup(int siteId, string mgrId, string supId, int empStatus)
		{
			var employees = new List<Employee>();
			using (SqlConnection connection = new SqlConnection(conn))
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Emp_BySup]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValueSafe("@intSiteID", siteId);
				command.Parameters.AddWithValueSafe("@nvcMgrID", mgrId);
				command.Parameters.AddWithValueSafe("@nvcSupID", supId);
				command.Parameters.AddWithValueSafe("@intEmpActive", empStatus);
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Employee employee = new Employee();
						employee.Id = dataReader["EmployeeId"].ToString();
						employee.Name = dataReader["Employee"].ToString();
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
			using (SqlCommand command = new SqlCommand("[EC].[sp_SelectFrom_Coaching_Log_Submitter]", connection))
			{
				command.CommandType = CommandType.StoredProcedure;
				command.CommandTimeout = 300;
				connection.Open();

				using (SqlDataReader dataReader = command.ExecuteReader())
				{
					while (dataReader.Read())
					{
						Employee employee = new Employee();
						employee.Id = dataReader["SubmitterID"].ToString();
						employee.Name = dataReader["Submitter"].ToString();
						employees.Add(employee);
					}
				}
			}
			return employees;
		}
	}
}
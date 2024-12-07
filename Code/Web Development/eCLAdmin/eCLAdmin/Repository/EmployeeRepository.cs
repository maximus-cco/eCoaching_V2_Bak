﻿using eCLAdmin.Extensions;
using eCLAdmin.Models.EmployeeLog;
using log4net;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace eCLAdmin.Repository
{
    public class EmployeeRepository : IEmployeeRepository
    {
        private readonly ILog logger = LogManager.GetLogger(typeof(EmployeeRepository));
        string conn = System.Configuration.ConfigurationManager.ConnectionStrings["CoachingConnectionString"].ConnectionString;

        public Employee GetEmployee(string employeeId)
        {
            Employee employee = new Employee();
			var query = "[EC].[sp_Select_Rec_Employee_Hierarchy]";

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
				command.CommandType = System.Data.CommandType.StoredProcedure;
				command.Parameters.AddWithValue("@EmployeeId", employeeId);
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

                    dataReader.Close();
                }
            }

            return employee;
        }

        public List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action)
        {
            logger.Debug("######userLanId=" + userLanId + ", logTypeId=" + logTypeId + ", moduleId=" + moduleId + ", action=" + action);
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

                    dataReader.Close();
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

                    dataReader.Close();
                }
            }

            return employees;
        }

        public List<Employee> GetReviewersBySite(int siteId)
        {
            logger.Debug("********* siteId=" + siteId);
            var reviewers = new List<Employee>();

            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_AT_Select_ReassignTo_Users]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@intSiteIDin", siteId);

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        Employee employee = new Employee();
                        employee.Id = dataReader["UserID"].ToString();
                        employee.Name = dataReader["UserName"].ToString();
                        employee.SiteName = dataReader["UserSite"].ToString();

                        reviewers.Add(employee);
                    }

                    dataReader.Close();
                }
            }

            return reviewers;
        }

        public List<Employee> GetEmployeesBySite(string site)
        {
            var employees = new List<Employee>();
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand("[EC].[sp_rptEmployeesBySite]", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.AddWithValue("@strEmpSitein", site);
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 250);
                retMsgParam.Direction = ParameterDirection.Output;

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var employee = new Employee();
                        employee.Id = dataReader["Emp_ID"].ToString();
                        employee.Name = dataReader["Emp_Name"].ToString();
                        employees.Add(employee);
                    }
                    dataReader.Close();
                }
            }

            return employees;
        }

        public List<Employee> GetEmployeesBySiteAndModule(int moduleId, int siteId, string hireDate, bool isWarning)
        {
            var employees = new List<Employee>();
            var storedProcedure = isWarning ? "[EC].[sp_rptWarningEmployeesBySiteAndModule]" : "[EC].[sp_rptCoachingEmployeesBySiteAndModule]";
            using (SqlConnection connection = new SqlConnection(conn))
            using (SqlCommand command = new SqlCommand(storedProcedure, connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                // sp is checking null for "All" instead of -1, so pass in null if -1
                string strModuleId = moduleId == -1 ? null : moduleId.ToString();
                string strSiteId = siteId == -1 ? null : siteId.ToString();
                command.Parameters.AddWithValue("@intModulein", strModuleId);
                command.Parameters.AddWithValue("@intSitein", strSiteId);
                // sp is checking hireDate null, not checking empty string, so if hireDate is empty, pass in null
                command.Parameters.AddWithValue("@strHDatein", string.IsNullOrEmpty(hireDate) ? null : hireDate );
                // output parameters
                SqlParameter retCodeParam = command.Parameters.Add("@returnCode", SqlDbType.Int);
                retCodeParam.Direction = ParameterDirection.Output;
                SqlParameter retMsgParam = command.Parameters.Add("@returnMessage", SqlDbType.VarChar, 250);
                retMsgParam.Direction = ParameterDirection.Output;

                connection.Open();

                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    while (dataReader.Read())
                    {
                        var employee = new Employee();
                        employee.Id = dataReader["EmpID"].ToString();
                        employee.Name = dataReader["EmpName"].ToString();
                        employees.Add(employee);
                    }
                    dataReader.Close();
                }
            }

            return employees;
        }

    }
}
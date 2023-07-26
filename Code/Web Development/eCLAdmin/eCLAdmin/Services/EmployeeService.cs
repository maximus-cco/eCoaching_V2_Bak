using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Repository;
using System;
using System.Collections.Generic;
using System.Linq;

namespace eCLAdmin.Services
{
    public class EmployeeService : IEmployeeService
    {
        private readonly IEmployeeRepository employeeRepository;

        public EmployeeService(IEmployeeRepository employeeRepository)
        {
            this.employeeRepository = employeeRepository;
        }

        public Employee GetEmployee(string employeeId)
        {
            return employeeRepository.GetEmployee(employeeId);
        }

        public List<Employee> GetEmployees(string userLanId, int logTypeId, int moduleId, string action)
        {
            return employeeRepository.GetEmployees(userLanId, logTypeId, moduleId, action);
        }

        public List<Employee> GetPendingReviewers(string userLanId, int moduleId, int logStatusId)
        {
            return employeeRepository.GetPendingReviewers(userLanId, moduleId, logStatusId);
        }

        public List<Employee> GetReviewersBySite(int siteId, string excludeReviewerId)
        {
            var reviewers = employeeRepository.GetReviewersBySite(siteId);
            if (!String.IsNullOrEmpty(excludeReviewerId))
            {
                reviewers = reviewers.Where(r => !r.Id.Equals(excludeReviewerId, StringComparison.OrdinalIgnoreCase)).ToList();
            }

            if (siteId == -1)
            {
                foreach (var r in reviewers)
                {
                    r.Name = r.Name + " (" + r.SiteName + ")";
                }
            }

            return reviewers;
        }

        public List<Employee> GetEmployeesBySite(string site)
        {
            var employees = new List<Employee>();
            if (site == "Select Site")
            {
                return employees;
            }

            employees = employeeRepository.GetEmployeesBySite(site);
            if (employees.Count == 1 && employees[0].Id == "-1")
            {
                employees[0].Id = "No employee found";
                employees[0].Name = "No employee found";
            }

            return employees;
        }

        public List<Employee> GetEmployeesBySiteAndModuleId(int moduleId, int siteId, string hireDate, bool isWarning)
        {
            var employees = new List<Employee>();
            if (siteId == -2)
            {
                return employees;
            }

            if (siteId == -1) // "All Sites"
            {
                employees.Add(new Employee("-1", "All Employees"));
                return employees;
            }

            employees = employeeRepository.GetEmployeesBySiteAndModule(moduleId, siteId, hireDate, isWarning);
            if ((employees.Count == 1 && employees[0].Id == "-1") || employees.Count == 0)
            {
                employees.Clear();
                employees.Add(new Employee("No employee found", "No employee found"));
            }

            return employees;
        }
    }
}
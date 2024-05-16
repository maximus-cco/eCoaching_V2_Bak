using eCLAdmin.Models.EmployeeLog;
using eCLAdmin.Models.Report;
using eCLAdmin.Repository;
using eCLAdmin.Utilities;
using log4net;
using System.Collections.Generic;
using System.Data;
using eCLAdmin.Models.User;
using eCLAdmin.ViewModels.Reports;
using eCLAdmin.Models.Common;
using System.Web.Mvc;
using System.Linq;

namespace eCLAdmin.Services
{
    public class ReportService : IReportService
    {
        private static readonly ILog logger = LogManager.GetLogger(typeof(ReportService));
        private readonly IReportRepository rptRepository;

        public ReportService(IReportRepository reportRepository)
        {
            this.rptRepository = reportRepository;
        }

        public List<eCLAdmin.Models.EmployeeLog.Action> GetActions(int logTypeId)
        {
            return this.rptRepository.GetActions(EclAdminUtil.GetLogTypeNameById(logTypeId));
        }

        public List<string> GetLogNames(string logType, string action, string startDate, string endDate)
        {
            return this.rptRepository.GetLogNames(logType, action, startDate, endDate);
        }

        public List<AdminActivity> GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName,
            int pageSize, int rowStartIndex, out int totalRows)
        {
            return this.rptRepository.GetActivityList(logType, action, logName, startDate, endDate, logOrEmpName, pageSize, rowStartIndex, out totalRows);
        }

        public DataSet GetActivityList(string logType, string action, string logName, string startDate, string endDate, string logOrEmpName)
        {
            var dataSet = this.rptRepository.GetActivityList(logType, action, logName, startDate, endDate, logOrEmpName);
            return dataSet;
        }

        public List<EmployeeHierarchy> GetEmployeeHierarchy(string site, string employeeId, int pageSize, int rowStartIndex, out int totalRows)
        {
            return this.rptRepository.GetEmployeeHierarchy(site, employeeId, pageSize, rowStartIndex, out totalRows);
        }

        public DataSet GetEmployeeHierarchy(string site, string employeeId)
        {
            var dataSet = this.rptRepository.GetEmployeeHierarchy(site, employeeId);
            return dataSet;
        }

        public List<Module> GetEmployeeLevels(User user)
        {
            return this.rptRepository.GetEmployeeLevels(user).OrderBy(x => x.Name).ToList<Module>();
        }

        public List<Reason> GetReasonsByModuleId(int moduleId, bool isWarning)
        {
            return this.rptRepository.GetReasonsByModuleId(moduleId, isWarning);
        }

        public List<Reason> GetSubreasons(int reasonId, bool isWarning)
        {
            return this.rptRepository.GetSubreasons(reasonId, isWarning);
        }

        public List<Status> GetLogStatusList(int moduleId, bool isWarning)
        {
            return this.rptRepository.GetLogStatusList(moduleId, isWarning);
        }

        public List<CoachingLog> GetCoachingLogs(CoachingSearchViewModel search, out int totalRows)
        {
            return this.rptRepository.GetCoachingLogs(search, out totalRows);
        }

        public DataSet GetCoachingLogs(CoachingSearchViewModel search)
        {
            return this.rptRepository.GetCoachingLogs(search);
        }

        public List<CoachingLogQn> GetCoachingLogQns(QualityNowSearchViewModel search, out int totalRows)
        {
            return this.rptRepository.GetCoachingLogQns(search, out totalRows);
        }

        public DataSet GetCoachingLogQns(QualityNowSearchViewModel search)
        {
            return this.rptRepository.GetCoachingLogQns(search);
        }

        public List<Status> GetWarningLogStates()
        {
            return this.rptRepository.GetWarningLogStates();
        }

        public List<WarningLog> GetWarningLogs(WarningSearchViewModel search, out int totalRows)
        {
            return this.rptRepository.GetWarningLogs(search, out totalRows);
        }

        public DataSet GetWarningLogs(WarningSearchViewModel search)
        {
            return this.rptRepository.GetWarningLogs(search);
        }

        public List<IdName> GetFeedCategories()
        {
            return this.rptRepository.GetFeedCategories();
        }

        public List<IdName> GetFeedReportCodes(int categoryId)
        {
            return this.rptRepository.GetFeedReportCodes(categoryId);
        }

        public List<FeedLoadHistory> GetFeedLoadHistory(string startDate, string endDate, int categoryId, int reportCodeId, int pageSize, int rowStartIndex, out int totalRows)
        {
            return this.rptRepository.GetFeedLoadHistory(startDate, endDate, categoryId, reportCodeId, pageSize, rowStartIndex, out totalRows);

        }
        // Export to excel
        public DataSet GeFeedLoadHistory(string startDate, string endDate, int categoryId, int reportCodeId)
        {
            return this.rptRepository.GetFeedLoadHistoryDataSet(startDate, endDate, categoryId, reportCodeId);
        }

    }
}
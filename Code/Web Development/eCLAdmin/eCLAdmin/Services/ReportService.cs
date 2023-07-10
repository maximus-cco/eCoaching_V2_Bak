using eCLAdmin.Models.Report;
using eCLAdmin.Repository;
using eCLAdmin.Utilities;
using log4net;
using System.Collections.Generic;
using System.Data;

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

    }
}
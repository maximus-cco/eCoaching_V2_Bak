using System.Collections.Generic;
namespace eCoachingLog.Models.Common
{
    public class MailParameter
    {
        //List<Employee> employees, int moduleId, bool isWarning, bool isCse, int sourceId, string templateFileName
        public List<Employee> Employees { get; set; }
        public int ModuleId { get; set; }
        public bool IsWarning { get; set; }
        public bool IsCse { get; set; }
        public int SourceId { get; set; }
        public string TemplateFileName { get; set; }

        public bool SaveMailStatus { get; set; }
        public string UserId { get; set; } // person id sending the mail

        public MailParameter(List<Employee> employees, int moduleId, bool isWarning, bool isCse, int sourceId, string templateFileName, bool saveMailStatus, string userId)
        {
            Employees = employees;
            ModuleId = moduleId;
            IsWarning = isWarning;
            IsCse = isCse;
            SourceId = sourceId;
            TemplateFileName = templateFileName;
            SaveMailStatus = saveMailStatus;
            UserId = userId;
        }
    }
}
using System.Collections.Generic;
namespace eCoachingLog.Models.Common
{
    public class MailParameter
    {
        public string MailSource { get; set; }

        //List<Employee> employees, int moduleId, bool isWarning, bool isCse, int sourceId, string templateFileName
        public List<NewSubmissionResult> NewSubmissionResult { get; set; }
        public int ModuleId { get; set; }
        public bool IsWarning { get; set; }
        public bool IsCse { get; set; }
        public int SourceId { get; set; }
        public string TemplateFileName { get; set; }

        public bool SaveMailStatus { get; set; }
        public string UserId { get; set; } // person id sending the mail

        // Review Comments
        public BaseLogDetail LogDetail { get; set; }
        public string MainReasonNotCoachable { get; set; }
        public string DetailReasonNotCoachable { get; set; }
        public string Comments { get; set; }
        public string Subject { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }

        public MailParameter(List<NewSubmissionResult> newSubmissionResult, int moduleId, bool isWarning, bool isCse, int sourceId, string templateFileName, bool saveMailStatus, string userId)
        {
            MailSource = "UI-Submissions";
            NewSubmissionResult = newSubmissionResult;
            ModuleId = moduleId;
            IsWarning = isWarning;
            IsCse = isCse;
            SourceId = sourceId;
            TemplateFileName = templateFileName;
            SaveMailStatus = saveMailStatus;
            UserId = userId;
        }

        public MailParameter(BaseLogDetail logDetail, string reasonNotCoachable, string detailReasonNotCoachable, string comments, string subject, string templateFileName, 
            string userId, string to = null, string cc = null)
        {
            MailSource = "UI-Comments";
            LogDetail = logDetail;
            Comments = comments;
            Subject = subject;
            TemplateFileName = templateFileName;
            UserId = userId;
            MainReasonNotCoachable = reasonNotCoachable;
            DetailReasonNotCoachable = detailReasonNotCoachable;
            To = to;
            Cc = cc;
        }
    }
}
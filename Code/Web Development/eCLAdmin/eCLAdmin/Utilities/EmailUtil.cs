using eCLAdmin.Models.EmployeeLog;

namespace eCLAdmin.Utilities
{
    public class EmailUtil
    {
        public static string GetTemplateFileName(EmailType emailType)
        {
            string templateFileName = null;
            switch (emailType)
            {
                case EmailType.Reactivation:
                    templateFileName = "EmployeeLogReactivation.html";
                    break;
                case EmailType.Reassignment:
                    templateFileName = "EmployeeLogReassignment.html";
                    break;
                default:
                    templateFileName = "unknown";
                    break;
            }

            return templateFileName;
        }

        public static string GetSubject(EmailType emailType)
        {
            string subject = null;
            switch (emailType)
            {
                case EmailType.Reactivation:
                    subject = Constants.EMAIL_SUBJECT_REACTIVATION;
                    break;
                case EmailType.Reassignment:
                    subject = Constants.EMAIL_SUBJECT_REASSIGNMENT;
                    break;
                default:
                    subject = "unknown";
                    break;
            }

            return subject;
        }

        public static string GetEmailTo(int statusId, Employee employee)
        {
            string emailTo = null;

            switch (statusId)
            {
                case Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT:
                    emailTo = employee.Email;
                    break;
                case Constants.LOG_STATUS_PENDING_EMPLOYEEREVIEW:
                    emailTo = employee.Email;
                    break;
                case Constants.LOG_STATUS_PENDING_MANAGERREVIEW:
                    emailTo = employee.ManagerEmail;
                    break;
                case Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW:
                    emailTo = employee.SupervisorEmail;
                    break;
                default:
                    break;
            }

            return emailTo;
        }
    }
}
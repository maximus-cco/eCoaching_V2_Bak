using eCoachingLog.Models.Common;

namespace eCoachingLog.Utilities
{
	public class EmailUtil
    {
        //public static string GetTemplateFileName(EmailType emailType)
        //{
        //    string templateFileName = null;
        //    switch (emailType)
        //    {
        //        case EmailType.Reactivation:
        //            templateFileName = "EmployeeLogReactivation.html";
        //            break;
        //        case EmailType.Reassignment:
        //            templateFileName = "EmployeeLogReassignment.html";
        //            break;
        //        default:
        //            templateFileName = "unknown";
        //            break;
        //    }

        //    return templateFileName;
        //}

        // Get address to send email.
        // CSR and Training modules: Pending Supervisor Review, Pending Manager Review
        // Supervisor module: Pending Manager Review, Pending Sr. Manager Review
        // Quality module: Pending Quality Lead Review
        // LSA module: Pending Supervisor Review
        public static string GetEmailTo(int moduleId,  int statusId, Employee employee)
        {
            string emailTo = null;
            switch (statusId)
            {
                case Constants.LOG_STATUS_PENDING_ACKNOWLEDGEMENT:
                    emailTo = employee.Email;
                    break;
                case Constants.LOG_STATUS_PENDING_EMPLOYEE_REVIEW:
                    emailTo = employee.Email;
                    break;
                case Constants.LOG_STATUS_PENDING_MANAGER_REVIEW:
                    emailTo = employee.ManagerEmail;
                    if (moduleId == Constants.MODULE_SUPERVISOR)
                    {
                        // For supervisors, their direct report is their supervisor
                        emailTo = employee.SupervisorEmail;
                    }
                    break;
                case Constants.LOG_STATUS_PENDING_SUPERVISOR_REVIEW:
                    emailTo = employee.SupervisorEmail;
                    break;
                case Constants.LOG_STATUS_PENDING_SRMANAGER_REVIEW:
                    emailTo = employee.ManagerEmail;
                    break;
                case Constants.LOG_STATUS_PENDING_QUALITYLEAD_REVIEW:
                    emailTo = employee.SupervisorEmail;
                    break;
                // This status is not being used in eCoaching Log.
                //case Constants.LOG_STATUS_PENDINGDE_PUTYPROGRAMMANAGER_REVIEW:
                //    emailTo = employee.ManagerEmail;
                //    break;
                default:
                    break;
            }

            return emailTo;
        }
    }
}
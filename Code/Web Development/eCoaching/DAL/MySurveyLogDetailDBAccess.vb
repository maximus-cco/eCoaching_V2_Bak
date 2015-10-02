Imports System.Data.SqlClient

Public Class MySurveyLogDetailDBAccess

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="logID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetLogReasons(logID As String) As DataTable
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strFormIDin", logID)
        }

        Return DBUtility.ExecuteSelectCommand("EC.sp_SelectReviewFrom_Coaching_Log_Reasons", CommandType.StoredProcedure, parameters)
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="logID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetLogDetail(logID As String) As MySurveyLogDetail
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strFormIDin", logID)
        }

        Dim logDetail As MySurveyLogDetail = New MySurveyLogDetail()
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectReviewFrom_Coaching_Log", CommandType.StoredProcedure, parameters)
            Dim row As DataRow = dataTable.Rows(0)

            logDetail.ID = logID
            logDetail.Status = StringUtils.GetSafeString(row("strFormStatus"))
            logDetail.Type = StringUtils.GetSafeString(row("strFormType"))
            logDetail.SubmittedDate = StringUtils.GetSafeString(row("SubmittedDate"))
            logDetail.EventDate = StringUtils.GetSafeString(row("EventDate"))
            logDetail.CoachingDate = StringUtils.GetSafeString(row("CoachingDate"))
            logDetail.Source = StringUtils.GetSafeString(row("strSource"))
            logDetail.Site = StringUtils.GetSafeString(row("strCSRSite"))
            logDetail.Description = StringUtils.GetSafeString(row("txtDescription"))
            logDetail.IsIQS = StringUtils.GetSafeString(row("isIQS"))
            logDetail.CSE = StringUtils.GetSafeString(row("Customer Service Escalation"))
            logDetail.IsCSE = StringUtils.GetSafeString(row("isCSE"))
            logDetail.VerintID = StringUtils.GetSafeString(row("strVerintID"))
            logDetail.VerintFormName = StringUtils.GetSafeString(row("VerintFormName"))
            logDetail.IsVerintMonitor = StringUtils.GetSafeString(row("isVerintMonitor"))
            logDetail.BehaviorAnalyticsID = StringUtils.GetSafeString(row("strBehaviorAnalyticsID"))
            logDetail.IsBehaviorAnalyticsMonitor = StringUtils.GetSafeString(row("isBehaviorAnalyticsMonitor"))
            logDetail.NGDActivityID = StringUtils.GetSafeString(row("strNGDActivityID"))
            logDetail.IsNGDActivityID = StringUtils.GetSafeString(row("isNGDActivityID"))
            logDetail.UCID = StringUtils.GetSafeString(row("strUCID"))
            logDetail.IsUCID = StringUtils.GetSafeString(row("isUCID"))
            logDetail.EmployeeName = StringUtils.GetSafeString(row("strCSRName"))
            logDetail.SupervisorName = StringUtils.GetSafeString(row("strCSRSupName"))
            logDetail.ManagerName = StringUtils.GetSafeString(row("strCSRMgr"))
            logDetail.SubmitterName = StringUtils.GetSafeString(row("strSubmitterName"))
            logDetail.ReviewerName = StringUtils.GetSafeString(row("strReviewer"))
            logDetail.ManagerNotes = StringUtils.GetSafeString(row("txtMgrNotes"))
            logDetail.CoachingNotes = StringUtils.GetSafeString(row("txtCoachingNotes"))
            logDetail.EmployeeComments = StringUtils.GetSafeString(row("txtCSRComments"))
            logDetail.EmployeeReviewedAutoDate = StringUtils.GetSafeString(row("CSRReviewAutoDate"))
            logDetail.ReviewerReviewedAutoDate = StringUtils.GetSafeString(row("SupReviewedAutoDate"))
        End Using

        Return logDetail
    End Function
End Class

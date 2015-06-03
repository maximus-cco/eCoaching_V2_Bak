Imports System.Data.SqlClient
Imports System.Data

Public Class HistoricalDashboardDBAccess

    Public Function GetAllSites() As DataTable
        Return DBUtility.ExecuteSelectCommand("EC.sp_Select_Sites_For_Dashboard", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetAllCSRs() As DataTable
        Return DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetAllSupervisors()
        Return DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetAllManagers() As DataTable
        Return DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetAllSubmitters() As DataTable
        Return DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetAllStatuses() As DataTable
        Return DBUtility.ExecuteSelectCommand("EC.sp_Select_Statuses_For_Dashboard", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetAllSources(ByVal userLanID As String) As DataTable
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strUserin", userLanID)
        }

        Return DBUtility.ExecuteSelectCommand("EC.sp_Select_Sources_For_Dashboard", CommandType.StoredProcedure, parameters)
    End Function

    Public Function GetAllValues() As DataTable
        Return DBUtility.ExecuteSelectCommand("EC.sp_Select_Values_For_Dashboard", CommandType.StoredProcedure, Nothing)
    End Function

    Public Function GetTotalRowCount(ByVal strSourcein As String,
                                ByVal strCSRSitein As String,
                                ByVal strCSRin As String,
                                ByVal strSUPin As String,
                                ByVal strMGRin As String,
                                ByVal strSubmitterin As String,
                                ByVal strSDatein As String,
                                ByVal strEDatein As String,
                                ByVal strStatusin As String,
                                ByVal strjobcode As String,
                                ByVal strValue As String
                            ) As Integer

        Dim count As Integer = 0
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strSourcein", strSourcein),
            New SqlParameter("@strCSRSitein", strCSRSitein),
            New SqlParameter("@strCSRin", strCSRin),
            New SqlParameter("@strSUPin", strSUPin),
            New SqlParameter("@strMGRin", strMGRin),
            New SqlParameter("@strSubmitterin", strSubmitterin),
            New SqlParameter("@strSDatein", strSDatein),
            New SqlParameter("@strEDatein", strEDatein),
            New SqlParameter("@strStatusin", strStatusin),
            New SqlParameter("@strjobcode", strjobcode),
            New SqlParameter("@strvalue", strValue)
        }

        count = DBUtility.ExecuteScalar("EC.sp_SelectFrom_Coaching_Log_HistoricalSUP_Count", CommandType.StoredProcedure, parameters)
        Return count
    End Function

    Public Function GetRows(ByVal startRowIndex As Integer,
                        ByVal pageSize As Integer,
                        ByVal strSourcein As String,
                        ByVal strCSRSitein As String,
                        ByVal strCSRin As String,
                        ByVal strSUPin As String,
                        ByVal strMGRin As String,
                        ByVal strSubmitterin As String,
                        ByVal strSDatein As String,
                        ByVal strEDatein As String,
                        ByVal strStatusin As String,
                        ByVal strjobcode As String,
                        ByVal strValue As String,
                        ByVal sortBy As String,
                        ByVal sortASC As String
                    ) As List(Of HistoricalDashboard)

        Dim rows As List(Of HistoricalDashboard) = New List(Of HistoricalDashboard)
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strSourcein", strSourcein),
            New SqlParameter("@strCSRSitein", strCSRSitein),
            New SqlParameter("@strCSRin", strCSRin),
            New SqlParameter("@strSUPin", strSUPin),
            New SqlParameter("@strMGRin", strMGRin),
            New SqlParameter("@strSubmitterin", strSubmitterin),
            New SqlParameter("@strSDatein", strSDatein),
            New SqlParameter("@strEDatein", strEDatein),
            New SqlParameter("@strvalue", strValue),
            New SqlParameter("@strStatusin", strStatusin),
            New SqlParameter("@strjobcode", strjobcode),
            New SqlParameter("@startRowIndex", startRowIndex),
            New SqlParameter("@PageSize", pageSize),
            New SqlParameter("@sortBy", sortBy),
            New SqlParameter("@sortASc", sortASC)
        }

        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_Log_HistoricalSUP", CommandType.StoredProcedure, parameters)
            For Each row In dataTable.Rows
                Dim historicalDashboard As HistoricalDashboard = New HistoricalDashboard()
                historicalDashboard.RowNumber = row("RowNumber")
                historicalDashboard.FormID = If(IsDBNull(row("strFormID")), String.Empty, row("strFormID"))
                historicalDashboard.EmployeeName = If(IsDBNull(row("strCSRName")), String.Empty, row("strCSRName"))
                historicalDashboard.SupervisorName = If(IsDBNull(row("strCSRSupName")), String.Empty, row("strCSRSupName"))
                historicalDashboard.ManagerName = If(IsDBNull(row("strCSRMgrName")), String.Empty, row("strCSRMgrName"))
                historicalDashboard.SubmitterName = If(IsDBNull(row("strSubmitterName")), String.Empty, row("strSubmitterName"))
                historicalDashboard.Source = If(IsDBNull(row("strSource")), String.Empty, row("strSource"))
                historicalDashboard.Status = If(IsDBNull(row("strFormStatus")), String.Empty, row("strFormStatus"))
                historicalDashboard.SubmittedDate = If(IsDBNull(row("SubmittedDate")), String.Empty, row("SubmittedDate"))
                Dim reasons As String = If(IsDBNull(row("strCoachingReason")), String.Empty, row("strCoachingReason"))
                Dim subReasons As String = If(IsDBNull(row("strSubCoachingReason")), String.Empty, row("strSubCoachingReason"))
                Dim values As String = If(IsDBNull(row("strValue")), String.Empty, row("strValue"))
                historicalDashboard.CoachingReasons = (From reason In reasons.Split("|") Select reason).ToList()
                historicalDashboard.CoachingSubReasons = (From subReason In subReasons.Split("|") Select subReason).ToList()
                historicalDashboard.Values = (From value In values.Split("|") Select value).ToList()

                rows.Add(historicalDashboard)
            Next
        End Using

        Return rows
    End Function

    Public Function GetExcelDataTable(ByRef filter As HistoricalDashboardFilter) As DataTable
        Dim parameters() As SqlParameter = New SqlParameter() {
            New SqlParameter("@strSourcein", filter.Source),
            New SqlParameter("@strCSRSitein", filter.SiteID),
            New SqlParameter("@strCSRin", filter.CSREmpID),
            New SqlParameter("@strSUPin", filter.SupervisorEmpID),
            New SqlParameter("@strMGRin", filter.ManagerEmpID),
            New SqlParameter("@strSubmitterin", filter.SubmitterEmpID),
            New SqlParameter("@strSDatein", filter.StartDate),
            New SqlParameter("@strEDatein", filter.EndDate),
            New SqlParameter("@strStatusin", filter.Status),
            New SqlParameter("@strvalue", filter.Value)
        }

        Return DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_Log_Historical_Export", CommandType.StoredProcedure, parameters)
    End Function

End Class

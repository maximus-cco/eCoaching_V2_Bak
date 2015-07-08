Imports System.Data.SqlClient
Imports System.Data

Public Class HistoricalDashboardDBAccess

    Public Function GetAllSites() As IEnumerable(Of Site)
        Dim sites As IList(Of Site) = New List(Of Site)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_Sites_For_Dashboard", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim site As Site = New Site()
                site.SiteID = row("SiteValue")
                site.SiteName = row("SiteText")
                sites.Add(site)
            Next
        End Using

        Return sites
    End Function

    Public Function GetAllCSRs() As IEnumerable(Of Employee)
        Dim CSRs As IList(Of Employee) = New List(Of Employee)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted_All", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim csr As Employee = New Employee()
                csr.EmployeeID = row("CSRValue")
                csr.EmployeeName = row("CSRText")
                CSRs.Add(csr)
            Next
        End Using
        Return CSRs
    End Function

    Public Function GetAllSupervisors() As IEnumerable(Of Employee)
        Dim supervisors As IList(Of Employee) = New List(Of Employee)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted_All", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim supervisor As Employee = New Employee()
                supervisor.EmployeeID = row("SUPValue")
                supervisor.EmployeeName = row("SUPText")
                supervisors.Add(supervisor)
            Next
        End Using
        Return supervisors
    End Function

    Public Function GetAllManagers() As IEnumerable(Of Employee)
        Dim managers As IList(Of Employee) = New List(Of Employee)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted_All", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim manager As Employee = New Employee()
                manager.EmployeeID = row("MGRValue")
                manager.EmployeeName = row("MGRText")
                managers.Add(manager)
            Next
        End Using
        Return managers
    End Function

    Public Function GetAllSubmitters() As IEnumerable(Of Employee)
        Dim submitters As IList(Of Employee) = New List(Of Employee)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim submitter As Employee = New Employee()
                submitter.EmployeeID = row("SubmitterValue")
                submitter.EmployeeName = row("SubmitterText")
                submitters.Add(submitter)
            Next
        End Using
        Return submitters
    End Function

    Public Function GetAllStatuses() As IEnumerable(Of Status)
        Dim statuses As IList(Of Status) = New List(Of Status)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_Statuses_For_Dashboard", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim status As Status = New Status()
                status.StatusID = row("StatusValue")
                status.StatusText = row("StatusText")
                statuses.Add(status)
            Next
        End Using
        Return statuses
    End Function

    Public Function GetAllSources(userLanID As String) As IEnumerable(Of Source)
        Dim sources As IList(Of Source) = New List(Of Source)
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strUserin", userLanID)
        }
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_Sources_For_Dashboard", CommandType.StoredProcedure, parameters)
            For Each row In dataTable.Rows
                Dim source As Source = New Source()
                source.SourceID = row("SourceValue")
                source.SourceText = row("SourceText")
                sources.Add(source)
            Next
        End Using
        Return sources
    End Function

    Public Function GetAllValues() As IEnumerable(Of Value)
        Dim values As IList(Of Value) = New List(Of Value)
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Select_Values_For_Dashboard", CommandType.StoredProcedure, Nothing)
            For Each row In dataTable.Rows
                Dim value As Value = New Value()
                value.ValueID = row("ValueValue")
                value.ValueText = row("ValueText")
                values.Add(value)
            Next
        End Using
        Return values
    End Function

    Public Function GetCSRsBySite(siteID As String) As IEnumerable(Of Employee)
        Dim CSRs As IList(Of Employee) = New List(Of Employee)
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strCSRSitein", siteID)
        }
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted_Site", CommandType.StoredProcedure, parameters)
            For Each row In dataTable.Rows
                Dim csr As Employee = New Employee()
                csr.EmployeeID = row("CSRValue")
                csr.EmployeeName = row("CSRText")
                CSRs.Add(csr)
            Next
        End Using
        Return CSRs
    End Function

    Public Function GetSupervisorsBySite(siteID As String) As IEnumerable(Of Employee)
        Dim supervisors As IList(Of Employee) = New List(Of Employee)
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strCSRSitein", siteID)
        }
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted_Site", CommandType.StoredProcedure, parameters)
            For Each row In dataTable.Rows
                Dim supervisor As Employee = New Employee()
                supervisor.EmployeeID = row("SUPValue")
                supervisor.EmployeeName = row("SUPText")
                supervisors.Add(supervisor)
            Next
        End Using
        Return supervisors
    End Function

    Public Function GetManagersBySite(siteID As String) As IEnumerable(Of Employee)
        Dim managers As IList(Of Employee) = New List(Of Employee)
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strCSRSitein", siteID)
        }
        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted_Site", CommandType.StoredProcedure, parameters)
            For Each row In dataTable.Rows
                Dim manager As Employee = New Employee()
                manager.EmployeeID = row("MGRValue")
                manager.EmployeeName = row("MGRText")
                managers.Add(manager)
            Next
        End Using
        Return managers
    End Function

    Public Function GetTotalRowCount(strSourcein As String,
                                strCSRSitein As String,
                                strCSRin As String,
                                strSUPin As String,
                                strMGRin As String,
                                strSubmitterin As String,
                                strSDatein As String,
                                strEDatein As String,
                                strStatusin As String,
                                strjobcode As String,
                                strValue As String
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

    Public Function GetRows(startRowIndex As Integer,
                        pageSize As Integer,
                        strSourcein As String,
                        strCSRSitein As String,
                        strCSRin As String,
                        strSUPin As String,
                        strMGRin As String,
                        strSubmitterin As String,
                        strSDatein As String,
                        strEDatein As String,
                        strStatusin As String,
                        strjobcode As String,
                        strValue As String,
                        sortBy As String,
                        sortASC As String
                    ) As IEnumerable(Of HistoricalDashboard)

        Dim rows As IList(Of HistoricalDashboard) = New List(Of HistoricalDashboard)
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

    Public Function GetExcelDataTable(filter As HistoricalDashboardFilter) As DataTable
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

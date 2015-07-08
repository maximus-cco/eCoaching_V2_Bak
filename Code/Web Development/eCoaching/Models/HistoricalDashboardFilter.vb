Public Class HistoricalDashboardFilter
    Public Property SiteID As String
    Public Property CSREmpID As String
    Public Property SupervisorEmpID As String
    Public Property ManagerEmpID As String
    Public Property SubmitterEmpID As String

    Public Property Site As String
    Public Property CSRName As String
    Public Property SupervisorName As String
    Public Property ManagerName As String
    Public Property SubmitterName As String
    Public Property Status As String
    Public Property Source As String
    Public Property Value As String
    Public Property StartDate As String
    Public Property EndDate As String

    Public Sub New(siteID As String, csrEmpID As String, supervisorEmpID As String, managerEmpID As String, submitterEmpID As String,
                   site As String, csrName As String, supervisorName As String, managerName As String,
                   submitterName As String, status As String, source As String, value As String,
                   startDate As String, endDate As String)

        Me.SiteID = siteID
        Me.CSREmpID = csrEmpID
        Me.SupervisorEmpID = supervisorEmpID
        Me.ManagerEmpID = managerEmpID
        Me.SubmitterEmpID = submitterEmpID

        Me.Site = site
        Me.CSRName = csrName
        Me.SupervisorName = supervisorName
        Me.ManagerName = managerName
        Me.SubmitterName = submitterName
        Me.Status = status
        Me.Source = source
        Me.Value = value
        Me.StartDate = startDate
        Me.EndDate = endDate
    End Sub
End Class

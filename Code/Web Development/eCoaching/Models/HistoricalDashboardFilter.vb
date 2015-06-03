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

    Public Sub New(ByVal siteID As String, ByVal csrEmpID As String, ByVal supervisorEmpID As String, ByVal managerEmpID As String, ByVal submitterEmpID As String,
                   ByVal site As String, ByVal csrName As String, ByVal supervisorName As String, ByVal managerName As String,
                    ByVal submitterName As String, ByVal status As String, ByVal source As String, ByVal value As String,
                    ByVal startDate As String, ByVal endDate As String)

        Me.SiteID = siteID
        Me.CSREmpID = csrEmpID
        Me.SupervisorEmpID = supervisorEmpID
        Me.ManagerEmpID = managerEmpID
        Me.SubmitterEmpID = submitterEmpID

        Me.Site = site
        Me.CSRName = CSRName
        Me.SupervisorName = SupervisorName
        Me.ManagerName = ManagerName
        Me.SubmitterName = SubmitterName
        Me.Status = Status
        Me.Source = Source
        Me.Value = Value
        Me.StartDate = StartDate
        Me.EndDate = EndDate
    End Sub
End Class

Public Class HistoricalDashboardFilter
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

    Public Sub New(ByVal site As String, ByVal csrName As String, ByVal supervisorName As String, ByVal managerName As String,
                    ByVal submitterName As String, ByVal status As String, ByVal source As String, ByVal value As String,
                    ByVal startDate As String, ByVal endDate As String)

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

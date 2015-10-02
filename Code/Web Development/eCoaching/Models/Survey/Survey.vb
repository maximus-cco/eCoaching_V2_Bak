<Serializable()> Public Class Survey
    Public Property ID As Integer
    Public Property LogName As String
    Public Property EmployeeID As Integer
    Public Property Questions As ICollection(Of Question)
    Public Property Comment As String
    Public Property ContainsHotTopic As Boolean
    Public Property Status As String

    Sub New()
        ID = -1
        LogName = String.Empty
        EmployeeID = -1
        Questions = New List(Of Question)
        Comment = String.Empty
        ContainsHotTopic = False
        Status = String.Empty
    End Sub

    Sub New(surveyID As Integer)
        ID = surveyID
    End Sub
End Class

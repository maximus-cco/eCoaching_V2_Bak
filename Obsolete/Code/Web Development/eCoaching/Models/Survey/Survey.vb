<Serializable()> Public Class Survey
    Public Property ID As Integer
    Public Property LogName As String
	Public Property EmployeeID As String
	Public Property Questions As ICollection(Of Question)
    Public Property Comment As String
	Public Property HasHotTopic As Boolean
	Public Property HasPilot As Boolean
	Public Property Status As String

	Sub New()
        ID = -1
        LogName = String.Empty
		EmployeeID = String.Empty
		Questions = New List(Of Question)
        Comment = String.Empty
		HasHotTopic = False
		Status = String.Empty
		HasPilot = False
	End Sub

    Sub New(surveyID As Integer)
        ID = surveyID
    End Sub
End Class

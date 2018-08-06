<Serializable()> Public Class Answer
    Public Property ID As Integer
    Public Property SingleChoice As Integer
    Public Property MultiLineText As String
    Public Property QuestionID As Integer

    Sub New()
        ID = -1
        SingleChoice = -1
        MultiLineText = String.Empty
        QuestionID = -1
    End Sub
End Class

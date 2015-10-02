<Serializable()> Public Class Question
    Public Property ID As Integer
    Public Property DisplayOrder As Integer
    Public Property QuestionLabel As String

    Public Property SingleChoices As ICollection(Of SingleChoice)

    Public Property TextBoxLabel As String
    Public Property Answer As Answer
    Public Property SurveyID As Integer
End Class

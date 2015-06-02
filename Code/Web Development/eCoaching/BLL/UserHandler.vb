Public Class UserHandler
    Private userDBAccess As UserDBAccess

    Public Sub New()
        userDBAccess = New UserDBAccess()
    End Sub

    ' Returns User Object if authentication is successful
    ' Otherwise returns Nothing
    Function AuthenticateUser(ByVal lanID As String) As User
        Dim user As User = GetUser(lanID)
        If Not IsInvalidUser(user) Then
            Return user
        End If

        Return Nothing
    End Function

    Function GetUser(ByVal lanID As String) As User
        Return userDBAccess.GetUser(lanID)
    End Function

    Function IsInvalidUser(ByVal user As User) As Boolean
        Return (user Is Nothing OrElse String.IsNullOrEmpty(user.Name) OrElse LCase(user.Name).Contains("unkonwn"))
    End Function
End Class

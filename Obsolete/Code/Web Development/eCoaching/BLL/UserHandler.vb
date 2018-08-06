Public Class UserHandler
    Private userDBAccess As UserDBAccess

    Public Sub New()
        userDBAccess = New UserDBAccess()
    End Sub

    ' Returns User Object if authentication is successful
    ' Otherwise returns Nothing
    Function AuthenticateUser(lanID As String) As User
        Dim user As User = GetUser(lanID)
        If Not IsInvalidUser(user) Then
            Return user
        End If

        Return Nothing
    End Function

    Function GetUser(lanID As String) As User
        Return userDBAccess.GetUser(lanID)
    End Function

    Function IsInvalidUser(user As User) As Boolean
        Return user Is Nothing OrElse String.IsNullOrEmpty(user.Name)
    End Function
End Class

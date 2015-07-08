' base class for all pages
Public MustInherit Class BasePage
    Inherits System.Web.UI.Page

    Protected Sub Page_PreInit(sender As Object, e As System.EventArgs) Handles Me.PreInit
        ' page post back (initial display) and authentication fails
        ' send user to unauthorized page
        If Not IsPostBack AndAlso Not AuthenticateUser() Then
            Response.Redirect("error.aspx")
        End If

        ' session times out, reload user to session
        If Session("eclUser") Is Nothing Then
            Dim userHandler = New UserHandler()
            Dim eclUser As User = userHandler.GetUser(GetLanId())
            Session("eclUser") = eclUser
        End If

    End Sub

    Private Function AuthenticateUser() As Boolean
        Dim authenticated As Boolean = (Not ((Session("eclUser") Is Nothing)))
        If Not authenticated Then
            Dim userHandler = New UserHandler()
            Dim eclUser As User = userHandler.AuthenticateUser(GetLanId())
            If Not (eclUser Is Nothing) Then
                Session("eclUser") = eclUser
                authenticated = True
            End If
        End If

        Return authenticated
    End Function

    Function GetLanId() As String
        Dim lanId As String = LCase(User.Identity.Name)
        lanId = Replace(lanId, "vngt\", "")
        lanId = Replace(lanId, "ad\", "")

        Return lanId
    End Function
End Class
' base class for all pages
Public MustInherit Class BasePage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If AuthenticateUser() Then
                Initialize()
            Else
                ' authentication failed, send user to unauthorized page
                Response.Redirect("error.aspx")
            End If
        Else
            HandlePageDisplay()
        End If
    End Sub

    Public MustOverride Sub Initialize()
    Public MustOverride Sub HandlePageDisplay()

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
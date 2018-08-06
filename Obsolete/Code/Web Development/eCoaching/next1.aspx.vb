Public Class next1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        Dim pre As String
        pre = LCase(Request.QueryString("FromURL"))
        'pre = "/review.aspx"

        '        MsgBox(pre)
        If (InStr(pre, "default2.aspx") > 0) Then

            Response.Redirect("default2.aspx")

        Else

            Button1.Attributes.Add("onclick", "window.close();")
        End If
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        Response.Write("<script language='javascript'> { window.close();}</script>")

    End Sub
End Class
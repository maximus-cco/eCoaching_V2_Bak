Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Configuration

' base class for all pages
Public Class BasePage
    Inherits System.Web.UI.Page

    Const unknow As String = "unknown"
    Protected lan As String = Nothing
    Protected connectionString As String = WebConfigurationManager.ConnectionStrings("CoachingConnectionString").ConnectionString

    Protected Overrides Sub OnInit(ByVal e As EventArgs)
        MyBase.OnInit(e)

        lan = GetLanId()
        ' check user access here
        If Session("userInfo") Is Nothing Then
            Dim userInfo As String = GetUserInfo()
            If IsValidUser(userInfo) Then
                Session("userInfo") = userInfo
            Else
                ' user doesn't have access, send user to unauthorized page
                Response.Redirect("error.aspx")
            End If
        End If
    End Sub

    ' call stored procedure sp_whoami to get user "jobcode$email$name"
    ' database access will need to move DAL layer later on
    Function GetUserInfo() As String
        Dim userInfo As String = Nothing
        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand("EC.sp_Whoami", connection)
                connection.Open()
                command.CommandType = CommandType.StoredProcedure
                command.Parameters.AddWithValue("@strUserin", lan)
                Using dataReader As SqlDataReader = command.ExecuteReader()
                    If dataReader.Read() Then
                        userInfo = dataReader("Submitter").ToString()
                    End If
                End Using
            End Using
        End Using

        Return userInfo
    End Function

    Function IsValidUser(ByVal userInfo As String) As Boolean
        Return IIf(LCase(userInfo).Contains(unknow), False, True)
    End Function

    Function GetLanId() As String
        Dim lanId As String = LCase(User.Identity.Name)
        lanId = Replace(lanId, "vngt\", "")
        lanId = Replace(lanId, "ad\", "")
        Return lanId
    End Function

    Function GetJobCode(ByVal userInfo As String) As String
        Return IIf(String.IsNullOrEmpty(userInfo), String.Empty, Split(userInfo, "$", -1, 1)(0))
    End Function

    Function GetEmail(ByVal userInfo As String) As String
        Return IIf(String.IsNullOrEmpty(userInfo), String.Empty, Split(userInfo, "$", -1, 1)(1))
    End Function

    Function GetName(ByVal userInfo As String) As String
        Return IIf(String.IsNullOrEmpty(userInfo), String.Empty, Split(userInfo, "$", -1, 1)(2))
    End Function

End Class
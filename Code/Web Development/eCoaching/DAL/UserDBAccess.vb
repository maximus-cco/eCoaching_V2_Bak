Imports System.Data.SqlClient

Public Class UserDBAccess
    Public Function GetUser(ByVal lanID As String) As User
        Dim user As User = Nothing
        Dim parameters() As SqlParameter = New SqlParameter() _
        {
            New SqlParameter("@strUserin", lanID)
        }

        Using dataTable As DataTable = DBUtility.ExecuteSelectCommand("EC.sp_Whoami", CommandType.StoredProcedure, parameters)
            If dataTable.Rows.Count = 1 Then
                Dim row As DataRow = dataTable.Rows(0)
                Dim userInfor As String = row("Submitter")

                user = New User()
                user.LanID = lanID
                user.Name = IIf(String.IsNullOrEmpty(userInfor), String.Empty, Split(userInfor, "$", -1, 1)(2))
                user.JobCode = IIf(String.IsNullOrEmpty(userInfor), String.Empty, Split(userInfor, "$", -1, 1)(0))
                user.Email = IIf(String.IsNullOrEmpty(userInfor), String.Empty, Split(userInfor, "$", -1, 1)(1))
            End If
        End Using

        Return user
    End Function
End Class

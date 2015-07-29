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
                user = New User()
                user.JobCode = row("EmpJobCode")
                user.Email = row("EmpEmail")
                user.Name = row("EmpName")
                user.EmployeeID = row("EmpID")
                user.LanID = lanID
            End If
        End Using

        Return user
    End Function
End Class

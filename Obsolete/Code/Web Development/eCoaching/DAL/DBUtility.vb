Imports System.Web.Configuration
Imports System.Data.SqlClient

Public Class DBUtility

    Public Shared ReadOnly connectionString As String = WebConfigurationManager.ConnectionStrings("CoachingConnectionString").ConnectionString

    Public Shared Function ExecuteSelectCommand(commandName As String, commandType As String, commandParameters As SqlParameter()) As DataTable
        Dim dataTable As DataTable = New DataTable()

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(commandName, connection)
                command.CommandType = commandType
                command.CommandTimeout = 300
                If commandParameters IsNot Nothing Then
                    command.Parameters.AddRange(commandParameters)
                End If
                Using dataAdapter As SqlDataAdapter = New SqlDataAdapter(command)
                    dataAdapter.Fill(dataTable)
                End Using
            End Using
        End Using

        Return dataTable
    End Function

    Public Shared Function ExecuteScalar(commandName As String, commandType As String, commandParameters As SqlParameter()) As Object
        Dim retVal As Object = Nothing

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Using command As New SqlCommand(commandName, connection)
                command.CommandType = commandType
                command.CommandTimeout = 300
                If commandParameters IsNot Nothing Then
                    command.Parameters.AddRange(commandParameters)
                End If

                retVal = command.ExecuteScalar()
            End Using
        End Using

        Return retVal
    End Function

End Class

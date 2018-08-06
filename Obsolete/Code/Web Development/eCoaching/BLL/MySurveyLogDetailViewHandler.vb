Public Class MySurveyLogDetailViewHandler
    Private mySurveyLogDetailDBAccess As MySurveyLogDetailDBAccess

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        mySurveyLogDetailDBAccess = New MySurveyLogDetailDBAccess()
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="logID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Function GetLogReasons(logID As String) As DataTable
        Return mySurveyLogDetailDBAccess.GetLogReasons(logID)
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="logID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Function GetLogDetail(logID As String) As MySurveyLogDetail
        Return mySurveyLogDetailDBAccess.GetLogDetail(logID)
    End Function
End Class

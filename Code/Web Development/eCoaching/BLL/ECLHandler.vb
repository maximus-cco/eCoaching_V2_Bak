Public Class ECLHandler

    Public Function IsHistoricalDashboardPageAccessAllowed(eclUser As User)
        If eclUser Is Nothing OrElse String.IsNullOrWhiteSpace(eclUser.JobCode) Then
            Return False
        End If

        Dim retValue = False
        Dim jobCode As String = eclUser.JobCode.Trim.ToUpper

        Select Case True
            Case jobCode.EndsWith("40"),
                 jobCode.EndsWith("50"),
                 jobCode.EndsWith("60"),
                 jobCode.EndsWith("70"),
                 jobCode.StartsWith("WISO"),
                 jobCode.StartsWith("WSTE"),
                 jobCode.StartsWith("WSQE"),
                 jobCode.StartsWith("WACQ"),
                 jobCode.StartsWith("WPPM"),
                 jobCode.StartsWith("WPSM"),
                 jobCode.StartsWith("WEEX"),
                 jobCode.StartsWith("WISY"),
                 jobCode.StartsWith("WPWL51"),
                 jobCode.StartsWith("WHER"),
                 jobCode.StartsWith("WHHR"),
                 jobCode.StartsWith("WHRC")

                retValue = True
        End Select

        Return retValue
    End Function

End Class

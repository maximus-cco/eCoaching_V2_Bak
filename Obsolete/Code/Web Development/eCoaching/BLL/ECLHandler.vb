Public Class ECLHandler
    Private userDBAccess As UserDBAccess

    Public Sub New()
        userDBAccess = New UserDBAccess()
    End Sub

    Public Function IsNewSubmissionsAccessAllowed(eclUser As User, arc As Int32)
        If eclUser Is Nothing OrElse String.IsNullOrWhiteSpace(eclUser.JobCode) Then
            Return False
        End If

        Dim jobCode As String = UCase(eclUser.JobCode.Trim())
        ' All users other than non-ARC CSRs and HRs have access.
        If ((IsCSRUser(eclUser) AndAlso arc = 0) OrElse IsHRUser(eclUser)) Then
            Return False
        End If

        Return True
    End Function

    Public Function IsMyDashboardAccessAllowed(eclUser As User)
        ' All users other than HRs have access.
        Return Not IsHRUser(eclUser)
    End Function

    Public Function IsMySubmissionAccessAllowed(eclUser As User, arc As Int32)
        ' All users other than non-ARC CSRs and HRs have access.
        If (IsHRUser(eclUser) OrElse (IsCSRUser(eclUser) AndAlso arc = 0)) Then
            Return False
        End If

        Return True
    End Function

    Public Function IsHistoricalDashboardPageAccessAllowed(eclUser As User)
        If eclUser Is Nothing OrElse String.IsNullOrWhiteSpace(eclUser.JobCode) Then
            Return False
        End If

        Dim retValue = False
        Dim jobCode As String = UCase(eclUser.JobCode.Trim())

        ' All users with jobcode matching the following criteria have access
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
                 jobCode.StartsWith("WPOP")

                retValue = True
        End Select

        ' HR Users also have access
        Return retValue OrElse IsHRUser(eclUser)
    End Function

    Public Function IsCSRUser(eclUser As User)
        If eclUser Is Nothing OrElse String.IsNullOrWhiteSpace(eclUser.JobCode) Then
            Return False
        End If

        Dim jobCode As String = UCase(eclUser.JobCode.Trim())
        If jobCode.StartsWith("WACS0") Then
            Return True
        End If

        Return False
    End Function

    Public Function IsHRUser(eclUser As User) As Boolean
        Return userDBAccess.IsValidHRUser(eclUser)
    End Function

    ' Move to DAL when the options are from database

    Public Function GetDttFeedbackOptions()
        Dim options As List(Of String) = New List(Of String)()
        options.Add("ATT Updated - with Approved Absence")
        options.Add("ATT Updated - with Unapproved Absence")
        options.Add("ATT Not Updated - SWP notified that Empower is inaccurate")
        options.Add("ATT Not Updated and Empower will not be updated")
        options.Add("ATT Not Updated - CSR Termed")
        options.Add("CSR on a Leave of Absence")
        options.Add("Absence is pending HR approval (LOA or WPA)")
        Return options
    End Function

End Class

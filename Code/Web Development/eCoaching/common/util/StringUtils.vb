Imports System.Web

Public Module StringUtils

    Public Function GetSafeString(obj As Object) As String
        Return If(obj Is Nothing OrElse IsDBNull(obj), String.Empty, obj.ToString().Trim())
    End Function

    Public Function Truncate(str As String, maxLength As Integer) As String
        str = GetSafeString(str)
        Return If(str.Length > maxLength, str.Substring(0, maxLength), str)
    End Function

    Public Function IsTrue(strToCheck As String)
        Return String.Equals(strToCheck, "True", StringComparison.OrdinalIgnoreCase)
    End Function

    Public Function Sanitize(str As String) As String
        If String.IsNullOrWhiteSpace(str) Then
            Return String.Empty
        End If

        str = HttpContext.Current.Server.HtmlEncode(str)
        str = Replace(str, "’", "&rsquo;")
        str = Replace(str, "‘", "&lsquo;")
        str = Replace(str, "'", "&prime;")
        str = Replace(str, Chr(147), "&ldquo;")
        str = Replace(str, Chr(148), "&rdquo;")
        str = Replace(str, "-", "&ndash;")
        Return str
    End Function
End Module

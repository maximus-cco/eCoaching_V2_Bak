Public Module StringUtils

    Public Function GetSafeString(obj As Object) As String
        Return If(obj Is Nothing OrElse IsDBNull(obj), String.Empty, obj.ToString().Trim)
    End Function

    Public Function Truncate(str As String, maxLength As Integer) As String
        str = GetSafeString(str)
        Return If(str.Length > maxLength, str.Substring(0, maxLength), str)
    End Function

    Public Function IsTrue(strToCheck As String)
        Return String.Equals(strToCheck, "True", StringComparison.OrdinalIgnoreCase)
    End Function
End Module

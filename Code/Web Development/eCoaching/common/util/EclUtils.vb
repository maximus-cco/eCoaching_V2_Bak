Imports System.Net.Mail

Public Class EclUtils

	Public Shared ReadOnly SMTP_HOST = "10.80.102.86" ' smtpout.gdit.com

	Public Shared Function SendEmail(toList As List(Of String), strSubject As String,
                                     strEmailContent As String, logoAbsolutePath As String) As Boolean
        Dim retValue = False

        Dim myMessage As System.Net.Mail.MailMessage = New System.Net.Mail.MailMessage()
        Dim mbody As String

        ' To:
        For Each emailAddress In toList
            myMessage.To.Add(emailAddress)
        Next

        ' From:
        myMessage.From = New System.Net.Mail.MailAddress("VIP@gdit.com", "eCoaching Log")

        ' Subject:
        myMessage.Subject = strSubject

        ' Body:
        mbody = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">" & vbCrLf _
        & "<html>" & vbCrLf _
        & "<head>" & vbCrLf _
        & " <title>eCoaching Log Automated Messaging</title>" & vbCrLf _
        & " <meta http-equiv=Content-Type content=""text/html; charset=iso-8859-1"">" & vbCrLf _
        & "</head>" & vbCrLf _
        & "<body style=""font-family: Tahoma,sans-serif; font-size: 10.0pt;"">" & vbCrLf _
        & " <p>** This is an automated email. Do not reply to this email. **</p>" & vbCrLf _
        & " <p>" & vbCrLf _
        & " <br />" & vbCrLf _
        & strEmailContent & vbCrLf _
        & " <br /> <br />" & vbCrLf _
        & " (Please do not respond to this automated notification)" & vbCrLf _
        & " <br /> <br />" & vbCrLf _
        & " Thank you," & vbCrLf _
        & " <br /> eCoaching Log Team <br />" & vbCrLf

        Dim htmlView As System.Net.Mail.AlternateView = System.Net.Mail.AlternateView.CreateAlternateViewFromString(mbody & "<img src=cid:HDIImage></body></html>", Nothing, "text/html")
        Dim imageResource As New System.Net.Mail.LinkedResource(logoAbsolutePath, "image/png")

        imageResource.TransferEncoding = Net.Mime.TransferEncoding.Base64
        imageResource.ContentId = "HDIImage"
        htmlView.LinkedResources.Add(imageResource)
        myMessage.AlternateViews.Add(htmlView)

        ' Send
        Try
            Dim mySmtpClient = New SmtpClient(SMTP_HOST)
            mySmtpClient.Send(myMessage)
            retValue = True
        Catch ex As Exception
            ' TODO: log this exception somewhere
        End Try

        Return retValue
    End Function
End Class

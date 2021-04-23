' Prod

' Begin - Environment Related
Const dbConnStr = "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoaching;Data Source=UVAAPADSQL50CCO"
Const eCoachingUrl = "https://uvaapadweb50cco.ad.local/ecl/"
Const fromAddress = "eCoachingProd@maximus.com"
Const imgPath = "\\UVAAPADSQL50CCO.ad.local\ssis\coaching\Notifications\images\BCC-eCL-LOGO-10142011-185x40.png"
Const strLogFile = "\\UVAAPADSQL50CCO.ad.local\ssis\coaching\Notifications\Logs\Reminders_Prod.log"
' End - Environment Related

' Begin - Non-Environment Related
Const imgName = "BCC-eCL-LOGO-10142011-185x40.png"
Const smtpServer = "ironport.maximus.com" 
Const ForAppending = 8
Const cdoReferenceTypeName = 1
Const cdoSendUsingPort = 2
Const adStateOpen = 1
' End - Non-Environment Related

'Specify log file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile(strLogFile, ForAppending, True)
objLogFile.WriteBlankLines(2) 
objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "Starting Reminders!"
'variables for database connection and recordset
Dim dbConn, rs

'variables for values returned from query
Dim  numID
Dim strFormName 
Dim strToEmail 
Dim strCCEmail 
Dim strSubject 
Dim strCtrMessage
Dim strsubCoachingSource
Dim numLogType


Dim arrResultSet
Dim totalPendingEmail

dim spGetEmailToSend : spGetEmailToSend = "EC.sp_SelectCoaching4Reminder"

On Error Resume Next


' Connect to database
Set dbConn = CreateObject("ADODB.Connection")
dbConn.Open dbConnStr
dbConn.commandTimeout = 120

    If Err.Number <> 0 Then ' If it failed, report the error
       objLogfile.Write "  " + cstr(date) + " " + cstr(time) + " - " + "Failed to connect to database:  " & Err.Number & Err.Description
       Err.Clear
   End If

' Get pending email to send
Set rs = dbConn.execute(spGetEmailToSend) 

If Err.Number <> 0 Then ' If it failed, report the error
   objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "Failed to execute stored procedure:  " & Err.Number & Err.Description
       Err.Clear
   SafeQuit rs, dbConn
End If

arrResultSet = rs.GetRows()
If Err.Number <> 0 Then
    Err.Clear
    SafeQuit rs, dbConn
End If

totalPendingEmail = UBound(arrResultSet, 2)

SafeCloseRecordSet rs
SafeCloseDbConn dbConn



' Send pending email

For j = 0 to totalPendingEmail

	numID = arrResultSet(0,j)
	strFormName = arrResultSet(1,j)
	strToEmail = arrResultSet(5,j) 
        strCCEmail = arrResultSet(6,j) 
	strsubCoachingSource = arrResultSet(3,j) 'Empower for DTT Feeds
        numLogType = arrResultSet(12,j)

	'configure the subject line
	strSubject = "Alert! eCoaching Log Past Due Follow-up:  "  '& " (" & strFormName & ")"

	'send mail
		SendMail strToEmail, strCCEmail, strSubject, strFormName


Next





Sub SendMail(strToEmail, strCCEmail, strSubject, strFormName)
'msgbox(strFormName)

'variables for sending mail
Dim htmlbody
Dim ToAddress
Dim ToSubject
Dim mailArray
Dim mailTo
Dim mailBody

dim spUpdateReminderMailSent


On Error Resume Next


  Select Case (strsubCoachingSource)
        Case "Warning"
        strSubject = "Alert! Warning Log Past Due Follow-up:  "  &  strFormName 
        Case Else
        strSubject = "Alert! eCoaching Log Past Due Follow-up:  "  &  strFormName 
  End Select


  mailbody =  strFormName & " requires your attention. Please review and discuss with the employee."

  Select Case (strsubCoachingSource)
        Case "Empower"
            mailBody = strFormName & " requires your attention. Please review the log and take appropriate action."
  Case "WAH-RTS"
            mailBody = strFormName & " requires your attention. Please review the log and take appropriate action."
        Case "Warning"
            mailBody = strFormName & " requires your attention. Please review and acknowledge the log."
  End Select

  strCtrMessage = (mailBody)


           

  strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
  & "  <a href=""" & eCoachingUrl & """ target=""_blank"">Please click here to open the eCoaching application and view the form details from the &#39;My Pending&#39; section on My Dashboard page.</a>"

               
  strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
  &  strFormName 

'msgbox(strCtrMessage)


'add Prod to subject line
ToSubject = strSubject
ToAddress = strToEmail
CCAddress = strCCEmail

'configure HTML message

    htmlbody = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">" & vbCrLf _
& "<html>" & vbCrLf _
& "<head>" & vbCrLf _
& "<title>eCoaching Log Automated Messaging</title>" & vbCrLf _
& "<meta http-equiv=Content-Type content=""text/html; charset=iso-8859-1"">" & vbCrLf _
& "</head>" & vbCrLf _
& "<body style=""font-family: Tahoma,sans-serif; font-size: 10.0pt;"">" & vbCrLf _
& "<p>** This is an automated email. Do not reply to this email. **</p>" & vbCrLf _
& "<p>" & vbCrLf _
& strCtrMessage & vbCrLf _
& "<br /> <br />" & vbCrLf _
& "(Please do not respond to this automated notification)" & vbCrLf _
& "<br /> <br />" & vbCrLf _
& "Thank you," & vbCrLf _
& "<br /> eCoaching Log Team <br />" & vbCrLf _
& "<img border=""0"" src=""cid:" & imgName & """ />" & vbCrLf _
& "</body>" & vbCrLf _
& "</html>"& vbCrLf 



	'variables for configuring mail message
    Dim objMsg 
    Dim objConfiguration 
    Dim objFields 
    Dim objBodyPart 

    Set objMsg = CreateObject("CDO.Message")
    Set objConfiguration = CreateObject("CDO.Configuration")
    Set objBodyPart = objMsg.AddRelatedBodyPart(imgPath, imgName, CdoReferenceTypeName)

	objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgName & ">"""
    objBodyPart.Fields.Update

    Set objFields = objConfiguration.Fields
    With objFields
            .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = cdoSendUsingPort
            .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer
            .Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10 
            .Update
    End With


' Apply the settings to the message.
 With objMsg
        Set .Configuration = objConfiguration

   'set mail importance
     ' For Outlook 2003:
          .Fields.Item( "urn:schemas:mailheader:X-MSMail-Priority" ) =  "High"     
      ' For Outlook 2003 also:
          .Fields.Item( "urn:schemas:mailheader:X-Priority" ) =  2 
      ' For Outlook Express:
          .Fields.Item( "urn:schemas:httpmail:importance" ) =  2 
          .Fields.Update

    .MimeFormatted = True

'change to line to ToAddress to go to the correct destination and uncomment the .CC line
    .To =  ToAddress '"susmitha.palacherla@gdit.com" 
    .Cc = CCAddress 
    .From = fromAddress
    .Subject = ToSubject
    .HTMLBody = htmlbody
On Error Resume Next ' Turn in-Line Error Handling On before sending email
  .Send
End With

  If Err.Number <> 0 Then ' If it failed, report the error
     objLogfile.Write "  " + cstr(date) + " " + cstr(time) + " - " + "Sending reminder for log " + cstr(numID) + " to " + ToAddress + " Failed. Error Code: " & Err.Number & Err.Description
 
  End If
   ' Clean up variables.
    Set objMsg = Nothing
    Set objConfiguration = Nothing
    Set objFields = Nothing
    Set objBodyPart = Nothing


  If Err.Number = 0 Then ' Email was successfully sent
	 Set dbConn = CreateObject("ADODB.Connection")
        dbConn.Open dbConnStr



'Update record to indicate mail has been sent - replace fromID field with new mail column
' use numbers because the actual string values aren't recognized without adovbs.inc - http://www.af-chicago.org/app/adovbs.inc



spUpdateReminderMailSent = "EXEC EC.sp_UpdateReminderMailSent @intNumID ='" & numID & "',@intLogType ='" & numLogType & "'"

'spUpdateReminderMailSent = "EXEC EC.sp_UpdateReminderMailSent @nvcNumID ='" & numID & "'"

dbConn.execute(spUpdateReminderMailSent), , 129
 SafeCloseDbConn dbConn
	Else
	    Err.Clear
	End If

End Sub


Sub SafeCloseRecordSet (rs)
    If Not (rs Is Nothing) Then
	    If rs.State = adStateOpen Then 
			rs.close
	    End If
		Set rs = Nothing
	End If
End Sub

Sub SafeCloseDbConn ( dbConn)
    If Not (dbConn Is Nothing) Then
	    If dbConn.State = adStateOpen Then 
		    dbConn.Close
		End If
		Set dbConn = Nothing
	End If
End Sub

Sub SafeQuit (rs, dbConn)
    SafeCloseRecordSet rs
	SafeCloseDbConn dbConn
	objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "End Reminders!"
        objLogfile.close
   Wscript.Quit
End Sub

objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "End Reminders!"
objLogfile.close
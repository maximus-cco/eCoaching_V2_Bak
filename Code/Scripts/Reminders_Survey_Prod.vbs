' Prod

' Begin - Environment Related
Const dbConnStr = "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingProd;Data Source=UVAAPADSQL50CCO"
Const eCoachingUrl = "https://uvaapadweb50cco.ad.local/ecl_Prod/Survey"
Const fromAddress = "eCoachingProd@maximus.com"
Const imgPath = "\\UVAAPADSQL50CCO.ad.local\ssis\coaching\Notifications\images\BCC-eCL-LOGO-10142011-185x40.png"
Const strLogFile = "\\UVAAPADSQL50CCO.ad.local\ssis\coaching\Notifications\Logs\Reminders_Survey_Prod.log"
' End - Environment Related

' Begin - Non-Environment Related
Const imgName = "BCC-eCL-LOGO-10142011-185x40.png"
Const ForAppending = 8
Const smtpServer = "ironport.maximus.com" 
Const cdoReferenceTypeName = 1
Const cdoSendUsingPort = 2
Const adStateOpen = 1
' End - Non-Environment Related

'Specify log file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile(strLogFile, ForAppending, True)
objLogFile.WriteBlankLines(2) 
objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "Starting Survey Reminders!"

'variables for database connection and recordset
Dim dbConn, rs


'variables for values returned from query
Dim strPerson 
Dim strFormName 
Dim strSubject 
Dim strCtrMessage
Dim strEmail 
Dim SurveyID 
Dim strExpiryDate

Dim arrResultSet
Dim totalPendingEmail


dim spGetEmailToSend : spGetEmailToSend = "EC.sp_SelectSurvey4Reminder"

On Error Resume Next

'connect to database and run stored procedure
Set dbConn = CreateObject("ADODB.Connection")
dbConn.Open dbConnStr


' Get pending email to send
Set rs = dbConn.execute(spGetEmailToSend) 


If Err.Number <> 0 Then
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

'To go through the entire list and send pending Email

For j = 0 to totalPendingEmail

	SurveyID = arrResultSet(0,j)
	strPerson = arrResultSet(4,j)
	strFormName = arrResultSet(1,j)
	strEmail = arrResultSet(3,j) 
	strExpiryDate= arrResultSet(6,j)


	'send mail
	SendMail strEmail, strSubject, strFormName, strPerson, SurveyID, strExpiryDate

Next


Sub SendMail(strEmail, strSubject, strFormName, strPerson, SurveyID,strExpiryDate)
'msgbox(strFormName)

'variables for sending mail
Dim htmlbody
Dim ToAddress
Dim ToSubject
Dim mailArray
Dim mailTo
Dim mailBody


On Error Resume Next


 strSubject = "eCoaching Log Survey Follow-up"  '& " (" & strPerson & ")"
 mailbody = "Please take time to complete this survey regarding a coaching session for "  & strFormName & ". This survey will expire on "  & strExpiryDate & "."
 strCtrMessage = (mailBody)
            


 strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
 & "  <a href=""" & eCoachingUrl & "?id=" & SurveyID & """>Please click here to open the survey form and respond to the questions.</a>"


'add Prod to subject line
ToSubject = strSubject
ToAddress = strEmail


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



set objMsg= CreateObject("CDO.Message")
set objConfiguration = CreateObject("CDO.Configuration")
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgPath, imgName, CdoReferenceTypeName)


objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgName & ">"""
objBodyPart.Fields.Update

Set objFields= objConfiguration.Fields

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
    .From = fromAddress
    .Subject = ToSubject
    .HTMLBody = htmlbody
On Error Resume Next ' Turn in-Line Error Handling On before sending email
  .Send
End With

  If Err.Number <> 0 Then ' If it failed, report the error
     objLogfile.Write "  " + cstr(date) + " " + cstr(time) + " - " + "Sending reminder for survey " + cstr(SurveyID) + " to " + ToAddress + " Failed. Error Code: " & Err.Number & Err.Description
 
  End If

  ' Clean up variables.
    Set objMsg = Nothing
    Set objConfiguration = Nothing
    Set objFields = Nothing
    Set objBodyPart = Nothing


End Sub


Sub SafeCloseRecordSet (rs)
    If Not (rs Is Nothing) Then
	    If rs.State = adStateOpen Then 
			rs.close
	    End If
		Set rs = Nothing
	End If
End Sub

Sub SafeCloseDbConn (dbConn)
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
	
	Wscript.Quit
End Sub
objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "End Survey Reminders!"
objLogfile.close
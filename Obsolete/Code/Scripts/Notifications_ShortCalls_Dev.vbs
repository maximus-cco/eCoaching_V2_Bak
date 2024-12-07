' Dev

' Begin - Environment Related
Const dbConnStr = "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingDev;Data Source=F3420-ECLDBD01"
Const fromAddress = "eCoachingDev@maximus.com"
Const imgPath = "\\f3420-ecldbd01\ssis\coaching\Notifications\images\BCC-eCL-LOGO-10142011-185x40.png"
' End - Environment Related

' Begin - Non-Environment Related
Const imgName = "BCC-eCL-LOGO-10142011-185x40.png"
Const smtpServer = "ironport.maximus.com" 
Const cdoReferenceTypeName = 1
Const cdoSendUsingPort = 2
Const adStateOpen = 1
' End - Non-Environment Related


'variables for database connection and recordset
Dim dbConn, rs


'variables for values returned from query
Dim numID
Dim strFormName 
Dim strStatus
Dim strEmail 
Dim strCSR
Dim strSubject 
Dim strCtrMessage



Dim arrResultSet
Dim totalPendingEmail


dim spGetEmailToSend : spGetEmailToSend = "EC.sp_SelectCoaching4ContactOMRShortCalls"

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

	numID = arrResultSet(0,j)
	strPerson = arrResultSet(4,j)
	strFormName = arrResultSet(1,j)
	strEmail = arrResultSet(3,j) 
	strStatus = arrResultSet(2,j) 


	'send mail
	SendMail strEmail, strSubject, strFormName, strPerson

Next


Sub SendMail(strEmail, strSubject, strFormName, strPerson)
'msgbox(strFormName)

'variables for sending mail
Dim htmlbody
Dim ToAddress
Dim ToSubject
Dim mailArray
Dim mailTo
Dim mailBody


On Error Resume Next


 strSubject = "eCL: Short Call Notification for " & strPerson 
 mailbody = "This is a notification that you are on the Short Call Report this week. The Short Call Report identifies CSRs with 10 or more short calls (60 seconds or less) in a week. Your supervisor will review the calls and determine if a coaching session is required. If you have any questions, please contact your supervisor."
 strCtrMessage = (mailBody)
            

'add test to subject line
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
  .Send
End With


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

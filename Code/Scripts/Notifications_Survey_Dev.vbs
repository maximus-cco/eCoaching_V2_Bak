'variables for database connection and recordset
Dim myConnection, myCommand, adoRec


'variables for values returned from query
Dim strPerson 
Dim strFormName 
Dim strSubject 
Dim strCtrMessage
Dim strEmail 
Dim SurveyID 
Dim mailArray 
Dim mailSent 
Dim rCount 
Dim sConn 

Dim mainArray
Dim jMax

rCount = 0
mailSent = True
dim sql1, sql2

'connect to database and run stored procedure
Set myConnection = CreateObject("ADODB.Connection")

myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingDev;Data Source=VRIVFSSDBT02\SCORD01,1437"
sql1 = "EC.sp_SelectSurvey4Contact"
Set adoRec = myConnection.execute(sql1) 

mainArray = adoRec.GetRows()
jMax = UBound(mainArray, 2)


adoRec.Close
set adoRec = Nothing

myConnection.Close
set myConnection = Nothing

'change the 5 to jMax to go through the entire list

For j = 0 to jMax

	SurveyID = mainArray(0,j)
	strPerson = mainArray(4,j)
	strFormName = mainArray(1,j)
	strEmail = mainArray(3,j) 
	strExpiryDate= mainArray(6,j)


	'configure the subject line
	strSubject = "eCoaching Log Survey "  '& " (" & strPerson & ")"

	'send mail
		SendMail strEmail, strSubject, strFormName, strPerson, SurveyID, strExpiryDate

	
	rCount = rCount + 1

next





Sub SendMail(strEmail, strSubject, strFormName, strPerson, SurveyID,strExpiryDate)
'msgbox(strFormName)

'variables for sending mail
Dim htmlbody
Dim ToAddress
Dim ToSubject
Dim mailArray
Dim mailTo
Dim mailBody
Dim i


'strEmail= "jourdain.augustin@gdit.com,jourdain.augustin@gdit.com,jourdain.augustin@gdit.com"
'setup an array of possible e-mail addresses




                strSubject = "eCoaching Log Survey "  '& " (" & strPerson & ")"
                mailbody = "Please take time to complete this survey regarding a coaching session for "  & strFormName & ". This survey will expire on "  & strExpiryDate & "."
                strCtrMessage = (mailBody)
                'strCtrMessage = Replace(strCtrMessage, "strDateTime", Now)
           

                'strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
'& " <a href=""http://localhost:50547/coach3/MySurvey.aspx?id=" & SurveyID & """>Please click here to open the survey form and respond to the questions.</a>"

                strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
    & "  <a href=""https://f3420-mpmd01.vangent.local/coach3/MySurvey.aspx?id=" & SurveyID & """>Please click here to open the survey form and respond to the questions.</a>"
'msgbox(strCtrMessage)




'assign network SMTP server
Const SMTPServer1 = "smtpout.gdit.com" 

'assign message from address
Const FromAddress = "VIPDev@GDIT.com"

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
& "<img border=""0"" src=""cid:BCC-eCL-LOGO-10142011-185x40.png"" />" & vbCrLf _
& "</body>" & vbCrLf _
& "</html>"& vbCrLf 



'variables for configuring mail message
Dim iMsg 
Dim iConf 
Dim Flds 

Dim objBP 
Const cdoReferenceTypeName = 1


Const cdoSendUsingPort = 2

set iMsg = CreateObject("CDO.Message")

set iConf = CreateObject("CDO.Configuration")
'C:\bit9prog\dev\Notifications\images\BCC-eCL-LOGO-10142011-185x40.png
'C:\bit9prog\dev\images
'C:\bit9prog\dev\Notifications\images\
'N:\scorecard-ssis\coaching\notifications\images\BCC-eCL-LOGO-10142011-185x40.png

Set objBP = iMsg.AddRelatedBodyPart("\\vrivfssdbt02\integrationservices\Coaching\Notifications\images\BCC-eCL-LOGO-10142011-185x40.png", "BCC-eCL-LOGO-10142011-185x40.png", CdoReferenceTypeName)


objBP.Fields.Item("urn:schemas:mailheader:Content-ID") = "<BCC-eCL-LOGO-10142011-185x40.png>"
objBP.Fields.Update

Set Flds = iConf.Fields

With Flds
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = cdoSendUsingPort
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTPServer1
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 10 
    .Update
End With


' Apply the settings to the message.
With iMsg
    Set .Configuration = iConf
    .MimeFormatted = True
'change to line to ToAddress to go to the correct destination and uncomment the .CC line
    .To =  ToAddress '"susmitha.palacherla@gdit.com" 
    .From = "VIPDev@GDIT.com"
    .Subject = ToSubject
    .HTMLBody = htmlbody
  .Send
End With
' Clean up variables.
Set iMsg = Nothing
Set iConf = Nothing
Set Flds = Nothing

Set myConnection = CreateObject("ADODB.Connection")
myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingDev;Data Source=VRIVFSSDBT02\SCORD01,1437"




'Update record to indicate mail has been sent - replace fromID field with new mail column
' use numbers because the actual string values aren't recognized without adovbs.inc - http://www.af-chicago.org/app/adovbs.inc



sql2 = "EXEC EC.sp_UpdateSurveyMailSent @nvcSurveyID ='" & SurveyID & "'"


myConnection.execute(sql2), , 129

myConnection.Close 
set myConnection = Nothing



End Sub

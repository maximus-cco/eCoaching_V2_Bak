'variables for database connection and recordset
Dim myConnection, myCommand, adoRec


'variables for values returned from query
Dim  numID
Dim strFormName 
Dim strToEmail 
Dim strCCEmail 
Dim strSubject 
Dim strCtrMessage
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


myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingTest;Data Source=VRIVFSSDBT02\SCORT01,1438"
sql1 = "EC.sp_SelectCoaching4Reminder"
Set adoRec = myConnection.execute(sql1) 

mainArray = adoRec.GetRows()
jMax = UBound(mainArray, 2)


adoRec.Close
set adoRec = Nothing

myConnection.Close
set myConnection = Nothing

'change the 5 to jMax to go through the entire list

For j = 0 to jMax

	numID = mainArray(0,j)
	strFormName = mainArray(1,j)
	strToEmail = mainArray(5,j) 
                  strCCEmail = mainArray(6,j) 
	


	'configure the subject line
	strSubject = "Alert! eCoaching Log Past Due Follow-up:  "  '& " (" & strFormName & ")"

	'send mail
		SendMail strToEmail, strCCEmail, strSubject, strFormName

	
	rCount = rCount + 1

next





Sub SendMail(strToEmail, strCCEmail, strSubject, strFormName)
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




               ' strSubject = "Alert! eCoaching Log Past Due Follow-up:  "  & " (" & strFormName & ")"
                strSubject = "Alert! eCoaching Log Past Due Follow-up:  "  &  strFormName 
                mailbody =  strFormName & " requires your attention.  Please review and discuss with the employee."
                strCtrMessage = (mailBody)
                'strCtrMessage = Replace(strCtrMessage, "strDateTime", Now)
           

                strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
    & "  <a href=""https://f3420-mpmd01.vangent.local/coach3/default.aspx"" target=""_blank"">Please click here to open the coaching application and select the &#39;My Dashboard&#39; tab to view the below form ID for details.</a>"

               
                strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
  &  strFormName 

'msgbox(strCtrMessage)



'assign network SMTP server
Const SMTPServer1 = "smtpout.gdit.com" 

'assign message from address
Const FromAddress = "VIPTest@GDIT.com"

'add test to subject line
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
    .From = "VIPTest@GDIT.com"
    .Subject = ToSubject
    .HTMLBody = htmlbody
  .Send
End With
' Clean up variables.
Set iMsg = Nothing
Set iConf = Nothing
Set Flds = Nothing

Set myConnection = CreateObject("ADODB.Connection")
myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingTest;Data Source=VRIVFSSDBT02\SCORT01,1438"




'Update record to indicate mail has been sent - replace fromID field with new mail column
' use numbers because the actual string values aren't recognized without adovbs.inc - http://www.af-chicago.org/app/adovbs.inc



sql2 = "EXEC EC.sp_UpdateReminderMailSent @nvcNumID ='" & numID & "'"


myConnection.execute(sql2), , 129

myConnection.Close 
set myConnection = Nothing



End Sub

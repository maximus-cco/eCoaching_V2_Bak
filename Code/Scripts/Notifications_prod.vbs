'variables for database connection and recordset
Dim myConnection, myCommand, adoRec


'variables for values returned from query
Dim strPerson
Dim strFormID
Dim strSubject
Dim strCtrMessage
Dim strEmail
Dim strCoachReason
Dim strSource
Dim strFormStatus
Dim numID
Dim mailArray
Dim mailSent
Dim rCount
Dim sConn
Dim strModule
Dim strSourceID
Dim isCSE
Dim isOMRARC

Dim mainArray
Dim jMax

rCount = 0
mailSent = True
dim sql1, sql2

'connect to database and run stored procedure
Set myConnection = CreateObject("ADODB.Connection")

myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ecoaching;Data Source=VDENSSDBP07\SCORP01,1436"
sql1 = "EC.sp_SelectCoaching4Contact"
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
	strPerson = mainArray(7,j)
	strFormID = mainArray(1,j)
	strEmail = mainArray(3,j) &","& mainArray(4,j) & "," & mainArray(5,j)
	strSource = mainArray(6,j)
	strFormStatus = mainArray(2,j)
	strModule = mainArray(14,j)
	strSourceID = mainArray(12,j)
	isCSE = mainArray(13,j)
	isOMRARC = mainArray(15,j) 'Will be 1 for IAT and IAE OMR Feeds


	'configure the subject line
	strSubject = "eCL: " & strFormStatus & " (" & strPerson & ")"

	'send mail
	mailArray = Split(strEmail, ",")

	if ((len(mailArray(0))> 8) AND (len(mailArray(1))> 8) AND (len(mailArray(2))> 8)) then

		SendMail strEmail, strSubject, strFormID, strFormStatus, strPerson, strSource, numID, strModule, strSourceID, isCSE

	end if

	rCount = rCount + 1

next





Sub SendMail(strEmail, strSubject, strFormID, strFormStatus, strPerson, strSource, numID, module, strSourceID, isCSE)
'msgbox(strFormID)

'variables for sending mail
Dim htmlbody
Dim ToCopy
Dim ToAddress
Dim ToSubject
Dim mailArray
Dim mailTo
Dim mailCopy
Dim mailCc
Dim mailBody
Dim i


'strEmail= "jourdain.augustin@gdit.com,jourdain.augustin@gdit.com,jourdain.augustin@gdit.com"
'setup an array of possible e-mail addresses

mailArray = Split(strEmail, ",")






dim objRS, objCmd, arrMail

Set myConnection = CreateObject("ADODB.Connection")

myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ecoaching;Data Source=VDENSSDBP07\SCORP01,1436"


'objRS.CursorLocation = adUseClient
'objRS.CursorType = adOpenStatic

set objRS = CreateObject("ADODB.Recordset")

set objCmd = CreateObject("ADODB.Command")
set objCmd.ActiveConnection = myConnection

objCmd.CommandText = "EC.sp_Select_Email_Attributes"
objCmd.CommandType = 4 'adCmdStoredProc

'msgbox(strSourceID)
'msgbox(isCSE)
objCmd.Parameters("@strModulein") = module
objCmd.Parameters("@intSourceIDin") = strSourceID
objCmd.Parameters("@bitisCSEin") = isCSE

Set objRS = objCmd.Execute
'msgbox("testing1")
	if (objRS.State = 1) then 'adStateOpen
'msgbox("testing2")
		if (NOT objRS.EOF) then
'msgbox("testing3")
			arrMail = objRS.GetRows()
			objRS.Close
			Set objRS = Nothing

			myConnection.Close
			set myConnection = Nothing
			'msgbox(strFormID)
			'msgbox(UBound(arrMail, 2))
For i = 0 to UBound(arrMail, 2)


	if (strFormStatus = arrMail(1, i)) then

		mailTo = arrMail(2, i)
		mailCopy = arrMail(4, i)
		mailCc = arrMail(5, i)
		mailBody = arrMail(3, i)	

	end if

Next
			

                strPerson = Replace(strPerson, "'", "")

'Begin check for OMRARC
              Select Case (isOMRARC)
	Case 1
	mailBody = "This eCoaching Log has been created in reference to an inappropriate escalation or transfer to the ARC.  Please review and coach your CSR accordingly."
	
        End Select

'End check for OMRARC


                Select Case (mailTo)

                    Case "Employee"

                        ToAddress = mailArray(0)


                    Case "Supervisor"

                        ToAddress = mailArray(1)

                    Case "Manager"

                        ToAddress = mailArray(2)

                    Case Else

                        ToAddress = mailArray(0)

                End Select




'Begin check for Copy/CC

                 Select Case (mailCopy) 'If (mailCopy = "1") Then
  
                 Case "True"


                    Select Case (mailCc)

                        Case "Employee"

                            ToCopy = mailArray(0)


                        Case "Supervisor"

                            ToCopy = mailArray(1)

                        Case "Manager"

                            ToCopy = mailArray(2)

			Case Else
	
                            ToCopy = ""

                    End Select

              End Select 'End If

'End check for Copy/CC


                strSubject = "eCL: " & strFormStatus & " (" & strPerson & ")"


                strCtrMessage = (mailBody)
                strCtrMessage = Replace(strCtrMessage, "strDateTime", Now)
                strCtrMessage = Replace(strCtrMessage, "strPerson", strPerson)

                strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
    & "  <a href=""https://F3420-MWBP11.vangent.local/coach/default.aspx"" target=""_blank"">Please click here to open the coaching application and select the &#39;My Dashboard&#39; tab to view the below form ID for details.</a>"
'msgbox(strCtrMessage)













'assign network SMTP server
Const SMTPServer1 = "smtpout.gdit.com" '"denexcp01.vangent.local" 

'assign message from address
Const FromAddress = "VIP@GDIT.com"

'add test to subject line
ToSubject = strSubject


'check form status to determine message content and addressee(s)






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
& "<br />" & vbCrLf _
& "Form ID: " & strFormID & vbCrLf _
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

Set objBP = iMsg.AddRelatedBodyPart("N:\scorecard-ssis\coaching\notifications\images\BCC-eCL-LOGO-10142011-185x40.png", "BCC-eCL-LOGO-10142011-185x40.png", CdoReferenceTypeName)


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
    .To = ToAddress
    .Cc = ToCopy
    .From = "VIP@vangent.com"
    .Subject = ToSubject
    .HTMLBody = htmlbody
  .Send
End With
' Clean up variables.
Set iMsg = Nothing
Set iConf = Nothing
Set Flds = Nothing




Set myConnection = CreateObject("ADODB.Connection")
myConnection.Open "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ecoaching;Data Source=VDENSSDBP07\SCORP01,1436"




'Update record to indicate mail has been sent - replace fromID field with new mail column
' use numbers because the actual string values aren't recognized without adovbs.inc - http://www.af-chicago.org/app/adovbs.inc

'sql2 = "Update EC.Coaching_Log Set EmailSent = '" & mailSent &"' where (strFormID = '"& strFormID &"')"
'sql2 = "EXEC EC.sp_UpdateFeedMailSent @nvcFormID ='" & strFormID & "'"
sql2 = "EXEC EC.sp_UpdateFeedMailSent @nvcNumID ='" & numID & "'"


myConnection.execute(sql2), , 129

myConnection.Close 
set myConnection = Nothing



	end if


else
		'objRS.Close
		set objRS = Nothing

		myConnection.Close
		set myConnection = Nothing

end if



End Sub

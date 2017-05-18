' Begin - Environment Related
' Prod
Const dbConnStr = "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ecoaching;Data Source=VDENSSDBP07\SCORP01,1436"
Const eCoachingUrl = "https://F3420-MWBP11.vangent.local/coach/default.aspx"
Const fromAddress = "VIP@GDIT.com"
Const imgPath = "N:\scorecard-ssis\coaching\notifications\images\BCC-eCL-LOGO-10142011-185x40.png"
Const imgName = "BCC-eCL-LOGO-10142011-185x40.png"
' End - Environment Related


' Non-Environment Related
Const smtpServer = "smtpout.gdit.com" 
Const cdoReferenceTypeName = 1
Const cdoSendUsingPort = 2
Const adStateOpen = 1
Const adCmdStoredProc = 4


'variables for database connection and recordset
Dim dbConn, rs

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
Dim arrEmail
Dim strModule
Dim strSourceID
Dim isCSE
Dim isOMRARC

Dim arrResultSet
Dim totalPendingEmail

dim spGetEmailToSend : spGetEmailToSend = "EC.sp_SelectCoaching4Contact"

On Error Resume Next

' Connect to database
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

' Send pending email
For i = 0 to totalPendingEmail
    numID = arrResultSet(0, i)
    strFormID = arrResultSet(1, i)
    strFormStatus = arrResultSet(2, i)
    strEmail = arrResultSet(3, i) & "," & arrResultSet(4, i) & "," & arrResultSet(5, i)
    strSource = arrResultSet(6, i)
    strPerson = arrResultSet(7, i)
    strSourceID = arrResultSet(12, i)
    isCSE = arrResultSet(13, i)
    strModule = arrResultSet(14, i)	
    isOMRARC = arrResultSet(15, i) ' 1 for IAT and IAE OMR Feeds

    strSubject = "eCL: " & strFormStatus & " (" & strPerson & ")"
    arrEmail = Split(strEmail, ",")
    If ((len(arrEmail(0))> 8) AND (len(arrEmail(1))> 8) AND (len(arrEmail(2))> 8)) then
        SendMail strEmail, strSubject, strFormID, strFormStatus, strPerson, strSource, numID, strModule, strSourceID, isCSE
    End If
Next


Sub SendMail(strEmail, strSubject, strFormID, strFormStatus, strPerson, strSource, numID, module, strSourceID, isCSE)
    ' msgBox("Try to send email for logID = " & numID)

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
    dim objRS, objCmd, arrMail
	
	dim spUpdateEmailSent
	
	On Error Resume Next
	
    ' Setup an array of possible e-mail addresses
    mailArray = Split(strEmail, ",")

    Set dbConn = CreateObject("ADODB.Connection")
    dbConn.Open dbConnStr

    Set objRS = CreateObject("ADODB.Recordset")
    Set objCmd = CreateObject("ADODB.Command")
    Set objCmd.ActiveConnection = dbConn

    objCmd.CommandText = "EC.sp_Select_Email_Attributes"
    objCmd.CommandType = adCmdStoredProc

    objCmd.Parameters("@strModulein") = module
    objCmd.Parameters("@intSourceIDin") = strSourceID
    objCmd.Parameters("@bitisCSEin") = isCSE

    Set objRS = objCmd.Execute
    arrMail = objRS.GetRows()
	If (Err.Number <> 0) Then
	    Err.Clear
	    SafeCloseRecordSet objRS
		SafeCloseDbConn dbConn
		
		' Return
		Exit Sub
	End If	
	
	SafeCloseRecordSet objRS
	SafeCloseDbConn dbConn
	
    For i = 0 to UBound(arrMail, 2)
        If (strFormStatus = arrMail(1, i)) then
            mailTo = arrMail(2, i)
            mailCopy = arrMail(4, i)
            mailCc = arrMail(5, i)
            mailBody = arrMail(3, i)	
        End If
    Next ' End For

    strPerson = Replace(strPerson, "'", "")

    Select Case (isOMRARC)
        Case 1
            mailBody = "This eCoaching Log has been created in reference to an inappropriate escalation or transfer to the ARC.  Please review and coach your CSR accordingly."
    End Select

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
            End Select ' End Select Case (mailCc)
    End Select ' End Select Case (mailCopy)

    strSubject = "PHASE II - eCL: " & strFormStatus & " (" & strPerson & ") - PHASE II"
    ToSubject = strSubject

    strCtrMessage = (mailBody)
    strCtrMessage = Replace(strCtrMessage, "strDateTime", Now)
    strCtrMessage = Replace(strCtrMessage, "strPerson", strPerson)
    strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
 		& "  <a href=""" & eCoachingUrl & """ target=""_blank"">Please click here to open the coaching application and select the &#39;My Dashboard&#39; tab to view the below form ID for details.</a>"

    ' Check form status to determine message content and addressee(s)
    ' Configure HTML message
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
            .MimeFormatted = True
            ' change to line to ToAddress to go to the correct destination and uncomment the .CC line
           .To =  ToAddress '"susmitha.palacherla@gdit.com" 
           .Cc = ToCopy
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

    If Err.Number = 0 Then ' Email was successfully sent
	    Set dbConn = CreateObject("ADODB.Connection")
        dbConn.Open dbConnStr

        ' Update record to indicate mail has been sent - replace fromID field with new mail column
        ' Use numbers because the actual string values aren't recognized without adovbs.inc - http://www.af-chicago.org/app/adovbs.inc
        spUpdateEmailSent = "EXEC EC.sp_UpdateFeedMailSent @nvcNumID ='" & numID & "'"

        dbConn.execute(spUpdateEmailSent), , 129
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
	
	Wscript.Quit
End Sub

' Dev

' Begin - Environment Related

Const dbConnStr = "Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=eCoachingDev;Data Source=UVAADADSQL50CCO"
Const eCoachingUrl = "https://uvaadadweb50cco.ad.local/ecl_dev/"
Const fromAddress = "eCoachingDev@maximus.com"
Const imgPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\BCC-eCL-LOGO-10142011-185x40.png"

Const imgaaPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\aa.png"
Const imgalPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\al.png"
Const imgccPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\cc.png"
Const imgnnPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\nn.png"
Const imgppPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\pp.png"
Const imgprPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\pr.png"
Const imgsoPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\so.png"
Const imgwcPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\wc.png"
Const imgqcPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\qc.png"
'Const imgqc2Path = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\qc2.png"
'Const imgqc3Path = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\qc3.png"
'Const imgqc4Path = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\qc4.png"

Const imgaa_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\aa_qm.png"
Const imgcc_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\cc_qm.png"
Const imgmm_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\mm_qm.png"
Const imgpp_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\pp_qm.png"
Const imgpr_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\pr_qm.png"
Const imgrr_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\rr_qm.png"
Const imgso_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\so_qm.png"
Const imgwc_qmPath = "\\UVAADADSQL50CCO.ad.local\ssis\coaching\Notifications\images\wc_qm.png"


Const strLogFile = "\\UVAADADSQL50CCO\ssis\Coaching\Notifications\Logs\Notifications_Bingo_Dev.log"

' End - Environment Related

' Begin - Non-Environment Related

Const smtpServer = "smtpint.maxcorp.maximus" 
Const ForAppending = 8
Const cdoReferenceTypeName = 1
Const cdoSendUsingPort = 2
Const adStateOpen = 1

Const imgName = "BCC-eCL-LOGO-10142011-185x40.png"

Const imgaaName = "aa.png"
Const imgalName = "al.png"
Const imgccName = "cc.png"
Const imgnnName = "nn.png"
Const imgppName = "pp.png"
Const imgprName = "pr.png"
Const imgsoName = "so.png"
Const imgwcName = "wc.png"
Const imgqcName = "qc.png"
'Const imgqc2Name = "qc2.png"
'Const imgqc3Name = "qc3.png"
'Const imgqc4Name = "qc4.png"


Const imgaa_qmName = "aa_qm.png"
Const imgcc_qmName = "cc_qm.png"
Const imgmm_qmName = "mm_qm.png"
Const imgpp_qmName = "pp_qm.png"
Const imgpr_qmName = "pr_qm.png"
Const imgrr_qmName = "rr_qm.png"
Const imgso_qmName = "so_qm.png"
Const imgwc_qmName = "wc_qm.png"

' End - Non-Environment Related

'Specify log file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile(strLogFile, ForAppending, True)
objLogFile.WriteBlankLines(2) 
objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "Starting Bingo Notifications!"


'variables for database connection and recordset
Dim dbConn, rs


'variables for values returned from query
Dim numID
Dim strFormID
Dim strFormStatus
Dim strEmpEmail 
Dim strEmpName
Dim strCCEmail
Dim strBingoType 
Dim strSubject 
Dim strCtrMessage
Dim strAchievements

Dim arrResultSet
Dim totalPendingEmail


dim spGetEmailToSend : spGetEmailToSend = "EC.sp_SelectCoaching4Bingo"

On Error Resume Next


'connect to database and run stored procedure
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

'To go through the entire list and send pending Email

For j = 0 to totalPendingEmail

	numID = arrResultSet(0,j)
        strFormID = arrResultSet(1,j)
	strFormStatus = arrResultSet(2,j)
	strEmpEmail = arrResultSet(3,j) 
	strEmpName = arrResultSet(4,j) 
        strCCEmail = arrResultSet(5,j) 
	strBingoType  = arrResultSet(6,j) 
	strAchievements = arrResultSet(7,j) 
	strSubject = "eCL: " & strFormStatus & " (" & strEmpName & ")"


	'send mail
      	SendMail  numID,strFormID, strFormStatus, strEmpEmail, strEmpName, strCCEmail, strSubject
Next


Sub SendMail(numID,strFormID, strFormStatus, strEmpEmail, strEmpName,strCCEmail, strSubject)
'msgbox(strFormName)

'variables for sending mail

Dim toAddress
Dim toSubject
Dim ccAddress
Dim htmlbody
Dim mailbody
Dim spUpdateEmailSent

On Error Resume Next

    Select Case (strBingoType)
        Case "QN"
            strCtrMessage = "Congratulations on earning the following Quality Now Bingo achievements for the month! For each achievement, you will receive a raffle entry in the upcoming prize drawing, as well as a sticker for your QN Bingo card. Keep up the great work!"
        Case "QM"
            strCtrMessage = "Congratulations on earning the following Quality Call Monitoring Bingo achievements for the month!  For each achievement, you will receive a raffle entry in the upcoming prize drawing as well as a sticker for your QCM Bingo card.  Keep up the great work!"
    End Select

            

'strCtrMessage = "<strong>Congratulations on earning the following Quality Now Bingo achievements for the month! For each achievement, you will receive a raffle entry in the upcoming prize drawing, as well as a sticker for your QN Bingo card. Keep up the great work!</strong>"

strCtrMessage = strCtrMessage & "  <br /><br />" & vbCrLf _
& "  <a href=""" & eCoachingUrl & """ target=""_blank"">Please click here to open the eCoaching application and view the form details from the &#39;My Pending&#39; section on My Dashboard page.</a>"

toSubject = strSubject
toAddress = strEmpEmail
ccAddress = strCCEmail



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
& strAchievements  & vbCrLf _
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

Set objBodyPart  = objMsg.AddRelatedBodyPart(imgaaPath, imgaaName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgalPath, imgalName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgccPath, imgccName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgnnPath, imgnnName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgppPath, imgppName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgprPath, imgprName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgsoPath, imgsoName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgwcPath, imgwcName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgqcPath, imgqcName, CdoReferenceTypeName)
'Set objBodyPart  = objMsg.AddRelatedBodyPart(imgqc2Path, imgqc2Name, CdoReferenceTypeName)
'Set objBodyPart  = objMsg.AddRelatedBodyPart(imgqc3Path, imgqc3Name, CdoReferenceTypeName)
'Set objBodyPart  = objMsg.AddRelatedBodyPart(imgqc4Path, imgqc4Name, CdoReferenceTypeName)

Set objBodyPart  = objMsg.AddRelatedBodyPart(imgaa_qmPath, imgaa_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgcc_qmPath, imgcc_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgmm_qmPath, imgmm_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgpp_qmPath, imgpp_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgpr_qmPath, imgpr_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgrr_qmPath, imgrr_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgso_qmPath, imgso_qmName, CdoReferenceTypeName)
Set objBodyPart  = objMsg.AddRelatedBodyPart(imgwc_qmPath, imgwc_qmName, CdoReferenceTypeName)

objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgName & ">"""

objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgaaName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgalName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgccName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgnnName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgppName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgprName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgsoName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgwcName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgqcName & ">"""
'objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgqc2Name & ">"""
'objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgqc3Name & ">"""
'objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgqc4Name & ">"""

objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgaa_qmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgcc_qmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgmmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgpp_qmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgpr_qmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgrr_qmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgso_qmName & ">"""
objBodyPart.Fields.Item("urn:schemas:mailheader:Content-ID") = """<" & imgwc_qmName & ">"""

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
        .MimeFormatted = True


    .To =  toAddress 
    .Cc =  ccAddress
    .From = fromAddress
    .Subject = toSubject
    .HTMLBody = htmlbody

On Error Resume Next ' Turn in-Line Error Handling On
  .Send

End With

'Using objFile.Write instead of objFile.WriteLine. This will write to the file without a newline at the end.

   If Err.Number <> 0 Then ' If it failed, report the error
     objLogfile.Write "  " + cstr(date) + " " + cstr(time) + " - " + "Sending notification for log " + cstr(numID) + " to " + ToAddress + " Failed. Error Code: " & Err.Number & Err.Description
   End If

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
	objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "End Bingo Notifications!"
	objLogfile.close
    Wscript.Quit
End Sub

objLogfile.WriteLine "  " + cstr(date) + " " + cstr(time) + " - " + "End Bingo Notifications!"
objLogfile.close



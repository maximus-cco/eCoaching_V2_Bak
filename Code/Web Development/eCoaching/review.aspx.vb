Public Class review
    Inherits BasePage

    Public Const COMMENTS_MAX_LENGTH = 3000

    Public Const REVIEW_OMR_SHORT_CALL_TEXT = "You are receiving this eCL because you have been assigned to listen to and provide feedback on calls that have been identified as having a short duration. Details of each call can be found within the Performance Report Catalog by clicking " &
        "<a href='https://cco.gdit.com/bi/ReportsCatalog/TQC_ShortCall/Forms/AllItems.aspx' target='_blank'>here</a>. " &
        "Please review the calls and provide specific details on opportunities that requiring coaching."

    Public Const REVIEW_TRAINING_SHORT_DURATION_REPORT_TEXT =
        "CSRs are scheduled for specific times in Empower to ensure understanding of training materials presented. " &
        "It is important to utilize the timeframe allotted to successfully understand the training content. " &
        "Please be aware that the scheduled timeframe is a metric which has been agreed upon by CCO and CMS. " &
        "You should use all or the majority of the scheduled time to review each eLearning module assigned."

    Public Const REVIEW_TRAINING_OVERDUE_TRAINING_TEXT = "The above training is now overdue. Please have the training completed and provide coaching on the specific reasons it was overdue."

    Public Const REVIEW_QUALITY_HIGH5_CLUB = "Customer satisfaction is critical to our success; therefore, " &
        "to help gauge our performance, every caller is offered the option to complete a Customer Satisfaction (CSAT) survey. " &
        "Using a scale from one to five, callers are able to rate their overall satisfaction. Top box, or a rating of ""5"", indicates the caller was extremely satisfied!  " &
        "Thank you for taking good care of your callers; you make a difference for each caller AND for the CCO!"

    Public Const REVIEW_QUALITY_KUDO_CSR = "Congratulations - you received a Kudos! Click " &
        "<a href='https://cco.gdit.com/Connection/Pages/KudosCentral.aspx' target='_blank'>here</a> " &
        "to take a listen to what a recent caller had to say about your customer service."

    Public Const REVIEW_QUALITY_KUDO_SUPERVISOR = "Click <a href='https://cco.gdit.com/Connection/Pages/KudosCentral.aspx' target='_blank'>here</a> " &
        "to listen to CSR kudos."

    Public Const REVIEW_OMR_BREAK_TEXT = "You are receiving this eCL record because an Employee on your team was identified in a Break Outlier Report. " &
        "Please review the <b><a href='https://cco.gdit.com/bi/ReportsCatalog/AvayaBreakPolicyReporting/Forms/AllItems.aspx' target='_blank'>ETS Breaks Outlier Report</a>, " &
        "the ETS entries</b>, and refer to HCSD-POL-HR-MISC-08 Break Time Policy and Break Policy Reference guide for additional information and provide the details in the record below."

    ' Performance Scorecard MSR and MSRS static text
    Public Const REVIEW_SCORECARD_MSR = "To review your full details, please visit the " &
        "<a href='https://f3420-mwbp11.vangent.local/scorecard/csrscorecard.aspx' target='_blank'>CCO Performance Scorecard</a>. " &
        "If you have any questions, please see your supervisor."
    Public Const REVIEW_SCORECARD_MSRS = "To review your full details, please visit the " &
        "<a href='https://f3420-mwbp11.vangent.local/scorecard/csrscorecard.aspx' target='_blank'>CCO Performance Scorecard</a>. " &
        "If you have any questions, please " &
        "<a href='https://cco.gdit.com/Reports/Performance_Scorecard/Lists/Scorecard_Escalated_Issues_Log/NewIssue.aspx' target='_blank'>submit an escalation</a> via the " &
        "<a href='https://cco.gdit.com/Reports/Performance_Scorecard/default.aspx' target='_blank'>CCO Performance Scorecard Information Station</a> " &
        "SharePoint site."

    ' ETS/HNC ETS/ICC
    ' Currently this is only for CSRs. Data feeds loaded as Pending Supervisor Review.
    ' Display this link only for Supervisors
    Public Const REVIEW_HNC_ICC = "Click " &
        "<a href='https://cco.gdit.com/Initiatives/floorcheck/Timecard_Compliance_Reporting/Timcard%20Changes%20Reports/Forms/AllItems.aspx' target='_blank'>here</a>" &
        " to view the report containing the details of these changes."


    Public Const PENDING_MGR_REVIEW = "Pending Manager Review"

    Public Const OMR_IAE_SUBREASON = "OMR: Inappropriate ARC Escalation"

    Dim pHolder As Label
    Dim panelHolder As Panel
    Dim pHolder2 As Label
    Dim panelHolder2 As Panel
    Dim recStatus As Label
    Dim userTitle As String

    Dim panelHolder1 As Panel
    Dim statusLevel As String

    Dim lblisCTC As Label
    Dim isCTC As Boolean

    ' New Attendance Discrepancy feed
    ' Logs come from Empower
    Dim lblisDTT As Label
    Dim isDTT As Boolean

    Dim lblisHigh5Club As Label
    Dim isHigh5Club As Boolean

    Dim lblisKudo As Label
    Dim isKudo As Boolean

    ' Performance Scorecard with report code MSR
    Dim lblIsScorecardMsr As Label
    Dim isScorecardMsr As Boolean

    ' Performance Scorecard with report code MSRS
    Dim lblIsScorecardMsrs As Label
    Dim isScorecardMsrs As Boolean

    Dim lblIsAttendance As Label
    Dim isAttendance As Boolean

    ' ETS/HNC and ICC.
    Dim lblIsHNC As Label
    Dim isHNC As Boolean
    Dim lblIsICC As Label
    Dim isICC As Boolean

    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim FromURL As String

    'The user employee ID.
    ' Employee_Hierarchy.EmpID
    Private m_strUserEmployeeID As String

    ' The user job code.
    ' Employee_Hierarchy.Emp_Job_Code
    Private m_strUserJobCode As String

    ' The employee ID in the log record.
    ' coaching_log/Warning_log.EmpID
    Private m_strEmployeeID As String

    ' The employee's supervisor employee ID in the Employee_Hierarchy table.
    ' Employee_Hierarchy.SupID
    Private m_strHierarchySupEmployeeID As String

    ' The employee's manager employee ID in the Employee_Hierarchy table.
    ' Employee_Hierarchy.MgrID
    Private m_strHierarchyMgrEmployeeID As String

    ' The employee's manager employee ID in the Coaching_Log table.
    Private m_strCLMgrEmployeeID As String

    ' Indicate if it is LCS record
    Private m_lowCustomerSatisfaction As String

    ' The submitter employee ID in the log record.
    ' coaching_log.SubmitterID
    Private m_strSubmitterEmployeeID As String

    ' The employee ID of the person to whom this log was reassigned.
    Private m_strReassignedToEmployeeID As String

    ' Indicates if the user is an ARC CSR. 
    ' Historical_Dashboard_ACL.Role as "ARC"
    Private m_blnUserIsARCCsr As Boolean

    Private eclHandler = New ECLHandler()

    Private Function IsAccessAllowed() As Boolean
        ' The user submitted the log.
        If (m_strUserEmployeeID = m_strSubmitterEmployeeID) Then
            ' Only non ARC CSR has access.
            Return Not m_blnUserIsARCCsr
        End If

        ' The user didn't submit the log.
        ' The user is one of these:
        ' the employee of the log
        ' the employee's current supervisor 
        ' the employee's current manager
        ' If it is LCS, then either the employee's current manager or the Employee's manager when the eCL was submitted 
        Return m_strUserEmployeeID = m_strEmployeeID OrElse
               m_strUserEmployeeID = m_strHierarchySupEmployeeID OrElse
               m_strUserEmployeeID = m_strHierarchyMgrEmployeeID OrElse
               (m_lowCustomerSatisfaction = 1 AndAlso m_strUserEmployeeID = m_strCLMgrEmployeeID) OrElse
               m_strUserEmployeeID = m_strReassignedToEmployeeID

    End Function

    Private Sub SetIsCTC()
        lblisCTC = ListView1.Items(0).FindControl("isCTC")
        If (lblisCTC.Text = "0") Then
            isCTC = False
        Else
            isCTC = True
        End If
    End Sub

    Private Sub SetIsDTT()
        lblisDTT = ListView1.Items(0).FindControl("isDTT")
        If (lblisDTT.Text = "0") Then
            isDTT = False
        Else
            isDTT = True
        End If
    End Sub

    Private Sub SetIsHigh5Club()
        lblisHigh5Club = ListView1.Items(0).FindControl("isHigh5Club")
        If (lblisHigh5Club.Text = "0") Then
            isHigh5Club = False
        Else
            isHigh5Club = True
        End If
    End Sub

    Private Sub SetIsKudo()
        lblisKudo = ListView1.Items(0).FindControl("isKudo")
        If (lblisKudo.Text = "0") Then
            isKudo = False
        Else
            isKudo = True
        End If
    End Sub

    Private Sub SetIsScorecardMsr()
        lblIsScorecardMsr = ListView1.Items(0).FindControl("isScorecardMsr")
        If (lblIsScorecardMsr.Text = "0") Then
            isScorecardMsr = False
        Else
            isScorecardMsr = True
        End If
    End Sub

    Private Sub SetIsScorecardMsrs()
        lblIsScorecardMsrs = ListView1.Items(0).FindControl("isScorecardMsrs")
        If (lblIsScorecardMsrs.Text = "0") Then
            isScorecardMsrs = False
        Else
            isScorecardMsrs = True
        End If
    End Sub

    Private Sub SetIsHNC()
        lblIsHNC = ListView1.Items(0).FindControl("isHNC")
        If (lblIsHNC.Text = "0") Then
            isHNC = False
        Else
            isHNC = True
        End If
    End Sub

    Private Sub SetIsICC()
        lblIsICC = ListView1.Items(0).FindControl("isICC")
        If (lblIsICC.Text = "0") Then
            isICC = False
        Else
            isICC = True
        End If
    End Sub

    Private Sub SetIsAttendance()
        lblIsAttendance = ListView1.Items(0).FindControl("isAttendance")
        If (lblIsAttendance.Text = "0") Then
            isAttendance = False
        Else
            isAttendance = True
        End If
    End Sub

    Protected Sub Page_Load2(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView1.DataBound 'record modifyable
        ' Load Non Coachable Reason Dropdown
        Dim exceededTimeOfBreak As Label = ListView1.Items(0).FindControl("exceededTimeOfBreak") ' OMR / BRL
        Dim exceededNumberOfBreaks As Label = ListView1.Items(0).FindControl("exceededNumberOfBreaks") ' OMR / BRK
        Dim reasons As List(Of String) = New List(Of String)()
        If (exceededTimeOfBreak.Text = "1" Or exceededNumberOfBreaks.Text = "1") Then
            reasons.Add("Approved accommodation on file")
        End If

        ' TFS 6881 - Add noncoachable reasons for OMR: Inappropriate ARC Escalation
        Dim isOmrInappropriateArcEsclation As Boolean = False
        For i As Integer = (GridView2.Rows.Count - 1) To 0 Step -1
            Dim row As GridViewRow = GridView2.Rows(i)
            Dim hfSubReason As HiddenField = row.FindControl("hfSubReason")
            Dim strSubReason As String = hfSubReason.Value
            If (String.Compare(strSubReason, OMR_IAE_SUBREASON, True) = 0) Then
                isOmrInappropriateArcEsclation = True
                Exit For
            End If
        Next

        If isOmrInappropriateArcEsclation Then
            reasons.Add("Agent no longer employed or on LOA")
            reasons.Add("Escalation was appropriate")
            reasons.Add("ISG or Supervisor told agent to escalate")
            reasons.Add("Not enough information to coach")
        End If

        reasons.Add("Other")
        ddlNonCoachableReason.DataSource = reasons
        ddlNonCoachableReason.DataBind()

        ' Get the user employee ID from session.
        m_strUserEmployeeID = Session("eclUser").EmployeeID

        m_strEmployeeID = LCase(DirectCast(ListView1.Items(0).FindControl("EmployeeID"), Label).Text)
        m_strHierarchySupEmployeeID = LCase(DirectCast(ListView1.Items(0).FindControl("HierarchySupEmployeeID"), Label).Text)
        m_strHierarchyMgrEmployeeID = LCase(DirectCast(ListView1.Items(0).FindControl("HierarchyMgrEmployeeID"), Label).Text)
        m_strSubmitterEmployeeID = LCase(DirectCast(ListView1.Items(0).FindControl("SubmitterEmployeeID"), Label).Text)

        m_strCLMgrEmployeeID = LCase(DirectCast(ListView1.Items(0).FindControl("CLMgrEmployeeID"), Label).Text)
        m_lowCustomerSatisfaction = LCase(DirectCast(ListView1.Items(0).FindControl("Label36"), Label).Text)

        m_strReassignedToEmployeeID = LCase(DirectCast(ListView1.Items(0).FindControl("ReassignedToEmployeeID"), Label).Text)

        m_blnUserIsARCCsr = Label241.Text <> "0"

        If (Not IsAccessAllowed()) Then
            ' Send the user to the authorized page.
            Response.Redirect("error3.aspx")
        End If

        SetIsCTC()
        SetIsHigh5Club()
        SetIsKudo()
        SetIsAttendance()

        SetIsScorecardMsr()
        SetIsScorecardMsrs()

        SetIsHNC()
        SetIsICC()

        SetIsDTT()

        If (isHigh5Club OrElse isKudo OrElse isScorecardMsr OrElse isScorecardMsrs) Then
            pnlStaticText.Visible = True

            If (isHigh5Club) Then
                lblStaticText.Text = REVIEW_QUALITY_HIGH5_CLUB
            ElseIf (isKudo) Then
                lblStaticText.Text = REVIEW_QUALITY_KUDO_CSR
                If (m_strUserEmployeeID = m_strHierarchySupEmployeeID) Then ' User is the CSR's supervisor
                    lblStaticText.Text = REVIEW_QUALITY_KUDO_SUPERVISOR
                End If
            ElseIf (isScorecardMsr) Then
                lblStaticText.Text = REVIEW_SCORECARD_MSR
            ElseIf (isScorecardMsrs) Then
                lblStaticText.Text = REVIEW_SCORECARD_MSRS
            End If
        End If

        If (isHNC OrElse isICC) Then
            Dim lblModule As Label = ListView1.Items(0).FindControl("Label31")
            Dim lblStatus As Label = ListView1.Items(0).FindControl("Label50")

            statusLevel = GetRecordStatusLevel(lblModule.Text, lblStatus.Text)
            If (statusLevel = 2) Then
                pnlStaticText.Visible = True
                lblStaticText.Text = REVIEW_HNC_ICC
            End If
        End If

        pHolder = ListView1.Items(0).FindControl("Label50")
        Label3.Text = pHolder.Text
        pHolder = ListView1.Items(0).FindControl("Label51")
        'Label10.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
        Label10.Text = pHolder.Text & "&nbsp;PDT"



        pHolder = ListView1.Items(0).FindControl("Label53") ' and here
        Label15.Text = pHolder.Text
        pHolder = ListView1.Items(0).FindControl("Label96")
        Label118.Text = pHolder.Text

        ' Coaching Monitor Yes/No?
        pHolder = ListView1.Items(0).FindControl("CoachingMonitorYesNo")
        txtCoachMonitorYesNo.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label59")
        Label23.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label60")
        Label25.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("ReassignedToSupName")
        ReassignedSupName.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label61")
        Label27.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("ReassignedToMgrName")
        ReassignedMgrName.Text = pHolder.Text

        Panel34.Visible = True
        pHolder = ListView1.Items(0).FindControl("Label121")
        Label120.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label62")
        Label11.Text = pHolder.Text

        If (pHolder.Text <> "Direct") Then ' = indirect
            Panel16.Visible = False
            Panel17.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label54")
            Label13.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label13.Text = pHolder.Text
        Else '=direct
            Panel17.Visible = False
            Panel16.Visible = True
            pHolder = ListView1.Items(0).FindControl("Label52") '-hhere
            Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label7.Text = pHolder.Text

        End If



        pHolder = ListView1.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text

        pHolder = ListView1.Items(0).FindControl("Label67")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then

            Panel18.Visible = False
        Else

            Panel18.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label56")
            Label17.Text = Server.HtmlDecode(pHolder.Text)

            pHolder = ListView1.Items(0).FindControl("Label159")

            Label64.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView1.Items(0).FindControl("Label68")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel19.Visible = False
        Else
            Panel19.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label57")
            Label19.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView1.Items(0).FindControl("Label69")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel20.Visible = False
        Else
            Panel20.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label58")
            Label21.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView1.Items(0).FindControl("Label157")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel14.Visible = False
        Else
            Panel14.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label158")
            Label149.Text = Server.HtmlDecode(pHolder.Text)

        End If

        '   MsgBox(i & "-" & pHolder.Text)

        'Next
        'find the controls relating to coaching reason and check the name

        'outside panels
        Dim pHolder7 As Label
        pHolder7 = ListView1.Items(0).FindControl("Label31")
        recStatus = DataList1.Items(0).FindControl("LabelStatus")
        statusLevel = GetRecordStatusLevel(pHolder7.Text, recStatus.Text)

        'pHolder = ListView1.Items(0).FindControl("Label45") ' strCSRSup

        'Dim logModule = "Supervisor"
        ' The user is the employee's current supervisor
        If (m_strUserEmployeeID = m_strHierarchySupEmployeeID OrElse m_strUserEmployeeID = m_strReassignedToEmployeeID) Then
            '        OrElse logModule = "Supervisor") Then
            'If (lan = LCase(pHolder.Text)) Then
            ' Date1.Text = DateTime.Now.ToString("d")
            CompareValidator1.ValueToCompare = TodaysDate

            Dim pHolder3
            Dim pHolder4
            Dim pHolder5
            Dim pHolder6

            pHolder3 = ListView1.Items(0).FindControl("Label126") ' isCoachingRequired
            pHolder4 = ListView1.Items(0).FindControl("Label106") ' txtMgrNotes
            pHolder5 = ListView1.Items(0).FindControl("Label33")  ' isIQS

            '  MsgBox("supervisor")
            If ((pHolder3.Text = "True") Or (pHolder4.Text <> "")) Then

                panelHolder = ListView1.Items(0).FindControl("Panel15") ' Notes from Manager:
                panelHolder.Visible = True

            End If

            recStatus = DataList1.Items(0).FindControl("LabelStatus")  ' strFormStatus
            pHolder6 = ListView1.Items(0).FindControl("Label90")       ' isCSRAcknowledged

            Select Case statusLevel
                Case 2
                    ' Pending Supervisor Review (CSR, Training, and LSA modules), Or
                    ' Pending Manager Review (Supervisor module), Or
                    ' Pending Quality Lead Review (Quality module)

                    ' It is from IQS or it is CTC or high CSAT5 or kudo or seasonal attendance
                    ' or performance scorecard MSR or MSRS.
                    If (pHolder5.Text = "1" OrElse isCTC OrElse isHigh5Club OrElse isKudo OrElse isAttendance OrElse isScorecardMsr OrElse isScorecardMsrs) Then

                        'If ((pHolder5.Text = "IQS") And (pHolder6.Text = "True")) Then

                        ' Panel28 includes "Management Notes" (Panel29, Label82, Label83) AND "Coaching Notes" (Label84, Label85)
                        panelHolder = ListView1.Items(0).FindControl("Panel28")
                        panelHolder.Visible = True ' Display "Coaching Notes"

                        pHolder = ListView1.Items(0).FindControl("Label83")     ' txtMgrNotes
                        panelHolder = ListView1.Items(0).FindControl("Panel29")

                        If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then  ' Panel15: "Notes from Manager:"
                            panelHolder.Visible = True ' Display "Management Notes"
                        End If

                        If (pHolder6.Text = "True") Then ' isCSRAcknowledged
                            ' pnlMgtAckReinforceLog -
                            ' 1. Check the box below to acknowledge the monitor:
                            ' I have read and understand all the information provided on this eCoaching Log.
                            pnlMgtAckReinforceLog.Visible = True
                        Else
                            ' Panel25 -
                            ' 1. Enter the date of coaching:
                            ' 2. Provide the details from the coaching session including action plans developed:
                            Panel25.Visible = True
                        End If
                    Else ' not from IQS
                        Dim pHolder2v ''
                        Dim pHolder2w

                        pHolder2v = ListView1.Items(0).FindControl("Label34") 'ETS / OAE
                        pHolder2w = ListView1.Items(0).FindControl("Label35") 'ETS / OAS

                        Dim omrIae As Label = ListView1.Items(0).FindControl("LabelOmrIae")
                        Dim omrIat As Label = ListView1.Items(0).FindControl("LabelOmrIat")
                        Dim trainingShortDuration As Label = ListView1.Items(0).FindControl("LabelShortDurationReport")
                        Dim trainingOverdue As Label = ListView1.Items(0).FindControl("LabelOverDueTraining")

                        ' Is it OMR/IAE (Inappropriate ARC Escalation) or OMR/IAT (Inappropriate ARC Transfer)
                        ' Or Training/SDR (short duration in training) or Training/ODT (Overdue Training)
                        ' Or OMR/BRL (exceed break length) or OMR/BRN (exceed break numbers)
                        If (pHolder2v.Text = "1" OrElse pHolder2w.Text = "1" _
                                OrElse omrIae.Text = "1" _
                                OrElse omrIat.Text = "1" _
                                OrElse trainingShortDuration.Text = "1" _
                                OrElse trainingOverdue.Text = "1" _
                                OrElse exceededTimeOfBreak.Text = "1" _
                                OrElse exceededNumberOfBreaks.Text = "1") Then
                            Panel37.Visible = True ' coaching required question group
                            Label138.Text = "3. Provide the details from the coaching session including action plans developed"
                            CalendarExtender4.EndDate = TodaysDate
                            CompareValidator5.ValueToCompare = TodaysDate
                            RequiredFieldValidator10.Enabled = True
                            If (pHolder2v.Text = "1") Then 'ETS OAE
                                HyperLink1.Text = "Contact Center Operations 3.06 Timecard Audit SOP"
                                Label134.Text = "You are receiving this eCL record because an Employee on your team was identified on the CCO TC Outstanding Actions report (also known as the TC Compliance Action report).  Please research why the employee did Not complete their timecard before the deadline laid out in the latest "

                            End If

                            If (pHolder2w.Text = "1") Then 'ETS OAS
                                HyperLink1.Text = "Contact Center Operations 3.06 Timecard Audit SOP"
                                Label134.Text = "You are receiving this eCL record because a Supervisor on your team was identified on the CCO TC Outstanding Actions report (also known as the TC Compliance Action report).  Please research why the supervisor did Not approve Or reject their CSR’s timecard before the deadline laid out in the latest "
                            End If

                            If (trainingShortDuration.Text = "1") Then
                                HyperLink1.Text = String.Empty
                                Label134.Text = REVIEW_TRAINING_SHORT_DURATION_REPORT_TEXT
                                Label132.Text = String.Empty
                            End If

                            ' Overdue Training
                            If (trainingOverdue.Text = "1") Then
                                HyperLink1.Text = String.Empty
                                Label134.Text = REVIEW_TRAINING_OVERDUE_TRAINING_TEXT
                                Label132.Text = String.Empty
                            End If

                            ' Breaks related
                            If (exceededTimeOfBreak.Text = "1" OrElse exceededNumberOfBreaks.Text = "1") Then
                                HyperLink1.Text = String.Empty
                                Label134.Text = REVIEW_OMR_BREAK_TEXT
                                Label132.Text = String.Empty
                            End If

                        Else ' not from IQS, not ETS/OAE/OAS, not OMR/IAE, not OMR/IAT, not Training/SDR, not Training/ODT
                            Panel25.Visible = True
                            calendarButtonExtender.EndDate = TodaysDate
                            RequiredFieldValidator3.Enabled = True
                        End If
                    End If

                Case 4 ' Pending Acknowledgement
                    pnlMgtAckReinforceLog.Visible = True 'Check the box below to acknowledge the monitor

                    panelHolder = ListView1.Items(0).FindControl("Panel28") ' Coaching Notes
                    panelHolder.Visible = True ' Display "Coaching Notes"

                    pHolder = ListView1.Items(0).FindControl("Label83")
                    panelHolder = ListView1.Items(0).FindControl("Panel29") 'Management Notes

                    If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then

                        panelHolder.Visible = True
                    End If
                Case Else

                    panelHolder = ListView1.Items(0).FindControl("Panel28") ' Coaching Notes
                    panelHolder.Visible = True ' Display "Coaching Notes"

                    pHolder = ListView1.Items(0).FindControl("Label83")
                    panelHolder = ListView1.Items(0).FindControl("Panel29") ' Management Notes

                    If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then

                        panelHolder.Visible = True
                    End If
            End Select
        End If ' End The user is the employee current supervisor


        pHolder = ListView1.Items(0).FindControl("Label75")  ' strCSRMgr
        ' The user is the employee's current manager, OR
        ' If it is a LCS, the user is either the employee's current mgr or the mgr when the eCL was submitted
        If (m_strUserEmployeeID = m_strHierarchyMgrEmployeeID OrElse
                (m_lowCustomerSatisfaction = 1 AndAlso m_strUserEmployeeID = m_strCLMgrEmployeeID) OrElse
                m_strUserEmployeeID = m_strReassignedToEmployeeID) Then
            'If (lan = LCase(pHolder.Text)) Then ' I'm the current record's level 3

            'recStatus = DataList1.Items(0).FindControl("LabelStatus")
            'If ((InStr(recStatus.Text, "Pending Manager Review") > 0) Or ((InStr(recStatus.Text, "Pending Sr. Manager Review") > 0)) Or ((InStr(recStatus.Text, "Pending Deputy Program Manager Review") > 0))) Then
            If (statusLevel = 3) Then
                Dim pHolder2x As Label
                Dim pHolder2y As Label
                Dim pHolder2z As Label
                Dim omrShortCall As Label

                pHolder2x = ListView1.Items(0).FindControl("Label133") 'Current Coaching Initiative
                pHolder2y = ListView1.Items(0).FindControl("Label151") 'OMR / Exceptions
                pHolder2z = ListView1.Items(0).FindControl("Label36")  'Low CSAT
                omrShortCall = ListView1.Items(0).FindControl("LabelOmrIsq") ' Short Call
                If ((pHolder2x.Text = "1") Or (pHolder2y.Text = "1") Or (pHolder2z.Text = "1")) Then 'Research Required?
                    '   MsgBox("found 1")
                    ''panelHolder1 = ListView1.Items(0).FindControl("Panel38") 'Details of the behavior being coached
                    ''panelHolder1.Visible = True 'display txtDescription 

                    Panel37.Visible = True ' coaching required question group
                    CalendarExtender4.EndDate = TodaysDate
                    CompareValidator5.ValueToCompare = TodaysDate
                    RequiredFieldValidator10.Enabled = True
                    If (pHolder2z.Text = "1") Then 'change text for Low CSAT
                        Label134.Text = "You are receiving this eCL because you have been assigned to listen to and provide feedback on a call that was identified as having low customer satisfaction.  Please review the call from a PPoM perspective and provide details on the specific opportunities  requiring coaching in the record below. "
                        HyperLink1.Visible = "False" ' hide hyperlink
                        Label132.Text = "" 'hide 2nd part of paragraph
                    ElseIf (omrShortCall.Text = "1") Then 'change text for Short Calls
                        Label134.Text = REVIEW_OMR_SHORT_CALL_TEXT
                        HyperLink1.Visible = "False"
                        Label132.Text = ""
                    End If

                    ' TFS1893: hide all editable fields if user is the hierarchy manager but not the log manager and not the reassigned reviewer
                    If (pHolder2z.Text = "1" AndAlso
                            m_strUserEmployeeID = m_strHierarchyMgrEmployeeID AndAlso
                            m_strHierarchyMgrEmployeeID <> m_strCLMgrEmployeeID AndAlso
                            m_strUserEmployeeID <> m_strReassignedToEmployeeID) Then

                        Label140.Visible = False
                        Label130.Visible = False
                        pnlDate.Visible = False
                        Label141.Visible = False
                        RadioButtonList3.Visible = False
                        panel0b.Visible = False
                        Button5.Visible = False
                    End If

                Else
                    Panel26.Visible = True 'Customer Service Escalation (CSE) question group
                    CalendarExtender1.EndDate = TodaysDate
                    CalendarExtender2.EndDate = TodaysDate 'new
                    If (RadioButtonList1.SelectedValue = "1") Then 'CSE
                        panel24.Style("display") = "inline"
                        panel24.Style("visibility") = "visible"
                        panel27.Style("display") = "none"
                        panel27.Style("visibility") = "hidden"
                        CalendarExtender1.EndDate = TodaysDate
                        RequiredFieldValidator1.Enabled = True
                        RequiredFieldValidator6.Enabled = True
                        RequiredFieldValidator2.Enabled = False
                        RequiredFieldValidator5.Enabled = False
                        CompareValidator2.Enabled = True
                        CompareValidator3.Enabled = False
                    End If
                    If (RadioButtonList1.SelectedValue = "0") Then 'NOT CSE
                        panel27.Style("display") = "inline"
                        panel27.Style("visibility") = "visible"
                        CalendarExtender2.EndDate = TodaysDate
                        RequiredFieldValidator1.Enabled = False
                        RequiredFieldValidator6.Enabled = False
                        RequiredFieldValidator2.Enabled = True
                        RequiredFieldValidator5.Enabled = True
                        CompareValidator3.Enabled = True
                        CompareValidator2.Enabled = False

                        panel24.Style("display") = "none"
                        panel24.Style("visibility") = "hidden"
                    End If

                    pHolder = ListView1.Items(0).FindControl("Label72")      ' txtCoachingNotes
                    panelHolder = ListView1.Items(0).FindControl("Panel23")  ' Coaching Notes
                    If (pHolder.Text <> "") Then
                        panelHolder.Visible = True
                    End If
                End If ' End of If ((pHolder2x.Text = "1") Or (pHolder2y.Text = "1") Or (pHolder2z.Text = "1"))
            Else ' statusLevel <> 3
                panelHolder = ListView1.Items(0).FindControl("Panel28")
                panelHolder.Visible = True

                pHolder = ListView1.Items(0).FindControl("Label83")
                panelHolder = ListView1.Items(0).FindControl("Panel29") 'Management Notes

                If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then
                    panelHolder.Visible = True
                End If
            End If ' End of If (statusLevel = 3)
        End If ' End of If (m_strUserEmployeeID = m_strHierarchyMgrEmployeeID OrElse m_strUserEMployeeID = m_strLogMgrEmployeeID)

        Dim pHolder2
        Dim pHolder8
        pHolder2 = ListView1.Items(0).FindControl("Label33") 'iSIQS
        pHolder = ListView1.Items(0).FindControl("Label88")
        ' The user is the current record's employee
        If (m_strUserEmployeeID = m_strEmployeeID) Then
            'If (lan = LCase(pHolder.Text)) Then ' I'm the current record's csr

            ' Display Coaching Notes.
            panelHolder = ListView1.Items(0).FindControl("Panel28")
            panelHolder.Visible = True

            If (statusLevel = 1) Then
                pHolder8 = ListView1.Items(0).FindControl("Label148") 'SupReviewedAutoDate

                ' IQS or CTC or high CSAT5 or kudo or seasonal attendance
                ' or performance scorecard MSR or MSRS.
                If ((pHolder2.Text = "1" OrElse isCTC OrElse isHigh5Club OrElse isKudo OrElse isAttendance OrElse isScorecardMsr OrElse isScorecardMsrs) AndAlso Len(pHolder8.Text) > 4) Then
                    pnlEmpAckReinforceLog.Visible = True ' 1. Check the box below to acknowledge the monitor:
                Else
                    If (isDTT) Then
                        divFeedbackTxtbox.Visible = False
                        divFeedbackDdl.Visible = True
                        ddlDttFeedback.DataSource = eclHandler.GetDttFeedbackOptions()
                        ddlDttFeedback.DataBind()
                    End If

                    Panel30.Visible = True ' 1. Check the box below to acknowledge the coaching opportunity:...

                End If
            End If

            If (statusLevel = 4) Then
                pnlEmpAckReinforceLog.Visible = True 'acknowledge monitor
            End If
        End If


        ''   pHolder = ListView1.Items(0).FindControl("Label90") ' removed for IQS
        '' If (pHolder.Text = "True") Then ' I'm the current record's csr
        '??????????????????????????????????
        ''Button4.Visible = True

        ''  End If

        'Label90
        'Button4


        ' The user is the submitter but not the employee of record, not the employee's supervisor, and not the employee's manager
        If (m_strUserEmployeeID = m_strSubmitterEmployeeID AndAlso
            m_strUserEmployeeID <> m_strEmployeeID AndAlso
            m_strUserEmployeeID <> m_strHierarchySupEmployeeID AndAlso
            m_strUserEmployeeID <> m_strHierarchyMgrEmployeeID) Then
            'If ((lan = LCase(pHolder4a.Text)) And (lan <> LCase(pHolder1a.Text)) And (lan <> LCase(pHolder2a.Text)) And (lan <> LCase(pHolder3a.Text))) Then

            'User is submitter but not the employee of record, not the employee's SUP, nor the employee's MGR
            panelHolder = ListView1.Items(0).FindControl("Panel28")
            panelHolder.Visible = True

            pHolder = ListView1.Items(0).FindControl("Label83") '' remove if shouldn't have for Outlier
            panelHolder = ListView1.Items(0).FindControl("Panel29") ''Management Notes remove if shouldn't have for Outlier

            If ((pHolder.Text <> "") And (ListView1.Items(0).FindControl("Panel15").Visible = False)) Then '' remove if shouldn't have for Outlier

                panelHolder.Visible = True '' remove if shouldn't have for Outlier


            End If '' remove if shouldn't have for Outlier
        End If


    End Sub



    Protected Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListView2.DataBound ' record not modifyable
        ' Get the user employee ID from session
        m_strUserEmployeeID = Session("eclUser").EmployeeID

        m_strEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("EmployeeID"), Label).Text)
        m_strHierarchySupEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("HierarchySupEmployeeID"), Label).Text)
        m_strHierarchyMgrEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("HierarchyMgrEmployeeID"), Label).Text)
        m_strSubmitterEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("SubmitterEmployeeID"), Label).Text)

        m_strReassignedToEmployeeID = LCase(DirectCast(ListView2.Items(0).FindControl("ReassignedToEmployeeID"), Label).Text)

        m_blnUserIsARCCsr = Label241.Text <> "0"

        If (Not IsAccessAllowed()) Then
            ' Send the user to the unauthorized page.
            Response.Redirect("error3.aspx")
        End If

        pHolder = ListView2.Items(0).FindControl("Label50")
        Label3.Text = pHolder.Text
        pHolder = ListView2.Items(0).FindControl("Label51")
        'Label10.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
        Label10.Text = pHolder.Text & "&nbsp;PDT"

        pHolder = ListView2.Items(0).FindControl("Label53")
        Label15.Text = pHolder.Text
        pHolder = ListView2.Items(0).FindControl("Label96")
        Label118.Text = pHolder.Text

        ' Coaching Monitor Yes/No?
        pHolder = ListView2.Items(0).FindControl("CoachingMonitorYesNo")
        txtCoachMonitorYesNo.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label59")
        Label23.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label60")
        Label25.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("ReassignedToSupName")
        ReassignedSupName.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label61")
        Label27.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("ReassignedToMgrName")
        ReassignedMgrName.Text = pHolder.Text

        Panel34.Visible = True
        pHolder = ListView2.Items(0).FindControl("Label121")
        Label120.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label62")
        Label11.Text = pHolder.Text

        If (pHolder.Text <> "Direct") Then '=Indirect
            Panel16.Visible = False
            Panel17.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label54")
            Label13.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label13.Text = pHolder.Text


        Else '= Direct
            Panel16.Visible = True
            pHolder = ListView2.Items(0).FindControl("Label52")
            Label7.Text = (CDate(pHolder.Text)).ToShortDateString() 'pHolder.Text
            'Label7.Text = pHolder.Text
            Panel17.Visible = False

        End If



        pHolder = ListView2.Items(0).FindControl("Label55")
        Label66.Text = pHolder.Text

        pHolder = ListView2.Items(0).FindControl("Label67")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel18.Visible = False
        Else
            Panel18.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label56")
            Label17.Text = Server.HtmlDecode(pHolder.Text)

            pHolder = ListView2.Items(0).FindControl("Label159")

            Label64.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView2.Items(0).FindControl("Label68")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel19.Visible = False
        Else
            Panel19.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label57")
            Label19.Text = Server.HtmlDecode(pHolder.Text)

        End If


        pHolder = ListView2.Items(0).FindControl("Label69")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel20.Visible = False
        Else
            Panel20.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label58")
            Label21.Text = Server.HtmlDecode(pHolder.Text)

        End If



        pHolder = ListView2.Items(0).FindControl("Label157")
        'MsgBox(pHolder.Text)
        If (pHolder.Text = "False") Then
            Panel14.Visible = False
        Else
            Panel14.Visible = True

            pHolder = ListView2.Items(0).FindControl("Label158")
            Label149.Text = Server.HtmlDecode(pHolder.Text)

        End If


        '   MsgBox(i & "-" & pHolder.Text)

        'Next

        'outside panels



        '' panelHolder = ListView2.Items(0).FindControl("Panel33") 'Details of the behavior being coached
        '' panelHolder.Visible = True

        pHolder = ListView2.Items(0).FindControl("Label107") ' Customer Service Escalation
        If (pHolder.Text = "1") Then
            pHolder = ListView2.Items(0).FindControl("Label89") 'isCSE
            If (pHolder.Text = "True") Then
                pHolder = ListView2.Items(0).FindControl("Label43") ' Coaching Opportunity was a confirmed Customer Service Escalation
                pHolder.Visible = True
            Else ' not CSE
                panelHolder = ListView2.Items(0).FindControl("Panel35")
                panelHolder.Visible = True ' Display "Coaching Opportunity was not a confirmed Customer Service Escalation"

                panelHolder = ListView2.Items(0).FindControl("Panel36") ' Management Notes
                pHolder = ListView2.Items(0).FindControl("Label103") ' txtMgrNotes
                If (pHolder.Text <> "") Then
                    panelHolder.Visible = True ' Display "Management Notes"
                End If
            End If
        End If


        pHolder = ListView2.Items(0).FindControl("Label101")

        If (Len(pHolder.Text) > 0) Then

            pHolder.Text = pHolder.Text & "&nbsp;PDT"

        End If





        panelHolder = ListView2.Items(0).FindControl("Panel23") 'Coaching Notes
        panelHolder.Visible = True


        Dim pHolder6
        Dim pHolder7
        pHolder6 = ListView2.Items(0).FindControl("Label33") 'isIQS
        pHolder7 = ListView2.Items(0).FindControl("Label50")

        If ((pHolder6.Text = "1") And (pHolder7.Text = "Completed")) Then ' IQS
            pHolder = ListView2.Items(0).FindControl("Label100")
            pHolder.Text = "Reviewed and acknowledged Quality Monitor on"

            panelHolder = ListView2.Items(0).FindControl("Panel41") 'Supervisor Review Information & Quality Monitor acknowledgement date
            panelHolder.Visible = True

            Dim pHolder8
            pHolder8 = ListView2.Items(0).FindControl("Label155")
            If (Len(pHolder8.Text) > 0) Then
                pHolder8.Text = pHolder8.Text & "&nbsp;PDT"
            End If
        Else
            pHolder = ListView2.Items(0).FindControl("Label100")
            pHolder.Text = "Reviewed and acknowledged coaching on"
        End If

        ' TFS 2196 - Show CSR Comments/Feedback always
        panelHolder = ListView2.Items(0).FindControl("Panel32") 'CSR Comments/Feedback
        panelHolder.Visible = True

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            HandlePageNonPostBack()
        End If
    End Sub

    ' called on page non post back but after authentication is successful
    Public Sub HandlePageNonPostBack()
        ' sp_Check_AgentRole
        SqlDataSource14.SelectParameters("nvcLanID").DefaultValue = Session("eclUser").LanID
        SqlDataSource14.SelectParameters("nvcRole").DefaultValue = "ARC"
        GridView1.DataBind()

        Dim formID
        Dim idArray

        formID = Request.QueryString("id")
        If (RadioButtonList1.SelectedValue = "1") Then
            panel24.Style("display") = "inline"
            panel24.Style("visibility") = "visible"
            panel27.Style("display") = "none"
            panel27.Style("visibility") = "hidden"
        End If
        If (RadioButtonList1.SelectedValue = "0") Then
            panel27.Style("display") = "inline"
            panel27.Style("visibility") = "visible"
            panel24.Style("display") = "none"
            panel24.Style("visibility") = "hidden"
        End If

        If (Len(formID) > 9) Then
            'eCL-Lanisa.Rodriguez-Tov-409432
            idArray = Split(formID, "-", -1, 1)
            'error
            'MsgBox(idArray(0) = "eCL")
            'MsgBox(UBound(idArray))
            'If ((idArray(0) = "eCL") And (Len(idArray(1)) = 4) Or (CInt(idArray(2)) > -1)) Then
            If ((LCase(idArray(0)) = "ecl") And (CInt(UBound(idArray)) > -1)) Then

                'If (LCase((idArray(0) = "eCL")) And (CInt(UBound(idArray)) > -1)) Then
                recStatus = DataList1.Items(0).FindControl("LabelStatus")

                If (recStatus.Text = "Completed") Then

                    ListView2.Visible = True
                    Panel31.Visible = True
                    Label6.Text = "Final"

                End If

                If (InStr(recStatus.Text, "Pending") > 0) Then

                    ListView1.Visible = True
                    Panel31.Visible = True
                    Label6.Text = "Review"

                End If

                CompareValidator2.ValueToCompare = TodaysDate
                CompareValidator3.ValueToCompare = TodaysDate
            Else
                Panel31.Visible = False
                DataList1.Visible = False
                DataList1.Enabled = False

                Panel4a.Visible = False ''True
                Label28.Visible = False
                Label29.Visible = False
            End If
        Else
            Panel31.Visible = False
            DataList1.Visible = False
            DataList1.Enabled = False
            Panel4a.Visible = False ''True
            Label28.Visible = False
            Label29.Visible = False
        End If
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID
        Dim currentDateTime As Date = CDate(DateTime.Now())

        'Supervisor submit
        Page.Validate()
        If Page.IsValid Then
            '   MsgBox(Request.QueryString("id"))

            ' Text5.Text: Coaching Plans Supervisor entered on Review page
            If (Len(TextBox5.Text) > 3000) Then
                TextBox5.Text = Left(TextBox5.Text, 3000)
            End If

            TextBox5.Text = Server.HtmlEncode(TextBox5.Text)
            TextBox5.Text = Replace(TextBox5.Text, "’", "&rsquo;")
            TextBox5.Text = Replace(TextBox5.Text, "‘", "&lsquo;")
            TextBox5.Text = Replace(TextBox5.Text, "'", "&prime;")
            TextBox5.Text = Replace(TextBox5.Text, Chr(147), "&ldquo;")
            TextBox5.Text = Replace(TextBox5.Text, Chr(148), "&rdquo;")
            TextBox5.Text = Replace(TextBox5.Text, "-", "&ndash;")

            ' Label105: Coaching Notes from coaching_log table
            Dim coachingNotesLabel As Label = ListView1.Items(0).FindControl("Label105")

            ' Label25.Text: Supervisor name
            Dim supervisorName = Label25.Text

            ' The supervisor name to whom the log was reassigned to.
            Dim reassignedToSupLabel As Label = ListView1.Items(0).FindControl("ReassignedToSupName")
            Dim reassignedToSupName = reassignedToSupLabel.Text

            SqlDataSource1.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource1.UpdateParameters("nvcReviewSupLanID").DefaultValue = lan
            SqlDataSource1.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"
            SqlDataSource1.UpdateParameters("dtmSupReviewedAutoDate").DefaultValue = currentDateTime
            ' Date1.Text: Coaching Date Supervisor entered on Review page
            SqlDataSource1.UpdateParameters("nvctxtCoachingNotes").DefaultValue = GetFormattedCoachingNotes(currentDateTime, CDate(Date1.Text), coachingNotesLabel.Text, TextBox5.Text, supervisorName, reassignedToSupName)

            SqlDataSource1.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)
            ' Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else
            Label116.Text = "Please correct all fields indicated in red to proceed."
        End If
    End Sub

    Private Function GetFormattedCoachingNotes(currentDateTime, coachingManualDate, coachingNotes, supervisorNotes, supervisorName, reassigneToSupName) As String
        Dim formattedSupervisorNotes As String = String.Empty

        If (String.IsNullOrEmpty(reassigneToSupName) OrElse
                String.Compare(reassigneToSupName.Trim(), "NA", True) = 0) Then
            formattedSupervisorNotes &= supervisorName
        Else
            ' The reassigned supervisor entered the coaching notes
            formattedSupervisorNotes &= reassigneToSupName
        End If

        formattedSupervisorNotes &= " (" & currentDateTime & " PDT) - " & coachingManualDate & " " & supervisorNotes

        'If String.IsNullOrEmpty(coachingNotesLabel.Text) Then
        If String.IsNullOrEmpty(coachingNotes) Then
            Return formattedSupervisorNotes
        End If

        Return coachingNotes & "<br />" & formattedSupervisorNotes
    End Function

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button2.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'Manager submit 1
        '' add dtmMgrReviewAutoDate to update parameters = CDate(DateTime.Now())
        'MsgBox("goodbye")

        If (RadioButtonList1.SelectedValue = "1") Then 'Panel26
            RequiredFieldValidator6.Enabled = True
            RequiredFieldValidator1.Enabled = True

            CompareValidator2.Enabled = True


            RequiredFieldValidator5.Enabled = False
            RequiredFieldValidator2.Enabled = False
            CompareValidator3.Enabled = False


            panel24.Style("display") = "inline"
            panel24.Style("visibility") = "visible"
            panel27.Style("display") = "none"
            panel27.Style("visibility") = "hidden"

        Else 'Panel26
            RequiredFieldValidator5.Enabled = True
            RequiredFieldValidator2.Enabled = True


            CompareValidator3.Enabled = True


            RequiredFieldValidator6.Enabled = False
            RequiredFieldValidator1.Enabled = False
            CompareValidator2.Enabled = False



            panel27.Style("display") = "inline"
            panel27.Style("visibility") = "visible"
            panel24.Style("display") = "none"
            panel24.Style("visibility") = "hidden"
        End If




        Page.Validate()

        If Page.IsValid Then


            SqlDataSource3.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource3.UpdateParameters("nvcReviewMgrLanID").DefaultValue = lan
            SqlDataSource3.UpdateParameters("bitisCSE").DefaultValue = CBool(RadioButtonList1.SelectedValue)

            Dim pHolder7 As Label
            pHolder7 = ListView1.Items(0).FindControl("Label31")

            Select Case pHolder7.Text ' Module check
                Case "CSR", "Training"
                    SqlDataSource3.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"
                Case "Supervisor"
                    SqlDataSource3.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Manager Review"
                Case "Quality"
                    SqlDataSource3.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Quality Lead Review"
            End Select

            SqlDataSource3.UpdateParameters("dtmMgrReviewAutoDate").DefaultValue = CDate(DateTime.Now())

            'supervisor /QS comments originally combined for notes
            pHolder2 = ListView1.Items(0).FindControl("Label105") ' txtcoachingnotes
            ' Label25: strCSRSupName
            ' Label27: strCSRMgrName

            'TextBox2.Text = "1. " & Label25.Text & " (Sup/QS " & Label10.Text & ")" & Server.HtmlDecode(pHolder2.Text) & "-----------------2. " & Label27.Text & " (MGMT " & TodaysDate & ") " & TextBox2.Text

            '"\r\n", "<br />"
            If (Len(TextBox2.Text) > 3000) Then
                TextBox2.Text = Left(TextBox2.Text, 3000)
            End If
            'MsgBox(TextBox2.Text)
            'add manager name and date for CSE manager notes
            'TextBox2.Text = Label27.Text & " (MGMT " & TodaysDate & ") " & Server.HtmlEncode(TextBox2.Text)
            TextBox2.Text = Server.HtmlEncode(TextBox2.Text)
            TextBox2.Text = Replace(TextBox2.Text, "’", "&rsquo;")
            TextBox2.Text = Replace(TextBox2.Text, "‘", "&lsquo;")
            TextBox2.Text = Replace(TextBox2.Text, "'", "&prime;")
            TextBox2.Text = Replace(TextBox2.Text, Chr(147), "&ldquo;")
            TextBox2.Text = Replace(TextBox2.Text, Chr(148), "&rdquo;")
            TextBox2.Text = Replace(TextBox2.Text, "-", "&ndash;")

            SqlDataSource3.UpdateParameters("nvctxtMgrNotes").DefaultValue = TextBox2.Text
            SqlDataSource3.UpdateParameters("dtmMgrReviewManualDate").DefaultValue = CDate(Date2.Text)

            SqlDataSource3.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


        End If




    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button3.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        'Manager submit 2


        If (RadioButtonList1.SelectedValue = "1") Then 'Panel26
            RequiredFieldValidator6.Enabled = True
            RequiredFieldValidator1.Enabled = True

            CompareValidator2.Enabled = True


            RequiredFieldValidator5.Enabled = False
            RequiredFieldValidator2.Enabled = False
            CompareValidator3.Enabled = False

        Else 'Panel26
            RequiredFieldValidator5.Enabled = True
            RequiredFieldValidator2.Enabled = True


            CompareValidator3.Enabled = True


            RequiredFieldValidator6.Enabled = False
            RequiredFieldValidator1.Enabled = False
            CompareValidator2.Enabled = False
        End If



        Page.Validate()
        If Page.IsValid Then


            SqlDataSource4.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource4.UpdateParameters("nvcReviewMgrLanID").DefaultValue = lan
            SqlDataSource4.UpdateParameters("bitisCSE").DefaultValue = CBool(RadioButtonList1.SelectedValue)
            SqlDataSource4.UpdateParameters("dtmMgrReviewManualDate").DefaultValue = CDate(Date3.Text)
            SqlDataSource4.UpdateParameters("dtmMgrReviewAutoDate").DefaultValue = CDate(DateTime.Now()) 'already existing for outlier, update EC.sp_Update3Review_Coaching_Log



            Dim pHolder7 As Label
            pHolder7 = ListView1.Items(0).FindControl("Label31")

            Select Case pHolder7.Text ' Module check


                Case "CSR", "LSA", "Training"
                    SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"

                Case "Supervisor"
                    SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Manager Review"

                Case "Quality"
                    SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Quality Lead Review"


            End Select

            ' SqlDataSource4.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"
            '' SqlDataSource4.UpdateParameters("bitisCoachingRequired").DefaultValue = CBool(RadioButtonList3.SelectedValue) 'new for outlier, update EC.sp_Update2Review_Coaching_Log

            If (Len(TextBox3.Text) > 3000) Then

                TextBox3.Text = Left(TextBox3.Text, 3000)

            End If

            TextBox3.Text = Server.HtmlEncode(TextBox3.Text)
            TextBox3.Text = Replace(TextBox3.Text, "�", "&rsquo;")
            TextBox3.Text = Replace(TextBox3.Text, "�", "&lsquo;")
            TextBox3.Text = Replace(TextBox3.Text, "'", "&prime;")
            TextBox3.Text = Replace(TextBox3.Text, Chr(147), "&ldquo;")
            TextBox3.Text = Replace(TextBox3.Text, Chr(148), "&rdquo;")
            TextBox3.Text = Replace(TextBox3.Text, "-", "&ndash;")

            SqlDataSource4.UpdateParameters("nvcMgrNotes").DefaultValue = TextBox3.Text


            SqlDataSource4.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


            ' Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."

        End If

    End Sub

    Protected Sub Button5_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button5.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID

        Dim reasonSelected As String = ddlNonCoachableReason.SelectedValue


        Dim moduleName As String = TryCast(ListView1.Items(0).FindControl("Label31"), Label).Text
        Dim recordStatus As String = TryCast(ListView1.Items(0).FindControl("Label50"), Label).Text

        statusLevel = GetRecordStatusLevel(moduleName, recordStatus)

        'Manager or Supervisor submit 3 - Outlier [OMR, OAE, OAM]

        RequiredFieldValidator10.Enabled = True

        If (RadioButtonList3.SelectedValue = "0") Then 'panel37
            RequiredFieldValidator9.Enabled = False
            RequiredFieldValidator4.Enabled = True

            panel0a.Style("display") = "inline"
            panel0a.Style("visibility") = "visible"
            panel0b.Style("display") = "none"
            panel0b.Style("visibility") = "hidden"
            '  MsgBox("AddlNotes")

        End If

        If (RadioButtonList3.SelectedValue = "1") Then 'panel37

            'panel37
            RequiredFieldValidator4.Enabled = False
            RequiredFieldValidator9.Enabled = True
            panel0b.Style("display") = "inline"
            panel0b.Style("visibility") = "visible"
            panel0a.Style("display") = "none"
            panel0a.Style("visibility") = "hidden"

            'MsgBox("TextBox1")
        End If

        Page.Validate()
        If Page.IsValid Then


            SqlDataSource7.UpdateParameters("nvcFormID").DefaultValue = Request.QueryString("id")
            SqlDataSource7.UpdateParameters("nvcReviewerLanID").DefaultValue = lan
            SqlDataSource7.UpdateParameters("dtmReviewAutoDate").DefaultValue = CDate(DateTime.Now()) 'already existing for outlier, update EC.sp_Update3Review_Coaching_Log
            SqlDataSource7.UpdateParameters("bitisCoachingRequired").DefaultValue = CBool(RadioButtonList3.SelectedValue)
            ' If the record status is at level 2
            ' Do not update Coaching_Log.coachingDate, append the date entered on the page to coachingNotes or txtReasonNotCoachable field
            ' See TFS 115 (SCR13631) - Coaching Notes Overwritten;
            If statusLevel = 2 Then
                SqlDataSource7.UpdateParameters("dtmReviewManualDate").DefaultValue = String.Empty ' CDate(Date4.Text)
            Else
                SqlDataSource7.UpdateParameters("dtmReviewManualDate").DefaultValue = CDate(Date4.Text)
            End If

            If RadioButtonList3.SelectedValue = "1" Then '[isCoachingRequired] = True/Yes/1

                ''    SqlDataSource7.UpdateParameters("nvcstrCoachReason_Current_Coaching_Initiatives").DefaultValue = "Opportunity"


                Dim pHolder7 As Label
                pHolder7 = ListView1.Items(0).FindControl("Label31")

                Dim pHolder1 As Label = ListView1.Items(0).FindControl("Label133") 'Current Coaching Initiative
                Dim pHolder2 As Label = ListView1.Items(0).FindControl("Label151") 'OMR / Exceptions
                Dim omrIae As Label = ListView1.Items(0).FindControl("LabelOmrIae") 'OMR / IAE
                Dim omrIat As Label = ListView1.Items(0).FindControl("LabelOmrIat") 'OMR / IAT
                Dim pHolder3 As Label = ListView1.Items(0).FindControl("Label34") 'ETS / OAE
                Dim pHolder4 As Label = ListView1.Items(0).FindControl("Label35") 'ETS / OAS
                Dim pHolder5 As Label = ListView1.Items(0).FindControl("Label36") 'Low CSAT
                Dim trainingShortDuration As Label = ListView1.Items(0).FindControl("LabelShortDurationReport") ' Training / SDR
                Dim trainingOverdue As Label = ListView1.Items(0).FindControl("LabelOverDueTraining") ' Training / ODT

                Dim exceededTimeOfBreak As Label = ListView1.Items(0).FindControl("exceededTimeOfBreak") ' OMR / BRL
                Dim exceededNumberOfBreaks As Label = ListView1.Items(0).FindControl("exceededNumberOfBreaks") ' OMR / BRK

                Select Case pHolder7.Text ' Module check

                    Case "CSR", "Training"

                        ' Current Coaching Initiative, OMR / Exception, Low CSAT
                        If (pHolder1.Text = "1" OrElse pHolder2.Text = "1" OrElse pHolder5.Text = "1") Then
                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"
                        End If

                        ' OMR/IAE, OMR/IAT, ETS/OAE, Training/SDR, Training/ODT
                        ' OMR/BRL, OMR/BRN
                        If (omrIae.Text = "1" OrElse omrIat.Text = "1" OrElse pHolder3.Text = "1" OrElse trainingShortDuration.Text = "1" OrElse trainingOverdue.Text = "1" _
                                OrElse exceededTimeOfBreak.Text = "1" OrElse exceededNumberOfBreaks.Text = "1") Then
                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"
                        End If

                    Case "Supervisor"

                        If ((pHolder1.Text = "1") Or (pHolder2.Text = "1")) Then

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Manager Review"


                        Else

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"

                        End If




                    Case "Quality"


                        If ((pHolder1.Text = "1") Or (pHolder2.Text = "1")) Then

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Quality Lead Review"


                        Else

                            SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Employee Review"

                        End If




                End Select



                ' SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Pending Supervisor Review"

                SqlDataSource7.UpdateParameters("nvcstrReasonNotCoachable").DefaultValue = ""

                'crop text if it is larger than 3000 chars
                If (Len(AddlNotes.Text) > 3000) Then

                    AddlNotes.Text = Left(AddlNotes.Text, 3000)

                End If

                'encode strings that are not valid and not caught by htmlencode
                AddlNotes.Text = Server.HtmlEncode(AddlNotes.Text)
                AddlNotes.Text = Replace(AddlNotes.Text, "�", "&rsquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, "�", "&lsquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, "'", "&prime;")
                AddlNotes.Text = Replace(AddlNotes.Text, Chr(147), "&ldquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, Chr(148), "&rdquo;")
                AddlNotes.Text = Replace(AddlNotes.Text, "-", "&ndash;")

                SqlDataSource7.UpdateParameters("nvctxtReasonNotCoachable").DefaultValue = ""
                SqlDataSource7.UpdateParameters("nvcstrReasonNotCoachable").DefaultValue = ""

                ' See TFS 115 (SCR13631) - Coaching Notes Overwritten;
                If statusLevel = 2 Then
                    Dim currentDateTime As Date = CDate(DateTime.Now())
                    ' Label25.Text: Supervisor name
                    Dim supervisorName = Label25.Text
                    ' Label105: Coaching Notes from coaching_log table
                    Dim coachingNotesLabel As Label = ListView1.Items(0).FindControl("Label105")
                    ' The supervisor name to whom the log was reassigned to.
                    Dim reassignedToSupLabel As Label = ListView1.Items(0).FindControl("ReassignedToSupName")
                    Dim reassignedToSupName = reassignedToSupLabel.Text

                    SqlDataSource7.UpdateParameters("nvcReviewerNotes").DefaultValue = GetFormattedCoachingNotes(currentDateTime, CDate(Date4.Text), coachingNotesLabel.Text, AddlNotes.Text, supervisorName, reassignedToSupName)
                Else
                    SqlDataSource7.UpdateParameters("nvcReviewerNotes").DefaultValue = AddlNotes.Text
                End If

            Else '[isCoachingRequired] = False/No/0

                ''     SqlDataSource7.UpdateParameters("nvcstrCoachReason_Current_Coaching_Initiatives").DefaultValue = "Not Coachable"
                SqlDataSource7.UpdateParameters("nvcFormStatus").DefaultValue = "Inactive"
                SqlDataSource7.UpdateParameters("nvcstrReasonNotCoachable").DefaultValue = reasonSelected

                'crop text if it is larger than 3000 chars
                If (Len(TextBox1.Text) > 3000) Then

                    TextBox1.Text = Left(TextBox1.Text, 3000)

                End If

                'encode strings that are not valid and not caught by htmlencode
                TextBox1.Text = Server.HtmlEncode(TextBox1.Text)
                TextBox1.Text = Replace(TextBox1.Text, "�", "&rsquo;")
                TextBox1.Text = Replace(TextBox1.Text, "�", "&lsquo;")
                TextBox1.Text = Replace(TextBox1.Text, "'", "&prime;")
                TextBox1.Text = Replace(TextBox1.Text, Chr(147), "&ldquo;")
                TextBox1.Text = Replace(TextBox1.Text, Chr(148), "&rdquo;")
                TextBox1.Text = Replace(TextBox1.Text, "-", "&ndash;")

                SqlDataSource7.UpdateParameters("nvcReviewerNotes").DefaultValue = ""

                ' See TFS 115 (SCR13631) - Coaching Notes Overwritten;
                If statusLevel = 2 Then
                    Dim currentDateTime As Date = CDate(DateTime.Now())
                    ' Label25.Text: Supervisor name
                    Dim supervisorName = Label25.Text
                    ' Label105: Coaching Notes from coaching_log table
                    Dim coachingNotesLabel As Label = ListView1.Items(0).FindControl("Label105")
                    ' The supervisor name to whom the log was reassigned to.
                    Dim reassignedToSupLabel As Label = ListView1.Items(0).FindControl("ReassignedToSupName")
                    Dim reassignedToSupName = reassignedToSupLabel.Text

                    SqlDataSource7.UpdateParameters("nvctxtReasonNotCoachable").DefaultValue = GetFormattedCoachingNotes(currentDateTime, CDate(Date4.Text), coachingNotesLabel.Text, TextBox1.Text, supervisorName, reassignedToSupName)
                Else
                    SqlDataSource7.UpdateParameters("nvctxtReasonNotCoachable").DefaultValue = TextBox1.Text
                End If
            End If


            SqlDataSource7.Update()

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)


            ' Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."

        End If

    End Sub


    Protected Sub Button4_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button4.Click
        'CSR Submit
        Page.Validate()
        SetIsDTT()

        If Page.IsValid Then
            Dim strFormName = Request.QueryString("id")
            SqlDataSource5.UpdateParameters("nvcFormID").DefaultValue = strFormName
            SqlDataSource5.UpdateParameters("nvcFormStatus").DefaultValue = "Completed"
            SqlDataSource5.UpdateParameters("dtmCSRReviewAutoDate").DefaultValue = CDate(DateTime.Now())

            If (Len(TextBox4.Text) > 3000) Then
                TextBox4.Text = Left(TextBox4.Text, 3000)
            End If

            Dim comments As String
            If (isDTT) Then
                comments = ddlDttFeedback.SelectedValue
            Else
                comments = Server.HtmlEncode(TextBox4.Text)
                comments = Replace(comments, "�", "&rsquo;")
                comments = Replace(comments, "�", "&lsquo;")
                comments = Replace(comments, "'", "&prime;")
                comments = Replace(comments, Chr(147), "&ldquo;")
                comments = Replace(comments, Chr(148), "&rdquo;")
                comments = Replace(comments, "-", "&ndash;")
            End If

            SqlDataSource5.UpdateParameters("nvcCSRComments").DefaultValue = comments
            SqlDataSource5.UpdateParameters("bitisCSRAcknowledged").DefaultValue = CheckBox2.Checked
            SqlDataSource5.Update()

            ' If CSRs complete logs, then email csr comment entered to hierarchey (Supervisor and manager)
            If (eclHandler.IsCSRUser(Session("eclUser"))) Then
                EmailComment(strFormName, TextBox4.Text)
            End If

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)
        Else
            Label116.Text = "Please correct all fields indicated in red to proceed."
            ' Remeber the selected value
            If (isDTT) Then
                ddlDttFeedback.SelectedValue = ddlDttFeedback.SelectedValue
            End If
        End If
    End Sub

    Private Function EmailComment(formName As String, comment As String) As Boolean
        Dim elcUser As User = Session("eclUser")
        Dim strSubject = "eCoaching Log Completed (" & elcUser.Name & ")"
        Dim toList As New List(Of String)
        Dim strEmailContent = "The following eCoaching Log has been completed. Please see the employee's comments below:" & vbCrLf _
                            & " <br /><br />" & vbCrLf _
                            & " Form ID: " & formName & vbCrLf _
                            & " <br />" & vbCrLf _
                            & " Comments: " & comment & vbCrLf

        pHolder = ListView1.Items(0).FindControl("SupEmail")
        toList.Add(pHolder.Text)
        pHolder = ListView1.Items(0).FindControl("MgrEmail")
        toList.Add(pHolder.Text)

        Return EclUtils.SendEmail(toList, strSubject, strEmailContent, GetEmailLogoPath())
    End Function

    Protected Sub Button6_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button6.Click
        'CSR Pending Ack Submit

        Dim nextStep As String = ""

        Page.Validate()
        recStatus = DataList1.Items(0).FindControl("LabelStatus")
        If (recStatus.Text = "Pending Acknowledgement") Then


            Dim pHolder7 As Label
            pHolder7 = ListView1.Items(0).FindControl("Label31")

            Select Case pHolder7.Text ' Module check


                Case "CSR", "Training"
                    nextStep = "Pending Supervisor Review"

                Case "Supervisor"
                    nextStep = "Pending Manager Review"

                Case "Quality"
                    nextStep = "Pending Quality Lead Review"


            End Select


            ' nextStep = "Pending Supervisor Review"

        Else
            nextStep = "Completed"

        End If

        If Page.IsValid Then

            ''add dtmSupReviewedAutoDate = current date to update fields
            Dim formName = Request.QueryString("id")
            Dim comment = StringUtils.Sanitize(txtAcknowledgeComments.Text)
            SqlDataSource9.UpdateParameters("nvcFormID").DefaultValue = formName
            SqlDataSource9.UpdateParameters("nvcFormStatus").DefaultValue = nextStep
            SqlDataSource9.UpdateParameters("dtmCSRReviewAutoDate").DefaultValue = CDate(DateTime.Now())
            SqlDataSource9.UpdateParameters("bitisCSRAcknowledged").DefaultValue = CheckBox1.Checked
            SqlDataSource9.UpdateParameters("nvcCSRComments").DefaultValue = comment
            SqlDataSource9.Update()

            Dim moduleName As String = TryCast(ListView1.Items(0).FindControl("Label31"), Label).Text
            If IsCompleteCsrModule(moduleName, nextStep) Then
                EmailComment(formName, comment)
            End If

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)
            'Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")
        Else
            Label116.Text = "Please correct all fields indicated in red to proceed."
        End If

    End Sub

    Private Function IsCompleteCsrModule(moduleName As String, status As String) As Boolean
        If (String.IsNullOrWhiteSpace(moduleName) _
                OrElse Not String.Equals(moduleName.Trim(), "CSR", StringComparison.OrdinalIgnoreCase) _
                OrElse String.IsNullOrWhiteSpace(status) _
                OrElse Not String.Equals(status.Trim(), "completed", StringComparison.OrdinalIgnoreCase)) Then

            Return False
        End If

        Return True
    End Function

    ' Management acknowledge
    ' For CTC, manager acknowledge;
    ' For all others, superviosr acknowledge
    Protected Sub Button7_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button7.Click
        Dim eclUser As User = Session("eclUser")
        Dim lan As String = eclUser.LanID
        Dim nextStep As String = ""

        Page.Validate()
        recStatus = DataList1.Items(0).FindControl("LabelStatus")
        If (recStatus.Text = "Pending Acknowledgement") Then
            nextStep = "Pending Employee Review"
        Else
            nextStep = "Completed"
        End If

        If Page.IsValid Then

            Dim formName = Request.QueryString("id")
            ''add dtmSupReviewedAutoDate = current date to update fields
            SqlDataSource10.UpdateParameters("nvcFormID").DefaultValue = formName
            SqlDataSource10.UpdateParameters("nvcReviewSupLanID").DefaultValue = lan
            SqlDataSource10.UpdateParameters("nvcFormStatus").DefaultValue = nextStep
            SqlDataSource10.UpdateParameters("dtmSUPReviewAutoDate").DefaultValue = CDate(DateTime.Now())
            SqlDataSource10.Update()

            Dim moduleName As String = TryCast(ListView1.Items(0).FindControl("Label31"), Label).Text
            If IsCompleteCsrModule(moduleName, nextStep) Then
                Dim csrComment = TryCast(ListView1.Items(0).FindControl("CsrComment"), Label).Text
                EmailComment(formName, csrComment)
            End If

            FromURL = Request.ServerVariables("URL")
            Response.Redirect("next1.aspx?FromURL=" & FromURL)

            'Response.Redirect("next1.aspx")  ' Response.Redirect("view2.aspx")

        Else

            Label116.Text = "Please correct all fields indicated in red to proceed."


        End If


    End Sub







    Protected Sub CheckBoxRequired1_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox1.Checked


    End Sub

    Protected Sub CheckBoxRequired2_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox2.Checked


    End Sub

    Protected Sub CheckBoxRequired3_ServerValidate(ByVal Source As Object, ByVal args As ServerValidateEventArgs)

        args.IsValid = CheckBox3.Checked

    End Sub



    Protected Sub ARC_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource14.Selected
        'EC.sp_Check_AgentRole 
        'MsgBox("param=" & e.Command.Parameters("nvcLanID").Value)

        Label241.Text = e.Command.Parameters("@Indirect@return_value").Value
        ' MsgBox("2- " & Label241.Text)
        'Dim spot3
        'For Each param In e.Command.Parameters

        ' Extract the name and value of the parameter.
        'spot3 = param.ParameterName & " - " & param.Value.ToString()
        'MsgBox(spot3)
        'Next

        'MsgBox("1-" & Label241.Text)
    End Sub


    Protected Sub OnRowDataBound2(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView2.DataBound
        For i As Integer = (GridView2.Rows.Count - 1) To 1 Step -1
            Dim row As GridViewRow = GridView2.Rows(i)
            Dim previousRow As GridViewRow = GridView2.Rows(i - 1)

            For j As Integer = 0 To row.Cells.Count - 1
                If (row.Cells(j).Text = previousRow.Cells(j).Text) Then
                    ' fixed issue for coaching_log.CoachingID: 1412519
                    ' AHT - Keeping the call on track - Opportunity
                    ' AHT - Other: Specify reason under coaching details - Opportunity
                    ' Attendance - Other: Specify reason under coaching details - Opportunity
                    ' Quality - Other: Specify reason under coaching details - Opportunity
                    If (j = 0 AndAlso row.Cells(j + 1).Text <> previousRow.Cells(j + 1).Text AndAlso row.Cells(j + 1).RowSpan > 0) Then
                        Continue For
                    End If

                    If (previousRow.Cells(j).RowSpan = 0) Then
                        If (row.Cells(j).RowSpan = 0) Then
                            previousRow.Cells(j).RowSpan += 2
                        Else
                            previousRow.Cells(j).RowSpan = row.Cells(j).RowSpan + 1
                        End If
                        row.Cells(j).Visible = False
                    End If
                End If
            Next
        Next
    End Sub


    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource6_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource6.Selecting
        'EC.sp_SelectRecordStatus 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource8_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource8.Selecting
        'EC.sp_SelectReviewFrom_Coaching_Log_Reasons 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource14_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource14.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub






    Protected Sub SqlDataSource1_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource1.Updating
        'EC.sp_Update1Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource3_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource3.Updating
        'EC.sp_Update2Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource4_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource4.Updating
        'EC.sp_Update3Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub


    Protected Sub SqlDataSource5_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource5.Updating
        'EC.sp_Update4Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource7_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource7.Updating


        'EC.sp_Update5Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub SqlDataSource9_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource9.Updating
        'EC.sp_Update6Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub



    Protected Sub SqlDataSource10_Updating(ByVal sender As Object, e As SqlDataSourceCommandEventArgs) Handles SqlDataSource10.Updating
        'EC.sp_Update7Review_Coaching_Log 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Private Function GetRecordStatusLevel(moduleName As String, recordStatus As String)
        Dim retValue As String = String.Empty

        Select Case moduleName
            Case "CSR", "Training"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Supervisor Review"
                        retValue = 2
                    Case "Pending Manager Review"
                        retValue = 3
                    Case "Pending Acknowledgement"
                        retValue = 4
                End Select

            Case "Supervisor"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Manager Review"
                        retValue = 2
                    Case "Pending Sr. Manager Review"
                        retValue = 3
                    Case "Pending Acknowledgement"
                        retValue = 4
                End Select

            Case "Quality"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Quality Lead Review"
                        retValue = 2
                    Case "Pending Deputy Program Manager Review"
                        retValue = 3
                    Case "Pending Acknowledgement"
                        retValue = 4
                End Select

            Case "LSA"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Supervisor Review"
                        retValue = 2
                End Select

            Case "Program Analyst"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Supervisor Review"
                        retValue = 2
                End Select

            Case "Administration"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Supervisor Review"
                        retValue = 2
                End Select

            Case "Analytics Reporting"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Supervisor Review"
                        retValue = 2
                End Select

            Case "Production Planning"
                Select Case recordStatus
                    Case "Pending Employee Review"
                        retValue = 1
                    Case "Pending Supervisor Review"
                        retValue = 2
                End Select

        End Select

        Return retValue
    End Function
End Class
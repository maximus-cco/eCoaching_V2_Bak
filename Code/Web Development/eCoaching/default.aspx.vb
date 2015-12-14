Public Class _default
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            HandlePageNonPostBack()
        End If
    End Sub

    ' called on page none post back but after authentication is successful
    Public Sub HandlePageNonPostBack()
        Dim eclUser As User = Session("eclUser")
        Dim eclHandler As ECLHandler = New ECLHandler()

        ' Check if ARC user.
        ' Result is stored in Label2.Text: 0 means not ARC user; non 0 means ARC user.
        ' This needs to be moved to BLL and DLL.
        SqlDataSource2.SelectParameters("nvcLanID").DefaultValue = eclUser.LanID
        SqlDataSource2.SelectParameters("nvcRole").DefaultValue = "ARC"
        GridView2.DataSourceID = "SqlDataSource2"
        GridView2.DataBind()

        ' New Submissions
        If eclHandler.IsNewSubmissionsAccessAllowed(eclUser, Label2.Text) Then
            NewSubmissionsTab.Visible = True
        End If

        ' My Dashboard
        If eclHandler.IsMyDashboardAccessAllowed(eclUser) Then
            MyDashboardTab.Visible = True
        End If

        ' My Submission
        If eclHandler.IsMySubmissionAccessAllowed(eclUser, Label2.Text) Then
            MySubmissionsTab.Visible = True
        End If

        ' Historical Dashboard
        If eclHandler.IsHistoricalDashboardPageAccessAllowed(eclUser) Then
            HistoricalTab.Visible = True
        End If

        ' Set active tab
        If NewSubmissionsTab.Visible Then
            ECLTabContainer.ActiveTabIndex = 0
        ElseIf MyDashboardTab.Visible Then
            ECLTabContainer.ActiveTabIndex = 1
        ElseIf MySubmissionsTab.Visible Then
            ECLTabContainer.ActiveTabIndex = 2
        Else
            ECLTabContainer.ActiveTabIndex = 3
        End If

    End Sub



    Protected Sub SqlDataSource2_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource2.Selecting
        'EC.sp_Check_AgentRole 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


    End Sub

    Protected Sub ARC_Selected(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs) Handles SqlDataSource2.Selected
        ' If (e.Command.Parameters("@Indirect@return_value").Value) Then
        'uncomment when there is an ARC check
        '  MsgBox(e.Command.Parameters("@Indirect@return_value"))
        ' MsgBox(e.Command.Parameters("@Indirect@return_value").Value)
        Label2.Text = e.Command.Parameters("@Indirect@return_value").Value

        'Else
        'Label2.Text = 0
        'End If

        'Label2.Text = e.Command.Parameters("@Indirect@return_value").Value
    End Sub

    'Protected Sub TabContainer1_ActiveTabChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TabContainer1.ActiveTabChanged
    'MsgBox(TabContainer1.ActiveTabIndex)
    '    If (TabContainer1.ActiveTabIndex = 0) Then
    'frame1.Attributes.Add("src", "warning.html")


    '   Dim iframe1 As New HtmlGenericControl
    '  iframe1.TagName = "iframe"
    ' iframe1.Attributes.Add("src", "view3.aspx")
    'TabContainer1.Tabs(0).HeaderText = "TestAssociateWithAccordion"
    'TabContainer1.Tabs(0).Controls.Add(iframe1)
    '   Else
    ' frame2.Attributes.Add("src", "warning.html")

    'Dim iframe2 As New HtmlGenericControl
    'iframe2.TagName = "iframe"
    'iframe2.Attributes.Add("src", "view3.aspx")
    'TabContainer1.Tabs(1).HeaderText = "TestAssociateWithAccordion"
    'TabContainer1.Tabs(1).Controls.Add(iframe2)
    '  End If
    ' End Sub
End Class
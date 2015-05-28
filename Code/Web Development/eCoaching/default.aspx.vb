Public Class _default
    Inherits System.Web.UI.Page

    Dim lan As String = LCase(User.Identity.Name) 'boulsh"
    Dim domain As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        Select Case True


            Case (InStr(1, lan, "vngt\", 1) > 0)
                lan = (Replace(lan, "vngt\", ""))
                domain = "LDAP://dc=vangent,dc=local"
            Case (InStr(1, lan, "ad\", 1) > 0)
                lan = (Replace(lan, "ad\", ""))
                domain = "LDAP://dc=ad,dc=local"

            Case Else
                ' MsgBox("2" & lan)
                Response.Redirect("error.aspx")

        End Select


        SqlDataSource1.SelectParameters("strUserin").DefaultValue = lan

        SqlDataSource1.DataBind()
        GridView1.DataBind()







        ' Try

        'subString1 = (CType(GridView1.Rows(0).FindControl("Job1"), Label).Text)
        Dim subString1 As String = DirectCast(GridView1.Rows(0).Cells(0).FindControl("Job1"), Label).Text



        If (InStr(1, subString1, "Unknown", 1) > 0) Then

            Label1.Text = "Error"
            subString1 = ""
            Response.Redirect("error.aspx")

        Else

            Dim subArray As Array

            subArray = Split(subString1, "$", -1, 1)

            Label1.Text = subArray(0) 'title


        End If





        Select Case True 'Label6a.Text


            Case (InStr(1, Label1.Text, "WACS0", 1) > 0)

                'no historical dashboard for CSRs of any kind
                ' TabPanel4.Visible = False

                'check to display My submissions and submission page

                ' If (Label1.Text = "WACS02") Then

                SqlDataSource2.SelectParameters("nvcLanID").DefaultValue = lan
                SqlDataSource2.SelectParameters("nvcRole").DefaultValue = "ARC"

                GridView2.DataBind()

                If (Label2.Text = 0) Then
                    '       MsgBox("test1")
                    TabPanel1.Visible = False
                    TabPanel3.Visible = False
                End If

                'Else

                'TabPanel1.Visible = False
                'TabPanel3.Visible = False

                'End If


            Case (InStr(1, Label1.Text, "40", 1) > 0), (InStr(1, Label1.Text, "50", 1) > 0), (InStr(1, Label1.Text, "60", 1) > 0), (InStr(1, Label1.Text, "70", 1) > 0), (InStr(1, Label1.Text, "WISO", 1) > 0), (InStr(1, Label1.Text, "WSTE", 1) > 0), (InStr(1, Label1.Text, "WSQE", 1) > 0), (InStr(1, Label1.Text, "WACQ", 1) > 0), (InStr(1, Label1.Text, "WPPM", 1) > 0), (InStr(1, Label1.Text, "WPSM", 1) > 0), (InStr(1, Label1.Text, "WEEX", 1) > 0), (InStr(1, Label1.Text, "WISY", 1) > 0), (InStr(1, Label1.Text, "WPWL51", 1) > 0)
                '"WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50", "WEEX"

                TabPanel4.Visible = True


            Case (InStr(1, Label1.Text, "WHER", 1) > 0), (InStr(1, Label1.Text, "WHHR", 1) > 0)


                TabPanel1.Visible = False
                TabPanel2.Visible = False
                TabPanel3.Visible = False
                TabPanel4.Visible = True


        End Select



    End Sub




    Protected Sub SqlDataSource1_Selecting(ByVal sender As Object, e As SqlDataSourceSelectingEventArgs) Handles SqlDataSource1.Selecting
        'EC.sp_Whoami 

        e.Command.CommandTimeout = 300 'wait 5 minutes modify the command sql timeout


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
Public Class view4
    Inherits BasePage

    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim backDate As String = DateAdd("D", -30, TodaysDate).ToShortDateString()

    Public Overrides Sub HandlePageDisplay()
    End Sub

    Public Overrides Sub Initialize()
        InitDropdowns()

        Date1.Text = backDate
        Date2.Text = TodaysDate
        Label6a.Text = TryCast(Session("eclUser"), User).JobCode
        Select Case True 'Label6a.Text
            Case (InStr(1, Label6a.Text, "40", 1) > 0), (InStr(1, Label6a.Text, "50", 1) > 0), (InStr(1, Label6a.Text, "60", 1) > 0), (InStr(1, Label6a.Text, "70", 1) > 0), (InStr(1, Label6a.Text, "WISO", 1) > 0), (InStr(1, Label6a.Text, "WSTE", 1) > 0), (InStr(1, Label6a.Text, "WSQE", 1) > 0), (InStr(1, Label6a.Text, "WACQ", 1) > 0), (InStr(1, Label6a.Text, "WPPM", 1) > 0), (InStr(1, Label6a.Text, "WPSM", 1) > 0), (InStr(1, Label6a.Text, "WEEX", 1) > 0), (InStr(1, Label6a.Text, "WISY", 1) > 0), (InStr(1, Label6a.Text, "WPWL51", 1) > 0), (InStr(1, Label6a.Text, "WHER", 1) > 0), (InStr(1, Label6a.Text, "WHHR", 1) > 0),
                 (InStr(1, Label6a.Text, "WHRC", 1) > 0)
                '"WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50", "WEEX"
                Label26.Text = "Welcome to the Historical Reporting Dashboard"

                CalendarExtender1.EndDate = TodaysDate
                CalendarExtender2.EndDate = TodaysDate
            Case Else
                Response.Redirect("error.aspx")
        End Select
    End Sub

    Private Sub InitDropdowns()
        Dim historicalDashoardHandler As HistoricalDashboardHandler = New HistoricalDashboardHandler()

        BindAllSitesDropdown(historicalDashoardHandler.GetAllSites())

        BindCSRsDropdown(historicalDashoardHandler.GetAllCSRs())
        BindSupervisorsDropdown(historicalDashoardHandler.GetAllSupervisors())
        BindManagersDropdown(historicalDashoardHandler.GetAllManagers())

        BindAllSubmittersDropdown(historicalDashoardHandler.GetAllSubmitters())
        BindAllStatusesDropdown(historicalDashoardHandler.GetAllStatuses())
        BindAllSourcesDropdown(historicalDashoardHandler.GetAllSources(TryCast(Session("eclUser"), User).LanID))
        BindAllValuesDropdown(historicalDashoardHandler.GetAllValues())
    End Sub

    Private Sub BindAllSitesDropdown(ByRef allSites As DataTable)
        ddSite.DataSource = allSites
        ddSite.DataTextField = "SiteText"
        ddSite.DataValueField = "SiteValue"
        ddSite.DataBind()
    End Sub

    Private Sub BindCSRsDropdown(ByRef CSRs As DataTable)
        ddCSR.DataSource = CSRs
        ddCSR.DataTextField = "CSRText"
        ddCSR.DataValueField = "CSRValue"
        ddCSR.DataBind()
    End Sub

    Private Sub BindSupervisorsDropdown(ByRef supervisors As DataTable)
        ddSUP.DataSource = supervisors
        ddSUP.DataTextField = "SUPText"
        ddSUP.DataValueField = "SUPValue"
        ddSUP.DataBind()
    End Sub

    Private Sub BindManagersDropdown(ByRef managers As DataTable)
        ddMGR.DataSource = managers
        ddMGR.DataTextField = "MGRText"
        ddMGR.DataValueField = "MGRValue"
        ddMGR.DataBind()
    End Sub

    Private Sub BindAllSubmittersDropdown(ByRef submitters As DataTable)
        ddSubmitter.DataSource = submitters
        ddSubmitter.DataTextField = "SubmitterText"
        ddSubmitter.DataValueField = "SubmitterValue"
        ddSubmitter.DataBind()
    End Sub

    Private Sub BindAllStatusesDropdown(ByRef statuses As DataTable)
        ddStatus.DataSource = statuses
        ddStatus.DataTextField = "StatusText"
        ddStatus.DataValueField = "StatusValue"
        ddStatus.DataBind()
    End Sub

    Private Sub BindAllSourcesDropdown(ByRef sources As DataTable)
        ddSource.DataSource = sources
        ddSource.DataTextField = "SourceText"
        ddSource.DataValueField = "SourceValue"
        ddSource.DataBind()
    End Sub

    Private Sub BindAllValuesDropdown(ByRef values As DataTable)
        ddValue.DataSource = values
        ddValue.DataTextField = "ValueText"
        ddValue.DataValueField = "ValueValue"
        ddValue.DataBind()
    End Sub

    Protected Sub ddSite1_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddSite.SelectedIndexChanged
        Dim historicalDashboardHandler As HistoricalDashboardHandler = New HistoricalDashboardHandler()
        If ddSite.SelectedValue = "%" Then
            BindCSRsDropdown(historicalDashboardHandler.GetAllCSRs())
            BindSupervisorsDropdown(historicalDashboardHandler.GetAllSupervisors())
            BindManagersDropdown(historicalDashboardHandler.GetAllManagers())
        Else
            BindCSRsDropdown(historicalDashboardHandler.GetCSRsBySite(ddSite.SelectedValue))
            BindSupervisorsDropdown(historicalDashboardHandler.GetSupervisorsBySite(ddSite.SelectedValue))
            BindManagersDropdown(historicalDashboardHandler.GetManagersBySite(ddSite.SelectedValue))
        End If
    End Sub

    Protected Function newDisplay(ByVal indicator As DateTime) As String
        If (DateDiff("D", indicator, TodaysDate) < 1) Then
            Return ("&nbsp;&nbsp;New!&nbsp;")
        Else
            Return ("")
        End If
    End Function

    Protected Function newDisplay2(ByVal indicator As DateTime) As String
        If (DateDiff("D", indicator, TodaysDate) < 1) Then
            Return ("True")
        Else
            Return ("False")
        End If
    End Function

    Protected Function oLink(ByVal indicator As String) As String
        If (indicator = "Warning") Then
            Return ("review3.aspx?id={0}")
        Else
            Return ("review2.aspx?id={0}")
        End If
    End Function

    Private Function GetSortDirection(ByVal column As String) As String
        Dim sortDirection = "ASC"
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            If sortExpression = column Then
                Dim lastDirection = TryCast(ViewState("SortDirection"), String)
                If lastDirection IsNot Nothing _
                    AndAlso lastDirection = "ASC" Then
                    sortDirection = "DESC"
                End If
            End If
        End If

        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column

        Return sortDirection
    End Function

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button1.Click
        If (Date1.Text = "") Then
            Date1.Text = backDate '"01/01/2011"
        End If

        If (Date2.Text = "") Then
            Date2.Text = TodaysDate
        End If

        GridView1.PageIndex = 0 ' reset to page 1
        DisplayDashboard()
    End Sub

    Protected Sub Dashboard_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound, GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.Footer Then
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = Session("totalCount") & " records"
        End If
    End Sub

    Protected Sub Dashboard_Sorting(sender As Object, e As GridViewSortEventArgs) Handles GridView1.Sorting
        HttpContext.Current.Session("sortExpression") = e.SortExpression
        HttpContext.Current.Session("sortDirection") = GetSortDirection(e.SortExpression)
        DisplayDashboard()
    End Sub

    Protected Sub Dashboard_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        GridView1.PageIndex = e.NewPageIndex
        HttpContext.Current.Items("pageIndexChangingTo") = e.NewPageIndex
        DisplayDashboard()
    End Sub

    Private Sub DisplayDashboard()
        LoadDashboard()
        GridView1.Visible = True
    End Sub

    Private Sub LoadDashboard()
        GridView1.DataSource = GetDashboardDataSource()
        GridView1.DataBind()
    End Sub

    Private Function GetDashboardDataSource() As ObjectDataSource
        Dim ods As ObjectDataSource = New ObjectDataSource()
        ods.EnablePaging = True
        ods.TypeName = "eCoachingFixed.HistoricalDashboardHandler"
        ods.SelectMethod = "GetRows"
        ods.SelectCountMethod = "GetTotalRowCount"
        ods.StartRowIndexParameterName = "startRowIndex"
        ods.MaximumRowsParameterName = "pageSize"

        ods.SelectParameters.Add("strSourcein", ddSource.SelectedValue)
        ods.SelectParameters.Add("strCSRSitein", ddSite.SelectedValue)
        ods.SelectParameters.Add("strCSRin", ddCSR.SelectedValue)
        ods.SelectParameters.Add("strSUPin", ddSUP.SelectedValue)
        ods.SelectParameters.Add("strMGRin", ddMGR.SelectedValue)
        ods.SelectParameters.Add("strSubmitterin", ddSubmitter.SelectedValue)
        ods.SelectParameters.Add("strSDatein", Date1.Text)
        ods.SelectParameters.Add("strEDatein", Date2.Text)
        ods.SelectParameters.Add("strStatusin", ddStatus.SelectedValue)
        ods.SelectParameters.Add("strjobcode", Label6a.Text)
        ods.SelectParameters.Add("strValue", ddValue.SelectedValue)

        ods.SelectParameters.Add("sortBy", HttpContext.Current.Session("sortExpression"))
        ods.SelectParameters.Add("sortDirection", HttpContext.Current.Session("sortDirection"))

        Return ods
    End Function

    Protected Sub ExportToExcelButton_Click(sender As Object, e As EventArgs) Handles ExportToExcelButton.Click
        Dim historicalDashboardHandler As HistoricalDashboardHandler = New HistoricalDashboardHandler()

        Response.Clear()
        Response.Buffer = True
        ' Needed for hiding Please Wait Modal dialog
        Response.AppendCookie(New HttpCookie("tokenValue", hiddenTokenId.Value))
        Response.Charset = "UTF-8"
        ' Give user option to open or save the excel file
        Response.AddHeader("content-disposition", "attachment;filename=" & historicalDashboardHandler.GetFileName())
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

        ' Write Excel Workbook to response outputstream
        historicalDashboardHandler.CreateExcel(GetHistoricalDashboardFilter()).Write(Response.OutputStream)
        Response.Flush()
        Response.End()
    End Sub

    Private Function GetHistoricalDashboardFilter() As HistoricalDashboardFilter
        Return New HistoricalDashboardFilter(
                                             ddSite.SelectedItem.Value,
                                             ddCSR.SelectedItem.Value,
                                             ddSUP.SelectedItem.Value,
                                             ddMGR.SelectedItem.Value,
                                             ddSubmitter.SelectedItem.Value,
                                             ddSite.SelectedItem.Text,
                                             ddCSR.SelectedItem.Text,
                                             ddSUP.SelectedItem.Text,
                                             ddMGR.SelectedItem.Text,
                                             ddSubmitter.SelectedItem.Text,
                                             ddStatus.SelectedItem.Value,
                                             ddSource.SelectedItem.Value,
                                             ddValue.SelectedItem.Value,
                                             If(String.IsNullOrEmpty(Date1.Text), backDate, Date1.Text),
                                             If(String.IsNullOrEmpty(Date2.Text), TodaysDate, Date2.Text)
                                            )
    End Function

End Class

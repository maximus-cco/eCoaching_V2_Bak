Public Class view4
    Inherits BasePage

    Private historicalDashoardHandler As HistoricalDashboardHandler

    Dim TodaysDate As String = DateTime.Today.ToShortDateString()
    Dim backDate As String = DateAdd("D", -30, TodaysDate).ToShortDateString()

    Protected Sub Page_PreLoad(sender As Object, e As System.EventArgs) Handles Me.PreLoad
        If historicalDashoardHandler Is Nothing Then
            historicalDashoardHandler = New HistoricalDashboardHandler()
        End If

        ' ajax call
        If ScriptManager.GetCurrent(Page).IsInAsyncPostBack() Then
            Dim eventTarget As String = Page.Request.Params.Get("__EVENTTARGET")
            If (Not String.IsNullOrEmpty(eventTarget)) Then
                Dim ctrl As Control = Page.FindControl(eventTarget)
                ' ajax call fired by the site dropdownlist
                If ctrl.ID = "ddSite" Then
                    ' viewstate for CSR, Supervisor, and Manger dropdownlists are disabled
                    ' need to re-load them
                    BindSiteRelatedDropdowns()
                End If ' end of ddSite
            End If ' end of eventTarget not null
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            HandlePageNonPostBack()
        End If
    End Sub

    ' called on page non post back but after authentication is successful
    Public Sub HandlePageNonPostBack()
        StartDate.Text = backDate
        EndDate.Text = TodaysDate
        Dim jobCode As String = TryCast(Session("eclUser"), User).JobCode
        Select Case True 'jobCode
            Case (InStr(1, jobCode, "40", 1) > 0), (InStr(1, jobCode, "50", 1) > 0), (InStr(1, jobCode, "60", 1) > 0), (InStr(1, jobCode, "70", 1) > 0), (InStr(1, jobCode, "WISO", 1) > 0), (InStr(1, jobCode, "WSTE", 1) > 0), (InStr(1, jobCode, "WSQE", 1) > 0), (InStr(1, jobCode, "WACQ", 1) > 0), (InStr(1, jobCode, "WPPM", 1) > 0), (InStr(1, jobCode, "WPSM", 1) > 0), (InStr(1, jobCode, "WEEX", 1) > 0), (InStr(1, jobCode, "WISY", 1) > 0), (InStr(1, jobCode, "WPWL51", 1) > 0), (InStr(1, jobCode, "WHER", 1) > 0), (InStr(1, jobCode, "WHHR", 1) > 0),
                 (InStr(1, jobCode, "WHRC", 1) > 0)
                '"WACS40", "WMPR40", "WPPT40", "WSQA40", "WTTR40", "WTTR50", "WPSM11", "WPSM12", "WPSM13", "WPSM14", "WPSM15", "WACS50", "WACS60", "WFFA60", "WPOP50", "WPOP60", "WPPM50", "WPPM60", "WPPT50", "WPPT60", "WSQA50", "WSQA70", "WPPM70", "WPPM80", "WEEX90", "WEEX91", "WISO11", "WISO13", "WISO14", "WSTE13", "WSTE14", "WSQE14", "WSQE15", "WBCO50", "WEEX"
                WelcomeLabel.Text = "Welcome to the Historical Reporting Dashboard"

                CalendarExtender1.EndDate = TodaysDate
                CalendarExtender2.EndDate = TodaysDate
            Case Else
                Response.Redirect("error.aspx")
        End Select

        BindAllDropdownsToAllSites()
    End Sub

    ' Bind all dropdowns - Sites, CSRs, Supervisors, Managers, Submittiters, Statuses, Sources, Values
    Private Sub BindAllDropdownsToAllSites()
        BindDropdown(ddSite, "SiteName", "SiteID", historicalDashoardHandler.GetAllSites())
        BindDropdown(ddCSR, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllCSRs())
        BindDropdown(ddSUP, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllSupervisors())
        BindDropdown(ddMGR, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllManagers())
        BindDropdown(ddSubmitter, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllSubmitters())
        BindDropdown(ddStatus, "StatusText", "StatusID", historicalDashoardHandler.GetAllStatuses())
        BindDropdown(ddSource, "SourceText", "SourceID", historicalDashoardHandler.GetAllSources(TryCast(Session("eclUser"), User).LanID))
        BindDropdown(ddValue, "ValueText", "ValueID", historicalDashoardHandler.GetAllValues())
    End Sub

    Private Sub BindDropdown(dropDown As DropDownList, text As String, value As String, list As IEnumerable(Of Object))
        dropDown.DataTextField = text
        dropDown.DataValueField = value
        dropDown.DataSource = list
        dropDown.DataBind()
    End Sub

    Private Sub BindSiteRelatedDropdowns()
        Dim siteID As String = ddSite.SelectedValue
        If siteID = "%" Then
            BindDropdown(ddCSR, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllCSRs())
            BindDropdown(ddSUP, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllSupervisors())
            BindDropdown(ddMGR, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetAllManagers())
        Else
            BindDropdown(ddCSR, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetCSRsBySite(siteID))
            BindDropdown(ddSUP, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetSupervisorsBySite(siteID))
            BindDropdown(ddMGR, "EmployeeName", "EmployeeID", historicalDashoardHandler.GetManagersBySite(siteID))
        End If
    End Sub

    Protected Function newDisplay(indicator As DateTime) As String
        If (DateDiff("D", indicator, TodaysDate) < 1) Then
            Return ("&nbsp;&nbsp;New!&nbsp;")
        Else
            Return ("")
        End If
    End Function

    Protected Function newDisplay2(indicator As DateTime) As String
        If (DateDiff("D", indicator, TodaysDate) < 1) Then
            Return ("True")
        Else
            Return ("False")
        End If
    End Function

    Protected Function oLink(indicator As String) As String
        If (indicator = "Warning") Then
            Return ("review3.aspx?id={0}")
        Else
            Return ("review2.aspx?id={0}")
        End If
    End Function

    Private Function GetSortDirection(column As String) As String
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

    Protected Sub ApplyButton_Click(sender As Object, e As EventArgs) Handles ApplyButton.Click
        If (StartDate.Text = "") Then
            StartDate.Text = backDate ' today's date minus 30 days
        End If

        If (EndDate.Text = "") Then
            EndDate.Text = TodaysDate
        End If

        ResetDashboard()
        DisplayDashboard()
    End Sub

    Private Sub ResetDashboard()
        GridView1.DataSource = Nothing
        ' reset to page 1
        GridView1.PageIndex = 0
        ViewState("SortDirection") = Nothing
        ViewState("SortExpression") = Nothing
        Session("sortDirection") = Nothing
        Session("sortExpression") = Nothing
        Session("totalCount") = Nothing
    End Sub

    Protected Sub Dashboard_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound, GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.Footer Then
            DirectCast(e.Row.FindControl("lblTotal"), Label).Text = Session("totalCount") & " records"
        End If
    End Sub

    Protected Sub Dashboard_Sorting(sender As Object, e As GridViewSortEventArgs) Handles GridView1.Sorting
        Session("sortExpression") = e.SortExpression
        Session("sortDirection") = GetSortDirection(e.SortExpression)
        DisplayDashboard()
    End Sub

    Protected Sub Dashboard_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        GridView1.PageIndex = e.NewPageIndex
        DisplayDashboard()
    End Sub

    Private Sub DisplayDashboard()
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
        ods.SelectParameters.Add("strCSRin", ddCSRSelectedValueHidden.Value)
        ods.SelectParameters.Add("strSUPin", ddSUPSelectedValueHidden.Value)
        ods.SelectParameters.Add("strMGRin", ddMGRSelectedValueHidden.Value)
        ods.SelectParameters.Add("strSubmitterin", ddSubmitter.SelectedValue)
        ods.SelectParameters.Add("strSDatein", StartDate.Text)
        ods.SelectParameters.Add("strEDatein", EndDate.Text)
        ods.SelectParameters.Add("strStatusin", ddStatus.SelectedValue)
        ods.SelectParameters.Add("strjobcode", Session("eclUser").JobCode)
        ods.SelectParameters.Add("strValue", ddValue.SelectedValue)
        ods.SelectParameters.Add("sortBy", Session("sortExpression"))
        ods.SelectParameters.Add("sortDirection", Session("sortDirection"))

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
                                             ddCSRSelectedValueHidden.Value,
                                             ddSUPSelectedValueHidden.Value,
                                             ddMGRSelectedValueHidden.Value,
                                             ddSubmitter.SelectedValue,
                                             ddSite.SelectedItem.Text,
                                             ddCSRSelectedTextHidden.Value,
                                             ddSUPSelectedTextHidden.Value,
                                             ddMGRSelectedTextHidden.Value,
                                             ddSubmitter.SelectedItem.Text,
                                             ddStatus.SelectedValue,
                                             ddSource.SelectedValue,
                                             ddValue.SelectedValue,
                                             If(String.IsNullOrEmpty(StartDate.Text), backDate, StartDate.Text),
                                             If(String.IsNullOrEmpty(EndDate.Text), TodaysDate, EndDate.Text)
                                            )
    End Function
End Class

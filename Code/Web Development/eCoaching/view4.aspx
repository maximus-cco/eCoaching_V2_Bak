<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master"
    CodeBehind="view4.aspx.vb" Inherits="eCoachingFixed.view4" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <br />
    <asp:Label ID="WelcomeLabel" runat="server" CssClass="dashHead"></asp:Label>
    <br />
    <input type="hidden" id="hiddenTokenId" runat="server" class="hidden-token-class"/>
    <asp:HiddenField ID="ddCSRSelectedValueHidden" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="ddCSRSelectedTextHidden" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="ddSUPSelectedValueHidden" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="ddSUPSelectedTextHidden" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="ddMGRSelectedValueHidden" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="ddMGRSelectedTextHidden" runat="server" ClientIDMode="Static" />

    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" AsyncPostBackTimeout="1200">
    </asp:ToolkitScriptManager>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" DisplayAfter="0" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                    <div style="text-align: center;">
                        loading...<br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" style="width: 180px" /></div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <br />
            <%= DateTime.Now.ToString() %>
            <br />
            <asp:Panel ID="FilterPanel" runat="server">
                <asp:DropDownList ID="ddSite" AutoPostBack="true" runat="server" class="TextBox" Style="margin-right: 5px;"></asp:DropDownList>
                <asp:DropDownList ID="ddCSR" runat="server" class="TextBox" Style="margin-right: 5px;" EnableViewState="false"></asp:DropDownList>
                <asp:DropDownList ID="ddSUP" runat="server" class="TextBox" Style="margin-right: 5px;" EnableViewState="false"></asp:DropDownList>
                <asp:DropDownList ID="ddMGR" runat="server" class="TextBox" Style="margin-right: 5px;" EnableViewState="false"></asp:DropDownList>
                <asp:DropDownList ID="ddSubmitter" runat="server" class="TextBox" Style="margin-right: 5px;"  EnableViewState="true"></asp:DropDownList>
                <asp:DropDownList ID="ddStatus" runat="server" class="TextBox" Style="margin-right: 5px;"  EnableViewState="true"></asp:DropDownList>
                <asp:DropDownList ID="ddSource" runat="server" class="TextBox" Style="margin-right: 5px;"  EnableViewState="true"></asp:DropDownList>
                <asp:DropDownList ID="ddValue" runat="server" class="TextBox" Style="margin-right: 5px;"  EnableViewState="true"></asp:DropDownList>
                <asp:Label ID="Label6" runat="server" Text="Submitted: "></asp:Label>
                <asp:TextBox runat="server" class="TextBox" ID="StartDate" Width="100px" ClientIDMode="Static" />&nbsp;
                <asp:Image runat="server" ID="cal1" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="true" TargetControlID="StartDate" PopupButtonID="cal1"></asp:CalendarExtender>
                <asp:TextBox runat="server" class="TextBox" ID="EndDate" Width="100px" ClientIDMode="Static" />&nbsp;
                <asp:Image runat="server" ID="cal2" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender2" runat="server" Enabled="true" TargetControlID="EndDate" PopupButtonID="cal2"></asp:CalendarExtender>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
        <ContentTemplate>            
            <asp:UpdateProgress ID="UpdateProgress2" runat="server" DynamicLayout="true" DisplayAfter="0" AssociatedUpdatePanelID="UpdatePanel2">
                <ProgressTemplate> 
                    <div style="text-align: center;">
                        searching...<br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" style="width: 180px" /></div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <br />

            <%= DateTime.Now.ToString() %>

            <asp:Panel id="Panel2" runat="server">                 
                <asp:Button ID="ApplyButton" runat="server" Text="Apply" CssClass="formButton" onClientClick="return setDropdownHiddenValues(); "></asp:Button>
                <asp:Button ID="ExportToExcelButton" runat="server" CssClass="formButton" Text="Export to Excel" onClientClick="return validateDateRange();"></asp:Button>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    EnableModelValidation="True" ForeColor="#333333" GridLines="Vertical" Width="90%"
                    AllowSorting="True" AllowPaging="True" PageSize="50" ShowFooter="True" Visible="true"
                    EnableViewState="false">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Eval("RowNumber") %></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("FormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("FormID", oLink(Eval("Source").toString)) %>'
                                    Text='<%# Eval("FormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge"></asp:HyperLink>
                                &nbsp;&nbsp;<asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png"
                                    AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
                                        ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>'
                                        Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(Server.HtmlDecode("EmployeeName"))%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("SupervisorName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("ManagerName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="Submitter Name" SortExpression="strSubmitterName" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("SubmitterName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source" SortExpression="strSource" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("Source") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="ReasonList" runat="server" DataSource='<%# Eval("CoachingReasons") %>' EnableViewState="false">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Container.DataItem %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="SubReasonList" runat="server" DataSource='<%# Eval("CoachingSubReasons") %>' EnableViewState="false">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Container.DataItem %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="ValueList" runat="server" DataSource='<%# Eval("Values") %>' EnableViewState="false">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Container.DataItem %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="Label11" runat="server" Text='<%# Eval("SubmittedDate") %>' ></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
            </asp:Panel>
        </ContentTemplate>

        <Triggers>
            <asp:PostBackTrigger ControlID="ExportToExcelButton" />
        </Triggers>

    </asp:UpdatePanel>


    <div id="invalidDateRangeModal" class="modal fade" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Invalid Date Range</h4>
                </div>
                <div class="modal-body">
                    Please narrow down your searching time range.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

<script type="text/javascript">

    function setDropdownHiddenValues() {
        $('#ddCSRSelectedValueHidden').val($('#<%= ddCSR.ClientID %>').val());
        $('#ddCSRSelectedTextHidden').val($('#<%= ddCSR.ClientID %> option:selected').text());
        $('#ddSUPSelectedValueHidden').val($('#<%= ddSUP.ClientID%>').val());
        $('#ddSUPSelectedTextHidden').val($('#<%= ddSUP.ClientID%> option:selected').text());
        $('#ddMGRSelectedValueHidden').val($('#<%= ddMGR.ClientID%>').val());
        $('#ddMGRSelectedTextHidden').val($('#<%= ddMGR.ClientID%> option:selected').text());
    }
</script>

</asp:Content>

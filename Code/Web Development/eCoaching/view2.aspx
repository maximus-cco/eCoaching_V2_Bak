<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master"
    CodeBehind="view2.aspx.vb" Inherits="eCoachingFixed.view2" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <br />
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="1200"></asp:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" DisplayAfter="0">
                <ProgressTemplate>
                    <div style="text-align: center;">
                        loading...
                        <br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" style="width: 180px" />
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <asp:Label ID="Label26" runat="server" CssClass="dashHead"></asp:Label>
            <br />
            <asp:Label ID="Label6a" runat="server" Text='' Visible="false"></asp:Label>
            <br />
            <asp:SqlDataSource ID="SqlDataSource41" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="SRMGR_Selected"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <SelectParameters>
                    <asp:Parameter Name="nvcLanID" Type="String" />
                    <asp:Parameter Name="nvcRole" Type="String" />
                    <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView12" runat="server" DataSourceID="SqlDataSource41" Visible="true"></asp:GridView>
            <asp:Label ID="Label241" runat="server" Text="" Visible="false"></asp:Label>
            <asp:Panel ID="Panel1" runat="server" Visible="false">
                <asp:Label ID="Label5" runat="server" Text="My Pending eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:GridView ID="GridView3" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                    CellPadding="4" DataSourceID="SqlDataSource3" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" Enabled="True" ShowFooter="true" OnRowDataBound="GridView3_Bound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>  
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' 
                                    onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="lblCoachingReasonSupPending" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="lblSubCoachingReasonSupPending" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:Label ID="lblValueSupPending" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label8" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label13" runat="server" CssClass="nodata" Text="There are no pending items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_SUPPending" SelectCommandType="StoredProcedure"
                    ViewStateMode="Disabled" EnableViewState="False">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource29" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label8" runat="server" Text="My Team's Pending eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:Label ID="Label20" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddCSR3" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource10" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSource3" DataTextField="SourceText" DataValueField="SourceValue"
                    AutoPostBack="true" runat="server" DataSourceID="SqlDataSource27" class="TextBox"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSupDistinctCSRTeam" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource27" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Sources_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView6" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    DataSourceID="SqlDataSource6" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" AllowSorting="True" Enabled="True" AllowPaging="True"
                    PageSize="20">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source" SortExpression="strSource">
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("strSource") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonSupTeamPending" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonSupTeamPending" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueSupTeamPending" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label10" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no pending items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_SUPCSRPending" SelectCommandType="StoredProcedure"
                    ViewStateMode="Enabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR3" Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strSourcein" Type="String" ControlID="ddSource3" Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource32" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label9" runat="server" Text="My Team's Completed eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:Label ID="Label19" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddMGR2" DataTextField="MGRText" DataValueField="MGRValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource7" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddCSR2" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource11" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSource4" DataTextField="SourceText" DataValueField="SourceValue"
                    AutoPostBack="true" runat="server" DataSourceID="SqlDataSource28" class="TextBox"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:Label ID="Label7" runat="server" Text="Submitted: "></asp:Label>
                <asp:TextBox runat="server" class="TextBox" ID="Date3" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal3" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender3" runat="server" Enabled="true" TargetControlID="Date3" PopupButtonID="cal3"></asp:CalendarExtender>
                <asp:TextBox runat="server" class="TextBox" ID="Date4" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal4" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender4" runat="server" Enabled="true" TargetControlID="Date4" PopupButtonID="cal4"></asp:CalendarExtender>
                <asp:Button ID="Button2" runat="server" Text="Go" CssClass="formButton" />
                <asp:SqlDataSource ID="SqlDataSource11" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSupDistinctCSRTeamCompleted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSupDistinctMGRTeamCompleted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource28" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Sources_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView8" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    DataSourceID="SqlDataSource9" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" AllowSorting="True" Enabled="True" AllowPaging="True"
                    PageSize="20" ShowFooter="true" OnRowDataBound="GridView8_Bound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source" SortExpression="strSource">
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("strSource") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonMgrTeamCompleted" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonMgrTeamCompleted" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueMgrTeamCompleted" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label10" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_SUPCSRCompleted" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                        <asp:Parameter Name="strSDatein" Type="String" />
                        <asp:Parameter Name="strEDatein" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR2"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRMGRin" Type="String" ControlID="ddMGR2"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strSourcein" Type="String" ControlID="ddSource4"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource33" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label11" runat="server" Text="My Completed eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:GridView ID="GridView10" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource17" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True" AllowPaging="True"
                    PageSize="20">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonCsrCompleted" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonCsrCompleted" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueCsrCompleted" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label16" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource17" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_CSRCompleted" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRin" Type="String" DefaultValue="%" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource34" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:Panel ID="Panel4" runat="server" Visible="false">
                    <p>
                        &nbsp;
                    </p>
                    <asp:Label ID="Label27" runat="server" Text="My Team's Warning eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                    <br />
                    <asp:Label ID="Label29" runat="server" Text="Filter: " Visible="True"></asp:Label>
                    <asp:DropDownList ID="ddState7" DataTextField="StateText" DataValueField="StateValue"
                        DataSourceID="SqlDataSource31" AutoPostBack="true" runat="server" class="TextBox"
                        Style="margin-right: 5px;">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource31" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_States_For_Dashboard" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    </asp:SqlDataSource>
                    <asp:Label ID="Label30" runat="server" Text="Submitted: "></asp:Label>
                    <asp:TextBox runat="server" class="TextBox" ID="Date7" Width="100px" />&nbsp;
                    <asp:Image runat="server" ID="cal7" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                    <asp:CalendarExtender ID="CalendarExtender5" runat="server" Enabled="true" TargetControlID="Date7" PopupButtonID="cal7"></asp:CalendarExtender>
                    <asp:TextBox runat="server" class="TextBox" ID="Date8" Width="100px" />&nbsp;
                    <asp:Image runat="server" ID="cal8" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                    <asp:CalendarExtender ID="CalendarExtender6" runat="server" Enabled="true" TargetControlID="Date8" PopupButtonID="cal8"></asp:CalendarExtender>
                    <asp:Button ID="Button3" runat="server" Text="Go" CssClass="formButton" />
                    <br />
                    <asp:GridView ID="GridView13" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataSourceID="SqlDataSource22" EnableModelValidation="True" Width="90%" CellPadding="4"
                        ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True" AllowPaging="True"
                        PageSize="20">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemTemplate>
                                    <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                                <ItemTemplate>
                                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review3.aspx?id={0}") %>'
                                        Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                        Target="vlarge">
                                    </asp:HyperLink>&nbsp;&nbsp;
                                    <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                    <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Warning Type" SortExpression="">
                                <ItemTemplate>
	                                <asp:Label ID="lblWarningTypeSupTeamCompleted" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Warning Reason(s)" SortExpression="">
                                <ItemTemplate>
                                    <asp:Label ID="lblWarningReasonSupTeamCompleted" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                                <ItemTemplate>
                                    <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                        <EmptyDataTemplate>
                            <asp:Label ID="Label16" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                        </EmptyDataTemplate>
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource22" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_SelectFrom_Warning_Log_SUPCSRCompleted" SelectCommandType="StoredProcedure"
                        EnableViewState="False" ViewStateMode="Disabled">
                        <SelectParameters>
                            <asp:Parameter Name="strCSRSUPin" Type="String" />
                            <asp:Parameter Name="strSDatein" Type="String" />
                            <asp:Parameter Name="strEDatein" Type="String" />
                            <asp:ControlParameter DefaultValue="%" Name="bitActive" Type="String" ControlID="ddState7" Direction="Input" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSource24" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_SelectReviewFrom_Warning_Log_Reasons" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader">
                        <SelectParameters>
                            <asp:Parameter Name="strFormIDin" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </asp:Panel>
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" Visible="false">
                <asp:Label ID="Label12" runat="server" Text="My Pending eCoaching Logs" ForeColor="#0099FF"
                    Visible="True"></asp:Label>
                <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource2" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonCsrPending" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonCsrPending" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueCsrPending" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label12" runat="server" CssClass="nodata" Text="There are no pending items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_CSRPending" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource35" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label4" runat="server" Text="My Completed eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource1" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True" AllowPaging="True"
                    PageSize="20">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonCsrCompleted" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonCsrCompleted" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueCsrCompleted" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label16" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_CSRCompleted" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRin" Type="String" DefaultValue="%" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource36" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
            <asp:Panel ID="Panel3" runat="server" Visible="false">
                <asp:Label ID="Label10" runat="server" Text="My Pending eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:Label ID="Label21" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddSUP1" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource14" runat="server" Style="margin-right: 5px;" class="TextBox">
                </asp:DropDownList>
                <asp:DropDownList ID="ddCSR1" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource13" runat="server" class="TextBox">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource13" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctCSR" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource14" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMGRDistinctSUP" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView9" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    DataSourceID="SqlDataSource4" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" Visible="True" AllowSorting="True" Enabled="True"
                    AllowPaging="True" ShowFooter="true" OnRowDataBound="GridView9_Bound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonMgrPending" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonMgrPending" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueMgrPending" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label8" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label14" runat="server" CssClass="nodata" Text="There are no pending items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MGRPending" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSUPin" Type="String" ControlID="ddSUP1"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR1"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource37" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label17" runat="server" Text="My Team's Pending eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label><br />
                <asp:Label ID="Label18" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddSUP3" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource21" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddCSR4" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource20" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSource2" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="SourceText" DataValueField="SourceValue" DataSourceID="SqlDataSource25"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource20" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctCSRTeam" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource21" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctSUPTeam" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource25" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Sources_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView5" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    DataSourceID="SqlDataSource5" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" ShowFooter="True" Visible="True" AllowSorting="True"
                    Enabled="True" AllowPaging="True" PageSize="20" OnRowDataBound="GridView5_Bound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source" SortExpression="strSource">
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("strSource") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonMgrTeamPending" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonMgrTeamPending" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueMgrTeamPending" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label10" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no pending items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MGRCSRPending" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR4"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSUPin" Type="String" ControlID="ddSUP3"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strSourcein" Type="String" ControlID="ddSource2"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource38" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label22" runat="server" Text="My Team's Completed eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:Label ID="Label23" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddSUP4" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource16" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddCSR5" DataTextField="EmpText" DataValueField="EmpValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource15" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSource" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="SourceText" DataValueField="SourceValue" DataSourceID="SqlDataSource26"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:Label ID="Label6" runat="server" Text="Submitted: "></asp:Label>
                <asp:TextBox runat="server" class="TextBox" ID="Date1" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal1" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="true" TargetControlID="Date1" PopupButtonID="cal1"></asp:CalendarExtender>
                <asp:TextBox runat="server" class="TextBox" ID="Date2" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal2" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender2" runat="server" Enabled="true" TargetControlID="Date2" PopupButtonID="cal2"></asp:CalendarExtender>
                <asp:Button ID="Button1" runat="server" Text="Go" CssClass="formButton" />
                <asp:SqlDataSource ID="SqlDataSource15" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctCSRTeamCompleted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource16" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctSUPTeamCompleted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource26" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Sources_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView7" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    DataSourceID="SqlDataSource8" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" Visible="True" AllowSorting="True" Enabled="True"
                    AllowPaging="true" PageSize="20" ShowFooter="True" OnRowDataBound="GridView7_Bound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source" SortExpression="strSource">
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("strSource") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblCoachingReasonMgrTeamCompleted" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblSubCoachingReasonMgrTeamCompleted" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="lblValueMgrTeamCompleted" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label10" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MGRCSRCompleted" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                        <asp:Parameter Name="strSDatein" Type="String" />
                        <asp:Parameter Name="strEDatein" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR5"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSUPin" Type="String" ControlID="ddSUP4"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strSourcein" Type="String" ControlID="ddSource"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource39" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label24" runat="server" Text="My Completed eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:GridView ID="GridView11" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource18" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True" AllowPaging="True"
                    PageSize="20">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="Label5" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
	                            <asp:Label ID="Label7" runat="server" Text='<%# Eval("strValue").ToString().Replace("|", "<br />") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label16" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource18" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_CSRCompleted" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRin" Type="String" DefaultValue="%" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource40" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:Panel ID="Panel5" runat="server" Visible="false">
                    <p>
                        &nbsp;
                    </p>
                    <asp:Label ID="Label28" runat="server" Text="My Team's Warning eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                    <br />
                    <asp:Label ID="Label31" runat="server" Text="Filter: " Visible="True"></asp:Label>
                    <asp:DropDownList ID="ddState" DataTextField="StateText" DataValueField="StateValue"
                        DataSourceID="SqlDataSource30" AutoPostBack="true" runat="server" class="TextBox"
                        Style="margin-right: 5px;">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource30" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_Select_States_For_Dashboard" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    </asp:SqlDataSource>
                    <asp:Label ID="Label32" runat="server" Text="Submitted: "></asp:Label>
                    <asp:TextBox runat="server" class="TextBox" ID="Date5" Width="100px" />&nbsp;
                    <asp:Image runat="server" ID="cal5" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                    <asp:CalendarExtender ID="CalendarExtender7" runat="server" Enabled="true" TargetControlID="Date5" PopupButtonID="cal5"></asp:CalendarExtender>
                    <asp:TextBox runat="server" class="TextBox" ID="Date6" Width="100px" />&nbsp;
                    <asp:Image runat="server" ID="cal6" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                    <asp:CalendarExtender ID="CalendarExtender8" runat="server" Enabled="true" TargetControlID="Date6" PopupButtonID="cal6"></asp:CalendarExtender>
                    <asp:Button ID="Button4" runat="server" Text="Go" CssClass="formButton" />
                    <br />
                    <asp:GridView ID="GridView14" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataSourceID="SqlDataSource23" EnableModelValidation="True" Width="90%" CellPadding="4"
                        ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True" AllowPaging="True"
                        PageSize="20">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemTemplate>
                                    <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                                <ItemTemplate>
                                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review3.aspx?id={0}") %>'
                                        Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                        Target="vlarge">
                                    </asp:HyperLink>&nbsp;&nbsp;
                                    <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                    <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee Name" SortExpression="strCSRName">
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strCSRName")) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strCSRSupName">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("strCSRSupName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Manager Name" SortExpression="strCSRMgrName">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("strCSRMgrName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Warning Type" SortExpression="">
                                <ItemTemplate>
	                                <asp:Label ID="lblWarningTypeMgrTeamCompleted" runat="server" Text='<%# Eval("strCoachingReason").ToString().Replace("|", "<br />") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Warning Reason(s)" SortExpression="">
                                <ItemTemplate>
	                                <asp:Label ID="lblWarningReasonMgrTeamCompleted" runat="server" Text='<%# Eval("strSubCoachingReason").ToString().Replace("|", "<br />") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                                <ItemTemplate>
                                    <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BackColor="#2461BF" />
                        <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                        <EmptyDataTemplate>
                            <asp:Label ID="Label16" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                        </EmptyDataTemplate>
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#EFF3FB" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource23" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_SelectFrom_Warning_Log_MGRCSRCompleted" SelectCommandType="StoredProcedure"
                        EnableViewState="False" ViewStateMode="Disabled">
                        <SelectParameters>
                            <asp:Parameter Name="strCSRMGRin" Type="String" />
                            <asp:Parameter Name="strSDatein" Type="String" />
                            <asp:Parameter Name="strEDatein" Type="String" />
                            <asp:ControlParameter DefaultValue="%" Name="bitActive" Type="String" ControlID="ddState"
                                Direction="Input" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDataSource19" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                        SelectCommand="EC.sp_SelectReviewFrom_Warning_Log_Reasons" SelectCommandType="StoredProcedure"
                        DataSourceMode="DataReader">
                        <SelectParameters>
                            <asp:Parameter Name="strFormIDin" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </asp:Panel>
            </asp:Panel>
            <asp:Panel ID="Panel6" runat="server" Visible="false">
                <p>
                    &nbsp;</p>
                <asp:Label ID="Label25" runat="server" Text="My Hierarchy eCoaching Logs" ForeColor="#0099FF"
                    Visible="True"></asp:Label><br />
                <asp:Label ID="Label33" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddMGR5" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="MGRText" DataValueField="MGRValue" DataSourceID="SqlDataSource43"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource43" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSrMgrDistinctMGRTeam" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSrMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:DropDownList ID="ddSUP5" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="SUPText" DataValueField="SUPValue" DataSourceID="SqlDataSource47"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource47" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSrMgrDistinctSUPTeam" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSrMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:DropDownList ID="ddEMP5" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="EMPText" DataValueField="EMPValue" DataSourceID="SqlDataSource48"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource48" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSrMgrDistinctCSRTeam" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSrMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:DropDownList ID="ddSource5" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="SourceText" DataValueField="SourceValue" DataSourceID="SqlDataSource44"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource44" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Sources_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:DropDownList ID="ddStatus5" AutoPostBack="true" runat="server" class="TextBox"
                    DataTextField="StatusText" DataValueField="StatusValue" DataSourceID="SqlDataSource42"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource42" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Statuses_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                </asp:SqlDataSource>
                <asp:Label ID="Label37" runat="server" Text="Submitted: "></asp:Label>
                <asp:TextBox runat="server" class="TextBox" ID="Date11" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal11" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender11" runat="server" Enabled="true" TargetControlID="Date11"
                    PopupButtonID="cal11">
                </asp:CalendarExtender>
                <asp:TextBox runat="server" class="TextBox" ID="Date12" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal12" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender12" runat="server" Enabled="true" TargetControlID="Date12"
                    PopupButtonID="cal12">
                </asp:CalendarExtender>
                <asp:Button ID="Button6" runat="server" Text="Go" CssClass="formButton" />

                <asp:GridView ID="GridView15" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    DataSourceID="SqlDataSource45" EnableModelValidation="True" ForeColor="#333333"
                    GridLines="Vertical" Width="90%" Visible="True" AllowSorting="True" Enabled="True"
                    AllowPaging="true" PageSize="20" ShowFooter="True" OnRowDataBound="GridView15_Bound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review2.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strEmpName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strEmpName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strEmpSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strEmpSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strEmpMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strEmpMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Source" SortExpression="strSource">
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("strSource") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("CoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist3" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("value") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label10" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource45" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_SRMGREmployeeCoaching" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strEMPSRMGRin" Type="String" />
                        <asp:Parameter Name="strSDatein" Type="String" />
                        <asp:Parameter Name="strEDatein" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strEMPMGRin" Type="String" ControlID="ddMGR5"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strEMPSUPin" Type="String" ControlID="ddSUP5"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strEMPin" Type="String" ControlID="ddEMP5"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strSourcein" Type="String" ControlID="ddSource5"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strStatus" Type="String" ControlID="ddStatus5"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource46" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;
                </p>
                <asp:Label ID="Label34" runat="server" Text="My Hierarchy Warning eCoaching Logs" ForeColor="#0099FF" Visible="True"></asp:Label>
                <br />
                <asp:Label ID="Label35" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddState6" DataTextField="StateText" DataValueField="StateValue"
                    DataSourceID="SqlDataSource49" AutoPostBack="true" runat="server" class="TextBox"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource49" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_States_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                </asp:SqlDataSource>
                <asp:Label ID="Label36" runat="server" Text="Submitted: "></asp:Label>
                <asp:TextBox runat="server" class="TextBox" ID="Date9" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal9" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender9" runat="server" Enabled="true" TargetControlID="Date9" PopupButtonID="cal9"></asp:CalendarExtender>
                <asp:TextBox runat="server" class="TextBox" ID="Date10" Width="100px" />&nbsp;
                <asp:Image runat="server" ID="cal10" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
                <asp:CalendarExtender ID="CalendarExtender10" runat="server" Enabled="true" TargetControlID="Date10" PopupButtonID="cal10"></asp:CalendarExtender>
                <asp:Button ID="Button5" runat="server" Text="Go" CssClass="formButton" />
                <br />
                <asp:GridView ID="GridView16" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource50" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="True" Enabled="True" AllowPaging="True"
                    PageSize="20">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:Label ID="index" runat="server"><%# Container.DataItemIndex + 1%></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name2" SortExpression="strFormID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("strFormID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FormID" SortExpression="strFormID">
                            <ItemTemplate>
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", "review3.aspx?id={0}") %>'
                                    Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                                    Target="vlarge">
                                </asp:HyperLink>&nbsp;&nbsp;
                                <asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' />
                                <asp:Label ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee Name" SortExpression="strEmpName">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval(server.htmldecode("strEmpName")) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supervisor Name" SortExpression="strEmpSupName">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("strEmpSupName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Manager Name" SortExpression="strEmpMgrName">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("strEmpMgrName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Warning Type" SortExpression="">
                            <ItemTemplate>
                                <asp:Label ID="Label6a" runat="server" Text='' />
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("CoachingReason") %>' Visible="false" />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Warning Reason(s)" SortExpression="">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                            <ItemTemplate>
                                <asp:Label ID="Label8" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>&nbsp;PDT
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EditRowStyle BackColor="#2461BF" />
                    <EmptyDataRowStyle BorderColor="#0066FF" BorderStyle="Solid" BorderWidth="1px" />
                    <EmptyDataTemplate>
                        <asp:Label ID="Label16" runat="server" CssClass="nodata" Text="There are no completed items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource50" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_SRMGREmployeeWarning" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strEMPSRMGRin" Type="String" />
                        <asp:Parameter Name="strSDatein" Type="String" />
                        <asp:Parameter Name="strEDatein" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="bitActive" Type="String" ControlID="ddState6" Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource51" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Warning_Log_Reasons" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

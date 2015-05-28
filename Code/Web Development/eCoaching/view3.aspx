<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master"
    CodeBehind="view3.aspx.vb" Inherits="eCoachingFixed.view3" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <br />
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="1200">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" DisplayAfter="0">
                <ProgressTemplate>
                    <div style="text-align: center;">
                        loading...<br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" style="width: 180px" /></div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <asp:Label ID="Label26" runat="server" CssClass="dashHead"></asp:Label>
            <br />
            <asp:Label ID="Label6a" runat="server" Text='' Visible="false"></asp:Label><br />
            <asp:SqlDataSource ID="SqlDataSource14" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="ARC_Selected"
                DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <SelectParameters>
                    <asp:Parameter Name="nvcLanID" Type="String" />
                    <asp:Parameter Name="nvcRole" Type="String" />
                    <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView5" runat="server" DataSourceID="SqlDataSource14" Visible="true">
            </asp:GridView>
            <asp:Label ID="Label241" runat="server" Text="" Visible="false"></asp:Label>
            <asp:SqlDataSource ID="SqlDataSource15" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                SelectCommand="EC.sp_Whoami" SelectCommandType="StoredProcedure" DataSourceMode="DataReader"
                EnableViewState="False" ViewStateMode="Disabled">
                <SelectParameters>
                    <asp:Parameter Name="strUserin" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView6" runat="server" DataSourceID="SqlDataSource15" AutoGenerateColumns="False"
                EnableModelValidation="True" Visible="false">
                <Columns>
                    <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Job" runat="server" Text='<%# Eval("Submitter") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Panel ID="Panel1" runat="server" Visible="false">
                <asp:Label ID="Label11" runat="server" Text="My Submitted eCoaching Logs" ForeColor="#0099FF"
                    Visible="True"></asp:Label><br />
                <asp:Label ID="Label14" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddMGR" DataTextField="MGRText" DataValueField="MGRValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource11" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSUP" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource12" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddStatus" DataTextField="StatusText" DataValueField="StatusValue"
                    DataSourceID="SqlDataSource16" AutoPostBack="true" runat="server" class="TextBox"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource16" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Statuses_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                </asp:SqlDataSource>
                <asp:DropDownList ID="ddCSR" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource10" runat="server" class="TextBox">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSupDistinctCSR" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource11" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSupDistinctMGR" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource12" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogSupDistinctSUP" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRSUPin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource7" EnableModelValidation="True" Width="90%" CellPadding="4"
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
                                    Target="vlarge"></asp:HyperLink>&nbsp;&nbsp;<asp:Image ID="Image1" runat="server"
                                        ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
                                            ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>'
                                            Visible="true"></asp:Label>
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
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("CoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist3" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("value") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
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
                        <asp:Label ID="Label7" runat="server" CssClass="nodata" Text="There are no submitted items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MySubmitted_DashboardSUP" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSupin" Type="String" ControlID="ddSUP"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRMgrin" Type="String" ControlID="ddMGR"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strStatusin" Type="String" ControlID="ddStatus"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource23" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" Visible="false">
                <asp:Label ID="Label8" runat="server" Text="My Submitted eCoaching Logs" ForeColor="#0099FF"
                    Visible="True"></asp:Label><br />
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
                                    Target="vlarge"></asp:HyperLink>&nbsp;&nbsp;<asp:Image ID="Image1" runat="server"
                                        ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
                                            ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>'
                                            Visible="true"></asp:Label>
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
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("CoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist3" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("value") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
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
                        <asp:Label ID="Label7" runat="server" CssClass="nodata" Text="There are no submitted items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MySubmitted_Dashboard" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource24" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
            <asp:Panel ID="Panel3" runat="server" Visible="false">
                <asp:Label ID="Label24" runat="server" Text="My Submitted eCoaching Logs" ForeColor="#0099FF"
                    Visible="True"></asp:Label><br />
                <asp:Label ID="Label25" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddMGR2" DataTextField="MGRText" DataValueField="MGRValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource19" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSUP2" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource22" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddStatus2" DataTextField="StatusText" DataValueField="StatusValue"
                    DataSourceID="SqlDataSource20" AutoPostBack="true" runat="server" class="TextBox"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource20" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_Select_Statuses_For_Dashboard" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                </asp:SqlDataSource>
                <asp:DropDownList ID="ddCSR2" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource18" runat="server" class="TextBox">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource18" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctCSRSubmitted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource19" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctMGRSubmitted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource22" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogMgrDistinctSUPSubmitted" SelectCommandType="StoredProcedure"
                    DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
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
                                    Target="vlarge"></asp:HyperLink>&nbsp;&nbsp;<asp:Image ID="Image1" runat="server"
                                        ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
                                            ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>'
                                            Visible="true"></asp:Label>
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
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("CoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist3" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("value") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
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
                        <asp:Label ID="Label7" runat="server" CssClass="nodata" Text="There are no submitted items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource17" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MySubmitted_DashboardMGR" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR2"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSupin" Type="String" ControlID="ddSUP2"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRMgrin" Type="String" ControlID="ddMGR2"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strStatusin" Type="String" ControlID="ddStatus2"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource21" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
            <asp:Panel ID="Panel4" runat="server" Visible="false">
                <asp:Label ID="Label9" runat="server" Text="My Submitted Pending eCoaching Logs"
                    ForeColor="#0099FF" Visible="false"></asp:Label><br />
                <asp:Label ID="Label10" runat="server" Text="Filter: "></asp:Label>
                <asp:DropDownList ID="ddMGR3" DataTextField="MGRText" DataValueField="MGRValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource4" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSUP3" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource3" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddEMP3" DataTextField="EmpText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource5" runat="server" class="TextBox">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogStaffDistinctPendingSUPSubmitted"
                    SelectCommandType="StoredProcedure" DataSourceMode="DataReader" EnableViewState="False"
                    ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogStaffDistinctPendingMGRSubmitted"
                    SelectCommandType="StoredProcedure" DataSourceMode="DataReader" EnableViewState="False"
                    ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogStaffDistinctPendingCSRSubmitted"
                    SelectCommandType="StoredProcedure" DataSourceMode="DataReader" EnableViewState="False"
                    ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource2" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="true" Enabled="True" AllowPaging="True"
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
                                    Target="vlarge"></asp:HyperLink>&nbsp;&nbsp;<asp:Image ID="Image1" runat="server"
                                        ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
                                            ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>'
                                            Visible="true"></asp:Label>
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
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("CoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist3" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("value") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
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
                        <asp:Label ID="Label7" runat="server" CssClass="nodata" Text="There are no submitted items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MyPenSubmitted_DashboardStaff" SelectCommandType="StoredProcedure"
                    EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddEMP3"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSupin" Type="String" ControlID="ddSUP3"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRMgrin" Type="String" ControlID="ddMGR3"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource26" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <p>
                    &nbsp;</p>
                <asp:Label ID="Label12" runat="server" Text="My Submitted Completed eCoaching Logs"
                    ForeColor="#0099FF" Visible="True"></asp:Label><br />
                <asp:Label ID="Label13" runat="server" Text="Filter: "></asp:Label>
                <asp:DropDownList ID="ddMGR4" DataTextField="MGRText" DataValueField="MGRValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource9" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSUP4" DataTextField="SUPText" DataValueField="SUPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource8" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddEMP4" DataTextField="EMPText" DataValueField="EMPValue" AutoPostBack="true"
                    DataSourceID="SqlDataSource13" runat="server" class="TextBox">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogStaffDistinctCompletedSUPSubmitted"
                    SelectCommandType="StoredProcedure" DataSourceMode="DataReader" EnableViewState="False"
                    ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogStaffDistinctCompletedMGRSubmitted"
                    SelectCommandType="StoredProcedure" DataSourceMode="DataReader" EnableViewState="False"
                    ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource13" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_LogStaffDistinctCompletedCSRSubmitted"
                    SelectCommandType="StoredProcedure" DataSourceMode="DataReader" EnableViewState="False"
                    ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strCSRMGRin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    DataSourceID="SqlDataSource6" EnableModelValidation="True" Width="90%" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" Visible="true" Enabled="True" AllowPaging="True"
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
                                    Target="vlarge"></asp:HyperLink>&nbsp;&nbsp;<asp:Image ID="Image1" runat="server"
                                        ImageUrl="images/1324418219_new.png" AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
                                            ID="Label182" runat="server" Text='<%# newDisplay(CDate(Eval("SubmittedDate"))) %>'
                                            Visible="true"></asp:Label>
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
                                <asp:DataList ID="Dlist1" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("CoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist2" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="Dlist3" runat="server">
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("value") %>' />
                                    </ItemTemplate>
                                </asp:DataList>
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
                        <asp:Label ID="Label7" runat="server" CssClass="nodata" Text="There are no submitted items to display."></asp:Label>
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectFrom_Coaching_Log_MyCompSubmitted_DashboardStaff"
                    SelectCommandType="StoredProcedure" EnableViewState="False" ViewStateMode="Disabled">
                    <SelectParameters>
                        <asp:Parameter Name="strUserin" Type="String" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddEMP4"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRSupin" Type="String" ControlID="ddSUP4"
                            Direction="Input" />
                        <asp:ControlParameter DefaultValue="%" Name="strCSRMgrin" Type="String" ControlID="ddMGR4"
                            Direction="Input" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource27" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
                    SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="strFormIDin" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

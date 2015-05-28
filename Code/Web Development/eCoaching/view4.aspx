<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master"
    CodeBehind="view4.aspx.vb" Inherits="eCoachingFixed.view4" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" AsyncPostBackTimeout="1200">
    </asp:ToolkitScriptManager>

    <br />
    <asp:Label ID="Label26" runat="server" CssClass="dashHead"></asp:Label>
    <br />

    <div style="float: right">
        <asp:Button ID="ExportButton" runat="server" CssClass="formButton" Text="Export to Excel" OnClientClick="blockUI();" OnClick="ExportButton_Click"/>
        <input type="hidden" id="hiddenTokenId" runat="server" class="hidden-token-class"/>
    </div>

    <br />
    <asp:Label ID="Label6a" runat="server" Text='' Visible="false"></asp:Label>
    <asp:Panel ID="Panel3" runat="server">
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_Whoami" SelectCommandType="StoredProcedure" DataSourceMode="DataReader"
            EnableViewState="False" ViewStateMode="Disabled">
            <SelectParameters>
                <asp:Parameter Name="strUserin" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:GridView ID="GridView3" runat="server" DataSourceID="SqlDataSource2" AutoGenerateColumns="False"
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
        <asp:Label ID="Label22" runat="server" Text="eCoaching Logs" ForeColor="#0099FF"
            Visible="True"></asp:Label><br />
        <asp:Label ID="Label23" runat="server" Text="Filter: " Visible="True"></asp:Label>
        <asp:DropDownList ID="ddSite" runat="server" DataTextField="SiteText" DataValueField="SiteValue"
            DataSourceID="SqlDataSource4" class="TextBox" Style="margin-right: 5px;"
            AutoPostBack="true">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_Select_Sites_For_Dashboard" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        </asp:SqlDataSource>

        <asp:DropDownList ID="ddCSR" DataTextField="CSRText" DataValueField="CSRValue"
            DataSourceID="SqlDataSource6" runat="server" class="TextBox" Style="margin-right: 5px;">                   
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted2" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource15" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctCSRCompleted" FilterExpression="strCSRSite Like '{0}' OR strCSRSite = '%'"
            SelectCommandType="StoredProcedure" DataSourceMode="DataSet" EnableViewState="True" 
            ViewStateMode="Enabled">
            <FilterParameters>
                <asp:ControlParameter Name="strCSRSite" ControlID="ddSite" PropertyName="SelectedValue"
                    Direction="Input" DefaultValue="%" />
            </FilterParameters>
        </asp:SqlDataSource>

        <asp:DropDownList ID="ddSUP" DataTextField="SUPText" DataValueField="SUPValue" DataSourceID="SqlDataSource7"
            runat="server" class="TextBox" Style="margin-right: 5px;">                    
        </asp:DropDownList>

        <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted2" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource12" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctSUPCompleted" FilterExpression="strCSRSite Like '{0}' OR strCSRSite = '%'"
            SelectCommandType="StoredProcedure" DataSourceMode="DataSet" EnableViewState="True"
            ViewStateMode="Enabled">
            <FilterParameters>
                <asp:ControlParameter Name="strCSRSite" ControlID="ddSite" PropertyName="SelectedValue"
                    Direction="Input" DefaultValue="%" />
            </FilterParameters>
        </asp:SqlDataSource>

        <asp:DropDownList ID="ddMGR" DataTextField="MGRText" DataValueField="MGRValue" DataSourceID="SqlDataSource9"
            runat="server" class="TextBox" Style="margin-right: 5px;">                    
        </asp:DropDownList>

        <asp:SqlDataSource ID="SqlDataSource9" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted2" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctMGRCompleted" FilterExpression="strCSRSite Like '{0}' OR strCSRSite = '%'"
            SelectCommandType="StoredProcedure" DataSourceMode="DataSet" EnableViewState="True"
            ViewStateMode="Enabled">
            <FilterParameters>
                <asp:ControlParameter Name="strCSRSite" ControlID="ddSite" PropertyName="SelectedValue"
                    Direction="Input" DefaultValue="%" />
            </FilterParameters>
        </asp:SqlDataSource>

            <asp:DropDownList ID="ddSubmitter" DataTextField="SubmitterText" DataValueField="SubmitterValue"
            DataSourceID="SqlDataSource13" runat="server" class="TextBox"
            Style="margin-right: 5px;">                   
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource13" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_LogDistinctSubmitterCompleted2" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        </asp:SqlDataSource>
        <asp:DropDownList ID="ddStatus" DataTextField="StatusText" DataValueField="StatusValue"
            DataSourceID="SqlDataSource1" runat="server" class="TextBox"
            Style="margin-right: 5px;">                   
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_Select_Statuses_For_Dashboard" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        </asp:SqlDataSource>
              
            <asp:DropDownList ID="ddSource" runat="server" DataTextField="SourceText" DataValueField="SourceValue"
            DataSourceID="SqlDataSource5" class="TextBox" Style="margin-right: 5px;">                                           
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_Select_Sources_For_Dashboard" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
                <SelectParameters>
                <asp:Parameter Name="strUserin" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
            <asp:DropDownList ID="ddValue" runat="server" DataTextField="ValueText" DataValueField="ValueValue"
            DataSourceID="SqlDataSource14" class="TextBox" Style="margin-right: 5px;">                                           
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource14" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_Select_Values_For_Dashboard" SelectCommandType="StoredProcedure"
            DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">                    
        </asp:SqlDataSource>
        <asp:Label ID="Label6" runat="server" Text="Submitted: "></asp:Label>
        <asp:TextBox runat="server" class="TextBox" ID="Date1" Width="100px" />&nbsp;
        <asp:Image runat="server" ID="cal1" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
        <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="true" TargetControlID="Date1"
            PopupButtonID="cal1">
        </asp:CalendarExtender>
        <asp:TextBox runat="server" class="TextBox" ID="Date2" Width="100px" />&nbsp;
        <asp:Image runat="server" ID="cal2" ImageUrl="images/Calendar_scheduleHS.png" Style="margin-right: 5px;" />
        <asp:CalendarExtender ID="CalendarExtender2" runat="server" Enabled="true" TargetControlID="Date2"
            PopupButtonID="cal2">
        </asp:CalendarExtender>
        <asp:Button ID="Button1" runat="server" Text="Apply" CssClass="formButton" OnClientClick="blockUI();" />
        <asp:GridView ID="GridView7" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataSourceID="SqlDataSource8" EnableModelValidation="True" ForeColor="#333333"
            GridLines="Vertical" Width="90%" AllowSorting="True" AllowPaging="True" PageSize="50"
            ShowFooter="True" OnRowDataBound="GridView7_Bound" Visible="false">
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
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("strFormID", oLink(Eval("strSource").toString)) %>'
                            Text='<%# Eval("strFormID") %>' onclick="vlarge1=window.open('','vlarge','resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=900,left=50,top=40');vlarge1.focus();return true;"
                            Target="vlarge"></asp:HyperLink>
                        &nbsp;&nbsp;<asp:Image ID="Image1" runat="server" ImageUrl="images/1324418219_new.png"
                            AlternateText="New Image" Visible='<%# newDisplay2(CDate(Eval("SubmittedDate"))) %>' /><asp:Label
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
                <asp:TemplateField HeaderText="Submitter Name" SortExpression="strSubmitterName">
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("strSubmitterName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Source" SortExpression="strSource">
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("strSource") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" SortExpression="strFormStatus">
                    <ItemTemplate>
                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("strFormStatus") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Coaching Reason" ItemStyle-VerticalAlign="Top">
                    <ItemTemplate>
                        <asp:DataList ID="Dlist1" runat="server">
                            <ItemTemplate>
                                <asp:Label ID="Label8" runat="server" Text='<%# Eval("CoachingReason") %>' />
                            </ItemTemplate>
                        </asp:DataList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sub-coaching Reason" ItemStyle-VerticalAlign="Top">
                    <ItemTemplate>
                        <asp:DataList ID="Dlist2" runat="server">
                            <ItemTemplate>
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("SubCoachingReason") %>' />
                            </ItemTemplate>
                        </asp:DataList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Value" ItemStyle-VerticalAlign="Top">
                    <ItemTemplate>
                        <asp:DataList ID="Dlist3" runat="server">
                            <ItemTemplate>
                                <asp:Label ID="Label10" runat="server" Text='<%# Eval("value") %>' />
                            </ItemTemplate>
                        </asp:DataList>
                    </ItemTemplate>
                </asp:TemplateField>

                    <asp:TemplateField HeaderText="Created Date" SortExpression="SubmittedDate">
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Eval("SubmittedDate") %>'></asp:Label>
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
        <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectFrom_Coaching_Log_HistoricalSUP" DataSourceMode="DataSet"
            SelectCommandType="StoredProcedure" EnableViewState="False" ViewStateMode="Disabled">
            <SelectParameters>
                <asp:Parameter Name="strSDatein" Type="String" />
                <asp:Parameter Name="strEDatein" Type="String" />
                <asp:Parameter Name="strjobcode" Type="String" />
                <asp:ControlParameter DefaultValue="%" Name="strValue" Type="String" ControlID="ddValue"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strCSRin" Type="String" ControlID="ddCSR"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strSUPin" Type="String" ControlID="ddSUP"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strMGRin" Type="String" ControlID="ddMGR"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strSubmitterin" Type="String" ControlID="ddSubmitter"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strCSRSitein" Type="String" ControlID="ddSite"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strSourcein" Type="String" ControlID="ddSource"
                    Direction="Input" PropertyName="SelectedValue" />
                <asp:ControlParameter DefaultValue="%" Name="strStatusin" Type="String" ControlID="ddStatus"
                    Direction="Input" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
            SelectCommand="EC.sp_SelectReviewFrom_Coaching_Log_Reasons" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Name="strFormIDin" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

    </asp:Panel>

</asp:Content>

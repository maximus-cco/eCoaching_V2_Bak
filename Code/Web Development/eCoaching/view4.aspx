<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master"
    CodeBehind="view4.aspx.vb" Inherits="eCoachingFixed.view4" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" AsyncPostBackTimeout="1200">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <br />
            <asp:Label ID="Label26" runat="server" CssClass="dashHead"></asp:Label>
            <br />
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" DisplayAfter="0">
                <ProgressTemplate>
                    <div style="text-align: center;">
                        loading...<br />
                        <img src="images/ajax-loader5.gif" alt="progress animation gif" style="width: 180px" /></div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <br />
            <asp:Label ID="Label6a" runat="server" Text='' Visible="false"></asp:Label>
            <asp:Panel ID="Panel3" runat="server">
                <asp:Label ID="Label22" runat="server" Text="eCoaching Logs" ForeColor="#0099FF"
                    Visible="True"></asp:Label><br />
                <asp:Label ID="Label23" runat="server" Text="Filter: " Visible="True"></asp:Label>
                <asp:DropDownList ID="ddSite" AutoPostBack="true" runat="server" class="TextBox"
                    Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddCSR" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSUP" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddMGR" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSubmitter" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                &nbsp;
                <asp:DropDownList ID="ddStatus" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddSource" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddValue" runat="server" class="TextBox" Style="margin-right: 5px;">
                </asp:DropDownList>
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
                <asp:Button ID="Button1" runat="server" Text="Apply" CssClass="formButton" />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4"
                    EnableModelValidation="True" ForeColor="#333333" GridLines="Vertical" Width="90%"
                    AllowSorting="True" AllowPaging="True" PageSize="50" ShowFooter="True" OnSorting="gvSorting"
                    OnRowDataBound="GridView1_Bound" Visible="false" OnPageIndexChanging="OnPaging">
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
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

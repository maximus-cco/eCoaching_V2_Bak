<%@ Page Title="" Language="C#" MasterPageFile="~/masterpages/Site1.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="eCLDeleteLog.Search" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="SearchContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-group">
        <asp:Label ID="SearchLabel" runat="server" CssClass="control-label" Text="Enter Log Form Name to delete: "></asp:Label>
        <asp:TextBox ID="FormNameTextBox" runat="server" CssClass="form-control input-sm" Width="300px"></asp:TextBox>
        
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="FormNameTextBox" ErrorMessage="Form name is required." 
            EnableClientScript="false"
            runat="server" />
    </div>

    <br />
    <asp:Button ID="SearchButton" runat="server" OnClick="SearchButton_Click" Text="Search" />
    <br />
    <br />

    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" AsyncPostBackTimeout="1200" />
    <asp:UpdatePanel ID="SearchResultUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Label ID="SuccessMessage" runat="server" CssClass="success-message" Visible="false"></asp:Label>
            <asp:Label ID="ErrorMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>
            <asp:Label ID="ExceptionMessage" runat="server" CssClass="error-message" Visible="true"></asp:Label>
            <asp:HiddenField ID="ViewNameHidden" runat="server" value="" ClientIDMode="Static" />
            <asp:GridView ID="SearchResultGridView" runat="server" CssClass="table table-hover" GridLines="None" AutoGenerateColumns="False" OnRowCommand="SearchResultGridView_RowCommand">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="DetailButton" runat="server" CommandName="viewDetail" Text="View Detail" CommandArgument='<%# Container.DataItemIndex %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="deleteLog" CommandArgument='<%# Container.DataItemIndex %>'
                                Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this record?');">
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField ReadOnly="True" HeaderText="Form Name" DataField="FormName" />
                    <asp:BoundField ReadOnly="True" HeaderText="Employee LAN ID" DataField="EmpLanID" />
                    <asp:BoundField ReadOnly="True" HeaderText="Employee ID" DataField="EmpID" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:HiddenField ID="LogIDHidden" runat="server" Value='<%# Eval("CoachingID") %>' />
                            <asp:HiddenField ID="FormNameHidden" runat="server" Value='<%# Eval("FormName") %>' />
                            <asp:HiddenField ID="SourceIDHidden" runat="server" Value='<%# Eval("SourceID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="Label15" runat="server" CssClass="nodata" Text="There are no items to display."></asp:Label>
                </EmptyDataTemplate>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div id="detailModal" class="modal fade" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Detail</h4>
                </div>
                <div class="modal-body" id="testdiv">
                    <iframe id="detailFrame" src="" width="100%" height="100%" frameborder="0"></iframe>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<%@ Page Title="eCL Access Control" Language="C#" MasterPageFile="~/Site1.Master"
    AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="eCLUsers._Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" SelectCommand="EC.sp_Check_AppRole"
                    SelectCommandType="StoredProcedure" ConnectionString="<%$ ConnectionStrings:ConnectionStringeCLLanId %>"
                    EnableCaching="False">
                            <SelectParameters>
                        <asp:Parameter Name="nvcLANID" Type="String" Direction="Input" />
                    </SelectParameters>
                    
                </asp:SqlDataSource>
            
    <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDataSource2"  
        AutoGenerateColumns="False" EnableModelValidation="True" Visible="false">
                        <Columns>
                        <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center">
                             <ItemTemplate>
                                <asp:Label ID="Level" runat="server" Text='<%# Eval("ISADMIN") %>' Visible="false"></asp:Label>
                                   </ItemTemplate>                            

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        </Columns>
                  
                        </asp:GridView>  
            <asp:Label ID="Label6" runat="server" Text="" visible="false" CssClass="question"></asp:Label>

    <asp:Label ID="Label3" runat="server" Text="Access Role: " CssClass="question"></asp:Label>
    <asp:DropDownList ID="AccessOption" runat="server" AutoPostBack="true" CssClass="TextBox">
        <asp:ListItem Value="ECL">Historical Dashboard Exception</asp:ListItem>
        <asp:ListItem Value="ARC">ARC CSR Users</asp:ListItem>
        <asp:ListItem Value="SRMGR">Senior Managers</asp:ListItem>
    </asp:DropDownList>
    &nbsp;&nbsp;
    <asp:Label ID="Label2" runat="server" Text="Add New User:" CssClass="question"></asp:Label>
    <asp:TextBox ID="NewUserLanId" runat="server" MaxLength="20" CssClass="TextBox" 
        Width="237px"></asp:TextBox>
    &nbsp;&nbsp;<asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/1348198141_add_user.png"
        OnClick="ImageButton1_Click" AlternateText="Add icon" />
    <br />
        <asp:Label ID="LanIDLenghtError" runat="server" CssClass="EMessage" Text="No LAN Id Was Entered" 
           visible="false"></asp:Label>
    <br />
    <h2 class="question">
        Current Users</h2>
    &nbsp;
    <br />
    <table>
        <tr>
            <td valign="top">
                <asp:GridView ID="GridView1" AllowPaging="True" OnRowUpdating="GridviewView_Updating"
                    OnRowDeleting="GridviewView_Deleting" AllowSorting="True" runat="server" DataSourceID="SqlDataSource1"
                    AutoGenerateColumns="False" Width="627px" EnableModelValidation="True" CellPadding="4"
                    ForeColor="#333333" GridLines="Vertical" PageSize="20">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField ShowHeader="False" HeaderText="" SortExpression="Row_ID" ItemStyle-HorizontalAlign="Center">
                            <EditItemTemplate>
                                <asp:Label ID="RowLabel1" runat="server" Text='<%# Eval("Row_ID") %>' Visible="false"></asp:Label>
                                <asp:ImageButton ID="ImageButton1" runat="server" AlternateText="Active User" ImageUrl='<%#setImage(Eval("User_LanID").ToString(), Eval("User_Name").ToString()) %>'
                                    Height="25" Width="25" CausesValidation="False" Enabled="False" />
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="RowLabel2" runat="server" Text='<%# Eval("Row_ID") %>' Visible="false"></asp:Label>
                                <asp:ImageButton ID="ImageButton2" runat="server" AlternateText="Active User" ImageUrl='<%#setImage(Eval("User_LanID").ToString(), Eval("User_Name").ToString()) %>'
                                    Height="25" Width="25" CausesValidation="False" Enabled="False" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User LAN ID" SortExpression="User_LanID" ItemStyle-HorizontalAlign="Center">
                            <EditItemTemplate>
                                <asp:TextBox ID="UserLAN" runat="server" Text='<%# Eval("User_LanID") %>' CssClass="TextBox"></asp:TextBox>
                                <br />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserLAN"
                                    Enabled="true" Display="Dynamic" Font-Size="X-Small" ErrorMessage="* Please enter a valid LAN ID."
                                    CssClass="EMessage"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="UserLAN"
                                    Display="Dynamic" Font-Size="X-Small" ErrorMessage="* LAN ID must be 6-20 characters."
                                    ValidationExpression="[0-9a-zA-Z' '\.]{6,21}$" CssClass="EMessage"></asp:RegularExpressionValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="UserLAN" runat="server" Text='<%# Eval("User_LanID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User Name" SortExpression="User_Name" ItemStyle-HorizontalAlign="Center">
                            <EditItemTemplate>
                                <asp:Label ID="UserName" runat="server" Text='<%# Eval("User_Name") %>' CssClass="TextBox" Width="250"></asp:Label>
                                <br />
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="UserName" runat="server" Text='<%# Eval("User_Name") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Role" SortExpression="Role" ItemStyle-HorizontalAlign="Center">
                            <EditItemTemplate>
                                <asp:DropDownList ID="RoleDropdown" runat="server" SelectedValue='<%# Eval("Role") %>'
                                    CssClass="TextBox">
                                    <asp:ListItem Value="ECL">ECL</asp:ListItem>
                                    <asp:ListItem Value="ARC">ARC</asp:ListItem>
                                    <asp:ListItem Value="SRMGR">SRMGR</asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Role" runat="server" Text='<%# Eval("Role") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="" CssClass="lview">
                                    <asp:ImageButton ID="ImageButton3" runat="server" AlternateText="Active User" ImageUrl="~/Images/1348194125_edit_user.png"
                                        Height="25" Width="25" BorderWidth="0" CommandName="Edit" />
                                </asp:LinkButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update" CssClass="lview"></asp:LinkButton>
                                &nbsp;<asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" CssClass="lview"></asp:LinkButton>
                            </EditItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete"
                                    Text="" CssClass="lview" OnClientClick="return confirm('Are you sure you want to delete this record?');">
                                    <asp:ImageButton ID="ImageButton4" runat="server" AlternateText="Active User" ImageUrl="~/Images/1348199313_delete_user.png"
                                        Height="25" Width="25" BorderWidth="0" CommandName="Delete" />
                                </asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" Font-Size=".9em" />
                    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                    <RowStyle BackColor="#FFFF99" ForeColor="#333333" />
                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                    SelectCommand="EC.sp_SelectFrom_Historical_Dashboard_ACL"
                    SelectCommandType="StoredProcedure" 
                    InsertCommand="EC.sp_InsertInto_Historical_Dashboard_ACL"
                    InsertCommandType="StoredProcedure" 
                    DeleteCommand="EC.sp_InsertInto_Historical_Dashboard_ACL"
                    DeleteCommandType="StoredProcedure" 
                    UpdateCommand="EC.sp_UpdateHistorical_Dashboard_ACL"
                    UpdateCommandType="StoredProcedure" ConnectionString="<%$ ConnectionStrings:ConnectionStringeCLLanId %>"
                    EnableCaching="False" OnInserted="errorFound_OnInserted">
                    <InsertParameters>
                        <asp:Parameter Name="nvcACTION" Size="10" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcLANID" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcUserLANID" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcRole" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcErrorMsgForEndUser" Size="180" Direction="InputOutput" Type="String" />
                    </InsertParameters>
                    <SelectParameters>
                        <asp:ControlParameter DefaultValue="ECL" Name="nvcRole" Type="String" ControlID="AccessOption"
                            Direction="Input" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="nvcRowID" Direction="Input" Type="Int32" />
                        <asp:Parameter Name="nvcLANID" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcRole" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcUserLANID" Size="30" Direction="Input" Type="String" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="nvcACTION" Size="10" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcLANID" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcUserLANID" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcRole" Size="30" Direction="Input" Type="String" />
                        <asp:Parameter Name="nvcErrorMsgForEndUser" Size="180" Direction="InputOutput" Type="String" />
                    </DeleteParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    <p>
        &nbsp;</p>
    <p>
        &nbsp;</p>
    <p>
        &nbsp;</p>
    <p>
        &nbsp;</p>
</asp:Content>

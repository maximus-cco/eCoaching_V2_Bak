<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master" CodeBehind="error3.aspx.vb" Inherits="eCoachingFixed.error3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <p>
        <img alt="warning" class="style75" src="images/folder_red_locked.png" 
            longdesc="unauthorized.html" /></p>
    <p>
    <asp:Label ID="Label1" runat="server" Text="You are not authorized to access this record." CssClass="warning"></asp:Label>
</p>
   
   
</asp:Content>

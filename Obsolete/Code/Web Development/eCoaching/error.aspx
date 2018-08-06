<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site2.Master" CodeBehind="error.aspx.vb" Inherits="eCoachingFixed._error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
 <style type="text/css">
        .style75
        {
            width: 256px;
            height: 256px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
 <p>
      &nbsp;</p>
    <p>
        <img alt="warning" class="style75" src="images/Symbols-Forbidden-icon.png" 
            longdesc="warning.html" /></p>
      <p>
              <asp:LoginName ID="LoginName1" CssClass="warning" runat="server" />
        <br/>
    <asp:Label ID="Label2" runat="server" Text="You are not authorized to access this application." CssClass="warning"></asp:Label>
</p>
  
</asp:Content>
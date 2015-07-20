<%@ Page Title="eCoaching Log" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master"
    CodeBehind="default.aspx.vb" Inherits="eCoachingFixed._default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ OutputCache Location="None" VaryByParam="None" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
    <asp:Label ID="Label1" runat="server" Text='' Visible="false"></asp:Label><br />
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:CoachingConnectionString %>"
        SelectCommand="EC.sp_Check_AgentRole" SelectCommandType="StoredProcedure" OnSelected="ARC_Selected"
        DataSourceMode="DataReader" EnableViewState="False" ViewStateMode="Disabled">
        <SelectParameters>
            <asp:Parameter Name="nvcLanID" Type="String" />
            <asp:Parameter Name="nvcRole" Type="String" />
            <asp:Parameter Direction="ReturnValue" Name="Indirect@return_value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GridView2" runat="server" Visible="true">
    </asp:GridView>
    <asp:Label ID="Label2" runat="server" Text="" Visible="false" ViewStateMode="Disabled"></asp:Label>
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" AsyncPostBackTimeout="1200">
    </asp:ToolkitScriptManager>

    <asp:TabContainer ID="TabContainer1" runat="server" AutoPostBack="false" OnDemand="true">
        <asp:TabPanel ID="TabPanel1" runat="server" HeaderText="New Submissions" OnDemandMode="Once">
            <ContentTemplate>
                <iframe id="frame1" src="default2.aspx" width="100%" height="550" frameborder="0">
                </iframe>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel ID="TabPanel2" runat="server" HeaderText="My Dashboard" OnDemandMode="Once">
            <ContentTemplate>
                <iframe id="frame2" src="view2.aspx" width="100%" height="800" frameborder="0"></iframe>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel ID="TabPanel3" runat="server" HeaderText="My Submissions" OnDemandMode="Once">
            <ContentTemplate>
                <iframe id="frame3" src="view3.aspx" width="100%" height="800" frameborder="0"></iframe>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel ID="TabPanel4" runat="server" HeaderText="Historical Dashboard" Visible="false"
            OnDemandMode="Once">
            <ContentTemplate>
                <iframe id="frame4" src="view4.aspx" width="100%" height="800" frameborder="0"></iframe>
            </ContentTemplate>
        </asp:TabPanel>
    </asp:TabContainer>
</asp:Content>
